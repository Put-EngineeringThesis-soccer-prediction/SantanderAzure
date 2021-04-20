import pyodbc
import pandas as pd

server = '####'
database = '####'
username = '####'
password = '####'

conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';PORT=1433;DATABASE='+database+';UID='+username+';PWD='+ password)

print(pd.read_sql_query("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';", conn))


QUERY = "SELECT L_PARTKEY, L_SUPPKEY, L_LINENUMBER, L_EXTENDEDPRICE, L_DISCOUNT, L_TAX, L_RETURNFLAG, L_LINESTATUS, L_SHIPDATE, L_COMMITDATE, L_RECEIPTDATE, L_SHIPINSTRUCT, L_SHIPMODE, L_COMMENT FROM LINEITEM "

print(pd.read_sql(QUERY, con=conn))

conn.close()

