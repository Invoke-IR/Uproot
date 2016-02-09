function Install-UprootSignature {
[CmdletBinding()]
    Param
    (
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession,

        [Parameter()]
        [Int32]
        $ThrottleLimit = 32
    )

    DynamicParam 
    {
        # Set the dynamic parameters' name
        $ParameterName = 'SigFile'
            
        # Create the dictionary 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            
        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet 
        $arrSet = (Get-ChildItem -Path "$($UprootPath)\Signatures").BaseName
        #$arrSet = (Get-ChildItem -Path 'C:\Users\tester\Documents\WindowsPowerShell\Modules\Uproot\Signatures').BaseName
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
    }

    begin
    {
        $SigFile = $PSBoundParameters['SigFile']
    }

    process
    {
        Get-Content "$($UprootPath)\Signatures\$($SigFile).ps1" | Out-String | Invoke-Expression
        #Get-Content "C:\Users\tester\Documents\WindowsPowerShell\Modules\Uproot\Signatures\$($SigFile).ps1" | Out-String | Invoke-Expression

        [System.Collections.ArrayList]$filters = @()
        [System.Collections.ArrayList]$consumers = @()

        foreach ($s in $subscriptions.GetEnumerator())
        {
            $filters.add($s.Name) | Out-Null
            $consumers.add($s.Value) | Out-Null
        }

        #Parse Filters
        $uniqfilters = $filters | Select-Object -Unique
        if($uniqfilters.Count -gt 1)
        { 
            $filters = $uniqfilters
        }
        else
        {
            $filters = @($uniqfilters)
        }

        #Parse Consumers 
        $uniqconsumers = $consumers | Select-Object -Unique
        if($uniqconsumers.Count -gt 1)
        { 
            $consumers = $uniqconsumers 
        }
        else
        {
            $consumers = @($uniqconsumers)
        }

        if($PSBoundParameters['CimSession'])
        {
            #Add all objects
            foreach($f in $filters)
            {
                . "$($UprootPath)\Filters\$($f).ps1"
                New-WmiEventFilter @props -CimSession $CimSession -ThrottleLimit $ThrottleLimit
            }
            foreach ($c in $consumers)
            {
                . "$($UprootPath)\Consumers\$($c).ps1"
                New-WmiEventConsumer @props -CimSession $CimSession -ThrottleLimit $ThrottleLimit
            }
            foreach ($s in $subscriptions.GetEnumerator())
            {
                New-WmiEventSubscription -CimSession $CimSession -ConsumerType ActiveScriptEventConsumer -FilterName $s.Name -ConsumerName $s.Value
            }
        }
        else
        {
            #Add all objects
            foreach($f in $filters)
            {
                . "$($UprootPath)\Filters\$($f).ps1"
                New-WmiEventFilter @props -ComputerName 'localhost'
            }
            foreach ($c in $consumers)
            {
                . "$($UprootPath)\Consumers\$($c).ps1"
                New-WmiEventConsumer @props -ComputerName 'localhost'
            }
            foreach ($s in $subscriptions.GetEnumerator())
            {
                New-WmiEventSubscription -ConsumerType ActiveScriptEventConsumer -FilterName $s.Name -ConsumerName $s.Value -ComputerName 'localhost'
            } 
        }
    }
}