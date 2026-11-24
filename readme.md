# DMart Sales Analytics
### End-to-End Data Engineering & Business Intelligence Project

## 1. Project Overview

DMart Sales Analytics is an end-to-end data engineering and business intelligence solution designed to transform daily sales data received from the Operations team into an interactive management dashboard.

The project focuses on building an automated data pipeline that extracts sales data from Excel, processes and manages it through Microsoft SQL Server, and delivers business insights through Power BI.

The solution follows a **Bronze, Silver, and Gold Medallion Architecture** to organise raw, cleaned, and business-ready data.

**End-to-End Architecture**

```text
Daily Excel Files
       |
       v
     Python
       |
       v
 Microsoft SQL Server
       |
       +----------------------+
       |                      |
       v                      v
  Bronze Layer           Batch Tracking
  (Raw Data)             (Load Metadata)
       |
       v
  Silver Layer
  (Cleaned & Validated Data)
       |
       v
   Gold Layer
   (Business-Ready Data)
       |
       v
    Power BI
       |
       v
 DMart Stores Dashboard
```

The final solution is designed to support daily data ingestion, data quality management, reliable reporting, and informed business decision-making.

## 2. Business Objectives

The Operations team provides sales data in a standardised Excel format.

The primary objectives of this project are to:

- Automate the ingestion of daily Excel sales files.
- Maintain historical source data and batch-level traceability.
- Clean, validate, and transform sales records.
- Store and manage structured data using Microsoft SQL Server.
- Develop reusable SQL stored procedures for data processing and retrieval.
- Build a reporting-ready data model.
- Develop an interactive Power BI dashboard for management.
- Enable scheduled data processing and regular dashboard updates.
- Provide actionable insights into sales, profitability, products, regions, and customers.

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| Microsoft Excel | Daily sales data source |
| Python 3.x | Data extraction, transformation and automation |
| Pandas | Data reading and manipulation |
| NumPy | Numerical operations and missing-value handling |
| OpenPyXL | Excel file processing |
| PyODBC | Python–SQL Server connectivity |
| Microsoft SQL Server Express | Database and data management |
| T-SQL | Data transformations and stored procedures |
| Power BI Desktop | Business intelligence and visualisation |
| Git and GitHub | Version control and source code management |
| Windows Task Scheduler | Scheduled pipeline execution |

## 4. Dataset Overview

**Source Dataset:** `DMart Data Store.xlsx`

The initial dataset contains 8,047 records and 17 business columns.

| Metric | Value |
|---|---:|
| Total Records | 8,047 |
| Total Columns | 17 |
| Missing Values | 0 |
| Exact Duplicate Rows | 2 |
| Unique Order IDs | 4,117 |
| Unique Customers | 792 |
| Countries | 15 |
| Customer Segments | 3 |
| Order Date Range | 2011–2014 |

### Dataset Attributes

1. Order ID
2. Order Date
3. Customer Name
4. Country
5. State
6. City
7. Region
8. Segment
9. Ship Mode
10. Category
11. Sub-Category
12. Product Name
13. Discount
14. Sales
15. Profit
16. Quantity
17. Feedback?

**Data considerations:**

- An Order ID can appear across multiple product line items and is therefore not a unique row identifier.
- Exact duplicate records are identified and audited before exclusion from reporting.
- The source column `Feedback?` is represented as `Feedback` in SQL Server.
- The Operations team supplies the complete historical dataset in each daily file.

## 5. Data Engineering Architecture

The solution uses the Medallion Architecture to organise data into three logical layers within Microsoft SQL Server.

### 5.1 Bronze Layer — Raw Data

The Bronze layer preserves source records as received and provides traceability for every accepted file submission.

**Key responsibilities:**

- Store raw sales records.
- Maintain source file and batch information.
- Track file fingerprints using SHA-256 hashing.
- Record ingestion timestamps and source row numbers.
- Maintain batch processing status and record counts.
- Support auditing and troubleshooting.

**Database objects:**

| Object | Description |
|---|---|
| `bronze.LoadBatch` | Stores source file and batch processing metadata |
| `bronze.SalesRaw` | Stores raw sales records with ingestion metadata |

### 5.2 Silver Layer — Cleaned and Validated Data

The Silver layer transforms raw records into a consistent and validated dataset.

**Key responsibilities:**

- Standardise text fields.
- Validate required fields and data types.
- Identify invalid records.
- Track rejected records and rejection reasons.
- Detect and audit exact duplicate records.
- Maintain lineage to the original Bronze records.
- Publish the latest successfully validated dataset.

**Planned database objects:**

| Object | Description |
|---|---|
| `silver.SalesClean` | Latest cleaned and validated sales dataset |
| `silver.SalesRejected` | Records that fail validation |
| `silver.SalesDuplicateAudit` | Duplicate detection and audit records |

### 5.3 Gold Layer — Business-Ready Data

The Gold layer provides structured and business-ready data for analytical reporting.

**Key responsibilities:**

- Organise validated records for business analysis.
- Create fact and dimension tables.
- Establish reporting relationships.
- Support consistent business metrics.
- Provide the reporting dataset consumed by Power BI.

**Planned database objects:**

| Object | Description |
|---|---|
| `gold.DimCustomer` | Customer information |
| `gold.DimProduct` | Product and category information |
| `gold.DimGeography` | Country, state, city and region information |
| `gold.DimDate` | Calendar and date attributes |
| `gold.FactSales` | Sales transaction measures and dimension references |

