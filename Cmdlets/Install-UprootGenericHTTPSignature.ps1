function Install-UprootGenericHTTPSignature {
[CmdletBinding()]
    Param
    (
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FilterName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]
        $FilterNamespace = 'root/cimv2',

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FilterQuery,

        [Parameter()]
        [Int32]
        $ThrottleLimit = 32
    )
    
    process
    {
        if($PSBoundParameters['CimSession'])
        {
            # build the properties for our custom-specified filter and create the new filter
            $FilterProps = @{
                Name = $FilterName;
                EventNamespace = $FilterNamespace;
                Query = $FilterQuery;
                QueryLanguage = 'WQL';
                CimSession = $CimSession;
                ThrottleLimit = $ThrottleLimit;
            }
            $Null = New-WmiEventFilter @FilterProps

            # the consumer is always going to be static for this script
            . "$($UprootPath)\Consumers\AS_GenericHTTP.ps1"
            $Null = New-WmiEventConsumer @props -CimSession $CimSession -ThrottleLimit $ThrottleLimit -ErrorAction SilentlyContinue
            
            $Null = New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -FilterName $FilterName -ConsumerName 'AS_GenericHTTP' -ErrorVariable err
            $err | ForEach-Object {
                Write-Warning "Error in executing New-WmiEventSubscription : $_"
            }
        }
        else
        {
            # if there's no CimSession, we're deploying the signature to the local system

            # the consumer is always going to be static for this script
            . "$($UprootPath)\Consumers\AS_GenericHTTP.ps1"
            $Null = New-WmiEventConsumer @props -ComputerName 'localhost' -ErrorAction SilentlyContinue

            # build the properties for our custom-specified filter and create the new filter
            $FilterProps = @{
                'Name' = $FilterName;
                'EventNamespace' = $FilterNamespace;
                'Query' = $FilterQuery;
                'QueryLanguage' = 'WQL';
                'ComputerName' = 'localhost';
                'ThrottleLimit' = $ThrottleLimit;
            }
            $Null = New-WmiEventFilter @FilterProps

            $Null = New-WmiEventSubscription -ConsumerType ActiveScriptEventConsumer -FilterName $FilterName -ConsumerName 'AS_GenericHTTP' -ComputerName 'localhost' -ErrorVariable err
            $err | ForEach-Object {
                Write-Warning "Error in executing New-WmiEventSubscription : $_"
            }
        }
    }
}
