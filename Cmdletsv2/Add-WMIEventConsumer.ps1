function Add-WmiEventConsumer
{
    [CmdletBinding(DefaultParameterSetName = 'ConsumerFile')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True, ParameterSetName = 'ConsumerFile')]
            [string]$ConsumerFile,
        [Parameter(Mandatory = $True, ParameterSetName = "LogFile")]
            [string]$Name,

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
    )

    BEGIN
    {
        
    }

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            if($PSBoundParameters.ContainsKey("ConsumerFile")){
                if(Test-Path $ConsumerFile -PathType Leaf)
                {
                    Get-Content $ConsumerFile | Out-String | Invoke-Expression
                    $props.Add('ComputerName', $computer)
                    Add-WMIEventConsumer @props
                }
            }
            else
            {
                if($PSCmdlet.ParameterSetName -eq "LogFile")
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
                else
                {
                    Write-Error "No ParameterSet Chosen"
                }
            }
        }
    }
}