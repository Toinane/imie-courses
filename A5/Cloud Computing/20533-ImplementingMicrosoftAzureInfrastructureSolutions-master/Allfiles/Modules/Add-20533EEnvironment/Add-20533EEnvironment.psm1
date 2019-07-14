Function Add-20533EEnvironment
# Prepare for demos and labs at the beginning of each module

{

    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {
 	    Write-Warning "You do not have Administrator rights to run this script!`nMake sure to launch Windows PowerShell as Administrator!"
        Break
    }

    $rootPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName
    Get-ChildItem -Path $rootPath -Recurse -File | Unblock-File

    # Variables
    $labInfoPath = Join-Path -Path $rootPath -ChildPath 'Configfiles\LabInfo.txt'

    # Get the lab number
    Write-Host
    Do {
        Write-Host -NoNewline "Which lab do you want to set up? Type a number from 1 - 11:   " -ForegroundColor Magenta
        $labNumber = Read-Host 
    } While ((1..11) -notcontains $labNumber)

    Write-Host
    Write-Host "The lab you want to set up is: Lab" $labNumber -ForegroundColor Green
    Write-Host

    # Display information about the setup steps
    Get-Content $labInfoPath | Select-Object -Index $($labNumber - 1)

    Do {
        # Confirm with user before proceeding
        Write-Host -NoNewline "Do you want to proceed? Y/N?:   "  -ForegroundColor Magenta
        $answer = Read-Host

        Switch ($answer)
        {
            Y { Write-Host "The lab to set up is: Lab" $labNumber -ForegroundColor Yellow }
            N { Return }
            Default {continue}
        }
    } While ($answer -notmatch "[YN]")

    $transcriptPath = Join-Path -Path $rootPath -ChildPath "Logs\New-20533EEnvironment-$labNumber.log"
    Start-Transcript -Path $transcriptPath  -IncludeInvocationHeader -Append -Force

    Write-Host
    Write-Host "Now setting up Lab $labNumber" -ForegroundColor White

    # Store the start time
    $startTime = Get-Date

    $global:20533ElabNumberGlobal = $labNumber
    $labNumberTwoDigit = ([int]$global:20533ElabNumberGlobal).ToString("00")
    $labFilesPath = Join-Path -Path $rootPath -ChildPath 'Labfiles'

    # Select the setup steps required for this lab
    Switch ($labNumber)
    {
        1 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM}
        2 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM; Set-20533EVMSize;
           Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)01-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 0 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeployvm1.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -vmSize "$global:20533EvmSizeGlobal"';
           Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)02-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 0 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeployvm2.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -vmSize "$global:20533EvmSizeGlobal"';
          }
        3 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM}
        4 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM; Set-20533EVMSize;
           Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)01-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 0 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeployfrontendvms.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -vmSize "$global:20533EvmSizeGlobal"';
           Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)01-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 0 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploybackendvm.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -vmSize "$global:20533EvmSizeGlobal"';
          }
        5 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM}
        6 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM; Set-20533EVMSize;
           Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)01-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 0 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -vmSize "$global:20533EvmSizeGlobal"';
          }  
        7 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM; Set-20533EVMSize;
           Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)01-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 0 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -vmSize "$global:20533EvmSizeGlobal"';
          }
        8 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM; Set-20533EVMSize;
           Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)01-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 0 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -vmSize "$global:20533EvmSizeGlobal"';
          }
        9 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM}
        10 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM; Set-20533EVMSize;
            Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)01-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 1 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -ArtifactStagingDirectoryPath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\bin\Debug\staging" -DSCSourceFolderPath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\DSC" -nestedTemplatesPath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\nestedtemplates" -vmSize "$global:20533EvmSizeGlobal"';
         } 
        11 {Add-AzureRmAccount; Select-20533ESubscriptionARM; Select-20533ELocationARM; Set-20533EVMSize;
            Invoke-Expression -Command 'Set-20533EEnvironment -resourceGroupName "20533E$($labNumberTwoDigit)01-LabRG" -resourceGroupLocation "$global:20533ElocationGlobal" -uploadArtifacts 0 -templateFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.json" -templateParametersFilePath "$labFilesPath\Lab$LabNumberTwoDigit\Starter\Templates\azuredeploy.parameters.json" -vmSize "$global:20533EvmSizeGlobal"';
         }
    }

    # Write status message
    Write-Host
    Write-Host "Lab $labNumber setup is complete" -ForegroundColor Green

    # Display time it took for the script to complete
    $endTime = Get-Date
    Write-Host "Started at $startTime" -ForegroundColor Magenta
    Write-Host "Ended at $endTime" -ForegroundColor Yellow
    Write-Host " "
    $elapsedTime = $endTime - $startTime

    If ($elapsedTime.Hours -gt 0){
        Write-Host Total elapsed time is $elapsedTime.Hours hours $elapsedTime.Minutes minutes -ForegroundColor Green
    }
    Else {
        Write-Host Total elapsed time is $elapsedTime.Minutes minutes -ForegroundColor Green
    }
    Write-Host " "

    Try {
        Stop-Transcript
    }
    Catch {}

}
