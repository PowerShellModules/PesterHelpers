$function = Get-Command -Name New-FunctionPesterTest
Describe 'New-FunctionPesterTest Tests' {
   Context 'Parameters for New-FunctionPesterTest'{
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


