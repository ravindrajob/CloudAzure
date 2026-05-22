<!--
################################################################
# Titre: Azure Automation README
# Description : Documentation for Azure Automation scripts and architecture
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 12/10/2025 [v1.1 | RJ] Maintenance & Branding update
################################################################
-->

# Structure
In our case, we used the following architecture to collect data and trigger alerts

Workers --> DataBase --> Restitution & Alerting --> Notification

### Result with Azure components:

![alt text](https://ravindrajob.blob.core.windows.net/assets/diagram01.png)
## Dependencies

### Don't forget to add the OMSIngestionAPI library in your Az automation  : 
![alt text](https://ravindrajob.blob.core.windows.net/assets/LibrairyOMS.png)