## 6. Data Processing and Refresh Strategy

The Operations team provides a complete historical dataset with each daily Excel submission.

The pipeline is therefore designed around snapshot processing:

- **Bronze:** Retains accepted source batches for historical traceability.
- **Silver:** Maintains the latest successfully validated snapshot.
- **Gold:** Maintains the latest successfully published reporting snapshot.

This approach prevents repeated historical records from accumulating in reporting tables.

The pipeline also incorporates file fingerprinting, batch tracking, data validation, error handling, and transaction management to improve processing reliability.

A failed processing run must not replace the previous successful reporting snapshot.

## 7. SQL Server Database

**Database:** `DMartDB`

The database contains separate schemas for each data processing layer:

```text
DMartDB
│
├── bronze
│   ├── LoadBatch
│   └── SalesRaw
│
├── silver
│   ├── SalesClean
│   ├── SalesRejected
│   └── SalesDuplicateAudit
│
└── gold
    ├── DimCustomer
    ├── DimProduct
    ├── DimGeography
    ├── DimDate
    └── FactSales
```

The design uses independent identity keys for technical row identification because Order IDs can repeat across product line items.

Financial values use appropriate DECIMAL data types to maintain monetary precision.

SQL stored procedures provide controlled data insertion, transformation, and reporting operations, including the planned `sp_InsertSalesData` and `sp_GetSalesData` interfaces.

## 8. Python Data Engineering Pipeline

Python coordinates the movement of data from Excel into the SQL Server architecture.

The planned pipeline includes:

1. Read the daily Excel file using Pandas and OpenPyXL.
2. Validate the source file structure and expected columns.
3. Handle data types, missing values, and text standardisation.
4. Calculate the source file SHA-256 fingerprint.
5. Register the processing batch in SQL Server.
6. Load source records into the Bronze layer.
7. Execute Silver data cleaning and validation.
8. Refresh the Gold reporting layer.
9. Record processing statistics and execution logs.
10. Handle processing errors and rejected records.

The Python pipeline is designed to support repeatable execution and scheduled daily processing.

## 9. Power BI Dashboard — DMart Stores

The final deliverable is an interactive Power BI dashboard designed to provide management with a consolidated view of business performance.

### 9.1 Key Performance Indicators

| KPI | Business Purpose |
|---|---|
| Total Sales | Measure overall revenue |
| Total Profit | Measure business profitability |
| Total Quantity | Measure units sold |
| Total Transactions | Measure order volume |
| Profit Margin % | Measure profitability relative to sales |
| Total Customers | Measure customer base |

### 9.2 Interactive Filters

The dashboard will include:

- Date range filter
- Region filter
- Sales range slider
- Profit range slider
- Quantity range slider

### 9.3 Business Analysis Visuals

| Visualisation | Business Insight |
|---|---|
| Geographical bubble map | Sales and profit distribution across locations |
| Horizontal bar chart | Sales by product sub-category |
| Sales and Profit combo chart | Quarterly sales and profitability trends |
| Segment donut chart | Sales contribution by customer segment |
| Treemap | Analysis by Ship Mode or Order Priority |
| Region donut/pie chart | Regional sales contribution |
| Top 5 Customers table | Highest-value customers with sales data bars |

### 9.4 Additional Analytical Insights

The dashboard may also include:

- Top and bottom performing products.
- Year-over-year sales growth.
- Discount versus profitability analysis.
- Regional profitability comparisons.
- Customer contribution analysis.

These additional views will help management identify performance trends, opportunities, and potential areas of concern.

## 10. Automation and Refresh Strategy

The solution is designed to support daily automated processing.

Windows Task Scheduler will execute the Python pipeline at a configured time, allowing new Excel files to be processed without manual execution.

The Power BI refresh strategy will be configured to reflect the deployment environment:

- Power BI Desktop refresh for local reporting.
- Power BI Service refresh and an appropriate gateway configuration if the report is published and requires access to the local SQL Server.

## 11. Expected Project Deliverables

The completed project will provide:

1. A structured SQL Server database implementing Bronze, Silver, and Gold layers.
2. A Python-based Excel ingestion and ETL pipeline.
3. Batch tracking, data validation, and duplicate auditing.
4. SQL stored procedures for data processing and retrieval.
5. A business-ready Gold reporting model.
6. An interactive Power BI dashboard titled **DMart Stores**.
7. A scheduled daily data processing workflow.
8. Technical documentation covering the architecture and pipeline.

## 12. Business Value and Project Outcome

DMart Sales Analytics will provide a repeatable and automated approach to transforming operational sales data into meaningful business intelligence.

The solution will help management:

- Monitor overall sales and profitability.
- Identify high-performing and underperforming products.
- Compare regional performance.
- Understand customer segment contributions.
- Analyse shipping and order patterns.
- Identify valuable customers.
- Track business performance over time.
- Make more informed sales and operational decisions.

The project demonstrates practical implementation of data engineering, ETL development, SQL database design, data quality management, data modelling, Power BI reporting, and workflow automation.

---

**Project Name:** DMart Sales Analytics  
**Dashboard Name:** DMart Stores  
**Database:** `DMartDB`  
**Architecture:** Bronze → Silver → Gold  
**Primary Data Source:** `DMart Data Store.xlsx`  
**Core Technologies:** Python, Microsoft SQL Server Express, Power BI Desktop