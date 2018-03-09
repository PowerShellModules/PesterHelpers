Describe 'Export-Function' {

        $FunctionValue = "New-FunctionPesterTest"
        $FunctionVerbValue = "New"
        
        $OutpathValue = 'C:\TextFile\PTest\'
        $NewItemPath = "$OutpathValue\$FunctionVerbValue\$FunctionValue.ps1"
        $tests = $NewItemPath

        $VerboseMessage1 = "Full Output path is $tests"
        



        Mock Export-Function {'New-FunctionPesterTest'} -Verifiable -ParameterFilter { $Function -eq $FunctionValue -and $OutPath -eq $OutpathValue }
        
        Mock New-Object {"SB"} -ParameterFilter {$TypeName -eq "System.Text.StringBuilder"} -Verifiable
        
        Mock Out-Null {} -Verifiable 
        
        Mock New-FunctionPesterTest {"New-FunctionPesterTest"} -Verifiable -ParameterFilter  { $Function -eq $FunctionValue -and $OutPath -eq $OutpathValue -and $VerbosePreference -eq $VerbosePreference } 
                   
        Mock New-Item {"New-FunctionPesterTest.ps1" } -Verifiable -ParameterFilter {$path -eq $tests -and $ItemType -eq "File" -and $force -eq $true } 
        
        Mock Set-Content {"New-FunctionPesterTest.ps1"} -Verifiable -ParameterFilter { $Path -eq $tests -and $Value -eq $ExpectedValue }
         
        Mock Write-Verbose {$VerboseMessage1} -Verifiable -ParameterFilter { $message -eq $VerboseMessage1}   
       
              
       It "Passes the Functional Mock" {   
           Export-Function -Function New-FunctionPesterTest -OutPath C:\TextFile\PTest\ -Verbose:$VerbosePreference | Should be "New-FunctionPesterTest"
           Assert-MockCalled -CommandName Export-Function -Times 1
           
       }

       It "Calls New-FunctionPesterTest" {
            New-FunctionPesterTest -Function $FunctionValue -OutPath $OutpathValue -Verbose:$VerbosePreference | Should Be "New-FunctionPesterTest"
            Assert-MockCalled -CommandName New-FunctionPesterTest -Times 1
            }



       It "Creates the required Objects" {
           New-Object -TypeName System.Text.StringBuilder | Should Be "SB"
           Assert-MockCalled -CommandName New-Object -Times 1
           }

       It "Creates the New-FunctionPesterTest File" {

       New-Item -Path $tests -ItemType "File" -Force | Should Be "New-FunctionPesterTest.ps1"
       Assert-MockCalled -CommandName New-Item -Times 1
       
       }
       
       It "Sets Content of the New-FunctionPesterTest File" {

       Set-Content -Path $tests -Value $ExpectedValue | Should be "New-FunctionPesterTest.ps1"
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


