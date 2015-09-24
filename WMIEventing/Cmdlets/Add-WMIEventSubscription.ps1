function Add-WmiEventSubscription
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string[]]$ComputerName = 'localhost',

        [Parameter()]
        [Int32]$ThrottleLimit = 32,

        [Parameter(Mandatory)]
        [string]$FilterName,
        
        [Parameter(Mandatory)]
        [ValidateSet('ActiveScriptEventConsumer', 'CommandLineEventConsumer', 'LogFileEventConsumer', 'NtEventLogEventConsumer', 'SMTPEventConsumer')]
        [string]$ConsumerType,

        [Parameter(Mandatory)]
        [string]$ConsumerName
    )

    begin
    {
        $props = @{
            'Filter' = "\\.\ROOT\subscription:__EventFilter.Name=`"$($FilterName)`""
            'Consumer' = "\\.\ROOT\subscription:$($ConsumerType).Name=`"$($ConsumerName)`""
        }

        $parameters = @{
            'Namespace' = 'root\subscription'
            'Class' = '__FilterToConsumerBinding'
            'Arguments' = $props
            'ThrottleLimit' = $ThrottleLimit
            'AsJob' = $True
        }
    }

    process
    {
        $jobs = Set-WmiInstance -ComputerName $ComputerName @parameters
    }

    end
    {
        Receive-Job -Job $jobs -Wait -AutoRemoveJob
    }
}