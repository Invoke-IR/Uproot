function Add-WmiEventConsumer
{
    [CmdletBinding()]
    Param(
        #region CommonParameters
        
        [Parameter()] 
            [string[]]$ComputerName = 'localhost',

        [Parameter()]
            [Int32]$ThrottleLimit = 32,
        
        [Parameter(Mandatory = $True)] 
            [string]$Name,

        [Parameter(ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(ParameterSetName = 'ActiveScriptTextComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [UInt32]$KillTimeout = 0,
        
        #endregion CommonParameters

        #region ActiveScriptParameters

        [Parameter(ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(ParameterSetName = 'ActiveScriptTextComputerSet')] 
        [ValidateSet("VBScript", "jscript")]
            [string]$ScriptingEngine = "VBScript",

        [Parameter(Mandatory = $True, ParameterSetName = 'ActiveScriptFileComputerSet')] 
        [ValidateNotNull()]
            [string]$ScriptFileName,
        
        [Parameter(Mandatory = $True, ParameterSetName = 'ActiveScriptTextComputerSet')] 
        [ValidateNotNull()]
            [string]$ScriptText,
        
        #endregion ActiveScriptParameters
        
        #region CommandLineParameters
        
        [Parameter(Mandatory = $True, ParameterSetName = 'CommandLineTemplateComputerSet')]
        #Validate executable exists
            [string]$CommandLineTemplate,
        
        [Parameter(Mandatory = $True, ParameterSetName = 'CommandLineComputerSet')]
            [string]$ExecutablePath,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [bool]$CreateNewProcessGroup = $True,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [bool]$CreateSeparateWowVdm = $False,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [bool]$CreateSharedWowVdm = $False,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [bool]$ForceOffFeedback = $False,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [bool]$ForceOnFeedback = $False,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [ValidateSet(0x20, 0x40, 0x80, 0x100)]
            [Int32]$Priority = 0x20,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [bool]$RunInteractively = $False,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [ValidateRange(0x00,0x0A)]
            [UInt32]$ShowWindowCommand,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [bool]$UseDefaultErrorMode = $False,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [string]$WindowTitle,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [string]$WorkingDirectory,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [UInt32]$XCoordinate,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [UInt32]$XNumCharacters,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [UInt32]$XSize,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [UInt32]$YCoordinate,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [UInt32]$YNumCharacters,
        
        [Parameter(ParameterSetName = 'CommandLineTemplateComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
            [UInt32]$YSize,
        
        #endregion CommandLineParameters

        #region LogFileParameters
        
        [Parameter(Mandatory = $True, ParameterSetName = "LogFileComputerSet")]
            [string]$Filename,
        
        [Parameter(ParameterSetName = "LogFileComputerSet")]
            [bool]$IsUnicode = $True,
        
        [Parameter(ParameterSetName = "LogFileComputerSet")]
            [UInt64]$MaximumFileSize = 0,
        
        [Parameter(Mandatory = $True, ParameterSetName = "LogFileComputerSet")]
            [string]$Text,
        
        #endregion LogFileParameters

        #region NtEventLogParameters
        
        [Parameter(ParameterSetName = "NtEventLogComputerSet")]
        [ValidateNotNull()]
            [UInt16]$Category,
        
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLogComputerSet")]
        [ValidateNotNull()]
            [UInt32]$EventID,
        
        [Parameter(ParameterSetName = "NtEventLogComputerSet")]
        [ValidateSet(0, 1, 2, 4, 8, 16)]
        [ValidateNotNull()]
            [UInt32]$EventType = 1,
        
        [Parameter(ParameterSetName = "NtEventLogComputerSet")]
            [string[]]$InsertionStringTemplates = @(),
        
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLogComputerSet")]
            [string]$NameOfUserSidProperty,
        
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLogComputerSet")]
            [string]$NameOfRawDataProperty,
        
        [Parameter(Mandatory = $True, ParameterSetName = "NtEventLogComputerSet")]
        [ValidateNotNull()]
        # Validate there is no ':' character
            [string]$SourceName,
        
        [Parameter(ParameterSetName = "NtEventLogComputerSet")]
            [string]$UNCServerName = 'localhost',
        
        #endregion NtEventLogParameters

        #region SMTPParameters
        [Parameter(ParameterSetName = "SMTPComputerSet")]
            [string]$BccLine = $null,
        
        [Parameter(ParameterSetName = "SMTPComputerSet")]
            [string]$CcLine = $null,
        
        [Parameter(ParameterSetName = "SMTPComputerSet")]
            [string]$FromLine = $null,
        
        [Parameter(ParameterSetName = "SMTPComputerSet")]
            [string[]]$HeaderFields = $null,
        
        [Parameter(Mandatory = $True, ParameterSetName = "SMTPComputerSet")]
            [string]$Message,
        
        [Parameter(ParameterSetName = "SMTPComputerSet")]
            [string]$ReplyToLine = $null,
        
        [Parameter(Mandatory = $True, ParameterSetName = "SMTPComputerSet")]
        [ValidateNotNull()]
            [string]$SMTPServer,
        
        [Parameter(ParameterSetName = "SMTPComputerSet")]
            [string]$Subject = $null,
        
        [Parameter(Mandatory = $True, ParameterSetName = "SMTPComputerSet")]
            [string]$ToLine
        
        #endregion SMTPParameters
    )

    BEGIN
    {
        if($PSCmdlet.ParameterSetName.Contains('ActiveScript'))
        {
            $class = 'ActiveScriptEventConsumer'
            
            if($PSCmdlet.ParameterSetName.Contains('File'))
            {
                $props = @{
                    'Name' = $Name
                    'KillTimeout' = $KillTimeout
                    'ScriptingEngine' = $ScriptingEngine
                    'ScriptFileName' = $ScriptFileName
                    'ScriptText' = $null
                }
            }
            elseif($PSCmdlet.ParameterSetName.Contains('Text'))
            {
                $props = @{
                    'Name' = $Name
                    'KillTimeout' = $KillTimeout
                    'ScriptingEngine' = $ScriptingEngine
                    'ScriptFileName' = $null
                    'ScriptText' = $ScriptText
                }
            }
            else
            {
                Write-Error 'No valid Parameter Set chosen'
            }
        }
        elseif($PSCmdlet.ParameterSetName.Contains('CommandLine'))
        {
            $class = 'CommandLineEventConsumer'

            if($PSCmdlet.ParameterSetName.Contains('Template'))
            {
                $props = @{
                    'Name' = $Name
                    'CommandLineTemplate' = $CommandLineTemplate
                    'CreateNewProcessGroup' = $CreateNewProcessGroup
                    'CreateSeparateWowVdm' = $CreateSeparateWowVdm
                    'CreateSharedWowVdm' = $CreateSharedWowVdm
                    'ExecutablePath' = $Null
                    'ForceOffFeedback' = $ForceOffFeedback
                    'ForceOnFeedback' = $ForceOnFeedback
                    'KillTimeout' = $KillTimeout
                    'Priority' = $Priority
                    'RunInteractively' = $RunInteractively
                    'ShowWindowCommand' = $ShowWindowCommand
                    'UseDefaultErrorMode' = $UseDefaultErrorMode
                    'WindowTitle' = $WindowTitle
                    'WorkingDirectory' = $WorkingDirectory
                    'XCoordinate' = $XCoordinate
                    'XNumCharacters' = $XNumCharacters
                    'XSize' = $XSize
                    'YCoordinate' = $YCoordinate
                    'YNumCharacters' = $YNumCharacters
                    'YSize' = $YSize
                }
            }
            else
            {
                $props = @{
                    'Name' = $Name
                    'CommandLineTemplate' = $Null
                    'CreateNewProcessGroup' = $CreateNewProcessGroup
                    'CreateSeparateWowVdm' = $CreateSeparateWowVdm
                    'CreateSharedWowVdm' = $CreateSharedWowVdm
                    'ExecutablePath' = $ExecutablePath
                    'ForceOffFeedback' = $ForceOffFeedback
                    'ForceOnFeedback' = $ForceOnFeedback
                    'KillTimeout' = $KillTimeout
                    'Priority' = $Priority
                    'RunInteractively' = $RunInteractively
                    'ShowWindowCommand' = $ShowWindowCommand
                    'UseDefaultErrorMode' = $UseDefaultErrorMode
                    'WindowTitle' = $WindowTitle
                    'WorkingDirectory' = $WorkingDirectory
                    'XCoordinate' = $XCoordinate
                    'XNumCharacters' = $XNumCharacters
                    'XSize' = $XSize
                    'YCoordinate' = $YCoordinate
                    'YNumCharacters' = $YNumCharacters
                    'YSize' = $YSize
                }
            }
        }
        elseif($PSCmdlet.ParameterSetName.Contains('LogFile'))
        {
            $class = 'LogFileEventConsumer'

            $props = @{
                'Name' = $Name
                'Filename' = $Filename
                'IsUnicode' = $IsUnicode
                'MaximumFileSize' = $MaximumFileSize
                'Text' = $Text
            }
        }
        elseif($PSCmdlet.ParameterSetName.Contains('NtEventLog'))
        {
            $class = 'NtEventLogEventConsumer'

            $props = @{
                'Category' = $Category
                'EventID' = $EventID
                'EventType' = $EventType
                'InsertionStringTemplates' = $InsertionStringTemplates
                'NumberOfInsertionStrings' = $InsertionStringTemplates.Length
                'NameOfUserSidProperty' = $NameOfUserSidProperty
                'NameOfRawDataProperty' = $NameOfRawDataProperty
                'SourceName' = $SourceName
                'UNCServerName' = $UNCServerName
            }
        }
        elseif($PSCmdlet.ParameterSetName.Contains('SMTP'))
        {
            $class = 'SMTPEventConsumer'

            $props = @{
                'BccLine' = $BccLine
                'CcLine' = $CcLine
                'FromLine' = $FromLine
                'HeaderFields' = $HeaderFields
                'Message' = $Message
                'ReplyToLine' = $ReplyToLine
                'SMTPServer' = $SMTPServer
                'Subject' = $Subject
                'ToLine' = $ToLine
            }
        }
        else
        {
            Write-Error 'No valid Parameter Set chosen'
        }
    }

    PROCESS
    {
        $jobs = Set-WmiInstance -ComputerName $ComputerName -Namespace root\subscription -Class $class -Arguments $props -AsJob -ThrottleLimit $ThrottleLimit 
    }
    
    END
    {
        Receive-Job -Job $jobs -Wait -AutoRemoveJob
    }
}