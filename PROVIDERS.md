# Providers

Convention: Following the Chef naming conventions, attributes are lower case and get upcased at the CWB server to follow environment variable conventions (Example: access_key => ACCESS_KEY).

## Amazon Web Services (AWS)

* EC2: https://aws.amazon.com/ec2/
* Console: https://console.aws.amazon.com/ec2
* Create AWS credentials: http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html
* Vagrant aws: https://github.com/mitchellh/vagrant-aws

### CWB Configuration

```ruby
'providers' => {
  'aws' => {
    'access_key' => 'AWS_ACCESS_KEY',
    'secret_key' => 'AWS_SECRET_KEY',
  },
},
```

## Microsoft Azure

* Virtual Machines: https://azure.microsoft.com/en-us/services/virtual-machines/
* Console: https://portal.azure.com/?whr=live.com#blade/HubsExtension/Resources/resourceType/Microsoft.Compute%2FVirtualMachines
* Vagrant azure: https://github.com/Azure/vagrant-azure
* Create Azure credentials: https://github.com/Azure/vagrant-azure#create-an-azure-active-directory-aad-application

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
