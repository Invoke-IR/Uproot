#WMIEventing [![Build status](https://ci.appveyor.com/api/projects/status/d40ntb7284up5f98?svg=true)](https://ci.appveyor.com/project/Invoke-IR/wmieventing)

Developed by [@jaredcatkinson](https://twitter.com/jaredcatkinson), [@harmj0y](https://twitter.com/harmj0y), [@sixdub](https://twitter.com/sixdub)

## Overview
An Event Filter is a WMI Query Language (WQL) query that specifies the type of object to look for (for more details on WQL please check out Ravikanth Chaganti's free ebook at http://www.ravichaganti.com/blog/ebook-wmi-query-language-via-powershell/). Event Consumers are the action component of the Event Subscription. Event Consumers tell the subscription what to do with an object that makes it past the filter. There are five default event consumers in Windows: ActionScriptEventConsumer (runs arbitrary vbscript or jscript code), CommandLineEventConsumer (executes an arbitrary command), LogFileEventConsumer (writes to a specified flat log file), NtEventLogEventConsumer (creates a new event log), and SMTPEventConsumer (sends an email). Lastly, the Filter to Consumer Binding pairs a Filter with a Consumer.

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

## Module Installation
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

## Examples
### Add an __EventFilter
```powershell
Add-WmiEventFilter -Name ProcessStartTrace -Query "SELECT * FROM Win32_ProcessStartTrace"
```

### Add an ActiveScriptEventConsumer
```powershell
$script = @"
Set objSysInfo = CreateObject("WinNTSystemInfo")
Set objHTTP = CreateObject("Microsoft.XMLHTTP")

objHTTP.open "POST", "http://$($ListeningPostIP)/", False
objHTTP.setRequestHeader "User-Agent", "UprootIDS"


Dim ipString

Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\localhost\root\cimv2")
Set IPConfigSet = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled=TRUE")

For Each IPConfig in IPConfigSet
    If Not IsNull(IPConfig.IPAddress) Then 
         ipString = IPConfig.IPAddress(0)
    End If
Next


Dim outputString

outputString = outputString & "{""TargetEvent"":{"
outputString = outputString & """TimeCreated"":""" & TargetEvent.Time_Created & ""","
outputString = outputString & """SourceIP"":""" & ipString & ""","
outputString = outputString & """Server"":""" & objSysInfo.ComputerName & ""","

If ((TargetEvent.Path_.Class = "__NamespaceOperationEvent") Or (TargetEvent.Path_.Class = "__NamespaceModificationEvent") Or (TargetEvent.Path_.Class = "__NamespaceDeletionEvent") Or (TargetEvent.Path_.Class = "__NamespaceCreationEvent") Or (TargetEvent.Path_.Class = "__ClassOperationEvent") Or (TargetEvent.Path_.Class = "__ClassModificationEvent") Or (TargetEvent.Path_.Class = "__ClassCreationEvent") Or (TargetEvent.Path_.Class = "__InstanceOperationEvent") Or (TargetEvent.Path_.Class = "__InstanceCreationEvent") Or (TargetEvent.Path_.Class = "__MethodInvocationEvent") Or (TargetEvent.Path_.Class = "__InstanceModificationEvent") Or (TargetEvent.Path_.Class = "__InstanceDeletionEvent") Or (TargetEvent.Path_.Class = "__TimerEvent")) Then
    outputString = outputString & """EventType"":""" & TargetEvent.Path_.Class & ""","
    outputString = outputString & """InstanceType"":""" & TargetEvent.TargetInstance.Path_.Class & ""","
    outputString = outputString & """TargetInstance"":{"

    For Each oProp in TargetEvent.TargetInstance.Properties_
         outputString = outputString & """" & oProp.Name & """:""" & oProp & ""","
    Next
Else
    outputString = outputString & """EventType"":""ExtrinsicEvent"","
    outputString = outputString & """InstanceType"":""" & TargetEvent.Path_.Class & ""","
    outputString = outputString & """TargetInstance"":{"

    For Each oProp in TargetEvent.Properties_
         If oProp.Name <> "Sid" Then
            outputString = outputString & """" & oProp.Name & """:" & """" & oProp & ""","
        End If
    Next
End If

outputString = Left(outputString, Len(outputString) - 1)
outputString = outputString & "}"
outputString = outputString & "}}"

objHTTP.send outputString

Set objHTTP = Nothing
"@

Add-WmiEventConsumer -Name AS_GenericHTTP -ScriptingEngine VBScript -ScriptText $script
```

### Add-WmiEventSubscription
```powershell
Add-WmiEventSubscription -FilterName ProcessStartTrace -ConsumerName AS_GenericHTTP -ConsumerType ActiveScriptEventConsumer
```

### Get-WmiEventFilter
```powershell
Get-WmiEventFilter
```

```powershell
Get-WmiEventFilter -Name ProcessStartTrace
```

### Get-WmiEventConsumer
```powershell
Get-WmiEventConsumer
```

```powershell
Get-WmiEventConsumer -Name AS_GenericHTTP
```

### Get-WmiEventSubscription
```powershell
Get-WmiEventSubscripton
```

### Remove-WmiEventFilter
```powershell
Remove-WmiEventFilter
```

```powershell
Remove-WmiEventFilter -Name ProcessStartTrace
```

```powershell
Get-WmiEventFilter | Remove-WmiEventFilter
```

### Remove-WmiEventConsumer
```powershell
Remove-WmiEventConsumer
```

```powershell
Remove-WmiEventConsumer -Name AS_GenericHTTP
```

```powershell
Get-WmiEventConsumer | Remove-WmiEventConsumer
```

### Remove-WmiEventSubscription
```powershell
Remove-WmiEventSubscription
```

