from sqlalchemy import text
from sqlalchemy import create_engine
from sqlalchemy.engine import URL
import pandas as pd

server = '####'
database = '####'
username = '####'
password = '####'
connection_string = f"Driver={{ODBC Driver 13 for SQL Server}};Server=tcp:{server},1433;Database={database};Uid={username};Pwd={password};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
connection_url = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})

engine = create_engine(connection_url, echo=True, connect_args={'autocommit': True})
delta = -90

QUERY = """SELECT L_RETURNFLAG, L_LINESTATUS, SUM(L_QUANTITY) AS SUM_QTY, SUM(L_EXTENDEDPRICE) AS SUM_BASE_PRICE, SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)) AS SUM_DISC_PRICE, 
SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1-L_TAX)) AS SUM_CHARGE, AVG(L_QUANTITY) AS AVG_QTY, AVG(L_EXTENDEDPRICE) AS AVG_PRICE, AVG(L_DISCOUNT) AS AVG_DISC, COUNT(*) AS COUNT_ORDER
FROM LINEITEM WHERE L_SHIPDATE <= dateadd(dd, """ + str(delta) + """, cast('1998-12-01' as datetime)) GROUP BY L_RETURNFLAG, L_LINESTATUS ORDER BY L_RETURNFLAG, L_LINESTATUS"""

print(pd.read_sql(QUERY, con=engine))