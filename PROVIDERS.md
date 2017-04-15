# Providers

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
* Create Azure credentials
  1. Create self-signed certificate (Windows only ?!): https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-certs-create
  2. Upload management certificate: https://docs.microsoft.com/en-us/azure/azure-api-management-certs

### CWB Configuration

```ruby
'providers' => {
  'azure' => {
    'azure_mgmt_certificate_FILE' => 'AZURE_MGMT_CERTIFICATE_FILE_CONTENT',
    'azure_subscription_id' => 'AZURE_SUBSCRIPTION_ID',
  },
},
```
