Describe "New-FunctionPesterTest" {

        $FunctionValue = "Export-Function"
        $FunctionVerbValue = "Export"
        
        $OutpathValue = 'C:\TextFile\PTest\'
        $NewItemPath = "$OutpathValue\$FunctionVerbValue\$FunctionValue.Tests.ps1"
        $tests = $NewItemPath

        $ExpectedValue = @'
$function = Get-Command -Name Export-Function
Describe 'Export-Function Tests' {
   Context 'Parameters for Export-Function'{
It 'Has a parameter called Function' {
            $function.Parameters.Keys.Contains('Function') | Should Be 'True'
            }
        It 'Function Parameter is Correctly Identified as being Mandatory' {
            $function.Parameters.Function.Attributes.Mandatory | Should be 'True'
            }
        It 'Function Parameter is of String Type' {
            $function.Parameters.Function.ParameterType.FullName | Should be 'System.String'
            }

It 'Has a parameter called OutPath' {
            $function.Parameters.Keys.Contains('OutPath') | Should Be 'True'
            }
        It 'OutPath Parameter is Correctly Identified as being Mandatory' {
            $function.Parameters.OutPath.Attributes.Mandatory | Should be 'True'
            }
        It 'OutPath Parameter is of String Type' {
            $function.Parameters.OutPath.ParameterType.FullName | Should be 'System.String'
            }

      }

 }
'@
        $VerboseMessage1 = "Full Output path is $tests"
        
        Mock New-Object {"SB"} -ParameterFilter {$TypeName -eq "System.Text.StringBuilder"} -Verifiable
        
        Mock New-Object {"ArrayList"} -ParameterFilter {$TypeName -eq "System.Collections.Arraylist"} -Verifiable

        Mock Out-Null {} -Verifiable 
        
        Mock New-FunctionPesterTest {"Export-Function"} -Verifiable -ParameterFilter  { $Function -eq $FunctionValue -and $OutPath -eq $OutpathValue } 
                   
        Mock New-Item {"Export-Function.Test.ps1" } -Verifiable -ParameterFilter {$path -eq $tests -and $ItemType -eq "File" -and $force -eq $true } 
        
        Mock Set-Content {"Export-Function.Test.ps1"} -Verifiable -ParameterFilter { $Path -eq $tests -and $Value -eq $ExpectedValue }
         
        Mock Write-Verbose {$VerboseMessage1} -Verifiable -ParameterFilter { $message -eq $VerboseMessage1}   
       
       
       It "Passes the Functional Mock" {   
           New-FunctionPesterTest -Function Export-Function -OutPath C:\TextFile\PTest\ | Should be "Export-Function"
           Assert-MockCalled -CommandName New-FunctionPesterTest -Times 1
           
       }
       
       It "Creates the required Objects" {
       New-Object -TypeName System.Text.StringBuilder | Should Be "SB"
       New-Object -TypeName System.Collections.ArrayList | Should Be "ArrayList"
       Assert-MockCalled -CommandName New-Object -Times 2
       }
       
       It "Creates the Export-Function Pester Test File" {

       New-Item -Path $tests -ItemType "File" -Force | Should Be "Export-Function.Test.ps1"
       Assert-MockCalled -CommandName New-Item -Times 1
       
       }
       
       It "Sets Content of the Export-Function Pester Test File" {

       Set-Content -Path $tests -Value $ExpectedValue | Should be "Export-Function.Test.ps1"
       Assert-MockCalled -CommandName Set-Content -Times 1 -Scope It
       
       }

       It "Mocked Out-Null" {

       Out-Null | Should BeNullOrEmpty 
       Assert-MockCalled -CommandName Out-Null -Times 1
       }
       

       It "Mocked Write-Verbose" {

       Write-Verbose "$VerboseMessage1" } | Should BeNullOrEmpty
       Assert-MockCalled -CommandName Write-Verbose -Times 1



       It "Mocked everything correctly" { Assert-VerifiableMock }

       

}    


