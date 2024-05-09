Import-Module SqlServer

Write-Host "Resetting AdventureWorks_TDM"
Invoke-Sqlcmd -InputFile ".\Database Reset\DBCC_Database_Clone-AdventureWorks.sql" -ServerInstance "WIN2016\"

subsetter.exe `
--database-engine sqlserver `
--source-connection-string "Server=localhost;Database=AdventureWorks;trusted_connection=yes;TrustServerCertificate=yes" `
--target-connection-string "Server=localhost;Database=AdventureWorks_TDM;trusted_connection=yes;TrustServerCertificate=yes" `
--target-database-write-mode Overwrite `
--config-file="./Subsetter/TargetSize.yaml"