Import-Module SqlServer

$projRoot = "C:\git\tdm-demos\simple-demos"
Write-Output "Project root is: $projRoot"

Write-Host "Resetting AdventureWorks_TDM"
Invoke-Sqlcmd -InputFile "$projRoot\Database Reset\DBCC_Database_Clone-AdventureWorks.sql" -ServerInstance "WIN2016\"

subsetter.exe `
--database-engine sqlserver `
--source-connection-string "Server=localhost;Database=AdventureWorks_Prod;trusted_connection=yes;TrustServerCertificate=yes" `
--target-connection-string "Server=localhost;Database=AdventureWorks_TDM;trusted_connection=yes;TrustServerCertificate=yes" `
--target-database-write-mode Overwrite `
--config-file="$projRoot\Subsetter\Filter.yaml"
