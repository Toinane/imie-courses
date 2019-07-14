# Module 3: Implementing virtual machines
# Lab A: Deploying Azure VMs
  
### Scenario
  
 As part of the planning for deployment of Azure VMs to Azure, Adatum Corporation has evaluated its deployment options. You must use the Azure portal and Azure PowerShell to deploy two Microsoft Azure VMs for the database tier of the Research and Development application. To facilitate resource tracking, you should ensure that the virtual machines are part of the same resource group. Both VMs should be part of the same availability set.

 You must use an Azure Resource Manager template to deploy two additional Linux VMs and two additional Windows VMs that the ResDev application will use. The virtual machines should be part of the resource group, to facilitate resource tracking. Linux virtual machines should reside on the virtual networks’ app subnet, and Windows virtual machines should reside on the web subnet of the 20533E0301-LabVNet virtual network.

### Objectives
  
 After completing this lab, you will be able to:

- Create Azure VMs by using the Azure portal and Azure PowerShell.

- Validate virtual-machine creation.

- Use Visual Studio and an Azure Resource Manager template to deploy Azure VMs

- Use Azure PowerShell and an Azure Resource Manager template to deploy Azure VMs

- Use Azure CLI and an Azure Resource Manager template to deploy Azure VMs


### Lab Setup
  
 Estimated Time: 60 minutes

 **Virtual machine**: **20533E-MIA-CL1**

 **User name**: **Student**

 **Password**: **Pa55w.rd**


## Exercise 1: Creating Azure VMs by using the Azure portal and Azure PowerShell
  
### Scenario
  
 You must deploy two Azure VMs that are running Windows Server 2016 Datacenter. Name these machines 20533E03LabVM1 and 20533E03LabVM2. You will use the Azure portal to deploy one VM, and Azure PowerShell to deploy the other VM. You must deploy both virtual machines into the 20533E0301-LabRG resource group, and you must configure the virtual machines to use the database subnet of the 20533E0301-LabVNet virtual network. Both VMs should use managed disks and be part of the same availability set. After deploying the virtual machines, you will confirm successful deployment of the virtual machines.


The main tasks for this exercise are as follows:

1. Use the Azure portal to create a virtual machine

2. Use Azure PowerShell to create a virtual machine



#### Task 1: Use the Azure portal to create a virtual machine
  
1. Ensure that you are signed in to MIA-CL1 as **Student** with the password **Pa55w.rd**. 

2. Start Microsoft Edge, browse to the Azure portal, and sign in by using the Microsoft account that is the Service Administrator of your Azure subscription.

3. In the Azure portal, create a new Azure VM based on the **Windows Server 2016 Datacenter** image with the following settings:

  -  Subscription: the name of your Azure subscription

  -  Resource group: a new resource group named **20533E0301-LabRG**. 
  
  -  Name: **20533E03labVM1**

  -  Region: an Azure region close to the location of the lab environment, in which you can provision Azure VMs
  
  -  Availability set: **20533E0301-db-avset** with 2 fault domains and 5 update domains
  
  -  Size: any available size with one vCPU
  
  -  User name: **Student**

  -  Password: **Pa55w.rd1234**

  -  Use managed disks: **Yes**

  -  Public inbound ports: **RDP**
  
  -  Windows licensing : included in the runtime rate of the VM
  
  -  OS disk type: **Standard HDD**  
  
  -  Virtual network: **20533E0301-labVNet** with address space **10.0.0.0/20** and a subnet named **database** with the address range **10.0.0.0/24**
  
  -  NIC network security group: **Basic**
  
  -  Load balancing: **No**
  
  -  Boot diagnostics: **On**
  
  -  Diagnostics storage account: accept the default setting
  
  -  OS guest diagnostics: **Off**
  
  -  System assigned maanged identity: **Off**
  
  -  Enable auto-shutdown: **Off**
  
  -  Enable backup: **Off**

  -  Accept the default settings for the **Guest config** and **Tags** settings. 

4. Wait for the deployment to complete successfully.

5. Leave the Microsoft Edge with the Azure portal window open.


#### Task 2: Use Azure PowerShell to create a virtual machine
  
1. On MIA-CL1, open a Windows PowerShell ISE window as Administrator

2. In the Windows PowerShell ISE, open the script **F:\\Labfiles\\Lab03\\Starter\\New-20533E03labVM2.ps1** and review its content. 

3. Run the script. 

