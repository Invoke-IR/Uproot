function Remove-WmiEventSubscription
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory = $False)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $False)]
            [switch]$Force,
        [Parameter(Mandatory = $True, ParameterSetName = 'Name', Position = 0)]
            [string]$Name,
        [Parameter(Mandatory = $True, ParameterSetName = "InputObject", ValueFromPipeline = $True)]
            $InputObject
    )

    PROCESS
    {
        if($PSCmdlet.ParameterSetName -eq "InputObject")
        {
            if($Force)
            {
                try
                {
                    ([WMI]$InputObject.FilterPath).Delete()
                }
                catch
                {
                    Write-Warning "Instance of $InputObject.FilterPath does not exist"
                }

                try
                {
                    ([WMI]$InputObject.ConsumerPath).Delete()
                }
                catch
                {
                    Write-Warning "Instance of $InputObject.ConsumerPath does not exist"
                }
            }
            ([WMI]$InputObject.Path).Delete()
        }
        else
        {
            foreach($computer in $ComputerName)
            {
                if($PSCmdlet.ParameterSetName -eq 'Name')
                {
                    $objects = Get-WmiObject -ComputerName $computer -Namespace root\subscription -Class __FilterToConsumerBinding | Where-Object {$_.Filter.Split('"')[1].Split('"')[0] -eq $Name}
                }
                else
                {
                    $objects = Get-WmiObject -ComputerName $computer -Namespace root\subscription -Class __FilterToConsumerBinding
                }

                foreach($obj in $objects)
                {
                    if($Force)
                    {
                        try
                        {
                            ([WMI]$InputObject.Filter).Delete()
                        }
                        catch
                        {
                            Write-Warning "Instance of $InputObject.FilterPath does not exist"
                        }

                        try
                        {
                            ([WMI]$obj.Consumer).Delete()
                        }
                        catch
                        {
                            Write-Warning "Instance of $InputObject.ConsumerPath does not exist"
                        }
                    }
                    $obj | Remove-WmiObject
                }
            }
        }
    }
}