$ErrorActionPreference = 'Stop'
          
# Authenticating against cloning cluster
Write-Output "Authenticating against the cloning cluster with token $env:RGCLONE_ACCESS_TOKEN"
rgclone auth -t $env:RGCLONE_ACCESS_TOKEN

# Reducing duplication with vars
$containerName = "my-container"
$oldName = "$containerName-old"
$deletingName = "$containerName-deleting"
$newName = "$containerName-new"
$currentName = "$containerName-current"

# Set any old containers to lifetime of 1m (fast delete)
Write-Output "If exists, renaming $oldName container to $deletingName, and setting lifetime to 1m"
rgclone update dc $oldName -n $deletingName
if ($lastExitCode -eq 0){
  rgclone update dc $deletingName -t 1m
}

# Create a new data container
Write-Output "Creating new data container, with name $newName"
rgclone create dc -i empty-sql-current -n $newName

# Name swap (near zero downtime)
Write-Output "Name swapping $currentName > $oldName"
rgclone update dc $currentName -n $oldName

Write-Output "Name swapping $newName > $currentName"
rgclone update dc $newName -n $currentName

