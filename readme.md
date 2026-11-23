# DMart Sales Analytics – End-to-End Data Engineering & Business Intelligence Project

## 1. Project Overview

The DMart Sales Analytics project aims to build an automated, end-to-end data pipeline that transforms raw sales data received from the Operations team into an interactive Power BI management dashboard.

The objective is to help management analyse sales performance, identify profitable products and regions, understand customer behaviour, and make data-driven business decisions.

The solution follows this architecture:

**Excel → Python → Microsoft SQL Server Express → Power BI**

The pipeline is designed to support daily data ingestion and dashboard updates.

## 2. Business Objective

The Operations team provides sales data in a standardised Excel format.

The project aims to:

- Automate the ingestion of daily Excel sales data.
- Store structured sales information in Microsoft SQL Server.
- Use Python for data extraction, validation, cleaning and loading.
- Develop SQL stored procedures for data insertion and retrieval.
- Build an interactive Power BI dashboard for management.
- Enable regular data refreshes for business reporting.

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| Microsoft Excel | Raw sales data source |
| Python 3.x | Data processing and automation |
| Pandas | Data extraction and manipulation |
| NumPy | Missing-value handling |
| OpenPyXL | Excel file reading |
| PyODBC | Python–SQL Server connectivity |
| Microsoft SQL Server Express | Relational database |
| SQL Stored Procedures | Data insertion and retrieval |
| Power BI Desktop | Interactive dashboard development |
| VS Code | Development environment |

## 4. Dataset Overview

**Dataset:** DMart Data Store.xlsx

Initial dataset exploration using Pandas identified:

| Metric | Result |
|---|---:|
| Total Records | 8,047 |
| Total Columns | 17 |
| Missing Values | 0 |
| Exact Duplicate Rows | 2 |
| Unique Order IDs | 4,117 |
| Unique Customers | 792 |
| Countries | 15 |
| Customer Segments | 3 |

**Order Date Range:** 1 January 2011 – 31 December 2014.

### Dataset Columns

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

## 5. Project Architecture

### Data Pipeline

1. **Excel:** Receive the raw sales dataset from the Operations team.
2. **Python:** Read the Excel file, validate records, clean data and prepare it for database insertion.
3. **SQL Server:** Store sales records in a structured relational database.
4. **Stored Procedures:** Insert and retrieve sales data.
5. **Power BI:** Consume SQL Server data and create interactive management dashboards.
6. **Automation:** Schedule the Python loader for daily execution.

## 6. Development Progress

### Phase 0 – Environment Setup
Status: In Progress

- [ ] Install Python 3.x
- [ ] Install VS Code
- [ ] Install Python extension
- [ ] Install SQL Server extension
- [ ] Install SQL Server Express
- [ ] Install ODBC Driver 18
- [ ] Install Power BI Desktop
- [ ] Configure Python virtual environment

### Phase 1 – Database Development
Status: Schema Approved

- [x] Explore Excel dataset using Pandas
- [x] Identify all 17 dataset columns
- [x] Inspect data types and missing values
- [x] Identify exact duplicate records
- [x] Finalise proposed SQL data types
- [x] Decide on an independent identity primary key
- [ ] Create DMartDB database
- [ ] Create SalesData table
- [ ] Verify database and table structure

### Phase 2 – SQL Stored Procedures
Status: Pending

- [ ] Create sp_InsertSalesData
- [ ] Implement duplicate-load protection
- [ ] Test data insertion

### Phase 3 – Python Data Pipeline
Status: Pending

- [ ] Develop load_sales_data.py
- [ ] Read Excel data using Pandas
- [ ] Validate and clean records
- [ ] Connect Python to SQL Server using PyODBC
- [ ] Execute insertion stored procedure
- [ ] Implement logging and error handling
- [ ] Test data loading

### Phase 4 – SQL Data Retrieval
Status: Pending

- [ ] Create sp_GetSalesData
- [ ] Test complete dataset retrieval

### Phase 5 – Power BI Dashboard
Status: Pending

- [ ] Connect Power BI to SQL Server
- [ ] Create DAX measures
- [ ] Build KPI cards
- [ ] Create interactive slicers
- [ ] Build geographical sales analysis
- [ ] Create product and customer analysis visuals
- [ ] Develop management dashboard

### Phase 6 – Automation
Status: Pending

- [ ] Create Windows batch file
- [ ] Configure Windows Task Scheduler
- [ ] Implement daily data loading
- [ ] Configure dashboard refresh strategy

### Phase 7 – Final Validation
Status: Pending

- [ ] Reconcile Excel and SQL totals
- [ ] Validate Power BI calculations
- [ ] Test daily loading
- [ ] Finalise documentation

## 7. Database Design Decisions

The proposed database name is `DMartDB`.

The proposed sales table is `dbo.SalesData`.

An independent identity column named `RowID` will serve as the primary key because Order ID is repeated across multiple product line items.

Financial columns Sales and Profit will use DECIMAL data types to support monetary precision.

The source column Feedback? will be renamed Feedback in SQL Server to simplify querying.

## 8. Expected Business Dashboard

The Power BI dashboard will provide:

- Total Sales
- Total Profit
- Total Quantity
- Total Transactions
- Profit Margin %
- Total Customers
- Sales and Profit trends
- Regional sales analysis
- Product sub-category performance
- Customer segment analysis
- Shipping mode analysis
- Top 5 customers
- Additional profitability and growth insights

## 9. Project Outcome

The expected outcome is a repeatable data pipeline that converts daily raw sales files into structured database records and provides management with an interactive sales analytics dashboard.

The project will demonstrate practical skills in Python, SQL Server, data engineering, ETL development, data modelling, Power BI and workflow automation.

---

**Project Name:** DMart Sales Analytics

**Development Environment:** Windows + VS Code

**Current Milestone:** Initial dataset exploration completed; SQL schema approved.