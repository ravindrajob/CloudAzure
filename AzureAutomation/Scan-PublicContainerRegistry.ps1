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
$LogType = "PublicContainerRegistry"

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
        $PublicContainerS = Get-AzContainerRegistry -ResourceGroupName $RG.ResourceGroupName            
        ForEach ($PublicContainer in $PublicContainerS)
            {
                If ($PublicContainer.NetworkRuleSet.DefaultAction -eq "Allow")
                {
                    $NewObject = New-Object System.Object
                    
                    $NewObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $PublicContainer.Name
                    $NewObject | Add-Member -MemberType NoteProperty -Name "ResourceGroup" -Value $RG.ResourceGroupName
                    $NewObject | Add-Member -MemberType NoteProperty -Name "Subscription" -Value $Subscription.Name

                    $object = New-Object System.Object
                    $object | add-member -Name "data" -value $NewObject -MemberType NoteProperty
                    $JsonStructur = @($object)
                    $JsonStructurReady = (ConvertTo-Json $JsonStructur)

                    Set-AzContext $MonitorContext
                    Send-OMSAPIIngestionFile -customerId $CustomerId -sharedKey $SharedKey -body $JsonStructurReady -logType $LogType -TimeStampField $TimeStampField

                    Write-Output "JSON :"
                    Write-Output "$JsonStructurReady"

                    Clear-Variable -Name "JsonStructurReady"
                    Clear-Variable -Name "object"
                    Clear-Variable -Name "NewObject"
                }
            }
        }
}