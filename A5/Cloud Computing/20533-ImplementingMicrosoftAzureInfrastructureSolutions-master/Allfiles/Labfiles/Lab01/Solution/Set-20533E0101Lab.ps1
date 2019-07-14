# Lab 01 Starter script - Using Azure PowerShell

# Variables
$rg1Name 	= '20533E0101-LabRG' # test resource group created in Exercise 2
$rg2Name 	= '20533E0102-LabRG' # resource group name to which you will move the resource
$resName	= '20533E0101-rt' # test resource created in Exercise 2

# Identify the location of the resource group containing the resource
$locName = (Get-AzureRmResourceGroup -Name $rg1Name).Location

# Create a new resource group in the same location
$rg2 = New-AzureRmResourceGroup -Name $rg2Name -Location $locName

# Retrieve an object representing the resource and store it in a variable
$res = Get-AzureRmResource -ResourceName $resName -ResourceGroupName $rg1Name

# Move the resource to the new resource group
Move-AzureRmResource -DestinationResourceGroupName $rg2Name -ResourceId $res.ResourceId

# View resources in the new resource group
Get-AzureRmResource | Where-Object ResourceGroupName -eq $rg2Name

# End of script
