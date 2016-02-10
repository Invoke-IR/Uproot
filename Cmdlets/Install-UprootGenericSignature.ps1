function Install-UprootGenericSignature {
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
        $ThrottleLimit = 32,

        [Parameter(Mandatory)]
        [ValidateSet("HTTP","EventLog")]
        [String]
        $Consumer
    )

    begin {
        Write-Verbose "Deplying signature to $($CimSession.count) machines"
    }
    
    process
    {
        if($Consumer -eq 'HTTP')
        {
            $Arguments = @{
                CimSession = $CimSession;
                FilterName = $FilterName;
                FilterNamespace = $FilterNamespace;
                FilterQuery = $FilterQuery;
                ThrottleLimit = $ThrottleLimit;
            }
            Install-GenericHTTPSignature @Arguments
        }
        elseif($Consumer -eq 'EventLog')
        {
            # TODO: implement New-GenericEventLogSignature
            Throw "New-GenericEventLogSignature not yet implemented!"
        }
    }
}
