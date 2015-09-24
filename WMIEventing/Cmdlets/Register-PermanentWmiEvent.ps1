function Register-PermanentWmiEvent
{
    [CmdletBinding()]
    Param(
        #region CommonParameters
        
        [Parameter()]
        [string[]]$ComputerName = 'localhost',

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [Int32]$ThrottleLimit = 32,
        
        #endregion CommonParameters

        #region FilterParameters
        
        [Parameter()]
        [string]$EventNamespace = 'root\cimv2',
        
        [Parameter(Mandatory)]
        [string]$Query,
        
        [Parameter()]
        [string]$QueryLanguage = 'WQL',

        #endregion FilterParameters

        #region CommonConsumerParameters
        
        [Parameter(ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(ParameterSetName = 'ActiveScriptTextComputerSet')]
        [Parameter(ParameterSetName = 'CommandLineComputerSet')]
        [UInt32]$KillTimeout = 0,
        
        #endregion CommonConsumerParameters

        #region ActiveScriptParameters

        [Parameter(ParameterSetName = 'ActiveScriptFileComputerSet')]
        [Parameter(ParameterSetName = 'ActiveScriptTextComputerSet')] 
        [ValidateSet("VBScript")]
        [string]$ScriptingEngine = "VBScript",

        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptFileComputerSet')] 
        [ValidateNotNull()]
        [string]$ScriptFileName,
        
        [Parameter(Mandatory, ParameterSetName = 'ActiveScriptTextComputerSet')] 
        [ValidateNotNull()]
        [string]$ScriptText,
        
        #endregion ActiveScriptParameters
        
        #region CommandLineParameters
        
        [Parameter(Mandatory, ParameterSetName = 'CommandLineTemplateComputerSet')]
        #Validate executable exists
        [string]$CommandLineTemplate,
        
        [Parameter(Mandatory, ParameterSetName = 'CommandLineComputerSet')]
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
        
        [Parameter(Mandatory, ParameterSetName = "LogFileComputerSet")]
        [string]$Filename,
        
        [Parameter(ParameterSetName = "LogFileComputerSet")]
        [bool]$IsUnicode,
        
        [Parameter(ParameterSetName = "LogFileComputerSet")]
        [UInt64]$MaximumFileSize = 0,
        
        [Parameter(Mandatory, ParameterSetName = "LogFileComputerSet")]
        [string]$Text,
        
        #endregion LogFileParameters

        #region NtEventLogParameters
        
        [Parameter(ParameterSetName = "NtEventLogComputerSet")]
        [ValidateNotNull()]
        [UInt16]$Category,
        
        [Parameter(Mandatory, ParameterSetName = "NtEventLogComputerSet")]
        [ValidateNotNull()]
        [UInt32]$EventID,
        
        [Parameter(ParameterSetName = "NtEventLogComputerSet")]
        [ValidateSet(0x00, 0x01, 0x02, 0x04, 0x08, 0x10)]
        [ValidateNotNull()]
        [UInt32]$EventType = 0x01,
        
        [Parameter(ParameterSetName = "NtEventLogComputerSet")]
        [string[]]$InsertionStringTemplates = @(),
        
        [Parameter(Mandatory, ParameterSetName = "NtEventLogComputerSet")]
        [string]$NameOfUserSidProperty,
        
        [Parameter(Mandatory, ParameterSetName = "NtEventLogComputerSet")]
        [string]$NameOfRawDataProperty,
        
        [Parameter(Mandatory, ParameterSetName = "NtEventLogComputerSet")]
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
        
        [Parameter(Mandatory, ParameterSetName = "SMTPComputerSet")]
        [string]$Message,
        
        [Parameter(ParameterSetName = "SMTPComputerSet")]
        [string]$ReplyToLine = $null,
        
        [Parameter(Mandatory, ParameterSetName = "SMTPComputerSet")]
        [ValidateNotNull()]
        [string]$SMTPServer,
        
        [Parameter(ParameterSetName = "SMTPComputerSet")]
        [string]$Subject = $null,
        
        [Parameter(Mandatory, ParameterSetName = "SMTPComputerSet")]
        [string]$ToLine
        
        #endregion SMTPParameters
    )

    begin
    {
        $FilterParamKeys = $PSBoundParameters.Keys | Where-Object { $_ -in (Get-Command Add-WmiEventFilter | ForEach-Object Parameters | ForEach-Object Keys) }
        $FilterProps = @{}
        $FilterParamKeys | ForEach-Object { $FilterProps[$_] = $PSBoundParameters[$_] }
        
        $ConsumerParamKeys = $PSBoundParameters.Keys | Where-Object { $_ -in (Get-Command Add-WmiEventConsumer | ForEach-Object Parameters | ForEach-Object Keys) }
        $ConsumerProps = @{}
        $ConsumerParamKeys | ForEach-Object { $ConsumerProps[$_] = $PSBoundParameters[$_] }

        switch($PSCmdlet.ParameterSetName)
        {
            'ActiveScriptFileComputerSet' {$ConsumerName = 'ActiveScriptEventConsumer'; break}
            'ActiveScriptTextComputerSet' {$ConsumerName = 'ActiveScriptEventConsumer'; break}
            'CommandLineComputerSet' {$ConsumerName = 'CommandLineEventConsumer'; break}
            'CommandLineTemplateComputerSet' {$ConsumerName = 'CommandLineEventConsumer'; break}
            'LogFileComputerSet' {$ConsumerName = 'LogFileEventConsumer'; break}
            'NtEventLogComputerSet' {$ConsumerName = 'NtEventLogEventConsumer'; break}
            'SMTPComputerSet' {$ConsumerName = 'SMTPEventConsumer'; break}
        }

        $SubscriptionParameters = @{
            'FilterName' = $Name
            'ConsumerType' = $ConsumerName
            'ConsumerName' = $Name
            'ThrottleLimit' = $ThrottleLimit
        }
    }

    process
    {
        Add-WmiEventFilter -ComputerName $ComputerName @FilterProps -ThrottleLimit $ThrottleLimit
        Add-WmiEventConsumer -ComputerName $ComputerName @ConsumerProps -ThrottleLimit $ThrottleLimit
        Add-WmiEventSubscription -ComputerName $ComputerName @SubscriptionParameters
    }
}