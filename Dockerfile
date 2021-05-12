FROM python:3.7

COPY requirements.txt .
COPY my.azureauth .

RUN apt-get update && \
    apt-get upgrade -y

# Install git
RUN apt-get install -y git

# Needed for pyodbc
RUN apt-get install -y unixodbc-dev

# Install libraries from requirements file
RUN pip install -r requirements.txt

# Install libraries for interacting with Azure
RUN pip install xlsxwriter azure-storage-file-datalake azure-mgmt azure-common

# Install ODBC 17
RUN apt-get install sudo
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN sudo apt-get update
RUN sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Clone the repository with scripts
RUN git clone https://github.com/Put-EngineeringThesis-soccer-prediction/SantanderAzure
