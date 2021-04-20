IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'region' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.region
	(
	 [R_REGIONKEY] int NOT NULL IDENTITY,
	 [R_NAME] nchar(25) NOT NULL,
	 [R_COMMENT] varchar(152) NOT NULL,
	 CONSTRAINT PK_R_REGIONKEY PRIMARY KEY NONCLUSTERED([R_REGIONKEY]) NOT ENFORCED
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_region
--AS
--BEGIN
COPY INTO dbo.region
(R_REGIONKEY 1, R_NAME 2, R_COMMENT 3)
FROM 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/tpc-h/region.csv'
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

SELECT TOP 100 * FROM dbo.region
GO