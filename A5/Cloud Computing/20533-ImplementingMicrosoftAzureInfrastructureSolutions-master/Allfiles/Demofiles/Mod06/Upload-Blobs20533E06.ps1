$storageAccountName = '<your_storage_account_name>'
$containerName = 'demo-container'

# Find the folder where this script is saved
$thisFolder = Split-Path -Parent $MyInvocation.MyCommand.Definition

# The local source subfolder
$sourceFolder = "$thisFolder\data"

# Get storage account key and context
$storageAccountKey = (Get-AzureRmStorageAccountKey -StorageAccountName $storageAccountName -ResourceGroupName)[0].Value
$context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Upload each file in the local folder to the blob container
$files = Get-ChildItem -Path $sourceFolder
foreach ($file in $files) {
  $fileName = "$sourceFolder\$file"
  $blobName = "$file"
  Set-AzureStorageBlobContent -File $filename -Container $containerName -Blob $blobName -Context $context -Force
}
