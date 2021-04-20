IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'supplier' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.supplier
	(
	 [S_SUPPKEY] int IDENTITY NOT NULL,
	 [S_NAME] nchar(25) NOT NULL,
	 [S_ADDRESS] varchar(40) NOT NULL,
	 [S_NATIONKEY] int NOT NULL,
	 [S_PHONE] nchar(15) NOT NULL,
	 [S_ACCTBAL] decimal(15,2) NOT NULL,
	 [S_COMMENT] varchar(101) NOT NULL,
	 CONSTRAINT PK_S_SUPPKEY  PRIMARY KEY NONCLUSTERED([S_SUPPKEY]) NOT ENFORCED
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_supplier
--AS
--BEGIN
COPY INTO dbo.supplier
(S_SUPPKEY 1, S_NAME 2, S_ADDRESS 3, S_NATIONKEY 4, S_PHONE 5, S_ACCTBAL 6, S_COMMENT 7)
FROM 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/tpc-h/supplier.csv'
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

SELECT TOP 100 * FROM dbo.supplier
GO