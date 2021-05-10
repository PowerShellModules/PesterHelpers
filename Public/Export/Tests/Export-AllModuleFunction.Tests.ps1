Describe 'Export-AllModuleFunction Tests' {

   Context 'Parameters for Export-AllModuleFunction'{

        It 'Has a Parameter called Module' {
            $Function.Parameters.Keys.Contains('Module') | Should -Be 'True'
            }
        It 'Module Parameter is Identified as Mandatory being True' {
            [String]$Function.Parameters.Module.Attributes.Mandatory | Should -Be 'True'
            }
        It 'Module Parameter is of String Type' {
            $Function.Parameters.Module.ParameterType.FullName | Should -Be 'System.String'
            }
        It 'Module Parameter is member of ParameterSets' {
            [String]$Function.Parameters.Module.ParameterSets.Keys | Should -Be '__AllParameterSets'
            }
        It 'Module Parameter Position is defined correctly' {
            [String]$Function.Parameters.Module.Attributes.Position | Should -Be '0'
            }
        It 'Does Module Parameter Accept Pipeline Input?' {
            [String]$Function.Parameters.Module.Attributes.ValueFromPipeline | Should -Be 'True'
            }
        It 'Does Module Parameter Accept Pipeline Input by PropertyName?' {
            [String]$Function.Parameters.Module.Attributes.ValueFromPipelineByPropertyName | Should -Be 'True'
            }
        It 'Does Module Parameter use advanced parameter Validation? ' {
            $Function.Parameters.Module.Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute' | Should -Be 'False'
            $Function.Parameters.Module.Attributes.TypeID.Name -contains 'ValidateNotNullAttribute' | Should -Be 'False'
            $Function.Parameters.Module.Attributes.TypeID.Name -contains 'ValidateScript' | Should -Be 'False'
            $Function.Parameters.Module.Attributes.TypeID.Name -contains 'ValidateRangeAttribute' | Should -Be 'False'
            $Function.Parameters.Module.Attributes.TypeID.Name -contains 'ValidatePatternAttribute' | Should -Be 'False'
            }
        It 'Has Parameter Help Text for Module '{
            $function.Definition.Contains('.PARAMETER Module') | Should -Be 'True'
            }
        It 'Has a Parameter called OutPath' {
            $Function.Parameters.Keys.Contains('OutPath') | Should -Be 'True'
            }
        It 'OutPath Parameter is Identified as Mandatory being True' {
            [String]$Function.Parameters.OutPath.Attributes.Mandatory | Should -Be 'True'
            }
        It 'OutPath Parameter is of String Type' {
            $Function.Parameters.OutPath.ParameterType.FullName | Should -Be 'System.String'
            }
        It 'OutPath Parameter is member of ParameterSets' {
            [String]$Function.Parameters.OutPath.ParameterSets.Keys | Should -Be '__AllParameterSets'
            }
        It 'OutPath Parameter Position is defined correctly' {
            [String]$Function.Parameters.OutPath.Attributes.Position | Should -Be '-2147483648'
            }
        It 'Does OutPath Parameter Accept Pipeline Input?' {
            [String]$Function.Parameters.OutPath.Attributes.ValueFromPipeline | Should -Be 'False'
            }
        It 'Does OutPath Parameter Accept Pipeline Input by PropertyName?' {
            [String]$Function.Parameters.OutPath.Attributes.ValueFromPipelineByPropertyName | Should -Be 'False'
            }
        It 'Does OutPath Parameter use advanced parameter Validation? ' {
            $Function.Parameters.OutPath.Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute' | Should -Be 'False'
            $Function.Parameters.OutPath.Attributes.TypeID.Name -contains 'ValidateNotNullAttribute' | Should -Be 'False'
            $Function.Parameters.OutPath.Attributes.TypeID.Name -contains 'ValidateScript' | Should -Be 'False'
            $Function.Parameters.OutPath.Attributes.TypeID.Name -contains 'ValidateRangeAttribute' | Should -Be 'False'
            $Function.Parameters.OutPath.Attributes.TypeID.Name -contains 'ValidatePatternAttribute' | Should -Be 'False'
            }
        It 'Has Parameter Help Text for OutPath '{
            $function.Definition.Contains('.PARAMETER OutPath') | Should -Be 'True'
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
