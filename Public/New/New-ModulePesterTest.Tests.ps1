$function = Get-Command -Name New-ModulePesterTest
Describe 'New-ModulePesterTest Tests' {

    Context 'Parameters for New-ModulePesterTest'{

        It 'Has a parameter called ModuleName' {
            $function.Parameters.Keys.Contains('ModuleName') | Should Be 'True'
            }
        It 'ModuleName Parameter is Correctly Identified as being Mandatory' {
            $function.Parameters.ModuleName.Attributes.Mandatory | Should be 'False' 
            }
        It 'ModuleName Parameter is of String Type' {
            $function.Parameters.ModuleName.ParameterType.FullName | Should be 'System.String' 
            }
        
      }
         
 }
