function Remove-WmiEventSubscription
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter()]
            [string[]]$ComputerName = 'localhost',

        [Parameter()]
            [Int32]$ThrottleLimit = 32,

        #[Parameter()]
        #    [switch]$Force,
        
        [Parameter(Mandatory = $True, ParameterSetName = 'Name', Position = 0)]
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
            $jobs = Get-WmiObject -ComputerName $ComputerName -Namespace root\subscription -Class __FilterToConsumerBinding -AsJob -ThrottleLimit $ThrottleLimit
            
            $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob

            if($PSCmdlet.ParameterSetName -eq 'Name')
            {
                $objects = $objects | Where-Object {$_.Filter.Split('"')[1].Split('"')[0] -eq $Name}
            }
            
            foreach($obj in $objects)
            {
                $obj | Remove-WmiObject
            }
        }
    }
}