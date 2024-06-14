@echo off
::cls

set databaseType=SqlServer
set connectionString="Server=localhost;Database=DMDatabase_Dev;trusted_connection=yes;TrustServerCertificate=yes;"

::set databaseType=Oracle
::set connectionString="DATA SOURCE=localhost/FREEPDB1;PASSWORD=P455w07d;USER ID=CO;"

::set databaseType=MySql
::set connectionString="Server=localhost;User ID=root;Password=P455w07d;Database=sakila;"

::set databaseType=postgres
::set connectionString="host=localhost;User ID=postgres;Password=postgres;Database=paglia3;"

echo End-to-End TDM
echo    %databaseType%
echo    %connectionString%
echo.
echo.

echo Classifying...
Anonymize.exe classify --database-engine %databaseType% --connection-string %connectionString% --classification-file classification.json --output-all-columns
echo.

echo Mapping...
Anonymize.exe map --classification-file classification.json --masking-file masking.json
echo.

echo Masking...
Anonymize.exe mask --database-engine %databaseType% --connection-string %connectionString% --masking-file masking.json --options-file anonymizeconfig.json
echo.

pause
