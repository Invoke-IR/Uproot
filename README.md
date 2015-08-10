#Uproot

Developed by [@jaredcatkinson](https://twitter.com/jaredcatkinson)

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
    AS_ExtrinsicHTTPPOST
    AS_IntrinsicHTTPPOST
    
## Examples
    Add-WmiEventFilter -FilterFile ProcessStartTrace
    Add-WmiEventConsumer -ConsumerFile AS_ExtrinsicHTTPPOST
    Add-WmiEventSubscription -FilterName ProcessStartTrace -ConsumerName AS_ExtrinsicHTTPPOST
    
    
