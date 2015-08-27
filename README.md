#Uproot
Developed by [@jaredcatkinson](https://twitter.com/jaredcatkinson), [@harmj0y](https://twitter.com/harmj0y), [@sixdub](https://twitter.com/sixdub)

## Overview
Uproot is a Host Based Intrusion Detection System (HIDS) that leverages Permanent Windows Management Instrumentation (WMI) Event Susbcriptions to detect malicious activity on a network. For more details on WMI Event Subscriptions please see the [WMIEventing Module](https://www.github.com/Invoke-IR/WMIEventing)

For best results, it is recommended to use Uproot's AS_GenericHTTP consumer and an Uproot Listening Post to forward events via syslog to a log aggregator such as Splunk.

Note: Uproot was designed for a controller with >= PowerShell v3 compatibility. The module can be used with PowerShell v2, but will be missing a great deal of functionality. Although, Microsoft has consistently included WMI in Microsoft Windows since Windows NT 4.0 and Windows 95.  Because of this, Uproot can be used with Windows OS endpoints from Windows NT 4.0 forward.

## Cmdlets

### Signature Sets - Prebuilt sets of filters, consumers, and subscriptions
```
Install-UprootSignature - Adds prebuilt signatures (sets of filters and consumers) to any specified computer.
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
NOTE: To avoid creating a privilege escalation vulnerability, we recommend that you move uprootd.exe to C:\Windows\system32\ before using New-UprootLP

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
function Get-UserModulePath {
 
    $Path = $env:PSModulePath -split ";" -match $env:USERNAME
 
    if (-not (Test-Path -Path $Path))
    {
        New-Item -Path $Path -ItemType Container | Out-Null
    }
        $Path
}
 
Invoke-Item (Get-UserModulePath)
```

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

### Install Signature File
```powershell
Install-UprootSignature -ComputerName (Get-Content .\hostlist.txt) -SigFile Basic
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
    
