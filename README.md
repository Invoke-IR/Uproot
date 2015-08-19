#Uproot

Developed by [@jaredcatkinson](https://twitter.com/jaredcatkinson), [@harmj0y](https://twitter.com/harmj0y), [@sixdub](https://twitter.com/sixdub)

## Overview

Note: Uproot was designed to be used on a PowerShell v3 or greater controller.  The module can be used with PowerShell v2, but will be missing a great deal of functionality.

## Install Module
```
Browse to download.uproot.invoke-ir.com
Decompress downloaded zip file
Rename folder to Uproot
Move folder PowerShell Module directory (Get-ChildItem Env:\PSModulePath | Select-Object -ExpandProperty Value)
Run PowerShell as Admin
Import-Module Uproot
```

## Remove Module
```

```

## Cmdlets
### Event Filter (__EventFilter):
    Add-WmiEventFilter
    Get-WmiEventFilter 
    Remove-WmiEventFilter  

### Event Consumers (__EventConsumer):
    Add-WmiEventConsumer
    Get-WmiEventConsumer
    Remove-WmiEventConsumer

### Event Subscription (__FilterToConsumerBinding):
    Add-WmiEventSubscription
    Get-WmiEventSubscription
    Remove-WmiEventSubscription

### Signature Sets - Prebuilt sets of filters, consumers, and subscriptions
    Install-Sig
    
### Uproot Listening Post
    Get-UprootLP
    New-UprootLP
    Remove-UprootLP
    Restart-UprootLP
    Start-UprootLP
    Stop-UprootLP
    
## Classes
    Uproot.Filter
    Uproot.ActiveScriptEventConsumer
    Uproot.CommandLineEventConsumer
    Uproot.LogFileEventConsumer
    Uproot.NtEventLogEventConsumer
    Uproot.SMTPEventConsumer
    Uproot.Subscription

## Signatures
### Filters
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

### Consumers
    Generic JSON formatters (format objects as JSON and POSTs to web server defined within consumer code)
    AS_ExtrinsicHTTPPOST - Generic ActiveScriptEventConsumer for Extrinsic Events (Win32_ProcessStartTrace)
    AS_IntrinsicHTTPPOST - Generic ActiveScriptEventConsumer for Intrinsic Events (Win32_ProcessCreation)
    
### Prebuilt Sigs
    Basic = an example signature file
    
## Examples
    ### Note: Edit IP Address in AS_ExtrinsicHTTPPOST file
    Add-WmiEventFilter -FilterFile ProcessStartTrace
    Add-WmiEventConsumer -ConsumerFile AS_ExtrinsicHTTPPOST
    Add-WmiEventSubscription -FilterName ProcessStartTrace -ConsumerName AS_ExtrinsicHTTPPOST
    
    ### Note: Edit Filename in LF_Generic file
    Add-WmiEventFilter -FilterFile ProcessCreation
    Add-WmiEventConsumer -ConsumerFile LF_Generic
    Add-WmiEventSubscription -FilterName ProcessCreation -ConsumerName LF_Generic
    
    ### Note: Edit ComputerName and SigFile as appropriate
    Install-Sig -ComputerName . -SigFile Basic
    
