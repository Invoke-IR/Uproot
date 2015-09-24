function Remove-WmiEventConsumer
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

    begin
    {
        $parameters = @{
            'Namespace' = 'root\subscription'
            'Class' = '__EventConsumer'
            'ThrottleLimit' = $ThrottleLimit
            'AsJob' = $True
        }
    }

    process
    {
        $jobs = Get-WmiObject -ComputerName $ComputerName @parameters
            
        $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob

        $objects = $objects | Where-Object {$_.Name -eq $Name}
        
        foreach($obj in $objects)
        {
            $obj | Remove-WmiObject
        }
    }
}