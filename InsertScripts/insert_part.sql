IF NOT EXISTS (SELECT * FROM sys.objects O JOIN sys.schemas S ON O.schema_id = S.schema_id WHERE O.NAME = 'part' AND O.TYPE = 'U' AND S.NAME = 'dbo')
CREATE TABLE dbo.part
	(
	 [P_PARTKEY] int IDENTITY NOT NULL,
	 [P_NAME] varchar(55) NOT NULL,
	 [P_MFGR] nchar(25) NOT NULL,
	 [P_BRAND] nchar(10) NOT NULL,
	 [P_TYPE] varchar(25) NOT NULL,
	 [P_SIZE] int NOT NULL,
	 [P_CONTAINER] nchar(10) NOT NULL,
	 [P_RETAILPRICE] decimal(15,2) NOT NULL,
	 [P_COMMENT] varchar(23) NOT NULL,
	 CONSTRAINT PK_P_PARTKEY PRIMARY KEY NONCLUSTERED([P_PARTKEY]) NOT ENFORCED
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN,
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_part
--AS
--BEGIN
COPY INTO dbo.part
(P_PARTKEY 1, P_NAME 2, P_MFGR 3, P_BRAND 4, P_TYPE 5, P_SIZE 6, P_CONTAINER 7, P_RETAILPRICE 8, P_COMMENT 9)
FROM 'https://mgrhdsantanderdl2.dfs.core.windows.net/khd-datalake/tpc-h/part.csv'
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

SELECT TOP 100 * FROM dbo.part
GO