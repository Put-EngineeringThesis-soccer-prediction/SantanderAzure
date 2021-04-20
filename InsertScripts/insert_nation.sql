IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'nation' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.nation
	(
	 [N_NATIONKEY] int IDENTITY NOT NULL,
	 [N_NAME] nchar(25) NOT NULL,
	 [N_REGIONKEY] int NOT NULL,
	 [NCOMMENT] varchar(152) NOT NULL,
	 CONSTRAINT PK_NATIONKEY  PRIMARY KEY NONCLUSTERED([N_NATIONKEY]) NOT ENFORCED
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_nation
--AS
--BEGIN
COPY INTO dbo.nation
(N_NATIONKEY 1, N_NAME 2, N_REGIONKEY 3, NCOMMENT 4)
FROM 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/tpc-h/nation.csv'
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

SELECT TOP 100 * FROM dbo.nation
GO