$function = Get-Command -Name New-FunctionFile
Describe 'New-FunctionFile Tests' {
   Context 'Parameters for New-FunctionFile'{
It 'Has a parameter called FunctionName' {
            $function.Parameters.Keys.Contains('FunctionName') | Should Be 'True'
            }
        It 'FunctionName Parameter is Correctly Identified as being Mandatory' {
            $function.Parameters.FunctionName.Attributes.Mandatory | Should be 'False'
            }
        It 'FunctionName Parameter is of Object Type' {
            $function.Parameters.FunctionName.ParameterType.FullName | Should be 'System.Object'
            }

      }

 }


