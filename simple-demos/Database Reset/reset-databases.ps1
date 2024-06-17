Import-Module SqlServer

$projRoot = "C:\git\tdm-demos\simple-demos"
Write-Output "Project root is: $projRoot"

Write-Host "Resetting AdventureWorks_TDM"
Invoke-Sqlcmd -InputFile "$projRoot\Database Reset\DBCC_Database_Clone-AdventureWorks.sql" -ServerInstance "WIN2016\"
