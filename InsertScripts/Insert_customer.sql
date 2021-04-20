IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'customer' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.customer
	(
	 [C_CUSTKEY] int IDENTITY NOT NULL,
	 [C_NAME] nvarchar(25) NOT NULL,
	 [C_ADDRESS] nvarchar(40) NOT NULL,
	 [C_NATIONKEY] int NOT NULL,
	 [C_PHONE] nchar(15) NOT NULL,
	 [C_ACCTBAL] decimal(15,2) NOT NULL,
	 [C_MKTSEGMENT] nchar(10) NOT NULL,
	 [C_COMMENT] nvarchar(117) NOT NULL,
	 CONSTRAINT PK_C_CUSTKEY  PRIMARY KEY NONCLUSTERED([C_CUSTKEY]) NOT ENFORCED
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
	-- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_customer
--AS
--BEGIN
COPY INTO dbo.customer
(C_CUSTKEY 1, C_NAME 2, C_ADDRESS 3, C_NATIONKEY 4, C_PHONE 5, C_ACCTBAL 6, C_MKTSEGMENT 7, C_COMMENT 8)
FROM 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/tpc-h/customer.csv'
WITH
(
	FILE_TYPE = 'CSV'
	,MAXERRORS = 0
	,FIELDTERMINATOR = '|'
	,FIRSTROW = 2
	,ERRORFILE = 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/'
	,IDENTITY_INSERT = 'ON'
)
--END
GO

SELECT TOP 100 * FROM dbo.customer
GO