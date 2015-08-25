#Uproot
Developed by [@jaredcatkinson](https://twitter.com/jaredcatkinson), [@harmj0y](https://twitter.com/harmj0y), [@sixdub](https://twitter.com/sixdub)

## Overview
Uproot is a Host Based Intrusion Detection System (HIDS) that leverages Permanent Windows Management Instrumentation (WMI) Event Susbcriptions to detect malicious activity on a network. An Event Subscription is made up of an Event Filter, an Event Consumer, and a Filter to Consumer Binding.

An Event Filter is a WMI Query Language (WQL) query that specifies the type of object to look for (for more details on WQL please check out Ravikanth Chaganti's free ebook at http://www.ravichaganti.com/blog/ebook-wmi-query-language-via-powershell/). Event Consumers are the action component of the Event Subscription. Event Consumers tell the subscription what to do with an object that makes it past the filter. There are five default event consumers in Windows: ActionScriptEventConsumer (runs arbitrary vbscript or jscript code), CommandLineEventConsumer (executes an arbitrary command), LogFileEventConsumer (writes to a specified flat log file), NtEventLogEventConsumer (creates a new event log), and SMTPEventConsumer (sends an email). Lastly, the Filter to Consumer Binding pairs a Filter with a Consumer.

For best results, it is recommended to use Uproot's AS_GenericHTTP consumer and an Uproot Listening Post to forward events via syslog to a log aggregator such as Splunk.

Note: Uproot was designed for a controller with >= PowerShell v3 compatibility. The module can be used with PowerShell v2, but will be missing a great deal of functionality. Although, Microsoft has consistently included WMI in Microsoft Windows since Windows NT 4.0 and Windows 95.  Because of this, Uproot can be used with Windows OS endpoints from Windows NT 4.0 forward.

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
Install-Sig - Adds prebuilt signatures (sets of filters and consumers) to any specified computer.
```

### Uproot Listening Post
The Uproot project includes a service executable that can be used as a Listening Post (LP) (a point in the network that aggregates and forwards on events). The Listening Post receives HTTP POST requests, coverts the recieved data to Syslog, and forwards the data to any specified location (ex. Splunk).

You can have multiple Listening Posts throughout your network to allow for load distribution, or to work with firewall restrictions.

Below is a list of Cmdlets to install/configure an Uproot Listening Post:
```
Get-UprootLP - Lists Uproot Listening Posts on a local or remote computer.
New-UprootLP - Creates a new Uproot Listening Post on a local or remote computer.
Remove-UprootLP - Removes the Uproot Listening Post from a local or remote computer.
Restart-UprootLP - Restarts the Uproot Listening Post on a local or remote computer with new configs.
Start-UprootLP - Starts the Uproot Listening Post on a local or remote computer.
Stop-UprootLP - Stops the Uproot Listening Post on a local or remote computer.
```

## Signatures
(Write something about Intrinsic vs. Extrinsic)
BOTTOM LINE: Whenever possible, use Extrinsic events instead of Intrinsic events. Intrinsic events require polling, which is more resource intensive (although I haven't come across any major issues yet) than Extrinsic events.

### Filters
```
DriverCreation - Intrinsic Event monitoring for the creation/registration of System Drivers
LoggedOnUserCreation - 
NetworkConnectionCreation - 
ProcessCreation - Intrinsic Event monitoring for process creation
ProcessStartTrace - Extrinsic Event monitoring for process creation 
ScheduledJobCreation - Intrinsic Event monitoring for the creation/registration of "AT" jobs
ServerConnectionCreation - 
ServiceCreation - 
ShadowCopyCreation - Intrinsic Event monitoring for the creation of a Volume Shadow Copy
ShareCreation - Intrinsic Event monitoring for the creation of a File Share
StartupCommandCreation - 
UserCreation - Intrinsic Event monitoring for the creation of a local user
UserProfileCreation - 
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
### Install Module (PSv3)
```powershell
Browse to download.uproot.invoke-ir.com
Decompress downloaded zip file
Rename folder to Uproot
Move folder PowerShell Module directory (Get-ChildItem Env:\PSModulePath | Select-Object -ExpandProperty Value)
Run PowerShell as Admin
Set-ExecutionPolicy Unrestricted
Unblock-File \path\to\module\Uproot\*
Unblock-File \path\to\module\Uproot\en-US\*
Import-Module Uproot
```

### Install Subscription
```powershell
Add-WmiEventFilter -FilterFile ProcessStartTrace
Add-WmiEventConsumer -ConsumerFile AS_ExtrinsicHTTPPOST
Add-WmiEventSubscription -FilterName ProcessStartTrace -ConsumerName AS_GenericHTTP
```

### Install Signature File
```powershell
Install-Sig -ComputerName (Get-Content .\hostlist.txt) -SigFile Basic
```

### Install Local Listening Post
```powershell
Copy-Item $PSModulePath\Uproot\bin\uprootd.exe C:\windows\System32\uprootd.exe
New-UprootLP -BinaryPathName C:\windows\System32\uprootd.exe
Start-UprootLP -Server 192.168.1.100
```

### Install Remote Listening Post
```powershell
Copy-Item $PSModulePath\Uproot\bin\uprootd.exe \\LPHost\C$\windows\System32\uprootd.exe
New-UprootLP -ComputerName LPHost -BinaryPathName C:\windows\System32\uprootd.exe
Start-UprootLP -ComputerName LPHost -Server 192.168.1.100
```

### Remove Local Listening Post
```powershell
Get-UprootLP
Stop-UprootLP
Remove-UprootLP
```

### Remove Remote Listening Post
```powershell
Get-UprootLP -ComputerName LPHost
Stop-UprootLP -ComputerName LPHost
Remove-UprootLP -ComputerName LPHost
```
    
