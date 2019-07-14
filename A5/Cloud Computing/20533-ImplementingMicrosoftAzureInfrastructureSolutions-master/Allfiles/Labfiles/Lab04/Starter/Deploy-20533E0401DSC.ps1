Add-AzureRmAccount

Select-20533ESubscriptionARM

$resourceGroupName = '20533E0401-LabRG'
$saPrefix = ('sa20533e04').ToLower()
$saType = 'Standard_LRS'

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName

$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName
If (!($storageAccount)) {
    Do { 
        $uniqueNumber = Get-Random
        $saName = $saPrefix + $uniqueNumber
    } Until ((Get-AzureRmStorageAccountNameAvailability -Name $saName).NameAvailable -eq $True)
    $storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupname -Name $saName -Type $saType -Location $resourceGroup.Location
}

$storageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccount[0].StorageAccountName)[0].Value

# we are using default container 
$containerName = 'windows-powershell-dsc'

$configurationName = 'IISInstall'
$configurationPath = "$PSScriptRoot\$configurationName.ps1"

$moduleURL = Publish-AzureRmVMDscConfiguration -ConfigurationPath $configurationPath -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccount.StorageAccountName -Force

$storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $storageAccountKey
$sasToken = New-AzureStorageContainerSASToken -Name $containerName -Context $storageContext -Permission r

$settingsHashTable = @{
"ModulesUrl" = "$moduleURL";
"ConfigurationFunction" = "$configurationName.ps1\$configurationName";
"SasToken" = "$sasToken"
}

$vmName1= '20533E0401-vm0'
$vmName2= '20533E0401-vm1'
$extensionName = 'DSC'
$extensionType = 'DSC'
$publisher = 'Microsoft.Powershell'
$typeHandlerVersion = '2.26'

Set-AzureRmVMExtension  -ResourceGroupName $resourceGroupName -VMName $vmName1 -Location $storageAccount.Location `
-Name $extensionName -Publisher $publisher -ExtensionType $extensionType -TypeHandlerVersion $typeHandlerVersion `
-Settings $settingsHashTable

Set-AzureRmVMExtension  -ResourceGroupName $resourceGroupName -VMName $vmName2 -Location $storageAccount.location `
-Name $extensionName -Publisher $publisher -ExtensionType $extensionType -TypeHandlerVersion $typeHandlerVersion `
-Settings $settingsHashTable
