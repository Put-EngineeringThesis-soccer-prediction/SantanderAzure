import os
import pyodbc
import pandas as pd
import pandas as pd
import io
import sys
from azure.storage.filedatalake import DataLakeServiceClient
server = 'mgrhd-santander-khd.sql.azuresynapse.net'
database = 'stdmgrkhd'
username = 'sqladmin'
password = os.environ['dbpassword']

conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';PORT=1433;DATABASE='+database+';UID='+username+';PWD='+ password)

print(pd.read_sql_query("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';", conn))

delta = -90

QUERY = """SELECT L_RETURNFLAG, L_LINESTATUS, SUM(L_QUANTITY) AS SUM_QTY, SUM(L_EXTENDEDPRICE) AS SUM_BASE_PRICE, SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)) AS SUM_DISC_PRICE, 
SUM(L_EXTENDEDPRICE*(1-L_DISCOUNT)*(1-L_TAX)) AS SUM_CHARGE, AVG(L_QUANTITY) AS AVG_QTY, AVG(L_EXTENDEDPRICE) AS AVG_PRICE, AVG(L_DISCOUNT) AS AVG_DISC, COUNT(*) AS COUNT_ORDER
FROM LINEITEM WHERE L_SHIPDATE <= dateadd(dd, """ + str(delta) + """, cast('1998-12-01' as datetime)) GROUP BY L_RETURNFLAG, L_LINESTATUS ORDER BY L_RETURNFLAG, L_LINESTATUS"""

df5 = pd.read_sql(QUERY, con=conn)



storage_account_name = "mgrhdsantanderdl2"
storage_account_key = os.environ['storage_account_key']
container_name = "khd-datalake"
directory_name = "test-python-output"
service_client = DataLakeServiceClient(account_url="{}://{}.dfs.core.windows.net".format(
        "https", storage_account_name), credential=storage_account_key)

file_system_client = service_client.get_file_system_client(file_system=container_name)
dir_client = file_system_client.get_directory_client(directory_name)
dir_client.create_directory()
file_client = dir_client.create_file("sampledata.xlsx")

excel_stream = io.BytesIO()

with pd.ExcelWriter(excel_stream, engine = 'xlsxwriter') as writer:
    df5.to_excel(writer, sheet_name = "Sheet1", index = False)
    writer.save()

file_client.append_data(data=excel_stream.getvalue(), offset=0, length=len(excel_stream.getvalue()))
file_client.flush_data(len(excel_stream.getvalue()))

