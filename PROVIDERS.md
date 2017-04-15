# Providers

Convention: Following the Chef naming conventions, attributes are lower case and get upcased at the CWB server to follow environment variable conventions (Example: access_key => ACCESS_KEY).

## Amazon Web Services (AWS)

* EC2: https://aws.amazon.com/ec2/
* Console: https://console.aws.amazon.com/ec2
* Create AWS credentials: http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html
* Vagrant aws: https://github.com/mitchellh/vagrant-aws

### AWS Configuration
* Instance types: https://aws.amazon.com/ec2/instance-types/
* Instance pricing: https://aws.amazon.com/ec2/pricing/on-demand/
* Canonical Ubuntu images: https://cloud-images.ubuntu.com/locator/ec2/
  * Release history: https://cloud-images.ubuntu.com/query/trusty/server/released.txt
* Regions: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html

### CWB Configuration

```ruby
'providers' => {
  'aws' => {
    'access_key' => 'AWS_ACCESS_KEY',
    'secret_key' => 'AWS_SECRET_KEY',
  },
},
```

## Microsoft Azure (Azure)

* Virtual Machines: https://azure.microsoft.com/en-us/services/virtual-machines/
* Console: https://portal.azure.com/?whr=live.com#blade/HubsExtension/Resources/resourceType/Microsoft.Compute%2FVirtualMachines
* Vagrant azure: https://github.com/Azure/vagrant-azure
* Create Azure credentials: https://github.com/Azure/vagrant-azure#create-an-azure-active-directory-aad-application

### Azure Configuration
* VM sizes: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes-general
* Linux VM pricing: https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/
* Image list: https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage
* Regions: https://azure.microsoft.com/en-us/regions/

### CWB Configuration

```ruby
'providers' => {
  'azure' => {
    'azure_subscription_id' => 'AZURE_SUBSCRIPTION_ID',
    'azure_tenant_id' => 'AZURE_TENANT_ID',
    'azure_client_id' => 'AZURE_CLIENT_ID',
    'azure_client_secret' => 'AZURE_CLIENT_SECRET',
  },
},
```

#### Public Key

Next to the private key path `/home/apps/.ssh/cloud-benchmarking.pem`, there MUST exist the matching public key with the name `cloud-benchmarking.pem.pub` according to [source](https://github.com/Azure/vagrant-azure/blob/v2.0/lib/vagrant-azure/action/run_instance.rb#L115).
