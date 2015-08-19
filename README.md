#Uproot
Developed by [@jaredcatkinson](https://twitter.com/jaredcatkinson), [@harmj0y](https://twitter.com/harmj0y), [@sixdub](https://twitter.com/sixdub)

## Overview
Uproot is a Host Based Intrusion Detection System (HIDS) that leverages Permanent Windows Management Instrumentation (WMI) Event Susbcriptions to detect malicious activity on a network.

WMI has been consistently included in Microsoft Windows since Windows NT 4.0 and Windows 95

Note: Uproot was designed for >= PowerShell v3 compatibility. The module can be used with PowerShell v2, but will be missing a great deal of functionality. 

## Cmdlets
### Event Filter (__EventFilter):
```
Add-WmiEventFilter
Get-WmiEventFilter 
Remove-WmiEventFilter  
```

### Event Consumers (__EventConsumer):
```
Add-WmiEventConsumer
Get-WmiEventConsumer
Remove-WmiEventConsumer
```

### Event Subscription (__FilterToConsumerBinding):
```
Add-WmiEventSubscription
Get-WmiEventSubscription
Remove-WmiEventSubscription
```

### Signature Sets - Prebuilt sets of filters, consumers, and subscriptions
```
Install-Sig
```

### Uproot Listening Post
The Uproot project includes a service executable that can be used as a Listening Post (a point in the network to aggregate and forward on events).  The Listening Post receives HTTP POST requests, coverts the recieved data to Syslog, and forwards the data to any specified location (ex. Splunk).

You can have multiple Listening Posts throughout your network to allow for load distribution, or to work with firewall restrictions.

Below is a list of Cmdlets to install/configure an Uproot Listening Post:
```
Get-UprootLP
New-UprootLP
Remove-UprootLP
Restart-UprootLP
Start-UprootLP
Stop-UprootLP
```

## Signatures
### Filters
```
DriverCreation
LoggedOnUserCreation
NetworkConnectionCreation
ProcessCreation
ProcessStartTrace
ScheduledJobCreation
ServerConnectionCreation
ServiceCreation
ShadowCopyCreation
ShareCreation
UserCreation
UserProfileCreation
```

### Consumers
```
** Generic JSON formatters (format objects as JSON and POSTs to web server defined within consumer code) **
AS_GenericHTTP - Generic ActiveScriptEventConsumer for All Events (this is the recommended consumer)
AS_ExtrinsicHTTP - Generic ActiveScriptEventConsumer for Extrinsic Events (Win32_ProcessStartTrace)
AS_IntrinsicHTTP - Generic ActiveScriptEventConsumer for Intrinsic Events (Win32_ProcessCreation)
```

### Prebuilt Sigs
```
Basic = an example signature file
```

## Examples
### Install Module
```
Browse to download.uproot.invoke-ir.com
Decompress downloaded zip file
Rename folder to Uproot
Move folder PowerShell Module directory (Get-ChildItem Env:\PSModulePath | Select-Object -ExpandProperty Value)
Run PowerShell as Admin
Set-ExecutionPolicy Unrestricted
Import-Module Uproot
```

### Install Signatures
```
Add-WmiEventFilter -FilterFile ProcessStartTrace
Add-WmiEventConsumer -ConsumerFile AS_ExtrinsicHTTPPOST
Add-WmiEventSubscription -FilterName ProcessStartTrace -ConsumerName AS_GenericHTTP
```

```
Install-Sig -ComputerName (Get-Content .\hostlist.txt) -SigFile Basic
```

### Install Local Listening Post
```
Copy-Item $PSModulePath\Uproot\bin\uprootd.exe C:\windows\System32\uprootd.exe
New-UprootLP -BinaryPathName C:\windows\System32\uprootd.exe
Start-UprootLP -Server 192.168.1.100
```

### Install Remote Listening Post
```
Copy-Item $PSModulePath\Uproot\bin\uprootd.exe \\LPHost\C$\windows\System32\uprootd.exe
New-UprootLP -ComputerName LPHost -BinaryPathName C:\windows\System32\uprootd.exe
Start-UprootLP -ComputerName LPHost -Server 192.168.1.100
```

### Remove Local Listening Post
```
Get-UprootLP
Stop-UprootLP
Remove-UprootLP
```

### Remove Remote Listening Post
```
** Remove Remote Listening Post **
Get-UprootLP -ComputerName LPHost
Stop-UprootLP -ComputerName LPHost
Remove-UprootLP -ComputerName LPHost
```
    
