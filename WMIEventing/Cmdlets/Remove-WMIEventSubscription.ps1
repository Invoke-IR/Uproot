function Remove-WmiEventSubscription
{
    [CmdletBinding()]
    Param(
        [Parameter()]
            [string[]]$ComputerName = 'localhost',

        [Parameter()]
            [Int32]$ThrottleLimit = 32,
        [Alias('FilterName')]
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
            [string]$Name
    )

    begin
    {
        $args = @{
            'Namespace' = 'root\subscription'
            'Class' = '__FilterToConsumerBinding'
            'ThrottleLimit' = $ThrottleLimit
            'AsJob' = $True
        }
    }
    process
    {
        $jobs = Get-WmiObject -ComputerName $ComputerName @args 
            
        $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob

        $objects = $objects | Where-Object {$_.Filter.Split('"')[1].Split('"')[0] -eq $Name}
            
        foreach($obj in $objects)
        {
            $obj | Remove-WmiObject
        }
    }
}