4. When prompted, sign in using the Microsoft account that is the Service Administrator of your Azure subscription.

5. If you have multiple subscriptions, select the one you used when running **Add-20533EEnvironment** at the beginning of this module.

6. When the script is complete, leave the Windows PowerShell ISE window open.


> **Result**: After completing this exercise, you have created virtual machines by using the Azure portal and Azure PowerShell.


## Exercise 2: Validating Azure VM deployment
  
### Scenario
  
 You now must validate the creation and configuration of the Azure VMs that you created, to ensure that they function properly.


The main tasks for this exercise are as follows:

1. Use Azure PowerShell to validate virtual machine deployment

2. Use the Azure portal to validate virtual machine deployment



#### Task 1: Use Azure PowerShell to validate virtual machine deployment
  
1. In the Windows PowerShell ISE window, at the command prompt, run the following command:

```
Get-AzureRmResource | Where-Object ResourceType -like "*VirtualMachines"
```

2. Confirm that the 20533E03labVM1 and the 20533E03labVM2 virtual machines are listed. 

3. Close the Windows PowerShell ISE window.


#### Task 2: Use the Azure portal to validate virtual machine deployment
  
1. On MIA-CL1, in the Microsoft Edge window, in the Azure portal, navigate to the **20533E0301-LabRG** resource group blade.

2. On the 20533E0301-LabRG blade, review the list of resources associated with both virtual machines.

3. In the Azure portal, navigate to the 20533E03labVM1 blade, and confirm the following values:

  -  Resource group: **20533E0301-LabRG**

  -  Virtual network/subnet: **20533E0301-labVNet/database**

4. Repeat step 3 for the **20533E03labVM2** virtual machine.


> **Result**: After completing this exercise, you will have validated the creation and configuration of Azure Virtual Machines.


## Exercise 3: Using Visual Studio and an Azure Resource Manager template to deploy Azure VMs
  
### Scenario
  
 You must use Visual Studio to deploy two Linux Azure Resource Manager virtual machines for use as app servers in the ResDev app. You should name the servers **20533E03LabVM3** and **20533E03LabVM4**. You have a deployment-template solution and the deployment details for both virtual machines. You must deploy the two virtual machines from Visual Studio, and then confirm that the virtual machines have been deployed successfully by using Azure PowerShell.

The main tasks for this exercise are as follows:

1. Use Visual Studio to deploy Linux app servers Azure VMs

2. Use Azure PowerShell to validate the deployment of the app servers Azure VMs


#### Task 1: Use Visual Studio to deploy Linux app servers Azure VMs
  
1. On MIA-CL1, start Visual Studio 2017. If prompted, sign in with the Microsoft account that is the Service Administrator of your Azure subscription. 

2. In Visual Studio, open the solution **ResDevLinuxDeploy.sln** from **F:\\Labfiles\\Lab03\\Starter\\Projects\\ResDevLinuxDeploy**. 

3. View the contents of the **azuredeploy.json** template.

4. From the Solution Explorer, start a new deployment process of the first virtual machine into the **20533E0301-LabRG** resource group with the following settings: 

  - vmName: **20533E03LabVM4**

  - adminUsername: **Student**

  - adminPassword: **Pa55w.rd1234**

  - virtualNetworkName: **20533E0301-LabVNet**

  - resourceGroupName: **20533E0301-LabRG**

  - subnetName: **app**

  - subnetPrefix: **10.0.1.0/24**

  - vmSize: set the value to the same Azure VM size you used when you provisioned an Azure VM from the Azure portal

  - ubuntuOSVersion: **16.04.0-LTS** or a more recent version if available

  - storageAccountType: **Standard\_LRS**

> **Note:** Deployment will run with the output that appears in the Output pane, which is at the bottom of the window. When deployment is complete, you will receive a message stating that the template was deployed successfully to the resource group 20533E0301-LabRG.

5. View the contents of the **Azuredeploy.parameters.json** file to verify that the parameters that you provided during deployment have been saved in this file.

6. Start another deployment process by using the deployment that you used for the first virtual machine. 

7. Deploy another Azure VM by using the same template, setting its name to **20533E03LabVM3** but leaving all other parameter values the same.

8. Close the solution but leave Visual Studio open.



#### Task 2: Use Azure PowerShell to validate the deployment of the app servers Azure VMs
  
1. On MIA-CL1, start Windows PowerShell ISE as Administrator.

