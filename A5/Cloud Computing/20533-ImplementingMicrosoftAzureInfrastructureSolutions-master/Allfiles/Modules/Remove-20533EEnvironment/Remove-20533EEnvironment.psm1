Function Remove-20533EEnvironment
# Remove 20533E resource groups

{
    # We want to see any errors...
    $ErrorActionPreference='Continue'

    # Store the start time
    $startTime = Get-Date

    Add-AzureRmAccount

    # Select the target subscription    
    Select-20533ESubscriptionARM

    $subscriptionName = (Get-AzureRmSubscription -SubscriptionId $20533EsubscriptionIdGlobal -ErrorAction SilentlyContinue).Name
    If (!($subscriptionName)) {
        $subscriptionName = (Get-AzureRmSubscription -SubscriptionId $20533EsubscriptionIdGlobal -ErrorAction SilentlyContinue).SubscriptionName
    }

    if (!($20533ElabNumberGlobal)) {
        Do {
            Write-Host -NoNewline "Which lab environment do you want to remove? Type a number from 1 - 11:   " -ForegroundColor Magenta
            $labNumber = Read-Host 
        } While ((1..11) -notcontains $labNumber)

        $global:20533ElabNumberGlobal = $labNumber
    }
    Do {
        # Confirm with user before proceeding
        $labNumberTwoDigit = ([int]$20533ElabNumberGlobal).ToString("00")
        Write-Host "This script will remove 20533E lab $20533ElabNumberGlobal environment from the subscription $subscriptionName" -ForegroundColor Magenta
        Write-Host "The script deletes all resource groups with names starting with 20533E$labNumberTwoDigit and their resources" -ForegroundColor Magenta 
        Write-Host "To remove 20533E environment for a different lab, press D when prompted " -ForegroundColor Magenta 
        Write-Host "Do you want to proceed? Y/N/D?: "  -ForegroundColor Magenta
        $answer = read-host
        Switch ($answer)
        {
            Y {Write-Host "Deleting all objects..." -ForegroundColor Yellow}
            N {Write-Host "Terminating the script..."; Start-Sleep -Seconds 2; Return }
            D {# Get the lab number
                Write-Host
                Do {
                    Write-Host -NoNewline "Which lab environment do you want to remove? Type a number from 1 - 11:   " -ForegroundColor Magenta
                    $labNumber = Read-Host 
                } While ((1..11) -notcontains $labNumber)
                $global:20533ElabNumberGlobal = $labNumber
                $labNumberTwoDigit = ([int]$20533ElabNumberGlobal).ToString("00")
                continue
            }  
            Default {continue}
        }
    } While ($answer -notmatch "[YN]")

    $rootPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName
    $transcriptPath = ""
    If ($20533ElabNumberGlobal) {
        $transcriptPath = Join-Path -Path $rootPath -ChildPath "Logs\Remove-20533EEnvironment-$20533ElabNumberGlobal.log"
    } else {
        $transcriptPath = Join-Path -Path $rootPath -ChildPath "Logs\Remove-20533EEnvironment-0.log"
    }
    Start-Transcript -Path $transcriptPath -IncludeInvocationHeader -Append -Force

    foreach ($resourceGroupName in (Get-AzureRMResourceGroup).ResourceGroupName) {
        if ($resourceGroupName -like "20533E$labNumberTwoDigit*") {
             Write-Host "Deleting $resourceGroupName resource group..."
             Remove-AzureRMResourceGroup -Name $resourceGroupName -Force -InformationAction SilentlyContinue
        }
    }

    # Display time taken for script to complete
    $endTime = Get-Date

    Write-Host "Started at $startTime" -ForegroundColor Magenta
    Write-Host "Ended at $endTime" -ForegroundColor Yellow
    Write-Host

    $elapsedTime = $endTime - $startTime

    If ($elapsedTime.Hours -ne 0){
        Write-Host "Total elapsed time is $($elapsedTime.Hours) hours $($elapsedTime.Minutes) minutes" -ForegroundColor Green
    } else {

        Write-Host "Total elapsed time is $($elapsedTime.Minutes) minutes" -ForegroundColor Green
    }

    Remove-Variable -Name 20533ElabNumberGlobal -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable -Name 20533EsubscriptionIdGlobal -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable -Name 20533ElocationGlobal -Scope Global -ErrorAction SilentlyContinue
    
    Write-Host
    Stop-Transcript
}
