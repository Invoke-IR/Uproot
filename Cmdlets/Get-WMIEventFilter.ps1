function Get-WMIEventFilter
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $False, ParameterSetName = 'Name')]
            [string]$Name
    )
    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            if($PSCmdlet.ParameterSetName -eq "Name")
            {
                $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class '__EventFilter' -Filter "Name=`'$Name`'"
            }
            else
            {
                $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class '__EventFilter'
            }

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
                $obj.PSObject.TypeNames.Insert(0, 'Uproot.Filter')
                Write-Output $obj
            }
        }
    }
}