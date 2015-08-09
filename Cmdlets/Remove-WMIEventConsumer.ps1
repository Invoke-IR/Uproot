function Remove-WmiEventConsumer
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory = $False)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True, ParameterSetName = 'Name')]
            [string]$Name,
        [Parameter(Mandatory = $True, ParameterSetName = "InputObject", ValueFromPipeline = $True)]
            $InputObject
    )

    BEGIN
    {

    }

    PROCESS
    {
        if($PSCmdlet.ParameterSetName -eq "InputObject")
        {
            $Name = $InputObject.Name
            $computer = $InputObject.ComputerName
            $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class __EventConsumer -Filter "__PATH LIKE `'%$Name%`'"
        }
        else
        {
            foreach($computer in $ComputerName)
            {
                if($PSCmdlet.ParameterSetName -eq 'Name')
                {
                    $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class __EventConsumer -Filter "__PATH LIKE `'%$Name%`'"
                }
                else
                {
                    $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class __EventConsumer
                }
            }
        }
        foreach($obj in $objects)
        {
            $obj | Remove-WmiObject
        }
    }
}