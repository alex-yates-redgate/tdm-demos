import-module dbatools
$sql = "C:\git\tdm-demos\simple-demos\Database Reset\DBCC_Database_Clone-AdventureWorks.sql"

Invoke-DbaQuery -SqlInstance WIN2016 -File $sql
