function Remove-WmiEventSubscription
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
            if($PSCmdlet.ParameterSetName -eq 'Name')
            {
                $objects = Get-WmiObject -ComputerName $computer -Namespace root\subscription -Class __FilterToConsumerBinding -Filter "__RELPATH LIKE `'%$Name%`'"
            }
            else
            {
                $objects = Get-WmiObject -ComputerName $computer -Namespace root\subscription -Class __FilterToConsumerBinding
            }

            foreach($obj in $objects)
            {
                $obj | Remove-WmiObject
            }
        }
    }
}