/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

/* 
   PROJECT NOTES / WARNINGS:
   -- W1: In a real-world production project, ID or date columns might contain 
         corrupted data or characters, so VARCHAR(MAX) is preferred in the Bronze layer. 
         However, for this portfolio/course context, static types (INT, DATE) are used.
*/
USE DataWarehouse;
GO

IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info
(
	cst_id				INT,			    --W1
	cst_key				NVARCHAR(50),
	cst_firstname		NVARCHAR(50),
	cst_lastname		NVARCHAR(50),
	cst_marital_status	NVARCHAR(50),
	cst_gndr			NVARCHAR(50),
	cst_create_date		DATE			--W1
);
GO

IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info
(
prd_id			INT,           --W1
prd_key			VARCHAR(50),
prd_nm			VARCHAR(50),
prd_cost		INT,           --W1
prd_line		VARCHAR(50),
prd_start_dt	DATE,        --W1
prd_end_dt		DATE         --W1
);                          
GO

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details
(
sls_ord_num		VARCHAR(50),
sls_prd_key		VARCHAR(50),
sls_cust_id		INT,            --W1
sls_order_dt	INT,            --W1
sls_ship_dt		INT,            --W1
sls_due_dt		INT,            --W1
sls_sales		INT,            --W1
sls_quantity	INT,            --W1
sls_price		INT             --W1
);
GO

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12
(
CID		NVARCHAR(50),
BDATE	DATE, --W1
GEN		NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101
(
CID			VARCHAR(50),
CNTRY		VARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2
(
İD				VARCHAR(50),
CAT				VARCHAR(50),
SUBCAT			VARCHAR(50),
MAINTENANCE		VARCHAR(50)
);
GO
