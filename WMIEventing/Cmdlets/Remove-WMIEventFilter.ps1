function Remove-WmiEventFilter
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter()]
            [string[]]$ComputerName = 'localhost',

        [Parameter()]
            [Int32]$ThrottleLimit = 32,

        [Parameter(Mandatory = $True, ParameterSetName = "Name", Position = 0)]
            [string]$Name,

        [Parameter(Mandatory = $True, ParameterSetName = "InputObject", ValueFromPipeline = $True)]
            $InputObject
    )

    PROCESS
    {
        if($PSCmdlet.ParameterSetName -eq "InputObject")
        {
            foreach($obj in $InputObject)
            {
                ([WMI]$obj.Path).Delete()
            }
        }
        else
        {
            if($PSCmdlet.ParameterSetName -eq "Name")
            {
                $jobs = Get-WmiObject -ComputerName $ComputerName -Namespace 'root\subscription' -Class '__EventFilter' -Filter "Name=`'$($Name)`'" -AsJob -ThrottleLimit $ThrottleLimit
            }
            else
            {
                $jobs = Get-WmiObject -ComputerName $ComputerName -Namespace 'root\subscription' -Class '__EventFilter' -AsJob -ThrottleLimit $ThrottleLimit
            }

            $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob

            foreach($obj in $objects)
            {
                $obj | Remove-WmiObject
            }
        }
    }
}