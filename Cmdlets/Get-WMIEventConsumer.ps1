function Get-WMIEventConsumer
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True)]
        [ValidateSet('ActiveScript', 'CommandLine', 'LogFile', 'NtEventLog', 'SMTP')]
            [string]$ConsumerType
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
        $class = $ConsumerType + 'EventConsumer'
        $arrSet = (Get-WmiObject -Namespace root\subscription -Class $class).Name
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
        $class = $ConsumerType + 'EventConsumer'
    }

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            if($PSCmdlet.ParameterSetName -eq 'Name')
            {
                $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class $class -Filter "Name=`'$Name`'"
            }
            else
            {
                $objects = Get-WmiObject -ComputerName $computer -Namespace 'root\subscription' -Class $class
            }

            foreach($obj in $objects)
            {
                switch($ConsumerType)
                {
                    ActiveScript 
                    {
                        $props = @{
                            'ComputerName' = $obj.__SERVER;
                            'Path' = $obj.Path;
                            'Name' = $obj.Name;
                            'KillTimeout' = $obj.KillTimeout;
                            'MaximumQueueSize' = $obj.MaximumQueueSize;
                            'ScriptingEngine' = $obj.ScriptingEngine;
                            'ScriptFileName' = $obj.ScriptFileName;
                            'ScriptText' = $obj.ScriptText;
                        }
                        $obj = New-Object -TypeName PSObject -Property $props
                        $obj.PSObject.TypeNames.Insert(0, 'Uproot.ActiveScriptEventConsumer')
                    }
                    CommandLine 
                    {
                        $props = @{
                            'ComputerName' = $obj.__SERVER;
                            'Path' = $obj.Path;
                            'Name' = $obj.Name;
                            'CommandLineTemplate' = $obj.CommandLineTemplate;
                            'CreateNewProcessGroup' = $obj.CreateNewProcessGroup;
                            'CreateSeparateWowVdm' = $obj.CreateSeparateWowVdm;
                            'CreateSharedWowVdm' = $obj.CreateSharedWowVdm;
                            'ExecutablePath' = $obj.ExecutablePath;
                            'FillAttributes' = $obj.FillAttributes;
                            'ForceOffFeedback' = $obj.ForceOffFeedback;
                            'ForceOnFeedback' = $obj.ForceOnFeedback;
                            'KillTimeout' = $obj.KillTimeout;
                            'Priority' = $obj.Priority;
                            'RunInteractively' = $obj.RunInteractively;
                            'ShowWindowCommand' = $obj.ShowWindowCommand;
                            'UseDefaultErrorMode' = $obj.UseDefaultErrorMode;
                            'WindowTitle' = $obj.WindowTitle;
                            'WorkingDirectory' = $obj.WorkingDirectory;
                            'XCoordinate' = $obj.XCoordinate;
                            'XNumCharacters' = $obj.XNumCharacters;
                            'XSize' = $obj.XSize;
                            'YCoordinate' = $obj.YCoordinate;
                            'YNumCharacters' = $obj.YNumCharacters;
                            'YSize' = $obj.YSize;
                        }
                        $obj = New-Object -TypeName PSObject -Property $props
                        $obj.PSObject.TypeNames.Insert(0, 'Uproot.CommandLineEventConsumer')
                    }
                    LogFile 
                    {
                        $props = @{
                            'ComputerName' = $obj.__SERVER;
                            'Path' = $obj.Path;
                            'Name' = $obj.Name;
                            'Filename' = $obj.Filename;
                            'IsUnicode' = $obj.IsUnicode;
                            'MaximumFileSize' = $obj.MaximumFileSize;
                            'Text' = $obj.Text;
                        }
                        New-Object -TypeName PSObject -Property $props
                        $obj.PSObject.TypeNames.Insert(0, 'Uproot.LogFileEventConsumer')
                    }
                    NtEventLog 
                    {
                        $props = @{
                            'ComputerName' = $obj.__SERVER;
                            'Path' = $obj.Path;
                            'Name' = $obj.Name;
                            'Category' = $obj.Category;
                            'EventID' = $obj.EventID;
                            'EventType' = $obj.EventType;
                            'InsertionStringTemplates' = $obj.InsertionStringTemplates;
                            'NumberOfInsertionStrings' = $obj.NumberOfInsertionStrings;
                            'NameOfUserSidProperty' = $obj.NameOfUserSidProperty;
                            'NameOfRawDataProperty' = $obj.NameOfRawDataProperty;
                            'SourceName' = $obj.SourceName;
                            'UNCServerName' = $obj.UNCServerName;
                        }
                        $obj = New-Object -TypeName PSObject -Property $props
                        $obj.PSObject.TypeNames.Insert(0, 'Uproot.NtEventLogEventConsumer')
                    }
                    SMTP 
                    {
                        $props = @{
                            'ComputerName' = $obj.__SERVER;
                            'Path' = $obj.Path;
                            'Name' = $obj.Name;
                            'BccLine' = $obj.BccLine
                            'CcLine' = $obj.CcLine
                            'FromLine' = $obj.FromLine
                            'HeaderFields' = $obj.HeaderFields
                            'Message' = $obj.Message
                            'ReplyToLine' = $obj.ReplyToLine
                            'SMTPServer' = $obj.SMTPServer
                            'Subject' = $obj.Subject
                            'ToLine' = $obj.ToLine
                        }
                        $obj = New-Object -TypeName PSObject -Property $props
                        $obj.PSObject.TypeNames.Insert(0, 'Uproot.SMTPEventConsumer')
                    }
                }

                Write-Output $obj
            }
        }
    }
}