Function New-FunctionPesterTest {
<#
.SYNOPSIS
   This Function Creates A PesterTest file for the Function being passed to it
.DESCRIPTION
   This Function creates a skeleton pester test file for the function that is being passed to it including whether the
   Function has parameters and creates some basic Pester Tests for these so that you can pull then in future have oppottunity
   to test the code you've written in more detail
.EXAMPLE
   New-FunctionPesterTest -Function New-FunctionPesterTest -OutPath C:\TextFile\PesterHelpers\
.EXAMPLE
   Get-Command -Module MyModule | Select-Object -ExpandProperty Name | ForEach-Object { New-FunctionPesterTest -Function $_ -OutPath C:\TextFile\PesterHelpers\
#>

[CmdletBinding(SupportsShouldProcess=$true)]
Param(
    [Parameter(Mandatory=$true)][String]$Function,
    [Parameter(Mandatory=$true)][String]$OutPath
    )

if ($PSCmdlet.ShouldProcess($OutPath,"Creating Pester test File for $Function"))
{
$sb               = New-Object -TypeName System.Text.StringBuilder
$ResolvedFunction = Get-Command $Function
$parameters       = New-Object System.Collections.ArrayList

$CommonParameters = (Get-Command Get-CommonParameter | Select-Object -ExpandProperty Parameters).Keys

$functionParams   = $ResolvedFunction.Parameters.Keys

$tests            = "$OutPath$($ResolvedFunction.Verb)\$($ResolvedFunction.Name).Tests.ps1"
Write-Verbose -Message "Full Output path is $tests"
$firstline        = '$function = Get-Command -Name'
$firstline        = $firstline+' '+$($ResolvedFunction.Name)
$sb.AppendLine($firstline) | Out-Null

$secondline       = @'
Describe '$function Tests' {

'@

$secondline       = $secondline.Replace('$function',$($ResolvedFunction.Name))
$sb.Append($secondline) | Out-Null

Write-Verbose -Message "Added initial lines to the StringBuilder variable being used"

If ($functionParams.Count -gt 0)
{

$functionParams.Foreach({$parameters.Add($_)}) | Out-Null

$CommonParameters.Foreach({$parameters.Remove($_)}) | Out-Null
Write-Verbose -Message "The Function $Function has $($parameters.Count) Non-Common Parameters"

$thirdline = @'
   Context 'Parameters for $function'{

'@
$thirdline = $thirdline.Replace('$function',$($ResolvedFunction.Name))
$sb.Append($thirdline) | Out-Null

Write-Verbose -Message "Added Initial Parameter Lines to StringBuilder Variable"

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
    $Type      = $($ResolvedFunction.Parameters[$parameter].ParameterType.Name)
    $FullType  = $($ResolvedFunction.Parameters[$parameter].ParameterType.FullName)
    $paramtext = $paramtext.Replace("String Type","$Type Type")
    $paramtext = $paramtext.Replace("System.String",$FullType)

    $sb.AppendLine($paramtext) | Out-Null
Write-Verbose -Message "Added the Parameter Pester Tests for the $parameter Parameter"
    }
$closingParams = @'
      }
'@
$sb.AppendLine($closingParams) | Out-Null
Write-Verbose -Message "Added the Closing lines for the Parameters Section"

}
$sbEnd = @'

 }

'@
    $sb.AppendLine($sbEnd) | Out-Null
Write-Verbose -Message "Added the Ending Line to the StringBuilder Variable"

    New-Item $tests -ItemType File -Force | Out-Null
    Write-Verbose "File $tests was created"
    Set-Content $tests -Value $($sb.ToString()) -Force -Encoding UTF8
    Write-Verbose -Message "Added the Content to the $tests File and Set the Encoding to UTF8"
}
}
