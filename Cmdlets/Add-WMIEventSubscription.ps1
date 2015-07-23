function Add-WMIEventSubscription
{
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True, ParameterSetName = 'Name')]
        [ValidateSet('ActiveScript', 'CommandLine', 'LogFile', 'NtEventLog', 'SMTP')]
            [string]$ConsumerType,
        [Parameter(Mandatory = $True, ParameterSetName = 'Path')]
            [string]$FilterPath,
        [Parameter(Mandatory = $True, ParameterSetName = 'Path')]
            [string]$ConsumerPath
    )

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = 'FilterName'
            
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
        
        # Set the dynamic parameters' name
        $ParameterName = 'ConsumerName'

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet 
        $class = $ConsumerType + 'EventConsumer'
        $arrSet1 = (Get-WmiObject -Namespace root\subscription -Class $class).Name
        $ValidateSetAttribute1 = New-Object System.Management.Automation.ValidateSetAttribute($arrSet1)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute1)

        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        
        return $RuntimeParameterDictionary
    }

    BEGIN
    {
        $FilterName = $PSBoundParameters["FilterName"]
        $ConsumerName = $PSBoundParameters["ConsumerName"]
    }

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            $class = [WMICLASS]"\\$computer\root\subscription:__FilterToConsumerBinding"
            
            $instance = $class.CreateInstance()
            if($PSCmdlet.ParameterSetName -eq 'Name')
            {
                $instance.Filter = (Get-WMIEventFilter -ComputerName $computer -Name $FilterName).Path
                $instance.Consumer = (Get-WMIEventConsumer -ComputerName $computer -ConsumerType $ConsumerType -Name $ConsumerName).Path
            }
            elseif($PSCmdlet.ParameterSetName -eq 'Path')
            {
                $instance.Filter = $FilterPath
                $instance.Consumer = $ConsumerPath
            }

            $instance.Put()
        }
    }
}