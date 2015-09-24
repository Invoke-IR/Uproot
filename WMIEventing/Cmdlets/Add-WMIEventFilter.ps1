function Add-WmiEventFilter
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [string[]]$ComputerName = 'localhost',

        [Parameter()]
        [Int32]$ThrottleLimit = 32,

        [Parameter(Mandatory)]
        [string]$Name,
        
        [Parameter()]
        [string]$EventNamespace = 'root\cimv2',
        
        [Parameter(Mandatory)]
        [string]$Query,
        
        [Parameter()]
        [string]$QueryLanguage = 'WQL' 
    )

    begin
    {
        $props = @{
            'Name' = $Name
            'EventNamespace' = $EventNamespace
            'Query' = $Query
            'QueryLanguage' = $QueryLanguage
        }

        $parameters = @{
            'Namespace' = 'root\subscription'
            'Class' = '__EventFilter'
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