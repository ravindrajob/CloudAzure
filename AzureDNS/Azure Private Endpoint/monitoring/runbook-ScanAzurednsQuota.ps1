<#
.SYNOPSIS
!powershell
...Date: 01/05/2020
..Titre: Azure DNS quota
.Auteur: Ravindra JOB
.Source:

.DESCRIPTION
Scan Azure DNS quota and store the result in a LogAnalytics

.NOTES
...Update: 01/09/2020 [RJ]
Alpha version - (json2oms est remplacé par la librairie azure)
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
    $connection = Get-AutomationConnection -Name 'YourAppsRegistration'
    Connect-AzAccount -ServicePrincipal `
                    -Tenant $connection.TenantId `
                    -ApplicationId $connection.ApplicationID  `
                    -CertificateThumbprint $connection.CertificateThumbprint
}


Azure-Connect

### Get all subscription
#$AllSubscription = Get-AzSubscription
#ForEach ($Souscription in $AllSubscription)
 #{
    Write-Output "On travaille sur la Souscription $Souscription"
    $Souscription="XXXXXXXXXXXXXXXXXXX" # Votre subscription ID
    Set-AzContext -Subscription $Souscription
    $AllRg = Get-AzResourceGroup
    Write-Output "Liste des RG  $AllRg.ResourceGroupName"
   
  ForEach ($RG in $AllRg.ResourceGroupName)
    { 
    Write-Output "On travaille sur le RG $RG"
    $PrivateDNSInTheRG=get-azprivatednszone -ResourceGroupName $RG
    $i = 0
    $FinalObj = New-Object System.Object
    while ($i -lt $PrivateDNSInTheRG.Count) 
        {
        $LogType="AzureDNS"
        $AzureDnsConf = New-Object System.Object
        $a = $PrivateDNSInTheRG[$i]
        $j = 0 
        
        while ($j -lt $a.psobject.properties.value.count) 
        {   
            $AzureDnsConf | Add-Member -MemberType NoteProperty -Name $a.psobject.properties.name[$j] -Value $a.psobject.properties.value[$j]                                  
            $j += 1                                
            $jobj = New-Object System.Object
            $jobj | add-member -Name "data" -value $AzureDnsConf -MemberType NoteProperty
            $JsonSchema = @($jobj)
            $JsonSchemaReady = (ConvertTo-Json $JsonSchema )
        } 
        # Send To OMS 
            Send-OMSAPIIngestionFile -customerId $CustomerId -sharedKey $SharedKey -body $JsonSchemaReady -logType $LogType -TimeStampField $TimeStampField
            Write-Output "Le JSON envoye est le suivant :"     
            Write-Output "$JsonSchemaReady"    
                        
        # On reset la variable FinalObj
        Clear-Variable -Name "JsonSchemaReady"            
        # On définit la variable AzureDnsConf comme "object" vu qu'on vient de la réinitaliser 
        $AzureDnsConf = New-Object System.Object

        $i += 1    
        }
    }
            

                  

