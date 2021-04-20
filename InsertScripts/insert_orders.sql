IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'orders' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.orders
	(
	 [O_ORDERKEY] int NOT NULL IDENTITY,
	 [O_CUSTKEY] int NOT NULL,
	 [O_ORDERSTATUS] nchar(1) NOT NULL,
	 [O_TOTALPRICE] decimal(15,2) NOT NULL,
	 [O_ORDERDATE] date NOT NULL,
	 [O_ORDERPRIORITY] nchar(15) NOT NULL,
	 [O_CLERK] nchar(15) NOT NULL,
	 [O_SHIPPRIORITY] int NOT NULL,
	 [O_COMMENT] varchar(79) NOT NULL,
	 CONSTRAINT PK_O_ORDERKEY PRIMARY KEY NONCLUSTERED([O_ORDERKEY]) NOT ENFORCED
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_orders
--AS
--BEGIN
COPY INTO dbo.orders
(O_ORDERKEY 1, O_CUSTKEY 2, O_ORDERSTATUS 3, O_TOTALPRICE 4, O_ORDERDATE 5, O_ORDERPRIORITY 6, O_CLERK 7, O_SHIPPRIORITY 8, O_COMMENT 9)
FROM 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/tpc-h/orders.csv'
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

SELECT TOP 100 * FROM dbo.orders
GO