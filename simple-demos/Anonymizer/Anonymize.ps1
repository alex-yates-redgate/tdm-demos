$databaseType = 'SqlServer'
$connectionString = 'Server=localhost;Database=AdventureWorks_TDM;trusted_connection=yes;TrustServerCertificate=yes;'
$projRoot = "C:\git\tdm-demos\simple-demos\Anonymizer"

Write-Host "End-to-End TDM CLI"
Write-Host "Database Type is - $databaseType"
Write-Host "Connection String is - $connectionString"
Write-Host "Project Root is - $projRoot"

Write-Host "Classifying..."
Anonymize.exe classify --database-engine $databaseType --connection-string $connectionString --classification-file "$projRoot\classification.json" --output-all-columns

Write-Host "Mapping..."
Anonymize.exe map --classification-file "$projRoot\classification.json" --masking-file "$projRoot\masking.json"

Write-Host "Masking..."
Anonymize.exe mask --database-engine $databaseType --connection-string $connectionString --masking-file "$projRoot\masking.json" --options-file "$projRoot\anonymizeconfig.json"
