#Uproot

Developed by [@jaredcatkinson](https://twitter.com/jaredcatkinson), [@harmjoy](https://twitter.com/harmj0y), and [@sixdub](https://twitter.com/sixdub)

## Cmdlets
### Event Filter (__EventFilter):
    Add-WMIEventFilter                -   
    Get-WMIEventFilter                -   
    Remove-WMIEventFilter             -   

### Event Consumers (__EventConsumer):
    Add-WMIEventConsumer              -   
    Get-WMIEventConsumer              -   
    Remove-WMIEventConsumer           -   

### Event Subscription (__FilterToConsumerBinding):
    Add-WMIEventSubscription          -   
    Get-WMIEventSubscription          -   
    Remove-WMIEventSubscription       -   
    
## Classes
### Windows Artifacts
    Uproot.Filter                     -   
    Uproot.ActiveScriptEventConsumer  -   
    Uproot.CommandLineEventConsumer   -   
    Uproot.LogFileEventConsumer       -   
    Uproot.NtEventLogEventConsumer    -   
    Uproot.SMTPEventConsumer          -   
    Uproot.Subscription               -   
