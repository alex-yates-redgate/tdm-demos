$ErrorActionPreference = 'Stop'

# Params
$gitRoot = 'C:\github\example-tdm-ado-yaml-pipelines'

# Authenticating against cloning cluster
Write-Output "Authenticating against the cloning cluster"
rgclone auth -t $env:RGCLONE_ACCESS_TOKEN

# Reducing duplication with vars
$imageName = "empty-sql"
$oldName = "$imageName-old"
$deletingName = "$imageName-deleting"
$newName = "$imageName-new"
$currentName = "$imageName-current"
$imageYaml = "$gitRoot\config\empty-sql.yaml"

# Set any old image to lifetime of 1m (fast delete)
Write-Output "If exists, renaming $oldName image to $deletingName, and setting lifetime to 1m"
rgclone update di $oldName -n $deletingName
rgclone update di $deletingName -t 1m

# Create a new data image
Write-Output "Creating new data image, with name $newName"
rgclone create di -f $imageYaml -n $newName

# Name swap (near zero downtime)
Write-Output "Name swapping $currentName > $oldName"
rgclone update di $currentName -n $oldName

Write-Output "Name swapping $newName > $currentName"
rgclone update di $newName -n $currentName