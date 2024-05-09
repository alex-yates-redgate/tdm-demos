$databaseType = 'SqlServer'
$connectionString = 'Server=localhost;Database=AdventureWorks_TDM;trusted_connection=yes;TrustServerCertificate=yes;'

Write-Host "End-to-End TDM CLI"
Write-Host "Database Type is - $databaseType"
Write-Host "Connection String is - $connectionString"

Import-Module SqlServer

Write-Host "Resetting AdventureWorks_TDM"
Invoke-Sqlcmd -InputFile ".\1. Database Creation\DBCC_Database_Clone-AdventureWorks.sql" -ServerInstance "WIN2016\"

Write-Host "Classifying..."
Anonymize.exe classify --database-engine $databaseType --connection-string $connectionString --classification-file classification.json --output-all-columns

Write-Host "Mapping..."
Anonymize.exe map --classification-file classification.json --masking-file masking.json

Write-Host "Masking..."
Anonymize.exe mask --database-engine $databaseType --connection-string $connectionString --masking-file masking.json --options-file .\Anonymizer\anonymizeconfig.json