<## 
Consumers

TODO:
Add ability to get all Consumers
Add CommandLineEventConsumer Support
CommandLine CommandLineTemplate or ExecutablePath

##>

if($PSVersionTable.PSVersion.Major -lt 3)
{
    Write-Warning "To utilize Uproot fully, uprgrade PowerShell to the latest version."
    # Read in all ps1 files in the Cmdlets Directory
    $Global:UprootPath = $PSScriptRoot
    Get-ChildItem $PSScriptRoot |
        ? {$_.PSIsContainer -and ($_.Name -eq 'Cmdletsv2')} |
        % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
        % {. $_.FullName}
}
else
{
    Add-Type -AssemblyName System.Serviceprocess
    # Read in all ps1 files in the Cmdlets Directory
    $Global:UprootPath = $PSScriptRoot
    Get-ChildItem $PSScriptRoot |
        ? {$_.PSIsContainer -and ($_.Name -eq 'Cmdlets')} |
        % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
        % {. $_.FullName}
}



