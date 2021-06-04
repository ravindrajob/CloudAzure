<#
.SYNOPSIS
!powershell
...Date: 14/02/2021
...Update: 04/06/2021
..Titre: Scan VNET peering
.Auteur:  Ravindra JOB
.Source: https://github.com/ravindrajob/Cloud-Azure

.DESCRIPTION
Scan des peering de toutes les subscriptions que l'appsregistration à accès

.NOTES
...Date: 
#>

#on récupère les credentials du Workspace
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
  $connection = Get-AutomationConnection -Name 'YourCredentialName'

  Connect-AzAccount -ServicePrincipal `
                  -Tenant $connection.TenantId `
                  -ApplicationId $connection.ApplicationID  `
                  -CertificateThumbprint $connection.CertificateThumbprint
}


### Connect to Azure
Azure-Connect

$TimeStampField = get-date
$TimeStampField = $TimeStampField.GetDateTimeFormats(115)

$Quotas = @()
$LogType="VnetPeeringTest" 

$Subscriptions = Get-AzSubscription
foreach ($sub in $Subscriptions) 
{
Select-AzSubscription -SubscriptionId $sub.Id
 write-output "Sub en cours $sub.name $sub.Id "   
#$CurrentSubName = (Get-AzContext).Subscription.Name

    $RGs = Get-AzResourceGroup
    foreach ($rg in $RGs.ResourceGroupName)
    {
        $vnets = Get-AzVirtualNetwork -ResourceGroupName $rg 
        foreach ($vnet in $vnets) 
        {
            write-output "VNET en cours $vnet.name "                
            $QuotaObj = New-Object System.Object
            $QuotaObj | Add-Member -MemberType NoteProperty -Name "VirtualNetwork" -Value $vnet.name
            $QuotaObj | Add-Member -MemberType NoteProperty -Name "Peeringdetected" -Value $vnets.length
            $Succeeded = 0
            foreach ($peering in $vnets.ProvisioningState) 
                    {
                     If ($peering -eq 'Succeeded')
                     {                                       
                      $Succeeded ++
                     }
                    }

            $QuotaObj | Add-Member -MemberType NoteProperty -Name "ProvisioningState" -Value $Succeeded
            $PeeringStateSucceeded = 0
            foreach ($PeeringState in $vnets.PeeringState) 
                    {
                     If ($PeeringState -eq 'Succeeded')
                     {                                       
                      $PeeringStateSucceeded ++
                     }
                    }

            $QuotaObj | Add-Member -MemberType NoteProperty -Name "PeeringState" -Value $PeeringStateSucceeded
            $QuotaObj | Add-Member -MemberType NoteProperty -Name "SubscriptionName" -Value $sub.Name
            $QuotaObj | Add-Member -MemberType NoteProperty -Name "SubscriptionId" -Value $sub.Id
            $QuotaObj | Add-Member -MemberType NoteProperty -Name "ResourceGroupe" -Value $rg
            $QuotaObj | Add-Member -MemberType NoteProperty -Name "Timestamp" -Value $TimeStampField[0]
            $Quotas += $QuotaObj
    
            $JsonSchemaReady = (ConvertTo-Json $QuotaObj)
            Send-OMSAPIIngestionFile -customerId $CustomerId -sharedKey $SharedKey -body $JsonSchemaReady -logType $LogType -TimeStampField $TimeStampField
            

        }

    }
    
}
 
