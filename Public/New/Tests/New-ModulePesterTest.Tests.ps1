Describe 'New-ModulePesterTest Tests' {

   Context 'Parameters for New-ModulePesterTest'{

        It 'Has a Parameter called ModuleName' {
            $Function.Parameters.Keys.Contains('ModuleName') | Should -Be 'True'
            }
        It 'ModuleName Parameter is Identified as Mandatory being False' {
            [String]$Function.Parameters.ModuleName.Attributes.Mandatory | Should -Be 'False'
            }
        It 'ModuleName Parameter is of String Type' {
            $Function.Parameters.ModuleName.ParameterType.FullName | Should -Be 'System.String'
            }
        It 'ModuleName Parameter is member of ParameterSets' {
            [String]$Function.Parameters.ModuleName.ParameterSets.Keys | Should -Be '__AllParameterSets'
            }
        It 'ModuleName Parameter Position is defined correctly' {
            [String]$Function.Parameters.ModuleName.Attributes.Position | Should -Be '0'
            }
        It 'Does ModuleName Parameter Accept Pipeline Input?' {
            [String]$Function.Parameters.ModuleName.Attributes.ValueFromPipeline | Should -Be 'False'
            }
        It 'Does ModuleName Parameter Accept Pipeline Input by PropertyName?' {
            [String]$Function.Parameters.ModuleName.Attributes.ValueFromPipelineByPropertyName | Should -Be 'False'
            }
        It 'Does ModuleName Parameter use advanced parameter Validation? ' {
            $Function.Parameters.ModuleName.Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute' | Should -Be 'False'
            $Function.Parameters.ModuleName.Attributes.TypeID.Name -contains 'ValidateNotNullAttribute' | Should -Be 'False'
            $Function.Parameters.ModuleName.Attributes.TypeID.Name -contains 'ValidateScript' | Should -Be 'False'
            $Function.Parameters.ModuleName.Attributes.TypeID.Name -contains 'ValidateRangeAttribute' | Should -Be 'False'
            $Function.Parameters.ModuleName.Attributes.TypeID.Name -contains 'ValidatePatternAttribute' | Should -Be 'False'
            }
        It 'Has Parameter Help Text for ModuleName '{
            $function.Definition.Contains('.PARAMETER ModuleName') | Should -Be 'True'
            }
        It 'Has a Parameter called OutPath' {
            $Function.Parameters.Keys.Contains('OutPath') | Should -Be 'True'
            }
        It 'OutPath Parameter is Identified as Mandatory being False' {
            [String]$Function.Parameters.OutPath.Attributes.Mandatory | Should -Be 'False'
            }
        It 'OutPath Parameter is of String Type' {
            $Function.Parameters.OutPath.ParameterType.FullName | Should -Be 'System.String'
            }
        It 'OutPath Parameter is member of ParameterSets' {
            [String]$Function.Parameters.OutPath.ParameterSets.Keys | Should -Be '__AllParameterSets'
            }
        It 'OutPath Parameter Position is defined correctly' {
            [String]$Function.Parameters.OutPath.Attributes.Position | Should -Be '1'
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


