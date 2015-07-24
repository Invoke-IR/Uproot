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
                
                # Derive Consumer Type
                if($obj.Consumer.Contains(':'))
                {
                    $ConsumerType = $obj.Consumer.Split(':')[1].Split('.')[0].Replace('EventConsumer', '')
                }
                else
                {
                    $ConsumerType = $obj.Consumer.Split('.')[0].Replace('EventConsumer', '')
                }

                # Derive Consumer Name
                $ConsumerName = $obj.Consumer.Split('"')[1]

                $Filter = Get-WMIEventFilter -ComputerName $computer -Name $FilterName 
                $Consumer = Get-WMIEventConsumer -ComputerName $computer -ConsumerType $ConsumerType -Name $ConsumerName

                $props = @{
                    'ComputerName' = $obj.__SERVER;
                    'Filter' = $Filter;
                    'FilterName' = $FilterName;
                    'FilterPath' = $Filter.Path;
                    'Consumer' = $Consumer;
                    'ConsumerType' = $ConsumerType;
                    'ConsumerName' = $ConsumerName;
                    'ConsumerPath' = $Consumer.Path;
                }

                $obj = New-Object -TypeName PSObject -Property $props | Write-Output
                $obj.PSObject.TypeNames.Insert(0, 'Uproot.Subscription')
                Write-Output $obj
            }
        }
    }
}