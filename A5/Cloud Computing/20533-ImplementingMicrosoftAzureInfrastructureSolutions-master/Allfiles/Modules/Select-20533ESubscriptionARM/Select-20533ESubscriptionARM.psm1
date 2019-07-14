Function Select-20533ESubscriptionARM
# Select the target subscription (Azure Resource Manager)

{

    $subs = Get-AzureRmSubscription

    #Check the number of subscriptions associated with the current account  

    if($subs.Count -eq 0)
    {
        Write-Host "No subscriptions found. Sign in with an account that is associated with an Azure subscription"
        Return
    }
    elseif($20533EsubscriptionIdGlobal)
    {
        $subscriptionName = (Get-AzureRmSubscription -SubscriptionId $20533EsubscriptionIdGlobal).Name
        If (!($subscriptionName)) {
            $subscriptionName = (Get-AzureRmSubscription -SubscriptionId $20533EsubscriptionIdGlobal).SubscriptionName
        }
        Write-Host "Subscription already selected - using the subscription: $subscriptionName Id: $20533EsubscriptionIdGlobal"
        Set-AzureRmContext -SubscriptionId $20533EsubscriptionIdGlobal
    }
    elseif($subs.Count -gt 1)
    {
        while($true)
        {
            for($i = 1;$i -lt ($subs.Count + 1); $i++)
            {
                if ($subs[$i-1].Id -eq $null) {
                    Write-Host "[$i] - " $subs[$i-1].SubscriptionName "- Id: " $subs[$i-1].SubscriptionId
		        } else {
                    Write-Host "[$i] - " $subs[$i-1].Name "- Id: " $subs[$i-1].Id
                }
            }
            Write-Host 
            $selectedSub = Read-Host -Prompt "Select the Azure subscription" 
            Write-Host 
            [int] $selectedEntry = $null
            if([int32]::TryParse($selectedSub, [ref]$selectedEntry) -eq $true)
            {
                if($selectedEntry -ge 1 -and $selectedEntry -lt ($subs.Count + 1))
                {
                    if ($subs[$selectedEntry - 1].Id -eq $null) {
                        Write-Host "Using the subscription: " $subs[$selectedEntry - 1].SubscriptionName " Id: " `
                                                                                                $subs[$selectedEntry - 1].SubscriptionId
                    	Set-AzureRmContext -SubscriptionId $subs[$selectedEntry - 1].SubscriptionId
		    	        $global:20533EsubscriptionIdGlobal = $subs[$selectedEntry - 1].SubscriptionId
		            } else {
		    	        Write-Host "Using the subscription: " $subs[$selectedEntry - 1].Name " Id: " `
                                                                                                $subs[$selectedEntry - 1].Id
                    	Set-AzureRmContext -SubscriptionId $subs[$selectedEntry - 1].Id 
                        $global:20533EsubscriptionIdGlobal = $subs[$selectedEntry - 1].Id
		            }
                    break               
                }
            }
        }
    }
    else 
    {
        if ($subs[0].Id -eq $null) {
            Write-Host "Using the subscription: " $subs[0].SubscriptionName " Id: " $subs[0].SubscriptionId
            Set-AzureRmContext -SubscriptionId $subs[0].SubscriptionId
            $global:20533EsubscriptionIdGlobal = $subs[0].SubscriptionId
        } else {
            Write-Host "Using the subscription: " $subs[0].Name " Id: " $subs[0].Id
            Set-AzureRmContext -SubscriptionId $subs[0].Id
            $global:20533EsubscriptionIdGlobal = $subs[0].Id
        } 
    }
}
