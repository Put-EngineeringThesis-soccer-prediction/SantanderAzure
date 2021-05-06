import os
import sys
from azure.common.client_factory import get_client_from_auth_file
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.containerinstance import ContainerInstanceManagementClient
from azure.mgmt.containerinstance.models import (ContainerGroup,
                                                 Container,
                                                 ContainerGroupNetworkProtocol,
                                                 ContainerGroupRestartPolicy,
                                                 ContainerPort,
                                                 EnvironmentVariable,
                                                 IpAddress,
                                                 Port,
                                                 ResourceRequests,
                                                 ResourceRequirements,
                                                 OperatingSystemTypes)

# Retrieve the IDs and secret to use with ClientSecretCredential
arguments = sys.argv[1:]
script_to_run = arguments[0]
container_name = arguments[1]
resource_group_name = arguments[2]
os.system(f"py {script_to_run}")

auth_file_path = os.getenv('AZURE_AUTH_LOCATION', None)
print(auth_file_path)
if auth_file_path is not None:
    print("Authenticating with Azure using credentials in file at {0}"
          .format(auth_file_path))

    aci_client = get_client_from_auth_file(
        ContainerInstanceManagementClient)
    res_client = get_client_from_auth_file(ResourceManagementClient)
else:
    print("\nFailed to authenticate to Azure. Have you set the")

aci_client.container_groups.delete(resource_group_name, container_name)