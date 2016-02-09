function Uninstall-UprootSignature {
[CmdletBinding(DefaultParameterSetName = 'None')]
    Param
    (
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession,

        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [String]
        $FilterName,

        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConsumerName,        

        [Parameter()]
        [Switch]
        $RemoveFilterAndConsumer,

        [Parameter()]
        [Int32]
        $ThrottleLimit = 32
    )

    process {
        if($PSBoundParameters['CimSession']) {
            if($PSBoundParameters['FilterName'])
            {
                $Subscription = Get-WmiEventSubscription -CimSession $CimSession | Where-Object {
                    ($_.Filter.Name -like $FilterName) -and ($_.Consumer.Name -like $ConsumerName)
                }
                $Subscription | Remove-CimInstance

                if($RemoveFilterAndConsumer)
                {
                    # if we're removing the associated filter and consumer as well

                    Get-WmiEventFilter -CimSession $CimSession -Name $FilterName | Remove-CimInstance

                    $Consumer = Get-WmiEventConsumer -CimSession $CimSession | Where-Object {
                        $_.Name -like $ConsumerName
                    }
                    $Consumer | Remove-CimInstance
                }
            }
            else
            {
                # if we're removing all subscriptions (and/or filters/consumers)

                Get-WmiEventSubscription -CimSession $CimSession | Remove-CimInstance

                if($RemoveFilterAndConsumer)
                {
                    Get-WmiEventFilter -CimSession $CimSession | Remove-CimInstance
                    Get-WmiEventConsumer -CimSession $CimSession | Remove-CimInstance
                }
            }
        }
        else {
            if($PSBoundParameters['FilterName'])
            {
                $Subscription = Get-WmiEventSubscription -ComputerName 'localhost' | Where-Object {
                    ($_.Filter.Name -like $FilterName) -and ($_.Consumer.Name -like $ConsumerName)
                }
                $Subscription | Remove-CimInstance

                if($RemoveFilterAndConsumer)
                {
                    # if we're removing the associated filter and consumer as well

                    Get-WmiEventFilter -ComputerName 'localhost' -Name $FilterName | Remove-CimInstance

                    $Consumer = Get-WmiEventConsumer -ComputerName 'localhost' | Where-Object {
                        $_.Name -like $ConsumerName
                    }
                    $Consumer  | Remove-CimInstance
                }
            }
            else
            {
                # if we're removing all subscriptions (and/or filters/consumers)

                Get-WmiEventSubscription -ComputerName 'localhost' | Remove-CimInstance

                if($RemoveFilterAndConsumer)
                {
                    Get-WmiEventFilter -ComputerName 'localhost' | Remove-CimInstance
                    Get-WmiEventConsumer -ComputerName 'localhost' | Remove-CimInstance
                }
            }
        }
    }
}
