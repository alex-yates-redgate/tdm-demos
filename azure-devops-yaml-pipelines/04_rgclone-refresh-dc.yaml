name: redgate-rgclone-container-example
 
schedules:
- cron: 0 0 * * SUN # cron syntax for 12am on Saturday morning
  branches:
    include: 
    - main
  displayName: 12am Sunday # friendly name given to a specific schedule

trigger: none

variables:
- group: rgclone

stages:
  - stage: RefreshDevClone  
    displayName: Refresh existing rgclone data-container
    jobs:
    - job: RefreshDevClone
      displayName: Refresh existing rgclone data-container

      steps:
      - powershell: |
          $ErrorActionPreference = 'Stop'
          
          # Authenticating against cloning cluster
          Write-Output "Authenticating against the cloning cluster with token $env:RGCLONE_ACCESS_TOKEN"
          rgclone auth -t $env:RGCLONE_ACCESS_TOKEN
          if ($lastExitCode -ne 0){
            echo "##vso[task.logissue type=error]Failed to authenticate against cloning cluster"
            exit 1
          }

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
            if ($lastExitCode -ne 0){
              echo "##vso[task.logissue type=error]No container found called $deletingName"
              exit 1
            }
          }
          else {
            echo "##vso[task.logissue type=warning]No container found called $oldName"
          }

          # Create a new data container
          Write-Output "Creating new data container, with name $newName"
          rgclone create dc -i empty-sql-current -n $newName
          if ($lastExitCode -ne 0){
            echo "##vso[task.logissue type=error]Failed to create container with name $newName"
            exit 1
          }

          # Name swap (near zero downtime)
          Write-Output "Name swapping $currentName > $oldName"
          rgclone update dc $currentName -n $oldName
          if ($lastExitCode -ne 0){
            echo "##vso[task.logissue type=warning]Failed to rename $currentName to $oldName"
          }
          Write-Output "Name swapping $newName > $currentName"
          rgclone update dc $newName -n $currentName
          if ($lastExitCode -ne 0){
            echo "##vso[task.logissue type=error]Failed to rename $newName to $currentName"
            exit 1
          } 
        env:
          RGCLONE_ACCESS_TOKEN: $(RGCLONE_ACCESS_TOKEN)
        displayName: 'Refresh rgclone data container'
