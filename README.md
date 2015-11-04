<h1 align="center">Uproot</h1>
<h5 align="center">Developed by <a href="https://twitter.com/jaredcatkinson">@jaredcatkinson</a>, <a href="https://twitter.com/mattifestation">@mattifestation</a>, <a href="https://twitter.com/harmj0y">@harmj0y</a>, <a href="https://twitter.com/sixdub">@sixdub</a></h5>

<p align="center">
  <a href="https://ci.appveyor.com/project/Invoke-IR/uproot">
    <img src="https://ci.appveyor.com/api/projects/status/46t5ew218wnaalod?svg=true" width="150">
  </a>
</p>

<p align="center">
  <a href="http://waffle.io/Invoke-IR/Uproot">
    <img src="https://badge.waffle.io/Invoke-IR/Uproot.svg?label=ready&title=Ready">
  </a>
  <a href="http://waffle.io/Invoke-IR/Uproot">
    <img src="https://badge.waffle.io/Invoke-IR/Uproot.svg?label=in%20progress&title=In%20Progress">
  </a>
</p>

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
The Uproot project includes a service executable that can be used as a Listening Post (LP) (a point in the network that aggregates and forwards on events). The Listening Post receives HTTP POST requests, converts the recieved data to Syslog, and forwards the data to any specified location (ex. Splunk).

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

## [Module Installation](https://msdn.microsoft.com/en-us/library/dd878350(v=vs.85).aspx)
Jakub Jareš wrote an [excellent introduction](http://www.powershellmagazine.com/2014/03/12/get-started-with-pester-powershell-unit-testing-framework/) to module installation, so I decided to adapt his example for Uproot. 

To begin open an internet browser and navigate to the main Uproot github [page](https://github.com/Invoke-IR/Uproot). Once on this page you will need to download and extract the module into your modules directory.

<p align="center">
  <img src="http://4.bp.blogspot.com/--awwh6xvH_A/Vd_C3tQpitI/AAAAAAAAA3Y/lCPGXa8mk08/s640/Screenshot%2B2015-08-27%2B21.52.40.png">
</p>

If you used Internet Explorer to download the archive, you need to unblock the archive before extraction, otherwise PowerShell will complain when you import the module. If you are using PowerShell 3.0 or newer you can use the Unblock-File cmdlet to do that:
```powershell
Unblock-File -Path "$env:UserProfile\Downloads\Uproot-master.zip"
```

If you are using an older version of PowerShell you will have to unblock the file manually. Go to your Downloads folder and right-click Uproot-master.zip and select "Properties". On the general tab click Unblock and then click OK to close the dialog.

<p align="center">
  <img src="http://2.bp.blogspot.com/-4QzeiRBwHfI/Vd_C3l1dIXI/AAAAAAAAA3U/rvverb1qbpM/s640/Screenshot%2B2015-08-27%2B21.57.21.png">
</p>

Open your Modules directory and create a new folder called Uproot. You can use this script to open the correct folder effortlessly:
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

Extract the archive to the Uproot folder. When you are done you should have all these files in your Uproot directory:

<p align="center">
  <img src="http://4.bp.blogspot.com/-NfSl2E5G7CM/Vd_Ei6Q_r6I/AAAAAAAAA3o/Ats2BlDSzmk/s640/Screenshot%2B2015-08-27%2B22.16.28.png">
</p>

Start a new PowerShell session and import the Uproot module using the commands below:
```powershell
Get-Module -ListAvailable -Name Uproot
Import-Module Uproot
Get-Command -Module Uproot
```

You are now ready to use the Uproot PowerShell module!

## Examples
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
    
