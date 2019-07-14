Function Set-20533EEnvironment
{
    Param(
        [Parameter(Mandatory=$true,Position=1)]
            [String]$resourceGroupName,
        [Parameter(Mandatory=$true,Position=2)]
            [String]$resourceGroupLocation,
        [Parameter(Mandatory=$false,Position=3)]
            [Boolean]$uploadArtifacts = $false,
        [Parameter(Mandatory=$false,Position=4)]
            [String]$templateFilePath = 'Templates\azuredeploy.json',
        [Parameter(Mandatory=$false,Position=5)]
            [String]$templateParametersFilePath = 'Templates\azuredeploy.parameters.json',
        [Parameter(Mandatory=$false,Position=6)]
            [String]$ArtifactStagingDirectoryPath = 'bin\Debug\staging',
        [Parameter(Mandatory=$false,Position=7)]
            [String]$DSCSourceFolderPath = 'DSC',
        [Parameter(Mandatory=$false,Position=8)]
            [String]$nestedTemplatesPath = 'nestedtemplates',
        [Parameter(Mandatory=$false,Position=9)]
            [String]$vmSize = 'Standard_D1_v2'
    )

    $labNumberTwoDigit = ([int]$global:20533ElabNumberGlobal).ToString("00")
    $rootPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName
    $labStartupFolder = Join-Path -Path $rootPath -ChildPath "Labfiles\Lab$labNumberTwoDigit\Starter"

    Write-Host "lab startup folder is $labStartupFolder"

    Set-Location -Path $env:USERPROFILE

    $rgDoesNotExist = $true
    Try {
        If (Get-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -ErrorAction SilentlyContinue) {
            $rgDoesNotExist = $false
        }
    }
    Catch {
    }
    
    If ($rgDoesNotExist) {
        $resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
    }

    $storageContainerName = $ResourceGroupName.ToLowerInvariant() + '-stageartifacts'
    $templateFile = [System.IO.Path]::Combine($PSScriptRoot, $templateFilePath)
    $templateParametersFile = [System.IO.Path]::Combine($PSScriptRoot, $templateParametersFilePath)

    $optionalParameters = New-Object -TypeName Hashtable

    if ($uploadArtifacts) {
        # Convert relative paths to absolute paths if needed
        $ArtifactStagingDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $ArtifactStagingDirectoryPath))
        $DSCSourceFolder = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $DSCSourceFolderPath))
        $nestedTemplatesFolder = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $nestedTemplatesPath))

        # Parse the parameter file and update the values of artifacts location and artifacts location SAS token if they are present
        $JsonParameters = Get-Content $templateParametersFile -Raw | ConvertFrom-Json
        if (($JsonParameters | Get-Member -Type NoteProperty 'parameters') -ne $null) {
            $JsonParameters = $JsonParameters.parameters
        }
        $ArtifactsLocationName = '_artifactsLocation'
        $ArtifactsLocationSasTokenName = '_artifactsLocationSasToken'
        $OptionalParameters[$ArtifactsLocationName] = $JsonParameters | Select -Expand $ArtifactsLocationName -ErrorAction Ignore | Select -Expand 'value' -ErrorAction Ignore
        $OptionalParameters[$ArtifactsLocationSasTokenName] = $JsonParameters | Select -Expand $ArtifactsLocationSasTokenName -ErrorAction Ignore | Select -Expand 'value' -ErrorAction Ignore

        # Create DSC configuration archive
        if (Test-Path $DSCSourceFolder) {
            $DSCSourceFilePaths = @(Get-ChildItem $DSCSourceFolder -File -Filter '*.ps1' | ForEach-Object -Process {$_.FullName})
            foreach ($DSCSourceFilePath in $DSCSourceFilePaths) {
                $DSCArchiveFilePath = $DSCSourceFilePath.Substring(0, $DSCSourceFilePath.Length - 4) + '.zip'
                Publish-AzureRmVMDscConfiguration $DSCSourceFilePath -OutputArchivePath $DSCArchiveFilePath -Force -Verbose
            }
        }

        If ((Get-AzureRmContext).Subscription.SubscriptionId -eq $null) {
            $subscriptionId = (Get-AzureRmContext).Subscription.Id
        } else {
            $subscriptionId = (Get-AzureRmContext).Subscription.SubscriptionId
        }

        # Create a storage account name if none was provided
        if ($StorageAccountName -eq $null) {
            $StorageAccountName = 'stage' + $subscriptionId.Replace('-', '').substring(0, 19)
        }

        $StorageAccount = (Get-AzureRmStorageAccount | Where-Object{$_.StorageAccountName -eq $StorageAccountName})

        # Create the storage account if it doesn't already exist
        if ($StorageAccount -eq $null) {
            Write-Host "Creating storage account $StorageAccountName"
            $StorageAccount = New-AzureRmStorageAccount -StorageAccountName $StorageAccountName -Type 'Standard_LRS' -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation
        }

        Do {
            Start-Sleep -Seconds 15
        } While ($StorageAccount.ProvisioningState -ne 'Succeeded')

        # Generate the value for artifacts location if it is not provided in the parameter file
        if ($OptionalParameters[$ArtifactsLocationName] -eq $null) {
            $OptionalParameters[$ArtifactsLocationName] = $StorageAccount.Context.BlobEndPoint + $StorageContainerName
        }

        # Copy files from the local storage staging location to the storage account container
        New-AzureStorageContainer -Name $StorageContainerName -Context $StorageAccount.Context -ErrorAction SilentlyContinue *>&1

        $ArtifactStagingDirectory = $DSCSourceFolderPath
        $ArtifactFilePaths = Get-ChildItem $ArtifactStagingDirectory -Recurse -File | ForEach-Object -Process {$_.FullName}
        foreach ($SourcePath in $ArtifactFilePaths) {
            $blobString = $SourcePath.Substring($labStartupFolder.Length + 1, ($SourcePath.Length - $labStartupFolder.Length - 1))
            Set-AzureStorageBlobContent -File $SourcePath -Blob $blobString `
                -Container $StorageContainerName -Context $StorageAccount.Context -Force
        }

        $ArtifactStagingDirectory = $nestedTemplatesPath
        $ArtifactFilePaths = Get-ChildItem $ArtifactStagingDirectory -Recurse -File | ForEach-Object -Process {$_.FullName}
        foreach ($SourcePath in $ArtifactFilePaths) {
            $blobString = $SourcePath.Substring($labStartupFolder.Length + 1, ($SourcePath.Length - $labStartupFolder.Length - 1))
            Set-AzureStorageBlobContent -File $SourcePath -Blob $blobString `
                -Container $StorageContainerName -Context $StorageAccount.Context -Force
        }


        # Generate a 4 hour SAS token for the artifacts location if one was not provided in the parameters file
        if ($OptionalParameters[$ArtifactsLocationSasTokenName] -eq $null) {
            $OptionalParameters[$ArtifactsLocationSasTokenName] = ConvertTo-SecureString -AsPlainText -Force `
                (New-AzureStorageContainerSASToken -Container $StorageContainerName -Context $StorageAccount.Context -Permission r -ExpiryTime (Get-Date).AddHours(4))
        }
    }

    # Create or update the resource group using the specified template file and template parameters file
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation -Verbose -Force

    if ($ValidateOnly) {
        $ErrorMessages = Format-ValidationOutput (Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
                                                                                      -TemplateFile $TemplateFile `
                                                                                      -TemplateParameterFile $TemplateParametersFile `
                                                                                      -vmSize $vmSize `
                                                                                      @OptionalParameters)
        if ($ErrorMessages) {
            Write-Output '', 'Validation returned the following errors:', @($ErrorMessages), '', 'Template is invalid.'
        }
        else {
            Write-Output '', 'Template is valid.'
        }
    }
    else {
        New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem $TemplateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmmss')) `
                                           -ResourceGroupName $ResourceGroupName `
                                           -TemplateFile $TemplateFile `
                                           -TemplateParameterFile $TemplateParametersFile `
                                           -vmSize $vmSize `
                                           @OptionalParameters `
                                           -Force -Verbose `
                                           -ErrorVariable ErrorMessages
        if ($ErrorMessages) {
            Write-Output '', 'Template deployment returned the following errors:', @(@($ErrorMessages) | ForEach-Object { $_.Exception.Message.TrimEnd("`r`n") })
        }
    }
}