function Remove-WmiEventFilter
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string[]]$ComputerName = 'localhost',

        [Parameter()]
        [Int32]$ThrottleLimit = 32,

        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [string]$Name
    )

    process
    {
        $parameters = @{
            'Namespace' = 'root\subscription'
            'Class' = '__EventFilter'
            'Filter' = "Name=`'$($Name)`'"
            'ThrottleLimit' = $ThrottleLimit
            'AsJob' = $True
        }

        $jobs = Get-WmiObject -ComputerName $ComputerName @parameters

        $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob

        foreach($obj in $objects)
        {
            $obj | Remove-WmiObject
        }
    }
}