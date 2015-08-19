#Uproot
Developed by [@jaredcatkinson](https://twitter.com/jaredcatkinson), [@harmj0y](https://twitter.com/harmj0y), [@sixdub](https://twitter.com/sixdub)

## Overview
Uproot is a Host Based Intrusion Detection System (HIDS) that leverages Permanent Windows Management Instrumentation (WMI) Event Susbcriptions to detect malicious activity on a network.

WMI has been consistently included in Microsoft Windows since Windows NT 4.0 and Windows 95

Note: Uproot was designed for >= PowerShell v3 compatibility. The module can be used with PowerShell v2, but will be missing a great deal of functionality. 

## Cmdlets
### Event Filter (__EventFilter):
```
Add-WmiEventFilter - Adds a WMI Event Filter to a local or remote computer.
Get-WmiEventFilter - Gets the WMI Event Filters that are "installed" on the local or a remote computer.
Remove-WmiEventFilter - Removes a WMI Event Filter to a local or remote computer.
```

### Event Consumers (__EventConsumer):
```
Add-WmiEventConsumer - Adds a WMI Event Consumer to a local or remote computer.
Get-WmiEventConsumer - Gets the WMI Event Consumers that are "installed" on the local computer or a remote computer.
Remove-WmiEventConsumer - Removes a WMI Event Consumer to a local or remote computer.
```

### Event Subscription (__FilterToConsumerBinding):
```
Add-WmiEventSubscription - Adds a WMI Event Subscription to a local or remote computer.
Get-WmiEventSubscription - Gets the WMI Event Subscriptions that are "installed" on the local computer or a remote computer.
Remove-WmiEventSubscription - Removes a WMI Event Subscriptions to a local or remote computer.
```

### Signature Sets - Prebuilt sets of filters, consumers, and subscriptions
```
Install-Sig - 
```

### Uproot Listening Post
The Uproot project includes a service executable that can be used as a Listening Post (LP) (a point in the network that aggregates and forwards on events). The Listening Post receives HTTP POST requests, coverts the recieved data to Syslog, and forwards the data to any specified location (ex. Splunk).

You can have multiple Listening Posts throughout your network to allow for load distribution, or to work with firewall restrictions.

Below is a list of Cmdlets to install/configure an Uproot Listening Post:
```
Get-UprootLP - 
New-UprootLP -
Remove-UprootLP -
Restart-UprootLP -
Start-UprootLP -
Stop-UprootLP -
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
StartupCommandCreation
UserCreation
UserProfileCreation
```

### ActiveScriptEventConsumers
```
AS_GenericHTTP - Generic ActiveScriptEventConsumer for All Events (this is the recommended consumer)
AS_ExtrinsicHTTP - Generic ActiveScriptEventConsumer for Extrinsic Events (Win32_ProcessStartTrace)
AS_IntrinsicHTTP - Generic ActiveScriptEventConsumer for Intrinsic Events (Win32_ProcessCreation)
```

### LogFileEventConsumers
```
LF_ProcessCreation_CSV_PSv2
LF_ProcessCreation_txt
```

### Prebuilt Sigs
```
Basic - An example signature file
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

### Install Subscription
```
Add-WmiEventFilter -FilterFile ProcessStartTrace
Add-WmiEventConsumer -ConsumerFile AS_ExtrinsicHTTPPOST
Add-WmiEventSubscription -FilterName ProcessStartTrace -ConsumerName AS_GenericHTTP
```

### Install Signature File
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
Get-UprootLP -ComputerName LPHost
Stop-UprootLP -ComputerName LPHost
Remove-UprootLP -ComputerName LPHost
```
    
