function Remove-WmiEventFilter
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory = $False)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True, ParameterSetName = "Name", Position = 0)]
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
                    $obj | Remove-WmiObject
                }
            }
        }
    }
}