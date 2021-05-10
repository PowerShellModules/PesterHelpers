Function Export-AllModuleFunction {
<#
.Synopsis
   Exports All Module Functions into Separate PS1 files

.DESCRIPTION
   Exposes all Private and Public Functions and exports them to a location that you tell it to Export to & Creates a Basic Shell Pester Test for the Function

.PARAMETER Module
    This should be passed the Module Name as a single string - for example 'PesterHelpers'

.PARAMETER OutPath
    This is the location that you want to output all the module files to. It is recommended not to use the same location as where the module is installed.
    Also always check the files output what you expect them to.
.EXAMPLE
   Export-AllModuleFunction -Module TestModule -OutPath C:\TestModule\

   This will get the Module TestModule that is loaded in the Current PowerShell Session and will then iterate through all the Private & Public Functions and
   export them to separate ps1 files with a non-functional test file and a blank Functional tests file created as well.
#>

    [CmdletBinding()]
    [Alias()]
    Param
    (

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [String]
        $Module,

        [Parameter(Mandatory=$true)]
        [String]
        $OutPath
    )
    $ModuleData = Get-Module $Module -Verbose:$VerbosePreference

    If ($null -eq $ModuleData) {throw 'Please Import Module into session'}
    else {
    Write-Verbose "$ModuleData"
    $PublicFunctions = (Get-command -Module $module).Where{$_.CommandType -ne 'Cmdlet'}

    Foreach ($PublicFunction in $PublicFunctions){
    Write-Verbose "Found $($PublicFunction.Name) being Exported"
    }

    $AllFunctions = & $moduleData {Param($modulename) (Get-command -CommandType Function -Module $modulename).Where{$_.CommandType -ne 'Cmdlet'}} $module

    $PrivateFunctions = Compare-Object $PublicFunctions -DifferenceObject $AllFunctions -PassThru -Verbose:$VerbosePreference

    Foreach ($PrivateFunction in $PrivateFunctions){
    Write-Verbose "We Found $($PrivateFunction.Name) that is not being Exported"
    }

    $PublicFunctions | ForEach-Object { Export-Function -Function $_.Name -ResolvedFunction $_ -OutPath $OutPath -Verbose:$VerbosePreference }

    $PrivateFunctions | ForEach-Object { Export-Function -Function $_.Name -ResolvedFunction $_ -OutPath $OutPath -PrivateFunction -Verbose:$VerbosePreference }
    }
}