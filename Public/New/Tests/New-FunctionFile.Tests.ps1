Describe 'New-FunctionFile Tests' {

   Context 'Parameters for New-FunctionFile'{

        It 'Has a Parameter called FunctionName' {
            $Function.Parameters.Keys.Contains('FunctionName') | Should -Be 'True'
            }
        It 'FunctionName Parameter is Identified as Mandatory being False' {
            [String]$Function.Parameters.FunctionName.Attributes.Mandatory | Should -Be 'False'
            }
        It 'FunctionName Parameter is of Object Type' {
            $Function.Parameters.FunctionName.ParameterType.FullName | Should -Be 'System.Object'
            }
        It 'FunctionName Parameter is member of ParameterSets' {
            [String]$Function.Parameters.FunctionName.ParameterSets.Keys | Should -Be '__AllParameterSets'
            }
        It 'FunctionName Parameter Position is defined correctly' {
            [String]$Function.Parameters.FunctionName.Attributes.Position | Should -Be '0'
            }
        It 'Does FunctionName Parameter Accept Pipeline Input?' {
            [String]$Function.Parameters.FunctionName.Attributes.ValueFromPipeline | Should -Be 'False'
            }
        It 'Does FunctionName Parameter Accept Pipeline Input by PropertyName?' {
            [String]$Function.Parameters.FunctionName.Attributes.ValueFromPipelineByPropertyName | Should -Be 'False'
            }
        It 'Does FunctionName Parameter use advanced parameter Validation? ' {
            $Function.Parameters.FunctionName.Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute' | Should -Be 'False'
            $Function.Parameters.FunctionName.Attributes.TypeID.Name -contains 'ValidateNotNullAttribute' | Should -Be 'False'
            $Function.Parameters.FunctionName.Attributes.TypeID.Name -contains 'ValidateScript' | Should -Be 'False'
            $Function.Parameters.FunctionName.Attributes.TypeID.Name -contains 'ValidateRangeAttribute' | Should -Be 'False'
            $Function.Parameters.FunctionName.Attributes.TypeID.Name -contains 'ValidatePatternAttribute' | Should -Be 'False'
            }
        It 'Has Parameter Help Text for FunctionName '{
            $function.Definition.Contains('.PARAMETER FunctionName') | Should -Be 'True'
            }
    }
    Context "Function $($function.Name) - Help Section" {

            It "Function $($function.Name) Has show-help comment block" {

                $function.Definition.Contains('<#') | Should -Be 'True'
                $function.Definition.Contains('#>') | Should -Be 'True'
            }

            It "Function $($function.Name) Has show-help comment block has a.SYNOPSIS" {

                $function.Definition.Contains('.SYNOPSIS') -or $function.Definition.Contains('.Synopsis') | Should -Be 'True'

            }

            It "Function $($function.Name) Has show-help comment block has an example" {

                $function.Definition.Contains('.EXAMPLE') | Should -Be 'True'
            }

            It "Function $($function.Name) Is an advanced function" {

                $function.CmdletBinding | Should -Be 'True'
                $function.Definition.Contains('param') -or  $function.Definition.Contains('Param') | Should -Be 'True'
            }

    }

 }


