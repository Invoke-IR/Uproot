function Add-WmiEventSubscription
{
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',

        [Parameter()]
            [Int32]$ThrottleLimit = 32,

        [Parameter(Mandatory = $True)]
            [string]$FilterName,
        
        [Parameter(Mandatory = $True)]
        [ValidateSet('ActiveScriptEventConsumer', 'CommandLineEventConsumer', 'LogFileEventConsumer', 'NtEventLogEventConsumer', 'SMTPEventConsumer')]
            [string]$ConsumerType,

        [Parameter(Mandatory = $True)]
            [string]$ConsumerName
    )

    BEGIN
    {
        $props = @{
            'Filter' = "\\.\ROOT\subscription:__EventFilter.Name=`"$($FilterName)`"";
            'Consumer' = "\\.\ROOT\subscription:$($ConsumerType).Name=`"$($ConsumerName)`"";
        }
    }

    PROCESS
    {
        $jobs = Set-WmiInstance -ComputerName $ComputerName -Namespace root\subscription -Class __FilterToConsumerBinding -Arguments $props -AsJob -ThrottleLimit $ThrottleLimit 
    }

    END
    {
        Receive-Job -Job $jobs -Wait -AutoRemoveJob
    }
}