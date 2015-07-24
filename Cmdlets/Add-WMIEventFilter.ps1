function Add-WmiEventFilter
{
    [CmdletBinding(DefaultParameterSetName = "Name")]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True, ParameterSetName = "Name")]
            [string]$Name,
        [Parameter(Mandatory = $False, ParameterSetName = "Name")]
            [string]$EventNamespace = 'root\cimv2',
        [Parameter(Mandatory = $True, ParameterSetName = "Name")]
            [string]$Query,
        [Parameter(Mandatory = $False, ParameterSetName = "Name")]
            [string]$QueryLanguage = 'WQL'
    )

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = 'FilterFile'
            
        # Create the dictionary 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            
        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $True
        $ParameterAttribute.ParameterSetName = "FilterFile"

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet 
        $arrSet = (Get-ChildItem $UprootPath\Filters -Filter *.ps1).BaseName
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
        $FilterFile = $PSBoundParameters["FilterFile"]
    }

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            if($PSBoundParameters.ContainsKey("FilterFile")){
                Get-Content "$($UprootPath)\Filters\$($FilterFile).ps1" | Out-String | Invoke-Expression
                Add-WMIEventFilter @props
            }

            else
            {
                $class = [WMICLASS]"\\$computer\root\subscription:__EventFilter"

                $instance = $class.CreateInstance()
                $instance.Name = $Name
                $instance.EventNamespace = $EventNamespace
                $instance.Query = $Query
                $instance.QueryLanguage = $QueryLanguage
                $instance.Put()
            }
        }
    }
}