function Get-WmiEventConsumer
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',

        [Parameter()]
            [Int32]$ThrottleLimit = 32,

        [Parameter(Mandatory = $True, ParameterSetName = 'Name', Position = 0)]
            [string]$Name
    )

    PROCESS
    {
        $jobs = Get-WmiObject -ComputerName $ComputerName -Namespace root\subscription -Class __EventConsumer -AsJob -ThrottleLimit $ThrottleLimit 
        
        $objects = Receive-Job -Job $jobs -Wait -AutoRemoveJob

        if($PSCmdlet.ParameterSetName -eq 'Name')
        {
            $objects = $objects | Where-Object {$_.Name -eq $Name}
        }

        foreach($obj in $objects)
        {
            switch($obj.__CLASS)
            {
                ActiveScriptEventConsumer
                {
                    $props = @{
                        'ComputerName' = $obj.__SERVER;
                        'Path' = $obj.Path;
                        'Name' = $obj.Name;
                        'ConsumerType' = $obj.__CLASS;
                        'KillTimeout' = $obj.KillTimeout;
                        'MaximumQueueSize' = $obj.MaximumQueueSize;
                        'ScriptingEngine' = $obj.ScriptingEngine;
                        'ScriptFileName' = $obj.ScriptFileName;
                        'ScriptText' = $obj.ScriptText;
                    }
                    $obj = New-Object -TypeName PSObject -Property $props
                    $obj.PSObject.TypeNames.Insert(0, 'WMIEventing.ActiveScriptEventConsumer')
                }
                CommandLineEventConsumer
                {
                    $props = @{
                        'ComputerName' = $obj.__SERVER;
                        'Path' = $obj.Path;
                        'Name' = $obj.Name;
                        'ConsumerType' = $class;
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
                    $obj.PSObject.TypeNames.Insert(0, 'WMIEventing.CommandLineEventConsumer')
                }
                LogFileEventConsumer
                {
                    $props = @{
                        'ComputerName' = $obj.__SERVER;
                        'Path' = $obj.Path;
                        'Name' = $obj.Name;
                        'ConsumerType' = $class;
                        'Filename' = $obj.Filename;
                        'IsUnicode' = $obj.IsUnicode;
                        'MaximumFileSize' = $obj.MaximumFileSize;
                        'Text' = $obj.Text;
                    }
                    $obj = New-Object -TypeName PSObject -Property $props
                    $obj.PSObject.TypeNames.Insert(0, 'WMIEventing.LogFileEventConsumer')
                }
                NtEventLogEventConsumer
                {
                    $props = @{
                        'ComputerName' = $obj.__SERVER;
                        'Path' = $obj.Path;
                        'Name' = $obj.Name;
                        'ConsumerType' = $class;
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
                    $obj.PSObject.TypeNames.Insert(0, 'WMIEventing.NtEventLogEventConsumer')
                }
                SMTPEventConsumer
                {
                    $props = @{
                        'ComputerName' = $obj.__SERVER;
                        'Path' = $obj.Path;
                        'Name' = $obj.Name;
                        'ConsumerType' = $class;
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
                    $obj.PSObject.TypeNames.Insert(0, 'WMIEventing.SMTPEventConsumer')
                }
            }

            Write-Output $obj
        }
    }
}