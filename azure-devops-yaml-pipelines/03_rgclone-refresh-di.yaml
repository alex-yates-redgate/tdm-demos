name: redgate-rgclone-image-example
 
schedules:
- cron: 0 0 * * SAT # cron syntax for 12am on Saturday morning
  branches:
    include: 
    - main
  displayName: 12am on Saturday # friendly name given to a specific schedule

trigger: none

variables:
- group: rgclone

stages:
  - stage: RefreshImage  
    displayName: Refresh existing rgclone data-image
    jobs:
    - job: RefreshImage
      displayName: Refresh existing rgclone data-image

      steps:
      - powershell: |
          $ErrorActionPreference = 'Stop'

          # Authenticating against cloning cluster
          Write-Output "Authenticating against the cloning cluster"
          rgclone auth -t $env:RGCLONE_ACCESS_TOKEN
          if ($lastExitCode -ne 0){
            echo "##vso[task.logissue type=error]Failed to authenticate against cloning cluster"
            exit 1
          }

          # Reducing duplication with vars
          $imageName = "empty-sql"
          $oldName = "$imageName-old"
          $deletingName = "$imageName-deleting"
          $newName = "$imageName-new"
          $currentName = "$imageName-current"

          # Set any old image to lifetime of 1m (fast delete)
          Write-Output "If exists, renaming $oldName image to $deletingName, and setting lifetime to 1m"
          rgclone update di $oldName -n $deletingName
          if ($lastExitCode -eq 0){
            rgclone update di $deletingName -t 1m
            if ($lastExitCode -ne 0){
              echo "##vso[task.logissue type=error]No image found called $deletingName"
              exit 1
            }
          }
          else {
            echo "##vso[task.logissue type=warning]No image found called $oldName"
          }

          # Create a new data image
          Write-Output "Creating new data image, with name $newName"
          rgclone create di -f config\empty-sql.yaml -n $newName
          if ($lastExitCode -ne 0){
            echo "##vso[task.logissue type=error]Failed to create image with name $newName"
            exit 1
          }

          # Name swap (near zero downtime)
          Write-Output "Name swapping $currentName > $oldName"
          rgclone update di $currentName -n $oldName
          if ($lastExitCode -ne 0){
            echo "##vso[task.logissue type=warning]Failed to rename $currentName to $oldName"
          }
          Write-Output "Name swapping $newName > $currentName"
          rgclone update di $newName -n $currentName
          if ($lastExitCode -ne 0){
            echo "##vso[task.logissue type=error]Failed to rename $newName to $currentName"
            exit 1
          } 
        env:
          RGCLONE_ACCESS_TOKEN: $(RGCLONE_ACCESS_TOKEN)
        displayName: 'Refresh rgclone data image'
