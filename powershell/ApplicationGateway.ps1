<#
.SYNOPSIS
!powershell
...Date: 09/03/2019

..Titre: Application gateway scan quotas
.Auteur: Ravindra JOB
.Source:

.DESCRIPTION
Scan les quotas des Application Gateway v1 et envoye vers logs analytics


.NOTES
...Update: 22/08/2020
.... 22/01/2021 - ADD compatibility Application Gateway SKU_V2 in the scan
.... 22/01/2021 - ADD state Application Gateway in the scan
#>

#On récupère les credentials du Workspace
$WorkspaceCredential = Get-AutomationPSCredential -Name 'WorkspaceCredentials'
$CustomerId = $WorkspaceCredential.UserName
$securePassword = $WorkspaceCredential.Password
$SharedKey = $WorkspaceCredential.GetNetworkCredential().Password
 
#On récupère la date
$TimeStampField = get-date
$TimeStampField = $TimeStampField.GetDateTimeFormats(115)

Function Azure-Connect
{
  ### Connection throw automation
  $connection = Get-AutomationConnection -Name 'YourAppsRegistrationName'

  Connect-AzAccount -ServicePrincipal `
                  -Tenant $connection.TenantId `
                  -ApplicationId $connection.ApplicationID  `
                  -CertificateThumbprint $connection.CertificateThumbprint
}

### Connect to Azure
Azure-Connect

$TimeStampField = get-date
$TimeStampField = $TimeStampField.GetDateTimeFormats(115)

#We can do a foreach, but for my need i use this :

$sub1 = "64524345-b0d8-4b2402-554-32fds154249"
$sub2 = "74524345-b0d8-4b2402-554-32fds154249"
$sub3 = "84524345-b0d8-4b2402-554-32fds154249"
$sub4 = "94524345-b0d8-4b2402-554-32fds154249"

$subs = @($sub1,$sub2,$sub3,$sub4)

$subs | ForEach-Object {

    $CurrentSub = $_
    "Subscription en cours est  $CurrentSub"
    Select-AzSubscription -SubscriptionId $CurrentSub
    $CurrentSubName = (Get-AzContext).Subscription.Name
    $rg = "appsgw-rg"
    

    #On récupère la configuration de toutes les Application Gateway
    $AppsGwList= Get-AzApplicationGateway -ResourceGroupName $rg

    #On stocke les noms de toutes les Application Gateway dans notre variable
    $AppsGws = $AppsGwList.name

    #Crée le compteur du scan
    $appsgwtotal = $AppsGwList.Length
    [INT]$CompteurAppsgw = 0

    $Quotas = @()

    $LogType="AppGwQuota" # Nom de la log dans notre workSpace LogAnalytics

    #On regarde dans chaque Application Gateway detectée
    ForEach ($AppsGw in $AppsGws)
    {
        $ArrayListener = New-Object System.Object
        $CompteurAppsgw++

        Write-output " ($CompteurAppsgw sur $appsgwtotal ) ----- Scan de $AppsGw en cours ..."

        # [ On récupère la configuration de l'Application Gateway ]
        $appsGwFullConf = Get-AzApplicationGateway -Name $AppsGw -ResourceGroupName $rg

        $OperationalState = $appsGwFullConf.OperationalState
        $ProvisioningState = $appsGwFullConf.ProvisioningState

        Write-output "Etat operationel est $OperationalState"
        Write-output "Etat du provisonning $ProvisioningState"
        
        Write-output " --- Recuperation des backends en cours ..."
        $appsGwBE = Get-AzApplicationGatewayBackendHealth -Name $AppsGw -ResourceGroupName $rg

        $AppsGwListener = $appsGwFullConf.HttpListeners.Name
        $ListenerCount = $AppsGwListener.Length
        $BackendCount = $appsGwBE.BackendAddressPools.Count
        $AppGwIP = $appsGwFullConf.FrontendIPConfigurations.PrivateIPAddress
        $PipFQDN = ""
        If (!$AppGwIP)
        {
            $pipName = ($appsGwFullConf.FrontendIPConfigurations.PublicIpAddressText | ConvertFrom-Json).Id.split("/")[-1]
            $pipRg = ($appsGwFullConf.FrontendIPConfigurations.PublicIpAddressText | ConvertFrom-Json).Id.split("/")[4]
            $PIP = Get-AzPublicIpAddress -Name $pipName -ResourceGroupName $pipRg
            $AppGwIP = $PIP.IpAddress
            $PipFQDN = $PIP.DnsSettings.Fqdn
        }

        # Post-AppGwIP -AppGwName $AppsGw -IP $AppGwIP
        $QuotaObj = New-Object System.Object
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "AppGwName" -Value $AppsGw
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "OperationalState" -Value $OperationalState
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "ProvisioningState" -Value $ProvisioningState
        # $QuotaObj | Add-Member -MemberType NoteProperty -Name "Subscription" -Value $CurrentSub
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "SubscriptionName" -Value $CurrentSubName
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "SubscriptionId" -Value $CurrentSub
        
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "IPAddress" -Value $AppGwIP
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "PipFQDN" -Value $PipFQDN
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "BackendCount" -Value $BackendCount
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "ListenerCount" -Value $ListenerCount
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "BackendLimit" -Value "100"
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "ListenerLimit" -Value "100"
        $QuotaObj | Add-Member -MemberType NoteProperty -Name "Timestamp" -Value $TimeStampField[0]

        $Quotas += $QuotaObj

        $JsonSchemaReady = (ConvertTo-Json $QuotaObj)
        Send-OMSAPIIngestionFile -customerId $CustomerId -sharedKey $SharedKey -body $JsonSchemaReady -logType $LogType -TimeStampField $TimeStampField
    }  
}
