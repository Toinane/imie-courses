Function Select-20533ELocationARM
#Get the list of available Azure regions

{

    $subscriptionName = (Get-AzureRmSubscription -SubscriptionId $20533EsubscriptionIdGlobal).Name
    If (!($subscriptionName)) {
        $subscriptionName = (Get-AzureRmSubscription -SubscriptionId $20533EsubscriptionIdGlobal).SubscriptionName
    }

    If ($subscriptionName -eq 'Azure Pass') {
        $locations = @("East US", "South Central US", "West Central US", "West US 2", "West Europe", "Southeast Asia")
    } else {
        $locations = (Get-AzureRmLocation).Location
    }

    $locationHashTable = [ordered]@{}
    $counter = 0
    foreach ($location in $locations) {
        $counter++
        $locationHashTable.Add($counter, $location)
    }

    #Display the list, and ask for the index number
    foreach ($key in $locationHashTable.Keys) {
        Write-Host "$key    $($locationHashTable[$key-1])"
    }
    Do {
        Write-Host
        Write-Host "Enter the number corresponding to the Azure region you want to use: " -ForegroundColor Magenta
        try {
            $locationSet = $true
            [int]$locationNumber = Read-Host
        }
        catch {
            $locationSet =  $false
        }
    } Until ($locationNumber -and ($locationNumber -ge 1) -and ($locationNumber -le $counter))
    
    #Display the chosen location
    $global:20533ElocationGlobal = $locationHashTable[$locationNumber-1]
    Write-Host "Your Azure region is: " $global:20533ElocationGlobal -ForegroundColor Green

}