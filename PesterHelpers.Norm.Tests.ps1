BeforeDiscovery {
    # $Here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $here = $PSScriptRoot

    $PrivateFunctions = Get-ChildItem "$here\Private\" -Filter '*.ps1' -Recurse | Where-Object { $_.name -NotMatch "Tests.ps1" }
    $PublicFunctions = Get-ChildItem "$here\Public\" -Filter '*.ps1' -Recurse | Where-Object { $_.name -NotMatch "Tests.ps1" }

    $PrivateFunctionsTests = Get-ChildItem "$here\Private\" -Filter '*Tests.ps1' -Recurse 
    $PublicFunctionsTests = Get-ChildItem "$here\Public\" -Filter '*Tests.ps1' -Recurse 

    $Rules = Get-ScriptAnalyzerRule

    $manifest = Get-Item "$Here\*.psd1"

    $module = $manifest.BaseName

    Import-Module "$Here\*.psd1"

    $ModuleData = Get-Module $Module 
    $AllFunctions = & $moduleData { Param($modulename) Get-command -CommandType Function -Module $modulename } $module

    $PublicFunctionPath = "$here\Public\"
    $PrivateFunctionPath = "$here\Private\"

}

if ($PrivateFunctions.count -gt 0) {
    foreach ($PrivateFunction in $PrivateFunctions) {

        # attach the data to the test here so you can use it when the test runs
        Describe "Testing Private Function  - $($PrivateFunction.BaseName) for Standard Processing" -ForEach @{ PrivateFuntion = $PrivateFunction } {

            It "Is valid Powershell (Has no script errors)" {
                $contents = Get-Content -Path $PrivateFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }      
        }

        $function = $AllFunctions.Where{ $_.Name -eq $PrivateFunction.BaseName }
        $PrivateFunctionTests = $PrivateFunctionstests.Where{ $_.Name -match $PrivateFunction.BaseName }

        foreach ($PrivateFunctionTest in $PrivateFunctionTests) {
            . $($PrivateFunctionTest.FullName) $function
        }    
    }
}

 
if ($PublicFunctions.count -gt 0) {
    foreach ($PublicFunction in $PublicFunctions) {

        Describe "Testing Public Function  - $($PublicFunction.BaseName) for Standard Processing" -Foreach @{ PublicFunction = $PublicFunction } {
            It "Is valid Powershell (Has no script errors)" {
                $contents = Get-Content -Path $PublicFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            } 
        }

        $function = $AllFunctions.Where{ $_.Name -eq $PublicFunction.BaseName }
        $publicfunctionTests = $Publicfunctionstests.Where{ $_.Name -match $PublicFunction.BaseName }

        foreach ($publicfunctionTest in $publicfunctionTests) {
            . $($PublicFunctionTest.FullName) $function
        }
    }
}

Describe 'ScriptAnalyzer Rule Testing' -Foreach @{ PublicFunctionPath = $PublidFunctionPaht; PrivateFunctionPath = $PrivateFunctionPath } {
    Context 'Public Functions' {
        It 'Passes the Script Analyzer ' {
            (Invoke-ScriptAnalyzer -Path $PublicFunctionPath -Recurse ).Count | Should Be 0
        }
    }

    Context 'Private Functions' {
        It 'Passes the Script Analyzer ' {
            (Invoke-ScriptAnalyzer -Path $PrivateFunctionPath ).Count | Should Be 0
        }
    }
}
