# Params
$serverInstance = "WIN2016"
$databaseName = "Northwind"
$backupDir = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup'
$gitRoot = 'C:\git\tdm-demos'
$restoreDb = "${databaseName}_FullRestore"
$subsetDb = "${databaseName}_Subset"

# Importing dbatools (we'll use this for a bunch of stuff)
import-module dbatools

# Finding the backup
try {
  Write-Output "Searching for most recent backup for $databaseName database"
  $mostRecentBackup = (Get-ChildItem -Path $backupDir | Where-Object {$_.Name -like "*$databaseName*"} | Sort-Object -Descending -Property LastWriteTime)[0]
}
catch {
  Write-Output "No backupo found. Taking a fresh backup"
  Backup-DbaDatabase -SqlInstance $serverInstance -Database $databaseName
  $mostRecentBackup = (Get-ChildItem -Path $backupDir | Where-Object {$_.Name -like "*$databaseName*"} | Sort-Object -Descending -Property LastWriteTime)[0]
}
$backupPath = "${backupDir}\$mostRecentBackup"
Write-Output "Most recent backup for $databaseName is: $backupPath"

# Restore the backup
Restore-DbaDatabase -SqlInstance $serverInstance -Path "$backupPath" -DatabaseName $restoreDb -DestinationFileSuffix "_FullRestore"

# Create a DBCC clone of the restored DB
$sql = "DBCC CLONEDATABASE ( $restoreDb , $subsetDb ); ALTER DATABASE $subsetDb SET READ_WRITE WITH ROLLBACK IMMEDIATE;"
Invoke-DbaQuery -SqlInstance $serverInstance -Query $sql
          
# Params for subset command
$sourceConnectionString = "server=${serverInstance};database=${restoreDb};Integrated Security=true;TrustServerCertificate=true"
$targetConnectionString = "server=${serverInstance};database=${subsetDb};Integrated Security=true;TrustServerCertificate=true"
$startingTable = "dbo.Orders"
$filterClause = "OrderId < 10260"

# Running subset
subsetter --database-engine=sqlserver --source-connection-string=$sourceConnectionString --target-connection-string=$targetConnectionString --starting-table=$startingTable --filter-clause=$filterClause
         
# Running anonymize
$maskFile = "${gitRoot}\config\masking.json"
$optionsFile = "${gitRoot}\config\options.json"
anonymize mask --database-engine SqlServer --connection-string "Server=${serverInstance}; Database=${subsetDb}; Integrated Security=true; TrustServerCertificate=true" --masking-file $maskFile  --options-file $optionsFile

# Backing up the subset DB
Backup-DbaDatabase -SqlInstance $serverInstance -Database $subsetDb
          
# Delete both restore and subset databases
Remove-DbaDatabase -SqlInstance $serverInstance -Database $subsetDb, $restoreDb -Confirm:$false
