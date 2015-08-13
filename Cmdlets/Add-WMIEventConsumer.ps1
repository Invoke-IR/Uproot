function Add-WmiEventConsumer
{
    [CmdletBinding(DefaultParameterSetName = 'ConsumerFile')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
#        [Parameter(Mandatory = $True, ParameterSetName = 'ConsumerFile')]
#            [string]$ConsumerFile,
        [Parameter(Mandatory = $True, ParameterSetName = 'ActiveScriptFile')] 
        [Parameter(Mandatory = $True, ParameterSetName = 'ActiveScriptText')] 
        [Parameter(Mandatory = $True, ParameterSetName = 'CommandLine')]
        [Parameter(Mandatory = $True, ParameterSetName = "LogFile")]
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLog")]
        [Parameter(Mandatory = $True, ParameterSetName = "SMTP")]
            [string]$Name,
        [Parameter(Mandatory = $False, ParameterSetName = 'ActiveScriptFile')]
        [Parameter(Mandatory = $False, ParameterSetName = 'ActiveScriptText')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [UInt32]$KillTimeout = 0,

        #region ActiveScriptParameters
        [Parameter(Mandatory = $False, ParameterSetName = 'ActiveScriptFile')]
        [Parameter(Mandatory = $False, ParameterSetName = 'ActiveScriptText')] 
        [ValidateSet("VBScript", "jscript")]
            [string]$ScriptingEngine = "VBScript",
        [Parameter(Mandatory = $True, ParameterSetName = 'ActiveScriptFile')] 
        [ValidateNotNull()]
            [string]$ScriptFileName,
        [Parameter(Mandatory = $True, ParameterSetName = 'ActiveScriptText')] 
        [ValidateNotNull()]
            [string]$ScriptText,
        #endregion ActiveScriptParameters
        
        #region CommandLineParameters
        [Parameter(Mandatory = $True, ParameterSetName = 'CommandLineTemplate')]
        #Validate executable exists
            [string]$CommandLineTemplate,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [bool]$CreateNewProcessGroup = $True,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [bool]$CreateSeparateWowVdm = $False,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [bool]$CreateSharedWowVdm = $False,
        [Parameter(Mandatory = $True, ParameterSetName = 'CommandLine')]
            [string]$ExecutablePath,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [bool]$ForceOffFeedback = $False,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [bool]$ForceOnFeedback = $False,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
        [ValidateSet(0x20, 0x40, 0x80, 0x100)]
            [Int32]$Priority = 0x20,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [bool]$RunInteractively = $False,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
        [ValidateRange(0x00,0x0A)]
            [UInt32]$ShowWindowCommand,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [bool]$UseDefaultErrorMode = $False,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [string]$WindowTitle,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [string]$WorkingDirectory,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [UInt32]$XCoordinate,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [UInt32]$XNumCharacters,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [UInt32]$XSize,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [UInt32]$YCoordinate,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [UInt32]$YNumCharacters,
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLineTemplate')]
        [Parameter(Mandatory = $False, ParameterSetName = 'CommandLine')]
            [UInt32]$YSize,
        #endregion CommandLineParameters

        #region LogFileParameters
        [Parameter(Mandatory = $True, ParameterSetName = "LogFile")]
            [string]$Filename,
        [Parameter(Mandatory = $False, ParameterSetName = "LogFile")]
            [bool]$IsUnicode = $True,
        [Parameter(Mandatory = $False, ParameterSetName = "LogFile")]
            [UInt64]$MaximumFileSize = 0,
        [Parameter(Mandatory = $True, ParameterSetName = "LogFile")]
            [string]$Text,
        #endregion LogFileParameters

        #region NtEventLogParameters
        [Parameter(Mandatory = $False, ParameterSetName = "NtEventLog")]
        [ValidateNotNull()]
            [UInt16]$Category,
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLog")]
        [ValidateNotNull()]
            [UInt32]$EventID,
        [Parameter(Mandatory = $False, ParameterSetName = "NtEventLog")]
        [ValidateSet(0, 1, 2, 4, 8, 16)]
        [ValidateNotNull()]
            [UInt32]$EventType = 1,
        [Parameter(Mandatory = $False, ParameterSetName = "NtEventLog")]
            [string[]]$InsertionStringTemplates = @(),
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLog")]
            [string]$NameOfUserSidProperty,
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLog")]
            [string]$NameOfRawDataProperty,
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLog")]
        [ValidateNotNull()]
        # Validate there is no ':' character
            [string]$SourceName,
        [Parameter(Mandatory = $False, ParameterSetName = "NtEventLog")]
            [string]$UNCServerName = 'localhost',
        #endregion NtEventLogParameters

        #region SMTPParameters
        [Parameter(Mandatory = $False, ParameterSetName = "SMTP")]
            [string]$BccLine = $null,
        [Parameter(Mandatory = $False, ParameterSetName = "SMTP")]
            [string]$CcLine = $null,
        [Parameter(Mandatory = $False, ParameterSetName = "SMTP")]
            [string]$FromLine = $null,
        [Parameter(Mandatory = $False, ParameterSetName = "SMTP")]
            [string[]]$HeaderFields = $null,
        [Parameter(Mandatory = $True, ParameterSetName = "SMTP")]
            [string]$Message,
        [Parameter(Mandatory = $False, ParameterSetName = "SMTP")]
            [string]$ReplyToLine = $null,
        [Parameter(Mandatory = $True, ParameterSetName = "SMTP")]
        [ValidateNotNull()]
            [string]$SMTPServer,
        [Parameter(Mandatory = $False, ParameterSetName = "SMTP")]
            [string]$Subject = $null,
        [Parameter(Mandatory = $True, ParameterSetName = "SMTP")]
            [string]$ToLine
        #endregion SMTPParameters
    )

    DynamicParam {
        # Set the dynamic parameters' name
        $ParameterName = 'ConsumerFile'
            
        # Create the dictionary 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            
        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.ParameterSetName = 'ConsumerFile'

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet 
        $arrSet = (Get-ChildItem -Path "$($UprootPath)\Consumers").BaseName
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
        $ConsumerFile = $PSBoundParameters['ConsumerFile']
    }

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            if($PSBoundParameters.ContainsKey("ConsumerFile")){
                Get-Content "$($UprootPath)\Consumers\$($ConsumerFile).ps1" | Out-String | Invoke-Expression
                $props.Add('ComputerName', $computer)
                Add-WMIEventConsumer @props
            }
            else
            {
                if($PSCmdlet.ParameterSetName.Contains("ActiveScript"))
                {
                    $class = [WMICLASS]"\\$computer\root\subscription:ActiveScriptEventConsumer"
                
                    $instance = $class.CreateInstance()
                    $instance.Name = $Name
                    $instance.KillTimeout = $KillTimeout
                    $instance.ScriptingEngine = $ScriptingEngine
                    if($PSCmdlet.ParameterSetName -eq "ActiveScriptFile")
                    {
                        $instance.ScriptFileName = $ScriptFileName
                        $instance.ScriptText = $null
                    }
                    elseif($PSCmdlet.ParameterSetName -eq "ActiveScriptText")
                    {
                        $instance.ScriptFileName = $null
                        $instance.ScriptText = $ScriptText
                    }

                    $instance.Put()
                }
                elseif($PSCmdlet.ParameterSetName -eq "CommandLine")
                {
                    $class = [WMICLASS]"\\$computer\root\subscription:CommandLineEventConsumer"

                    $instance = $class.CreateInstance()
                    $instance.Name = $Name
                    $instance.CommandLineTemplate = $CommandLineTemplate
                    $instance.CreateNewProcessGroup = $CreateNewProcessGroup
                    $instance.CreateSeparateWowVdm = $CreateSeparateWowVdm
                    $instance.CreateSharedWowVdm = $CreateSharedWowVdm
                    $instance.ExecutablePath = $ExecutablePath
                    $instance.ForceOffFeedback = $ForceOffFeedback
                    $instance.ForceOnFeedback = $ForceOnFeedback
                    $instance.KillTimeout = $KillTimeout
                    $instance.Priority = $Priority
                    $instance.RunInteractively = $RunInteractively
                    $instance.ShowWindowCommand = $ShowWindowCommand
                    $instance.UseDefaultErrorMode = $UseDefaultErrorMode
                    $instance.WindowTitle = $WindowTitle
                    $instance.WorkingDirectory = $WorkingDirectory
                    $instance.XCoordinate = $XCoordinate
                    $instance.XNumCharacters = $XNumCharacters
                    $instance.XSize = $XSize
                    $instance.YCoordinate = $YCoordinate
                    $instance.YNumCharacters = $YNumCharacters
                    $instance.YSize = $YSize

                    $instance.Put()
                }
                elseif($PSCmdlet.ParameterSetName -eq "LogFile")
                {
                    $class = [WMICLASS]"\\$computer\root\subscription:LogFileEventConsumer"
                
                    $instance = $class.CreateInstance()
                    $instance.Name = $Name
                    $instance.Filename = $Filename
                    $instance.IsUnicode = $IsUnicode
                    $instance.MaximumFileSize = $MaximumFileSize
                    $instance.Text = $Text

                    $instance.Put()
                }
                elseif($PSCmdlet.ParameterSetName -eq "NtEventLog")
                {
                    $class = [WMICLASS]"\\$computer\root\subscription:NtEventLogEventConsumer"

                    $instance = $class.CreateInstance()
                    $instance.Category = $Category
                    $instance.EventID = $EventID
                    $instance.EventType = $EventType
                    $instance.InsertionStringTemplates = $InsertionStringTemplates
                    $instance.NumberOfInsertionStrings = $InsertionStringTemplates.Length
                    $instance.NameOfUserSidProperty = $NameOfUserSidProperty
                    $instance.NameOfRawDataProperty = $NameOfRawDataProperty
                    $instance.SourceName = $SourceName
                    $instance.UNCServerName = $UNCServerName

                    $instance.Put()
                }
                elseif($PSCmdlet.ParameterSetName -eq "SMTP")
                {
                    $class = [WMICLASS]"\\$computer\root\subscription:SMTPEventConsumer"
                
                    $instance = $class.CreateInstance()
                    $instance.BccLine = $BccLine
                    $instance.CcLine = $CcLine
                    $instance.FromLine = $FromLine
                    $instance.HeaderFields = $HeaderFields
                    $instance.Message = $Message
                    $instance.ReplyToLine = $ReplyToLine
                    $instance.SMTPServer = $SMTPServer
                    $instance.Subject = $Subject
                    $instance.ToLine = $ToLine

                    $instance.Put()
                }
                else
                {
                    Write-Error "No ParameterSet Chosen"
                }
            }
        }
    }
}