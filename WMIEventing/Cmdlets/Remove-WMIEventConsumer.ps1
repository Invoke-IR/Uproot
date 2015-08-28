function Remove-WmiEventConsumer
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter()]
            [string[]]$ComputerName = 'localhost',

        [Parameter()]
            [Int32]$ThrottleLimit = 32,
        
        [Parameter(Mandatory = $True, ParameterSetName = 'Name', Position = 0)]
            [string]$Name,

        [Parameter(Mandatory = $True, ParameterSetName = "InputObject", ValueFromPipeline = $True)]
            $InputObject
    )

    PROCESS
    {
        if($PSCmdlet.ParameterSetName -eq "InputObject")
        {
            ([WMI]$InputObject.Path).Delete()
        }
        else
        {
            $jobs = Get-WmiObject -ComputerName $ComputerName -Namespace 'root\subscription' -Class __EventConsumer -AsJob -ThrottleLimit $ThrottleLimit
            
            $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob

            if($PSCmdlet.ParameterSetName -eq 'Name')
            {
                $objects = $objects | Where-Object {$_.Name -eq $Name}
            }
        
            foreach($obj in $objects)
            {
                $obj | Remove-WmiObject
            }
        }
    }
}