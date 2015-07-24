function Get-WmiEventFilter
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost'
    )

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = 'Name'
            
        # Create the dictionary 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            
        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $True
        $ParameterAttribute.ParameterSetName = 'Name'

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet 
        $arrSet = (Get-WmiObject -Namespace root\subscription -Class __EventFilter).Name
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
        $Name = $PSBoundParameters["Name"]
    }

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            if($PSCmdlet.ParameterSetName -eq "Name")
            {
                $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class '__EventFilter' -Filter "Name=`'$Name`'"
            }
            else
            {
                $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class '__EventFilter'
            }

            foreach($obj in $objects)
            {
                $props = @{
                    'ComputerName' = $obj.__SERVER;
                    'Path' = $obj.Path;
                    'EventNamespace' = $obj.EventNamespace;
                    'Name' = $obj.Name;
                    'Query' = $obj.Query;
                    'QueryLanguage' = $obj.QueryLanguage;
                }

                $obj = New-Object -TypeName PSObject -Property $props
                $obj.PSObject.TypeNames.Insert(0, 'Uproot.Filter')
                Write-Output $obj
            }
        }
    }
}