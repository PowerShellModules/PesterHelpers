PesterHelpers is a module to help people create a subset of Pester Tests for existing code that they will likely already have.

PesterHelpers has the following functions

* Export-Function
* New-ModulePesterTest

PesterHelpers has the following dependency

* PSScriptAnalyzer - Tested with v 1.4.0 though should work with prior versions as well.


Export-Function will allow you to export a function to a new ps1 file (& accompanying Pester test file) to the location that you specify

An example of this working in a PowerShell v2/v3 environment would be the following

```powershell
Get-Command -Module SPCSPS | Where-Object {$_.CommandType -eq 'Function'}  | ForEach-Object { Export-Function -Function $_.Name -OutPath C:\TextFile\SPCSPS\ }
```
Though in PowerShell v4/5 we can also do the following for an extra added performance boost
```powershell
(Get-Command -Module SPCSPS).Where{$_.CommandType -eq 'Function'}.Foreach{Export-Function -Function $_.Name -OutPath C:\TextFile\SPCSPS\}
```
This will get all the Functions from the module SPCSPS and export the Function Definition of all the functions to a new PS1 file located in the C:\TextFile\SPCSPS\ folder - this will split all the Functions into sub-folders based on the Function Verb.

This does require that the module is either loaded into memory or is located in a $env:PSModulePath location.

The New-ModulePesterTest function can be used in the below manner
```powershell
New-ModulePesterTest -ModuleName SPCSPS
```
This will grab the Module Path from the module and create a basic Pester Test for the Module in that Folder - note that for modules installed via PowerShell Gallery or are in the ProgramFiles\WindowsPowerShell\Modules\ location this will need to be run in an elevated session. This is predominantly for those modules that you have previously written and struggle to find the time to write any tests for and is quite comprehensive in its use of the PowerShell ScriptAnalyzer to build a number of tests.

To Install the Module and if you are running PowerShell v5 then just run the below
```powershell
Install-Module PesterHelpers
```
