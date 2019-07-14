$ouNameSync 	= 'AccountsToSync'
$ouNameNoSync 	= 'AccountsNotToSync'

New-ADOrganizationalUnit -Name $ouNameSync -Path "DC=adatum,DC=com" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name $ouNameNoSync -Path "DC=adatum,DC=com" -ProtectedFromAccidentalDeletion $false

New-ADUser -Name 'Beverly Beach' -GivenName 'Beverly' -Surname 'Beach' -SamAccountName 'bbeach' -UserPrincipalName 'bbeach@adatum.com' -AccountPassword (ConvertTo-SecureString -AsPlainText 'Pa55w.rd' -Force) -Path "OU=$ouNameSync,DC=adatum,DC=com" -PassThru | Enable-ADAccount
New-ADUser -Name 'Darwin Shivers' -GivenName 'Darwin' -Surname 'Shivers' -SamAccountName 'dshivers' -UserPrincipalName 'dshivers@adatum.com' -AccountPassword (ConvertTo-SecureString -AsPlainText 'Pa55w.rd' -Force) -Path "OU=$ouNameNoSync,DC=adatum,DC=com" -PassThru | Enable-ADAccount