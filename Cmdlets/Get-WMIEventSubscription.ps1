function Get-WmiEventSubscription
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $False, ParameterSetName = 'Name', Position = 0)]
            [string]$Name
    )

    PROCESS
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
                # Derive Filter Name
                $FilterName = $obj.Filter.Split('"')[1]
                $FilterPath = $obj.Filter

                # Derive Consumer Name
                $ConsumerName = $obj.Consumer.Split('"')[1]
                $ConsumerType = $obj.Consumer.Split(":")[1].Split(".")[0]
                $ConsumerPath = $obj.Consumer

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