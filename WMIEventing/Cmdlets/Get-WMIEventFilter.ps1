function Get-WmiEventFilter
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter()]
        [string[]]$ComputerName = 'localhost',

        [Parameter()]
        [Int32]$ThrottleLimit = 32,
        
        [Parameter(Mandatory, ParameterSetName = "Name", Position = 0)]
        [string]$Name
    )

    begin
    {
        if($PSCmdlet.ParameterSetName -eq 'Name')
        {
            $parameters = @{
                'Namespace' = 'root\subscription'
                'Class' = '__EventFilter'
                'ThrottleLimit' = $ThrottleLimit
                'Filter' = "Name=`'$($Name)`'"
                'AsJob' = $True
            }
        }
        else
        {
            $parameters = @{
                'Namespace' = 'root\subscription'
                'Class' = '__EventFilter'
                'ThrottleLimit' = $ThrottleLimit
                'AsJob' = $True
            }
        }
    }

    process
    {
        $jobs = Get-WmiObject -ComputerName $ComputerName @parameters

        $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob
        
        foreach($obj in $objects)
        {
            $props = @{
                'ComputerName' = $obj.__SERVER;
                'Path' = $obj.Path;
                'EventNamespace' = $obj.EventNamespace;
                'Name' = $obj.Name;
                'Query' = $obj.Query;
                'QueryLanguage' = $obj.QueryLanguage;
            }

            $obj = New-Object -TypeName PSObject -Property $props
            $obj.PSObject.TypeNames.Insert(0, 'WMIEventing.Filter')
            Write-Output $obj
        }
    }
}