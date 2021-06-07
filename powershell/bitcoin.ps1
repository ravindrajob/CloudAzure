#On rentre les informations de la CLEF API 
 $User = "UserKey"
 $Key = "PasswordKey"
 $Secret = "SecretKey"
 
#On déclare les correspondances des API
$BitcoinValueNowAPI = "https://cex.io/api/last_price/BTC/EUR"
 
#Get powershell version 
$PowershellVersion = $PSVersionTable
 
#On authorise tous les protocoles de connexions 
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
 
$TimeLaps=1
$BarreChargement = 1
 
while ($TimeLaps -le 10)
{                                                                
    $TimeLaps=1
    clear
    if ($BarreChargement -eq 1) { write-host '/' -foreground "DarkCyan"}
    if ($BarreChargement -eq 2) { write-host '--' -foreground "DarkCyan"}
    if ($BarreChargement -eq 3) { write-host '\' -foreground "DarkCyan"}
    if ($BarreChargement -eq 4) { write-host '|' -foreground "DarkCyan"}
    if ($BarreChargement -eq 5) { write-host '-' -foreground "DarkCyan"}
    if ($BarreChargement -eq 6) { write-host '|' -foreground "DarkCyan"
    #on reset la barre de chargement
    $BarreChargement = 1
}
  #On incrémente la barre de chargement à chaque passage                   
  $BarreChargement++
 
 
#On vérifie le montant du Bitcoin actuel
$BitcoinValueNowResult = Invoke-WebRequest -Uri $BitcoinValueNowAPI -Method GET -TimeoutSec 5 | ConvertFrom-Json | Select lprice
$BitcoinValue = $BitcoinValueNowResult.lprice

$BitcoinValue | get-member


#Comparaison  d'y a une seconde 
if ($BitcoinValue -igt $BitcoinSaved) 
    {   
    #En train de monter :(
    write-host " La valeur du Bitcoin est de $BitcoinValue donc elle monte" -foreground "red" 
    $BitcoinSaved = $BitcoinValue 
    }
 
    else 
    {
    #En train de chuter :)
    write-host " La valeur du Bitcoin est de $BitcoinValue donc elle chute !!" -foreground "green"
    $BitcoinSaved = $BitcoinValue 
    }
 
    sleep 5
    }    
 
 
#Ce dont on a besoin
 
write-host "Taux actuel :"
write-host "Meilleur taux du mois :"
write-host "Meilleur taux de la journée :"
write-host "Meilleur taux de l'heure :"
 
 
#On rentre la valeur du Bitcoin actuelle
#Comparaison de la valeur par rapport à 1 semaine
#Envoi d'un SMS sur la GW SMS pour alerter les traders de la baisse
