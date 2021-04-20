IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'partsupp' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.partsupp
	(
	 [PS_PARTKEY] int NOT NULL,
	 [PS_SUPPKEY] int NOT NULL,
	 [PS_AVAILQTY] int NOT NULL,
	 [PS_SUPPLYCOST] decimal(15,2) NOT NULL,
	 [PS_COMMENT] varchar(199) NOT NULL)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_partsupp
--AS
--BEGIN
COPY INTO dbo.partsupp
(PS_PARTKEY 1, PS_SUPPKEY 2, PS_AVAILQTY 3, PS_SUPPLYCOST 4, PS_COMMENT 5)
FROM 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/tpc-h/partsupp.csv'
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

SELECT TOP 100 * FROM dbo.partsupp
GO

SELECT COUNT(*)  FROM dbo.partsupp
GO