function Install-UprootSignature
{
    [CmdletBinding()]
    Param
    (
        [Parameter()]
            [string[]]$ComputerName = 'localhost'
    )

    DynamicParam {
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
        $arrSet = (Get-ChildItem -Path "$($UprootPath)\Sigs").BaseName
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
    }

    BEGIN
    {
        $SigFile = $PSBoundParameters['SigFile']
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
            switch($s.Value.Split('_')[0])
            {
                'AS'{$ConsumerType = 'ActiveScriptEventConsumer'; break}
                'CL'{$ConsumerType = 'CommandLineEventConsumer'; break}
                'LF'{$ConsumerType = 'LogFileEventConsumer'; break}
                'EL'{$ConsumerType = 'NtEventLogEventConsumer'; break}
                'SMTP'{$ConsumerType = 'SMTPEventConsumer'; break}
                'Default'{Write-Error "Invalid prefix on consumer name for $($s.Value)."; break}
            }

            Add-WmiEventSubscription -ComputerName $ComputerName -FilterName $s.Name -ConsumerName $s.Value -ConsumerType $ConsumerType
        }
    }
}