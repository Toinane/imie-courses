workflow Stop-AzureVMs-Workflow
{  
 $c = Get-AutomationConnection -Name 'AzureRunAsConnection'
 Add-AzureRmAccount -ServicePrincipal -Tenant $c.TenantID -ApplicationID $c.ApplicationID -CertificateThumbprint $c.CertificateThumbprint
 $vm0 = Get-AutomationVariable -Name 'VM0'
 $vm1 = Get-AutomationVariable -Name 'VM1'
 $rg = Get-AutomationVariable -Name 'ResourceGroup'
 Parallel
 {
    Stop-AzureRmVM -Name $vm0 -ResourceGroupName $rg -Force
    Stop-AzureRmVM -Name $vm1 -ResourceGroupName $rg -Force
 }   
}
