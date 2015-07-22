function Add-WMIEventFilter
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True)]
            [string]$Name,
        [Parameter(Mandatory = $False)]
            [string]$EventNamespace = 'root\cimv2',
        [Parameter(Mandatory = $True)]
            [string]$Query,
        [Parameter(Mandatory = $False)]
            [string]$QueryLanguage = 'WQL'
    )

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            $class = [WMICLASS]"\\$computer\root\subscription:__EventFilter"

            $instance = $class.CreateInstance()
            $instance.Name = $Name
            $instance.EventNamespace = $EventNamespace
            $instance.Query = $Query
            $instance.QueryLanguage = $QueryLanguage
            $instance.Put()
        }
    }
}