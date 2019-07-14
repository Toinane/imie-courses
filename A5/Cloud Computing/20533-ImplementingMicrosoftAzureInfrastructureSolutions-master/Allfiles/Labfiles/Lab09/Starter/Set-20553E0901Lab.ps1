# Lab 09 Starter script - Using Microsoft Azure Active Directory Module for Windows PowerShell

New-MsolUser -UserPrincipalName mledford@<#Copy your Azure Directory domain name here#>.onmicrosoft.com -DisplayName 'Mario Ledford' -FirstName 'Mario' -LastName 'Ledford' -Password 'Pa55w.rd' -ForceChangePassword $false -UsageLocation 'US'

New-MsolGroup -DisplayName 'Azure team' -Description 'Adatum Azure team users'

$group = Get-MsolGroup | Where-Object DisplayName -eq 'Azure team'

$user = Get-MsolUser | Where-Object DisplayName -eq 'Mario Ledford'

Add-MsolGroupMember -GroupObjectId $group.ObjectId -GroupMemberType 'User' -GroupMemberObjectId $user.ObjectId

Get-MsolGroupMember -GroupObjectId $group.ObjectId