2. From the console pane of the Windows PowerShell ISE window, authenticate to Azure Resource Manager endpoint of your Azure subscription. 

3. From the console pane of the Windows PowerShell ISE window, review the list of subscriptions associated with the account you used to sign in. Identify the value of the subscription Id property of the Azure subscription you want to use in this lab. 

4. If there are multiple Azure subscriptions associated with your account, run the **Set-AzureRmContext** with the **-SubscriptionId** parameter to designate the one you want to use in this lab. 

5. From the console pane of the Windows PowerShell ISE window, identify all resources in the resource group **20533E0301-LabRG**, including their **ResourceName** and **ResourceType** properties by running the **Find-AzureRmResource** cmdlet. 

> **Note** If you are using AzureRM 6.8.1 or newer, use the **Get-AzureRmResource** cmdlet instead

6. In the cmdlet output, note the resources created in this exercise including virtual machines, disks, NICs, public IPs, and a storage account.

7. Leave the Windows PowerShell ISE window open for the next exercise.


> **Result**: After completing this exercise, you will have deployed Azure Virtual Machines by using Visual Studio and an Azure Resource Manager template.


## Exercise 4: Using Azure PowerShell and an Azure Resource Manager template to deploy Azure VMs
  
### Scenario
  
 You must deploy the Web tier virtual machines by using an Azure Resource Manager template and the Azure portal. The Web tier should consist of two virtual machines named **20533E03LabVM5** and **20533E03LabVM6**, running Windows Server 2016. You should deploy these two VMs to the **20533E0301-LabRG** resource group and the **web** subnet of the **20533E0301-LabVNet** virtual network. You have a template and a Windows PowerShell script that you should edit to use to deploy the first of these two VMs. After you deploy the first VM, confirm the deployment by viewing the newly deployed resources in the Azure portal.

The main tasks for this exercise are as follows:

1. Use Azure PowerShell to deploy the Windows virtual machines 

2. Use the Azure portal to monitor deployment

3. Use the Azure portal to validate deployment of the Windows virtual machine


#### Task 1: Use Azure PowerShell to deploy the Windows virtual machines
  
1. In the Windows PowerShell ISE window that you launched in the previous exercise, open **F:\\Labfiles\\Lab03\\Starter\\Templates\\Deploy-AzureResourceGroup.ps1**

2. Review the script that will deploy the template.

> **Note:** Note the $templateFile and $rgName variables. These represent the location of the Azure Resource Manager template file and the resource group to which you will deploy the virtual machines.

3. Switch to Visual Studio and open the file **F:\\Labfiles\\Lab03\\Starter\\Templates\\azuredeploywebvm.json**.
 
> **Note:** Note that the template has a very similar structure to the template for the Linux virtual machines in the previous exercise. The primary differences between the two templates include the variables identifying the operating system image, the target subnet, and the availability set. You could replace these variables with equivalent parameters, in order to minimize the number of templates used to deploy Azure VMs. 

4. Close Visual Studio.

5. Switch back to the Windows PowerShell ISE window and run the **Deploy-AzureResourceGroup.ps1** script. When prompted, provide the following values:

  - vmName: **20533E03LabVM5**

  - adminUsername: **Student**

  - adminPassword: **Pa55w.rd1234**

  - virtualNetworkName: **20533E0301-LabVNet**

  - vmSize: **as specified by the instructor**


#### Task 2: Use the Azure portal to monitor deployment
  
1. To monitor the progress of the deployment, in Microsoft Edge, in the Azure portal, navigate to the **20533E0301-LabRG** resource group blade.

2. On the 20533E0301-LabRG blade, in the Settings section, click the **Deployments** link. 

3. On the 20533E0301-LabRG - Deployments blade, click the **WebTierVM1-Deployment** link.


#### Task 3: Use the Azure portal to validate deployment of the Windows virtual machine
  
1. In Microsoft Edge, in the Azure portal, navigate back to the **20533E0301-LabRG** blade.

2. On the 20533E0301-LabRG blade, in the Overview section, view the list of resources. 

3. Navigate to the **20533E03LabVM5** blade and, in the Essentials section, note that 20533E03LabVM5 has been assigned to the **20533E0301-LabVNet/web** virtual network/subnet and the operating system is **Windows**.

> **Result**: After completing this exercise, you should have deployed Azure Virtual Machines by using Azure PowerShell and Resource Manager templates.


