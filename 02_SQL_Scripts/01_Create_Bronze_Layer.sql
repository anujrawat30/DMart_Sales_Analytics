
/*
Project: DMart Sales Analytics
Phase: Bronze Layer
Database: DMartDB
SQL Server Instance: localhost\SQLEXPRESS

Creates:
1. bronze schema
2. bronze.LoadBatch
3. bronze.SalesRaw
*/

USE DMartDB;
GO

-- 1. Create Bronze schema if it does not exist
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'bronze'
)
BEGIN
    EXEC('CREATE SCHEMA bronze');
END;
GO

-- 2. Create batch tracking table
IF OBJECT_ID('bronze.LoadBatch', 'U') IS NULL
BEGIN
    CREATE TABLE bronze.LoadBatch
    (
        BatchID BIGINT IDENTITY(1,1) NOT NULL,

        SourceFileName NVARCHAR(260) NOT NULL,
        FileHash CHAR(64) NOT NULL,
        FileSizeBytes BIGINT NOT NULL,

        LoadStartedAt DATETIME2(0) NOT NULL
            CONSTRAINT DF_LoadBatch_LoadStartedAt
            DEFAULT SYSDATETIME(),

        LoadCompletedAt DATETIME2(0) NULL,

        RowsRead INT NOT NULL
            CONSTRAINT DF_LoadBatch_RowsRead DEFAULT 0,

        RowsLoaded INT NOT NULL
            CONSTRAINT DF_LoadBatch_RowsLoaded DEFAULT 0,

        RowsRejected INT NOT NULL
            CONSTRAINT DF_LoadBatch_RowsRejected DEFAULT 0,

        BatchStatus VARCHAR(20) NOT NULL
            CONSTRAINT DF_LoadBatch_BatchStatus
            DEFAULT 'Processing',

        ErrorMessage NVARCHAR(2000) NULL,

        CONSTRAINT PK_LoadBatch
            PRIMARY KEY (BatchID),

        CONSTRAINT CK_LoadBatch_FileSize
            CHECK (FileSizeBytes >= 0),

        CONSTRAINT CK_LoadBatch_RowCounts
            CHECK (
                RowsRead >= 0
                AND RowsLoaded >= 0
                AND RowsRejected >= 0
            ),

        CONSTRAINT CK_LoadBatch_Status
            CHECK (
                BatchStatus IN (
                    'Processing',
                    'Completed',
                    'Failed',
                    'Skipped'
                )
            )
    );
END;
GO

-- 3. Create raw sales table
IF OBJECT_ID('bronze.SalesRaw', 'U') IS NULL
BEGIN
    CREATE TABLE bronze.SalesRaw
    (
        -- Technical metadata
        BronzeRowID BIGINT IDENTITY(1,1) NOT NULL,
        BatchID BIGINT NOT NULL,
        SourceRowNumber INT NOT NULL,

        IngestedAt DATETIME2(0) NOT NULL
            CONSTRAINT DF_SalesRaw_IngestedAt
            DEFAULT SYSDATETIME(),

        -- Business columns from Excel
        OrderID NVARCHAR(30) NOT NULL,
        OrderDate DATE NOT NULL,
        CustomerName NVARCHAR(100) NOT NULL,
        Country NVARCHAR(100) NOT NULL,
        State NVARCHAR(100) NOT NULL,
        City NVARCHAR(100) NOT NULL,
        Region NVARCHAR(50) NOT NULL,
        Segment NVARCHAR(50) NOT NULL,
        ShipMode NVARCHAR(50) NOT NULL,
        Category NVARCHAR(100) NOT NULL,
        SubCategory NVARCHAR(100) NOT NULL,
        ProductName NVARCHAR(255) NOT NULL,

        Discount DECIMAL(10,4) NOT NULL,
        Sales DECIMAL(18,2) NOT NULL,
        Profit DECIMAL(18,2) NOT NULL,
        Quantity INT NOT NULL,
        Feedback BIT NOT NULL,

        -- Primary key
        CONSTRAINT PK_SalesRaw
            PRIMARY KEY (BronzeRowID),

        -- Link each row to its source batch
        CONSTRAINT FK_SalesRaw_LoadBatch
            FOREIGN KEY (BatchID)
            REFERENCES bronze.LoadBatch(BatchID),

        -- Prevent inserting the same Excel row
        -- twice within one batch
        CONSTRAINT UQ_SalesRaw_Batch_SourceRow
            UNIQUE (BatchID, SourceRowNumber),

        -- Excel data rows must have positive row numbers
        CONSTRAINT CK_SalesRaw_SourceRowNumber
            CHECK (SourceRowNumber > 0),

        CONSTRAINT CK_SalesRaw_Quantity
            CHECK (Quantity >= 0),

        CONSTRAINT CK_SalesRaw_Discount
            CHECK (Discount >= 0 AND Discount <= 1)
    );
END;
GO

-- 4. Index for batch-based data retrieval
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_SalesRaw_BatchID'
      AND object_id = OBJECT_ID('bronze.SalesRaw')
)
BEGIN
    CREATE INDEX IX_SalesRaw_BatchID
        ON bronze.SalesRaw(BatchID);
END;
GO

-- 5. Verify Bronze objects
SELECT
    s.name AS SchemaName,
    t.name AS TableName
FROM sys.tables t
INNER JOIN sys.schemas s
    ON t.schema_id = s.schema_id
WHERE s.name = 'bronze'
ORDER BY t.name;
GO
