<#
.SYNOPSIS
!powershell
...Date: 14/10/2021
...Update: 04/01/2021
..Titre: Scan LB public IP
.Auteur:  Ravindra JOB
.Source: https://github.com/ravindrajob/Cloud-Azure

.DESCRIPTION
Scan LB4 Public IP

.NOTES
...Date: 
#>

#on récupère les credentials du Workspace
$WorkspaceCredential = Get-AutomationPSCredential -Name 'WorkspaceCredential'
$CustomerId = $WorkspaceCredential.UserName
$securePassword = $WorkspaceCredential.Password
$SharedKey = $WorkspaceCredential.GetNetworkCredential().Password
 
#On récupère la date
$TimeStampField = get-date
$TimeStampField = $TimeStampField.GetDateTimeFormats(115)

Function Azure-Connect
{
  ### Connection throw automation
  $connection = Get-AutomationConnection -Name 'audit-rssi'

  Connect-AzAccount -ServicePrincipal `
                  -Tenant $connection.TenantId `
                  -ApplicationId $connection.ApplicationID  `
                  -CertificateThumbprint $connection.CertificateThumbprint
}

### Connect to Azure
Azure-Connect
$Subscriptions = Get-AzSubscription
$LogType = "ScanAzurePublicLB"

ForEach ($Subscription in $Subscriptions)
{
    $NoOutput = Select-AzSubscription $Subscription.Name
    Write-Output $Subscription.Name
    Set-AzContext $Subscription
    $Context = Get-AzContext
    $RGs = Get-AzResourceGroup -DefaultProfile $Context

    ForEach ($RG in $RGs)
    {
    Write-Output $RG.ResourceGroupName
    Set-AzContext $Subscription
    $PLBS = Get-AzLoadBalancer -ResourceGroupName $RG.ResourceGroupName            
    
    ForEach ($PLB in $PLBS)
    {
    If ($PLB.FrontendIpConfigurations[0].PublicIpAddress -ne $null)
    {
        $Object = New-Object System.Object
        $Object | Add-Member -MemberType NoteProperty -Name "Subscription" -Value $Subscription.Name
        $Object | Add-Member -MemberType NoteProperty -Name "LoadBalancerName" -Value $PLB.Name
        $Object | Add-Member -MemberType NoteProperty -Name "ResourceGroupName" -Value $RG.ResourceGroupName
        
        $jobj = New-Object System.Object
        $jobj | add-member -Name "data" -value $Object -MemberType NoteProperty
        $JsonSchema = @($jobj)
        $JsonSchemaReady = (ConvertTo-Json $JsonSchema)

        Send-OMSAPIIngestionFile -customerId $CustomerId -sharedKey $SharedKey -body $JsonSchemaReady -logType $LogType -TimeStampField $TimeStampField
        Write-Output "JSON :"
        Write-Output "$JsonSchemaReady"
        Clear-Variable -Name "JsonSchemaReady"
        Clear-Variable -Name "jobj"
        Clear-Variable -Name "Object"
    }
    }
    }
    
}