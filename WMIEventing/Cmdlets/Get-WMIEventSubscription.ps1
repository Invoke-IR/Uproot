function Get-WmiEventSubscription
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter()]
        [string[]]$ComputerName = 'localhost',

        [Parameter()]
        [Int32]$ThrottleLimit = 32,

        [Parameter(Mandatory, ParameterSetName = 'Name', Position = 0)]
        [string]$Name
    )

    begin
    {
        $parameters = @{
            'Namespace' = 'root\subscription'
            'Class' = '__FilterToConsumerBinding'
            'ThrottleLimit' = $ThrottleLimit
            'AsJob' = $True
        }
    }

    process
    { 
        $jobs = Get-WmiObject -ComputerName $ComputerName @parameters

        $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob

        if($PSCmdlet.ParameterSetName -eq 'Name')
        {
            $objects = $objects | Where-Object {$_.Filter.Split('"')[1].Split('"')[0] -eq $Name} 
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
            $obj.PSObject.TypeNames.Insert(0, 'WMIEventing.Subscription')
            Write-Output $obj
        }
    }
}