function Remove-WmiEventSubscription
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

    PROCESS
    {
        if($PSCmdlet.ParameterSetName -eq "InputObject")
        {
            $Name = $InputObject.Filter.Name
            $computer = $InputObject.ComputerName
            $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class __FilterToConsumerBinding -Filter "__RELPATH LIKE `'%$Name%`'" | Remove-WmiObject
        }
        else
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
}