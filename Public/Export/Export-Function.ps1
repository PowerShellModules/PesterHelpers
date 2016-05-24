Function Export-Function {
 <#
    .Synopsis
        Exports a function from a module into a user given path
    .Description
        As synopsis
    .EXAMPLE
        Export-Function -Function Get-TwitterTweet -OutPath C:\TextFile\
        
        This will export the function into the C:\TextFile\Get\Get-TwitterTweet.ps1 file and also create a basic test file C:\TextFile\Get\Get-TwitterTweet.Tests.ps1
    .EXAMPLE
        Get-Command -Module SPCSPS | Where-Object {$_.CommandType -eq 'Function'}  | ForEach-Object { Export-Function -Function $_.Name -OutPath C:\TextFile\SPCSPS\ }    
         
        This will get all the Functions in the SPCSPS module (if it is loaded into memory or in a $env:PSModulePath as required by ModuleAutoLoading) and will export all the Functions into the C:\TextFile\SPCSPS\ folder under the respective Function Verbs. It will also create a basic Tests.ps1 file just like the prior example        
    #>

Param(
    [Parameter(Mandatory=$true)][String]$Function,
    [Parameter(Mandatory=$true)][String]$OutPath
    )


 
 $sb1 = New-Object -TypeName System.Text.StringBuilder
 $sb2 = New-Object -TypeName System.Text.StringBuilder
 $ResolvedFunction = Get-Command $Function
 $code = $ResolvedFunction | Select-Object -ExpandProperty Definition

$parameters = New-Object System.Collections.ArrayList
Function Get-CommonParameter { [cmdletbinding(SupportsShouldProcess)] param() }
$CommonParameters = (Get-Command Get-CommonParameter  | Select-Object -ExpandProperty Parameters).Keys
((Get-Command $function | Select-Object -ExpandProperty Parameters).Keys).Foreach({$parameters.Add($_)}) | Out-Null
$CommonParameters.Foreach({$parameters.Remove($_)}) | Out-Null

$ps1 = "$OutPath\$($ResolvedFunction.Verb)\$($ResolvedFunction.Name).ps1"
$tests = "$OutPath\$($ResolvedFunction.Verb)\$($ResolvedFunction.Name).Tests.ps1"

$firstline = '$function = Get-Command -Name'
$firstline = $firstline+' '+$($ResolvedFunction.Name)
$sb2.AppendLine($firstline) | Out-Null

$secondline = @'
Describe '$function Tests' {

    Context 'Parameters for $function'{

        
'@

$secondline = $secondline.Replace('$function',$($ResolvedFunction.Name))
$sb2.Append($secondline) | Out-Null
foreach ($parameter in $parameters) { 
    $paramtext = @'
It 'Has a parameter called $parameter' {
            $function.Parameters.Keys.Contains('$parameter') | Should Be 'True'
            }
        It '$parameter Parameter is Correctly Identified as being Mandatory' {
            $function.Parameters.$parameter.Attributes.Mandatory | Should be $Mandatory 
            }
        It '$parameter Parameter is of String Type' {
            $function.Parameters.$parameter.ParameterType.FullName | Should be 'System.String' 
            }
        
'@

    $paramtext = $paramtext.Replace('$parameter',$parameter)
    $mandatory = $($ResolvedFunction.Parameters[$parameter].Attributes.Mandatory)
    $paramtext = $paramtext.Replace('$Mandatory',"'$mandatory'")
    $Type = $($ResolvedFunction.Parameters[$parameter].ParameterType.Name)
    $FullType = $($ResolvedFunction.Parameters[$parameter].ParameterType.FullName)
    $paramtext = $paramtext.Replace("String Type","$Type Type")
    $paramtext = $paramtext.Replace("System.String",$FullType)
    
    $sb2.AppendLine($paramtext) | Out-Null
    }
$sb2End = @'
      }
         
 }
'@
    $sb2.AppendLine($sb2End) | Out-Null
     

        $sb1.AppendLine("function $function {") | Out-Null
        
        foreach ($line in $code -split '\r?\n') {
            $sb1.AppendLine('    {0}' -f $line) | Out-Null
        }

        $sb1.AppendLine('}') | Out-Null
        New-Item $ps1 -ItemType File -Force -Value $($sb1.ToString()) | Out-Null
        
        New-Item $tests -ItemType File -Value $($sb2.ToString()) -Force | Out-Null
}
