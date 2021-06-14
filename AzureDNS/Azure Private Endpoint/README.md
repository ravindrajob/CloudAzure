### Azure private and legagy
In our case, we want resolve azure private FQDN with Azure DNS, and resolve my legacy fqdn with my private DNS server. 

Actually is not possible to use azure dns to forward to legacy dns.
More information on Azure private dns and this limit here : https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns

## Quota & Limit
DNS forwarding also enables DNS resolution between virtual networks, and allows your on-premises machines to resolve Azure-provided host names. In order to resolve a VM's host name, the DNS server VM must reside in the same virtual network, and be configured to forward host name queries to Azure

Actualy the number of DNS queries a virtual machine can send to Azure DNS resolver: 1000 /sec
more information here : https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits
## Configuration
To configure properly, we need :

- On-premises network
- Virtual network connected to on-premises (expressroute or VPN)
- Peered virtual network 
- DNS forwarder (like unbound or Bind)
- Private DNS zones like a azure.ravindra-job.com with type A record

The following diagram shows the DNS resolution for both networks, on-premises and virtual networks

# High level diagram
![alt text](https://ravindrajob.blob.core.windows.net/assets/FW-AzureDNS2Legacy-HL2.png)

# Infrastructure level diagram
![alt text](https://ravindrajob.blob.core.windows.net/assets/FW-AzureDNS2Legacy-LL.png)

Information : DNS forwarder is responsible for resolving all the DNS queries via a server-level forwarder to the Azure-provided DNS service 168.63.129.16.
