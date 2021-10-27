<#
.SYNOPSIS
  Get an overview of all logged on client systems 
.DESCRIPTION
  Export an overview of all client systems to a CSV.

  When this is run for several days, the CSV has to be filtered for unique clientName entries with powershell.

  Get unique entries with following line:
  Import-Csv .\ClientDataBase.csv | sort clientname -Unique | select clientName,UserFullName,ClientAddress,ClientPlatform,ClientVersion | Export-Csv .\ClientDataBase_Unique.csv

.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  CSV with following data:
  Starttime,UserFullName,clientName,ClientAddress,ClientPlatform,AgentVersion,ClientVersion
.NOTES
  Version:        1.0
  Author:         Bart Tacken
  Creation Date:  13-10-2021
  Purpose/Change: Initial script development
.PREREQUISITES
  Citrix broker module (available on Delivery Controller)

.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
  <Example explanation goes here>
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
[string]$DateStr = (Get-Date).ToString("s").Replace(":","-") # +"_" # Easy sortable date string    
Start-Transcript ('c:\windows\temp\' + $DateStr  + '_Get-CitrixClientOverview.log') -Force # Start logging

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'
Add-PSSnapin Citrix*
#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Any Global Declarations go here
$ExportCSV = "C:\Scripts\Get-CitrixClientOverview\ClientDataBase.csv"
#-----------------------------------------------------------[Execution]------------------------------------------------------------
#Script Execution goes here

$Brokersessions = Get-Brokersession | select *
$Brokersessions | select Starttime,UserFullName,clientName,ClientAddress,ClientPlatform,AgentVersion,ClientVersion | sort Starttime | Export-CSV -Append -Path $ExportCSV -NoTypeInformation
#$Brokersessions | Export-CSV -Append -Path $ExportCSV

$AllUserConnections = Invoke-RestMethod -usedefaultcredential -URI "http://<DLC-FQDN>/Citrix/Monitor/OData/v3/Data/Connections"
$AllUserConnections.content.properties | Group ClientPlatform

Stop-Transcript


