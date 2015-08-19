function Install-Sig {
[CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = '.'
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
        $ParameterAttribute.ParameterSetName = 'SigFile'

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
        foreach($computer in $ComputerName)
        {
            if($PSBoundParameters.ContainsKey("SigFile"))
            {
                Get-Content "$($UprootPath)\Sigs\$($SigFile).ps1" | Out-String | Invoke-Expression

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
                foreach($f in $filters){
                    Add-WmiEventFilter -ComputerName $computer -FilterFile $f
                }
                foreach ($c in $consumers){
                    Add-WmiEventConsumer -ComputerName $computer -ConsumerFile $c
                }

                foreach ($s in $subscriptions.GetEnumerator())
                {
                  Add-WmiEventSubscription -ComputerName $computer -FilterName $_.Name -ConsumerName $_.Value
                }
            }

            else
            {
                Write-Error "Require Sig File"
            }
        }
    }
}