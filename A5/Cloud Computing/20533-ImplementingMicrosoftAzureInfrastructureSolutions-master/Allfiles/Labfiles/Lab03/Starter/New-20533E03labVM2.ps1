# Sign in to Azure
Add-AzureRmAccount

Select-20533ESubscriptionARM

# Assign variables
$rgName		= '20533E0301-LabRG'
$vmName 	= '20533E03labVM2'
$pubName	= 'MicrosoftWindowsServer'
$offerName	= 'WindowsServer'
$skuName	= '2016-Datacenter'
$vmSize 	= (Get-AzureRmResource -ResourceGroupName 20533E0301-LabRG -ResourceType Microsoft.Compute/virtualMachines -ResourceName '20533E03labVM1' -ApiVersion 2017-12-01)[0].Properties.hardwareProfile.vmSize
$vnetName 	= '20533E0301-LabVNet'
$subnetName = 'database'
$avSetName  = '20533E0301-db-avset'
$nsgName    = "$vmName-nsg"
$pipName    = "$vmName-pip" 
$nicName    = "$vmName-nic"
$osDiskName = "$vmName-osdisk"
$osDiskSize = 128
$osDiskType = (Get-AzureRmResource -ResourceGroupName $rgName -ResourceType Microsoft.Compute/disks)[0].Sku.name

# Identify virtual network and subnet
$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName
$subnetid = (Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet).Id

# Identify the Azure region
$location = $vnet.Location

# Identify the diagnostics storage account
$storageAccount	= Get-AzureRmStorageAccount | Where-Object {($_.Location -eq $location) -and ($_.ResourceGroupName -eq $rgName)}

# Create admin credentials
$adminUsername = 'Student'
$adminPassword = 'Pa55w.rd1234'
$adminCreds = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force) 

# Create an NSG
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name 'default-allow-rdp' -Protocol Tcp -Direction Inbound -Priority 1000 `
                    -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $location -Name $nsgName -SecurityRules $nsgRuleRDP

# Create a public IP and NIC
$pip = New-AzureRmPublicIpAddress -Name $pipName -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic 
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location `
        -SubnetId $subnetid -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# Identify the availability set
$avSet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgName -Name $avSetName

# Set VM Configuration
$vmConfig	= New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $avSet.Id
Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $nic.Id
Set-AzureRmVMBootDiagnostics -Enable -ResourceGroupName $rgName -VM $vmConfig -StorageAccountName $storageAccount[0].StorageAccountName
Set-AzureRmVMOperatingSystem -VM $vmConfig -Windows -ComputerName $vmName -Credential $adminCreds 
Set-AzureRmVMSourceImage -VM $vmConfig -PublisherName $pubName -Offer $offerName -Skus $skuName -Version 'latest'
try {
    Set-AzureRmVMOSDisk -VM $vmConfig -Name $osDiskName -DiskSizeInGB $osDiskSize -StorageAccountType $osDiskType -CreateOption fromImage
} catch {
    $osDiskType = (Get-AzureRmResource -ResourceGroupName $rgName -ResourceType Microsoft.Compute/disks)[0].Sku.name -Replace '_',""
    Set-AzureRmVMOSDisk -VM $vmConfig -Name $osDiskName -DiskSizeInGB $osDiskSize -StorageAccountType $osDiskType -CreateOption fromImage
}

#Create the VM
New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vmConfig


