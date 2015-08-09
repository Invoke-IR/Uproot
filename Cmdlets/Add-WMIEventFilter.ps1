function Add-WmiEventFilter
{
    [CmdletBinding(DefaultParameterSetName = "Name")]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True, ParameterSetName = "Name")]
            [string]$Name,
        [Parameter(Mandatory = $False, ParameterSetName = "Name")]
            [string]$EventNamespace = 'root\cimv2',
        [Parameter(Mandatory = $True, ParameterSetName = "Name")]
            [string]$Query,
        [Parameter(Mandatory = $False, ParameterSetName = "Name")]
            [string]$QueryLanguage = 'WQL',
        [Parameter(Mandatory = $True, ParameterSetName = "FilterFile")]
            [string]$FilterFile

    )

    BEGIN
    {
        
    }

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            if($PSBoundParameters.ContainsKey("FilterFile")){
                Get-Content "$($UprootPath)\Filters\$($FilterFile).ps1" | Out-String | Invoke-Expression
                $props.Add('ComputerName', $computer)
                Add-WMIEventFilter @props
            }

            else
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
}