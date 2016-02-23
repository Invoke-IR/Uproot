function Deploy-Subscription
{
    Param(
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession
    )
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-ShareCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName EXT-WmiRemoteRegistryMethods
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName EXT-WmiProcessEnum
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName EXT-ProcessStartTrace
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-ShadowCopyCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-StartupCommandCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-NetworkConnectionCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-ServiceCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-ServerConnectionCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName EXT-ProcessCreateMethod
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName EXT-WmiComputerSystemEnum
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-DriverCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-ProcessCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-UserCreation
    Start-Sleep -Milliseconds 500
    New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -ConsumerName AS_GenericHTTP -FilterName INT-ScheduledJobCreation
    Start-Sleep -Milliseconds 500
}