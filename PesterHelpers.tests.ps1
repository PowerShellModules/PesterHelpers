$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$module_name = Split-Path -Leaf $here

$PrivateFunctions = Get-ChildItem "$here\Private\" -Filter '*.ps1' -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}
$PublicFunctions = Get-ChildItem "$here\Public\" -Filter '*.ps1' -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}

$PrivateFunctionsTests = Get-ChildItem "$here\Private\" -Filter '*Tests.ps1' -Recurse 
$PublicFunctionsTests = Get-ChildItem "$here\Public\" -Filter '*Tests.ps1' -Recurse 

$Rules = Get-ScriptAnalyzerRule

Import-Module "$Here\*.psd1"

Describe "Tests the module framework for $module_name" {
    It "Has a root module file ($module_name.psm1)" {        
            
        "$here\$module_name.psm1" | Should Exist
    }

    It "Is valid PowerShell" {

        $contents = Get-Content -Path "$here\$module_name.psm1" -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    It 'passes the PSScriptAnalyzer without Errors' {
        (Invoke-ScriptAnalyzer -Path $here -Recurse -Severity Error).Count | Should Be 0
    }

     It 'passes the PSScriptAnalyzer with less than 10 Warnings' {
        (Invoke-ScriptAnalyzer -Path $here -Recurse -Severity Warning).Count | Should BeLessThan 10 
    }

    It "Has a manifest file ($module_name.psd1)" {
            
        "$here\$module_name.psd1" | Should Exist
    }

    It "Contains a root module path in the manifest" {
            
        "$here\$module_name.psd1" | Should Contain "$module_name.psm1"
    }

    It "Contains all needed properties in the Manifest for PSGallery Uploads" {
    
        "$here\$module_name.psd1" | Should Contain "Author = *"
    }
}

Describe "Tests the Functions to ensure that they are correctly formatted" {
$functions = Get-Command -FullyQualifiedModule $module_name 
    foreach($modulefunction in $functions)
    {

        Context "Function $($modulefunction.Name)" {
            It "Function $($modulefunction.Name) Has show-help comment block" {

                $modulefunction.Definition.Contains('<#') | should be 'True'
                $modulefunction.Definition.Contains('#>') | should be 'True'
            }

            It "Function $($modulefunction.Name) Has show-help comment block has a.SYNOPSIS" {

                $modulefunction.Definition.Contains('.SYNOPSIS') -or $modulefunction.Definition.Contains('.Synopsis') | should be 'True'
                

            }

            It "Function $($modulefunction.Name) Has show-help comment block has an example" {

                $modulefunction.Definition.Contains('.EXAMPLE') | should be 'True'
            }

            It "Function $($modulefunction.Name) Is an advanced function" {

                $modulefunction.CmdletBinding | should be 'True'
                $modulefunction.Definition.Contains('param') -or  $modulefunction.Definition.Contains('Param') | should be 'True'
            }
        }
    }
}


if ($PrivateFunctions.count -gt 0) {
Describe "Testing all Private Functions in this Repo to be be correctly formatted" {

    foreach($PrivateFunction in $PrivateFunctions)
    {

    Context "Testing Private Function  - $($PrivateFunction.BaseName) for Standard Processing" {
    
    Import-Module $PrivateFunction.FullName
    
          It "Is valid Powershell (Has no script errors)" {

                $contents = Get-Content -Path $PrivateFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }
            

    foreach ($rule in $rules) {

                    It “passes the PSScriptAnalyzer Rule $rule“ {

                        (Invoke-ScriptAnalyzer -Path $PrivateFunction.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0

                    }
                 }

            }
    
    }
 }
}

if ($PublicFunctions.count -gt 0) {
Describe "Testing all Public Functions in this Repo to be be correctly formatted" {

    foreach($PublicFunction in $PublicFunctions)
    {

    Context "Testing Public Function  - $($PublicFunction.BaseName) for Standard Processing" {
    
    Import-Module $PublicFunction.FullName
          
          It "Is valid Powershell (Has no script errors)" {

                $contents = Get-Content -Path $PublicFunction.FullName -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }
            

    foreach ($rule in $rules) {

                    It “passes the PSScriptAnalyzer Rule $rule“ {

                        (Invoke-ScriptAnalyzer -Path $PublicFunction.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0

                        }
                    }

    }

    $function = Get-Command $PublicFunction.BaseName 
        
        Context "Testing that the function - $($function.Name) - is compliant" {
            It "Function $($function.Name) Has show-help comment block" {

                $function.Definition.Contains('<#') | should be 'True'
                $function.Definition.Contains('#>') | should be 'True'
            }

            It "Function $($function.Name) Has show-help comment block has a.SYNOPSIS" {

                $function.Definition.Contains('.SYNOPSIS') -or $function.Definition.Contains('.Synopsis') | should be 'True'

            }

            It "Function $($function.Name) Has show-help comment block has an example" {

                $function.Definition.Contains('.EXAMPLE') | should be 'True'
            }

            It "Function $($function.Name) Is an advanced function" {

                $function.CmdletBinding | should be 'True'
                $function.Definition.Contains('param') -or  $function.Definition.Contains('Param') | should be 'True'
            }
            }
        }
    Remove-Module $PublicFunction.BaseName
    }
}

if ($PublicFunctionsTests.count -gt 0) {

    foreach($PublicFunctionTest in $PublicFunctionsTests)
        { . $PublicFunctionTest.FullName }

    }

if ($PrivateFunctionsTests.count -gt 0) {

    foreach($PrivateFunctionTest in $PrivateFunctionsTests)
        { . $PrivateFunctionTest.FullName }

    }

