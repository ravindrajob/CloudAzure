<#
.SYNOPSIS
!powershell
...Date: 12/01/2019
..Titre: Scan AppRegistration for expiration
.Auteur: Ravindra JOB
.Source: https://github.com/ravindrajob/CloudAzure

.DESCRIPTION
Scan AppRegistration for a expiration and store the result in a Azure logs analytics

.NOTES
...Update: 22/01/2020 [RJ]

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
  $connection = Get-AutomationConnection -Name 'NameOfAppsRegistration'

  Connect-AzAccount -ServicePrincipal `
                  -Tenant $connection.TenantId `
                  -ApplicationId $connection.ApplicationID  `
                  -CertificateThumbprint $connection.CertificateThumbprint
}

### Connect to Azure
Azure-Connect
$TimeStampField = get-date
$TimeStampField = $TimeStampField.GetDateTimeFormats(115)
$LogType="AppsRegistrationAudittest"
$apps = Get-AzADApplication

#In my case i want to scan only a specific appsregistration
$OurAppRegistration = @('rj-fr-','rj-dev-')


foreach ($app in $apps) 
    { 
     $Name = $app.DisplayName
     #write-output "Scan de $Name vs $OurAppRegistration"
     
     if ($OurAppRegistration | ForEach-Object {If ($Name.toLower().Contains($_.toLower())) {$True}})

       {   
            write-output "Scan en cours sur $Name"
            $secrets = Get-AzADAppCredential -ObjectId $app.ObjectId

            if ($null -eq $secrets){}
            else 
            {  
                foreach ($secret in $secrets) 
                { 
                 #$AppsRegistrations = @()                 
                 $AppsRegObj = New-Object System.Object
                 $AppsRegObj | Add-Member -MemberType NoteProperty -Name "StartDate" -Value $secret.StartDate   
                 $AppsRegObj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $Name   
                 $AppsRegObj | Add-Member -MemberType NoteProperty -Name "EndDate" -Value $secret.EndDate   
                 $AppsRegObj | Add-Member -MemberType NoteProperty -Name "id" -Value $app.ObjectId 
                 #$AppsRegObj | Add-Member -MemberType NoteProperty -Name "TimeStampField" -Value $TimeStampField[0] 
                 Get-Date -Date $secret.EndDate  -UFormat %s
                 $AppsRegObj | Add-Member -MemberType NoteProperty -Name "timestampunix" -Value $secret.EndDate  
                      
                #write-output "On affiche l'object :"
                #write-output "$AppsRegObj"

                #write-output "On affiche le JSON :"
                #write-output "$JsonSchemaReady"
                
                #$AppsRegistrations += $AppsRegObj
                $JsonSchemaReady = (ConvertTo-Json $AppsRegObj)      
                Send-OMSAPIIngestionFile -customerId $CustomerId -sharedKey $SharedKey -body $JsonSchemaReady -logType $LogType -TimeStampField $TimeStampField
                }
            }
        }

     }

              



