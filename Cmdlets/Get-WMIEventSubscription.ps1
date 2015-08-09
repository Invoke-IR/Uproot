function Get-WmiEventSubscription
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
                # Derive Filter Name
                $FilterName = $obj.Filter.Split('"')[1]
                $FilterPath = $obj.__PATH.Split(':')[0] + ":" + $obj.Filter

                # Derive Consumer Name
                $ConsumerName = $obj.Consumer.Split('"')[1]
                $ConusumerType = $obj.Consumer.Split(".")[0]
                $ConsumerPath = $obj.__PATH.Split(':')[0] + ":" + $obj.Consumer

                $props = @{
                    'ComputerName' = $obj.__SERVER;
                    'Path' = $obj.__PATH;
                    'FilterName' = $FilterName;
                    'FilterPath' = $FilterPath;
                    'ConsumerType' = $ConsumerType;
                    'ConsumerName' = $ConsumerName;
                    'ConsumerPath' = $ConsumerPath;
                }

                $obj = New-Object -TypeName PSObject -Property $props | Write-Output
                $obj.PSObject.TypeNames.Insert(0, 'Uproot.Subscription')
                Write-Output $obj
            }
        }
    }
}