## Exercise 5: Using Azure CLI and an Azure Resource Manager template to deploy Azure VMs
  
### Scenario
  
 You also want to test an alternative process of deploying Azure VMs by using Azure CLI and Azure Resource Manager templates.

The main tasks for this exercise are as follows:

1. Use Azure CLI to deploy the Windows virtual machines

2. Use the Azure portal to monitor deployment

3. Use the Azure portal to validate deployment of the Windows virtual machine

4. Remove the lab environment



#### Task 1: Use Azure CLI to deploy the Windows virtual machines
  
1. On MIA-CL1, start **Command Prompt** as Administrator

2. From **Administrator: Command Prompt**, use Azure CLI 2.0 to sign in to your Azure subscription. 

3. From **Administrator: Command Prompt**, use Azure CLI 2.0 to display properties of the Azure subscription associated with the account you used to sign in. Take note of the value of the **id** parameter, representing your Azure subscription ID. 

4. Run the **az account set** command to specify the subscription in which you are going to create a virtual network.

5. Run the **az group deployment create** command to create a deployment named **WebTierVM2-Deployment** of an Azure VM named **20533E03LabVM6** into the virtual network **20533E0301-LabVNet** and the resource group **20533E0301-LabRG** by using the template **F:\\Labfiles\\Lab03\Starter\\Templates\\azuredeploywebvm.json** 

6. When prompted to provide securestring value for **adminUsername** , **adminPassword** , **vmSize** , type **Student** , **Pa55w.rd1234**, vmSize (Ask your instructor to determine the size of the VM) respectively.


#### Task 2: Use the Azure portal to monitor deployment
  
1. To monitor the progress of the deployment, in Microsoft Edge, in the Azure portal, navigate to the **20533E0301-LabRG** resource group blade.

2. On the 20533E0301-LabRG blade, in the Settings section, click the **Deployments** link. 

3. On the 20533E0301-LabRG - Deployments blade, click the **WebTierVM2-Deployment** link.


#### Task 3: Use the Azure portal to validate deployment of the Windows virtual machine
  
1. In Microsoft Edge, in the Azure portal, navigate back to the **20533E0301-LabRG** blade.

2. On the 20533E0301-LabRG blade, in the Overview section, view the list of resources. 

3. Navigate to the 20533E03LabVM6 blade and, in the Essentials section, note that 20533E03LabVM6 has been assigned to the **20533E0301-LabVNet/web** virtual network/subnet and the operating system is **Windows**.


#### Task 4: Remove the lab environment

1. On MIA-CL1, close all open windows without saving any files.

2. Start **Windows PowerShell** as Administrator and, from the **Administrator: Windows PowerShell** window, run **Remove-20533EEnvironment**.

3. When prompted, sign in by using the Microsoft account that is the Service Administrator of your Azure subscription.

4. If you have multiple Azure subscriptions, select the one you want the script to target.

5. If prompted, specify the current lab number.

6. When prompted for confirmation, type **y**.

7. Start Microsoft Edge, browse to the Azure portal, and sign in by using the Microsoft account that is the Service Administrator of your Azure subscription.

8. In the Azure portal, reset the dashboard to the default state. 

9. Close all open windows.

> **Result**: After completing this exercise, you should have deployed Azure Virtual Machines by using Azure CLI and Resource Manager templates.


**Question** 
What differences regarding Azure VM resources did you notice when you created a virtual machine in the Azure portal versus in Azure PowerShell?

**Question** 
Can Microsoft Visual Studio and Azure PowerShell use the same Azure Resource Manager template to deploy an Azure VM?

**Question** 
How would you configure an Azure Resource Manager template to deploy multiple Azure VMs with different configurations?


©2016 Microsoft Corporation. All rights reserved.

The text in this document is available under the [Creative Commons Attribution 3.0 License](https://creativecommons.org/licenses/by/3.0/legalcode "Creative Commons Attribution 3.0 License"), additional terms may apply.  All other content contained in this document (including, without limitation, trademarks, logos, images, etc.) are **not** included within the Creative Commons license grant.  This document does not provide you with any legal rights to any intellectual property in any Microsoft product. You may copy and use this document for your internal, reference purposes.

This document is provided "as-is." Information and views expressed in this document, including URL and other Internet Web site references, may change without notice. You bear the risk of using it. Some examples are for illustration only and are fictitious. No real association is intended or inferred. Microsoft makes no warranties, express or implied, with respect to the information provided here.
