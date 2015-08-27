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
            [string]$ConsumerName
    )

    BEGIN
    {
        $props = @{
            'Filter' = "\\.\ROOT\subscription:__EventFilter.Name=`"$($FilterName)`"";
            'Consumer' = "\\.\ROOT\subscription:__EventConsume.Name=`"$($ConsumerName)`"";
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