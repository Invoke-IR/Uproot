function Install-UprootSignature
{
    [CmdletBinding()]
    Param
    (
        [Parameter()]
            [string[]]$ComputerName = 'localhost',

        [Parameter(Mandatory = $True)]
            [string]$SigFile
    )

    BEGIN
    {

    }

    PROCESS
    {
        . "$($UprootPath)\Sigs\$($SigFile).ps1"

        [System.Collections.ArrayList]$filters = @()
        [System.Collections.ArrayList]$consumers = @()

        foreach ($s in $subscriptions.GetEnumerator())
        {
            $filters.add($s.Name) | out-null
            $consumers.add($s.Value) | out-null
        }

        #Parse Filters
        $uniqfilters = $filters | select -Unique
        if($uniqfilters.Count -gt 1)
        { 
            $filters = $uniqfilters
        }
        else
        {
            $filters = @($uniqfilters)
        }

        #Parse Consumers 
        $uniqconsumers = $consumers | select -Unique
        if($uniqconsumers.Count -gt 1)
        { 
            $consumers = $uniqconsumers 
        }
        else
        {
            $consumers = @($uniqconsumers)
        }

        #Add all objects
        foreach($f in $filters)
        {
            . "$($UprootPath)\Filters\$($f).ps1"
            Add-WmiEventFilter -ComputerName $ComputerName @props
        }
        foreach ($c in $consumers)
        {
            . "$($UprootPath)\Consumers\$($c).ps1"
            Add-WmiEventConsumer -ComputerName $ComputerName @props
        }

        foreach ($s in $subscriptions.GetEnumerator())
        {
            Add-WmiEventSubscription -ComputerName $ComputerName -FilterName $s.Name -ConsumerName $s.Value
        }
    }
}