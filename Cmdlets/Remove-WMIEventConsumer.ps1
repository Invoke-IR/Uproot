function Remove-WMIEventConsumer
{
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True)]
        [ValidateSet('ActiveScript', 'CommandLine', 'LogFile', 'NtEventLog', 'SMTP')]
            [string]$ConsumerType,
        [Parameter(Mandatory = $True, ParameterSetName = 'Name')]
            [string]$Name
    )

    BEGIN
    {
        switch($ConsumerType)
        {
            ActiveScript 
            {
                $class = 'ActiveScriptEventConsumer'
            }
            CommandLine 
            {
                $class = 'CommandLineEventConsumer'
            }
            LogFile 
            {
                $class = 'LogFileEventConsumer'
            }
            NtEventLog 
            {
                $class = 'NtEventLogEventConsumer'
            }
            SMTP 
            {
                $class = 'SMTPEventConsumer'
            }
        }
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
                $obj | Remove-WmiObject
            }
        }
    }
}