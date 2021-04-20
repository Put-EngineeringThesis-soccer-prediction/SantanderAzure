IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'lineitem' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.lineitem
	(
	 [L_ORDERKEY] int NOT NULL,
	 [L_PARTKEY] int NOT NULL,
	 [L_SUPPKEY] int NOT NULL,
	 [L_LINENUMBER] int NOT NULL,
	 [L_QUANTITY] decimal(15,2) NOT NULL,
	 [L_EXTENDEDPRICE] decimal(15,2) NOT NULL,
	 [L_DISCOUNT] decimal(15,2) NOT NULL,
	 [L_TAX] decimal(15,2) NOT NULL,
	 [L_RETURNFLAG] nchar(1) NOT NULL,
	 [L_LINESTATUS] nchar(1) NOT NULL,
	 [L_SHIPDATE] date NOT NULL,
	 [L_COMMITDATE] date NOT NULL,
	 [L_RECEIPTDATE] date NOT NULL,
	 [L_SHIPINSTRUCT] nchar(25) NOT NULL,
	 [L_SHIPMODE] nchar(10) NOT NULL,
	 [L_COMMENT] varchar(44) NOT NULL
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_lineitem
--AS
--BEGIN
COPY INTO dbo.lineitem
(L_ORDERKEY 1, L_PARTKEY 2, L_SUPPKEY 3, L_LINENUMBER 4, L_QUANTITY 5, L_EXTENDEDPRICE 6, L_DISCOUNT 7, L_TAX 8, L_RETURNFLAG 9, L_LINESTATUS 10, L_SHIPDATE 11, L_COMMITDATE 12, L_RECEIPTDATE 13, L_SHIPINSTRUCT 14, L_SHIPMODE 15, L_COMMENT 16)
FROM 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/tpc-h/lineitem.csv'
WITH
(
	FILE_TYPE = 'CSV'
	,MAXERRORS = 0
	,FIELDTERMINATOR = '|'
	,FIRSTROW = 2
	,ERRORFILE = 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/'
	,IDENTITY_INSERT = 'OFF'
)
--END
GO

SELECT TOP 100 * FROM dbo.lineitem
GO