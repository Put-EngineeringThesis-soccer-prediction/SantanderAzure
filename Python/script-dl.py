import os
import pyodbc
import pandas as pd
import io
import sys
from azure.storage.filedatalake import DataLakeServiceClient, DelimitedTextDialect


storage_account_name = "mgrhdstddl2"
storage_account_key = os.environ['storage_account_key']
container_name = "khd-datalake"
directory_name = "tpc-h"
service_client = DataLakeServiceClient(account_url="{}://{}.dfs.core.windows.net".format(
        "https", storage_account_name), credential=storage_account_key)

file_system_client = service_client.get_file_system_client(file_system=container_name)
dir_client = file_system_client.get_directory_client(directory_name)
dir_client.create_directory()
file_client = dir_client.get_file_client("nation.csv")

csv_stream = io.BytesIO()
file_client.download_file().readinto(csv_stream)
csv_stream.seek(0)
df5 = pd.read_csv(csv_stream, delimiter='|', header='infer')
df5.where(df5['N_NAME'] == 'BRAZIL', inplace = True)
excel_stream = io.BytesIO()

dir_client_save = file_system_client.get_directory_client("test-python-output")
dir_client_save.create_directory()
file_client_save = dir_client_save.create_file("Brazil_description.xlsx")


with pd.ExcelWriter(excel_stream, engine = 'xlsxwriter') as writer:
    df5.to_excel(writer, sheet_name = "Sheet1", index = False)
    writer.save()

file_client_save.append_data(data=excel_stream.getvalue(), offset=0, length=len(excel_stream.getvalue()))
file_client_save.flush_data(len(excel_stream.getvalue()))

