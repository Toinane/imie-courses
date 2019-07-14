Function Set-20533EVMSize
# Prepare the list of VM sizes to be presented when running Add-20533EEnvironment (this is a static list maintained in \Allfiles\Configfiles\VMSizes.txt) 

{

    $rootPath = (Get-Item $PSScriptRoot).Parent.Parent.FullName
    $VMSizeInfoPath = Join-Path -Path $rootPath -ChildPath 'Configfiles\VMSizes.txt'
    $vmSizes = Get-Content -Path $VMSizeInfoPath

    $vmSizeHashTable = [ordered]@{}
    $counter = 0
    foreach ($vmSize in $vmSizes) {
        $counter++
        $vmSizeHashTable.Add($counter, $vmSize)
    }

    #Display the list, and ask for the index number
    foreach ($key in $vmSizeHashTable.Keys) {
        Write-Host "$key    $($vmSizeHashTable[$key-1])"
    }
    Do {
        Write-Host
        Write-Host "Enter the number corresponding to the VM size you want to use (check with the instructor first): " -ForegroundColor Magenta
        try {
            $vmSizeSet = $true
            [int]$vmSizeNumber = Read-Host
        }
        catch {
            $vmSizeSet =  $false
        }
    } Until ($vmSizeNumber -and ($vmSizeNumber -ge 1) -and ($vmSizeNumber -le $counter))
 
    $global:20533EvmSizeGlobal = $vmSizeHashTable[$vmSizeNumber-1]
    Write-Host "Your VM Size is: " $global:20533EvmSizeGlobal -ForegroundColor Green
   
}