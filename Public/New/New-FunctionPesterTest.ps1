Function New-FunctionPesterTest {
<#
.SYNOPSIS
   This Function Creates 2 Pester Test files for the Function being passed to it

.DESCRIPTION
   This Function creates a skeleton pester test file for the Function that is being passed to it including whether the
   Function has Parameters and creates some basic Pester Tests for these so that you can pull then in future have oppottunity
   to test the code you've written in more detail - This is a Non-Functional Pester Test called <Function>.Tests.ps1

   The Function also creates a blank file in the same location for you to create your Functional Pester Tests and this is created
   called <Function>.Functional.Tests.ps1

.PARAMETER Function
    This Parameter takes a String input and is used in Both Parameter Sets

.PARAMETER ResolvedFunction
    This Should -Be passed the Function that you want to work with as an object making use of the following
    $ResolvedFunction = Get-Command "Command"

.PARAMETER OutPath
    This is the location that you want to output all the module files to. It is recommended not to use the same location as where the module is installed.
    Also always check the files output what you expect them to.

.PARAMETER PrivateFunction
    This is a switch that is used to correctly export Private Functions and is used internally in Export-AllModuleFunction

.EXAMPLE
   New-FunctionPesterTest -Function New-FunctionPesterTest -OutPath C:\TextFile\PesterHelpers\
.EXAMPLE
   Get-Command -Module MyModule | Select-Object -ExpandProperty Name | ForEach-Object { New-FunctionPesterTest -Function $_ -OutPath C:\TextFile\PesterHelpers\
.EXAMPLE
    In this example we have a PrivateFunction that we need to export - In this case it is Get-CommonParameter

    $Function = 'Get-CommonParameter'
    $Module = 'PesterHelpers'
    $ModuleData = Get-Module $module

    However as it is a Private Function we need to run the following to essentially flush the function into our available local scope
    For this piece of code thanks goes to Bruce Payette @BrucePayette

    $AllFunctions = & $moduleData {Param($modulename) Get-command -CommandType Function -Module $modulename} $module

    $ResolvedFunction = $AllFunctions.Where{ $_.Name -eq $function}

    New-FunctionPesterTest -Function $Function -ResolvedFunction $ResolvedFunction -PrivateFunction -OutPath $OutPath -Verbose

    However it is unlikely that you would need to run something similar to this example though this is added for completeness and
    should help in understanding the story of what happens under the hood

.EXAMPLE
    New-FunctionPesterTest -Function 'New-FunctionPesterTest -OutPath C:\TextFile -Verbose

    This is useful for when you have created a Function and have no tests and could potentially be used with simple scripts that really just encapsulated as 1 function
#>

[CmdletBinding(SupportsShouldProcess=$true,
               DefaultParametersetName='Basic')]
Param(
    [Parameter(Mandatory=$true,ParametersetName='Basic')]
    [Parameter(Mandatory=$true,ParametersetName='Passthru')]
    [String]
    $Function,

    [Parameter(Mandatory=$true,ParametersetName='Passthru')]
    $ResolvedFunction,

    [Parameter(Mandatory=$true,ParametersetName='Basic')]
    [Parameter(Mandatory=$true,ParametersetName='Passthru')]
    [String]
    $OutPath,

    [Parameter(Mandatory=$false,ParametersetName='Passthru')]
    [Switch]
    $PrivateFunction
    )

if ($PSCmdlet.ShouldProcess($OutPath,"Creating Pester test File for $Function"))
{
    $SB               = New-Object -TypeName System.Text.StringBuilder
    $Parameters       = New-Object System.Collections.ArrayList
    $CommonParameters = (Get-Command Get-CommonParameter | Select-Object -ExpandProperty Parameters).Keys
    If (!($ResolvedFunction)) {$ResolvedFunction = Get-Command $Function }
    If (!($PrivateFunction)) {  $Tests = "$OutPath\$($ResolvedFunction.Verb)\Tests\$($ResolvedFunction.Name).Tests.ps1"
                                $FunctionalTests = "$OutPath\$($ResolvedFunction.Verb)\Tests\$($ResolvedFunction.Name).Functional.Tests.ps1" }
    Elseif ($PrivateFunction) { $Tests = "$OutPath\Private\Tests\$Function.Tests.ps1"
                                $FunctionalTests = "$OutPath\Private\Tests\$Function.Functional.Tests.ps1" }

    $FunctionParams   = $ResolvedFunction.Parameters.Keys

$VerboseMessage = "Full Output path is $Tests"
Write-Verbose -Message $VerboseMessage

$SecondLine       = @'
Describe '$Function Tests' {


'@

$SecondLine       = $SecondLine.Replace('$Function',$Function)
$SB.Append($SecondLine) | Out-Null

Write-Verbose -Message "Added initial lines to the StringBuilder variable being used"

If ($FunctionParams.Count -gt 0)  {

    $FunctionParams.Foreach({$Parameters.Add($_)}) | Out-Null

    $CommonParameters.Foreach({$Parameters.Remove($_)}) | Out-Null
    Write-Verbose -Message "The Function $Function has $($Parameters.Count) Non-Common Parameters"

    $ThirdLine = @'
   Context 'Parameters for $Function'{


'@
    $ThirdLine = $ThirdLine.Replace('$Function',$Function)
    $SB.Append($ThirdLine) | Out-Null

    Write-Verbose -Message "Added Initial Parameter Lines to StringBuilder Variable"

foreach ($Parameter in $Parameters) {
    $ParamText = @'
        It 'Has a Parameter called $Parameter' {
            $Function.Parameters.Keys.Contains('$Parameter') | Should -Be 'True'
            }
        It '$Parameter Parameter is Identified as Mandatory being $MandatoryValue' {
            [String]$Function.Parameters.$Parameter.Attributes.Mandatory | Should -Be $Mandatory
            }
        It '$Parameter Parameter is of String Type' {
            $Function.Parameters.$Parameter.ParameterType.FullName | Should -Be 'System.String'
            }
        It '$Parameter Parameter is member of ParameterSets' {
            [String]$Function.Parameters.$Parameter.ParameterSets.Keys | Should -Be $ParamSets
            }
        It '$Parameter Parameter Position is defined correctly' {
            [String]$Function.Parameters.$Parameter.Attributes.Position | Should -Be $Positions
            }
        It 'Does $Parameter Parameter Accept Pipeline Input?' {
            [String]$Function.Parameters.$Parameter.Attributes.ValueFromPipeline | Should -Be $ValueFromPipeline
            }
        It 'Does $Parameter Parameter Accept Pipeline Input by PropertyName?' {
            [String]$Function.Parameters.$Parameter.Attributes.ValueFromPipelineByPropertyName | Should -Be $PipelineByPropertyName
            }
        It 'Does $Parameter Parameter use advanced parameter Validation? ' {
            $Function.Parameters.$Parameter.Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute' | Should -Be $VNNEAttribute
            $Function.Parameters.$Parameter.Attributes.TypeID.Name -contains 'ValidateNotNullAttribute' | Should -Be $VNNAttribute
            $Function.Parameters.$Parameter.Attributes.TypeID.Name -contains 'ValidateScript' | Should -Be $VSAttribute
            $Function.Parameters.$Parameter.Attributes.TypeID.Name -contains 'ValidateRangeAttribute' | Should -Be $VRAttribute
            $Function.Parameters.$Parameter.Attributes.TypeID.Name -contains 'ValidatePatternAttribute' | Should -Be $VRPattern
            }
        It 'Has Parameter Help Text for $Parameter '{
            $function.Definition.Contains('.PARAMETER $Parameter') | Should -Be 'True'
            }
'@


    $Mandatory = $($ResolvedFunction.Parameters[$parameter].Attributes.Mandatory)
    $Type      = $($ResolvedFunction.Parameters[$parameter].ParameterType.Name)
    $FullType  = $($ResolvedFunction.Parameters[$parameter].ParameterType.FullName)
    $ParamSets = $($ResolvedFunction.Parameters[$parameter].ParameterSets.Keys)
    $Positions = $($ResolvedFunction.Parameters[$parameter].Attributes.Position)
    $ValueFromPipeline = $($ResolvedFunction.Parameters[$parameter].Attributes.ValueFromPipeline)
    $PipelineByPropertyName = $($ResolvedFunction.Parameters[$parameter].Attributes.ValueFromPipelineByPropertyName)
    $VNNEAttribute = $($ResolvedFunction.Parameters[$parameter].Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute')
    $VNNAttribute = $($ResolvedFunction.Parameters[$parameter].Attributes.TypeID.Name -contains 'ValidateNotNullAttribute')
    $VSAttribute = $($ResolvedFunction.Parameters[$parameter].Attributes.TypeID.Name -contains 'ValidateScript')
    $VRAttribute = $($ResolvedFunction.Parameters[$parameter].Attributes.TypeID.Name -contains 'ValidateRangeAttribute')
    $VRPattern = $($ResolvedFunction.Parameters[$parameter].Attributes.TypeID.Name -contains 'ValidatePatternAttribute')

    # Replacing text section
    $ParamText = $ParamText.Replace('$Parameter',$Parameter)
    $ParamText = $ParamText.Replace('$MandatoryValue',$Mandatory)
    $ParamText = $ParamText.Replace('$VNNEAttribute',"'$VNNEAttribute'")
    $ParamText = $ParamText.Replace('$VNNAttribute',"'$VNNAttribute'")
    $ParamText = $ParamText.Replace('$VSAttribute',"'$VSAttribute'")
    $ParamText = $ParamText.Replace('$VRAttribute',"'$VRAttribute'")
    $ParamText = $ParamText.Replace('$VRPattern',"'$VRPattern'")
    $ParamText = $ParamText.Replace('$Mandatory',"'$Mandatory'")
    $ParamText = $ParamText.Replace('$ParamSets',"'$ParamSets'")
    $ParamText = $ParamText.Replace('$Positions',"'$Positions'")
    $ParamText = $ParamText.Replace('$ValueFromPipeline',"'$ValueFromPipeline'")
    $ParamText = $ParamText.Replace('$PipelineByPropertyName',"'$PipelineByPropertyName'")
    $ParamText = $ParamText.Replace("String Type","$Type Type")
    $ParamText = $ParamText.Replace("System.String",$FullType)


    $SB.AppendLine($ParamText) | Out-Null

    Write-Verbose -Message "Added the Parameter Pester Tests for the $Parameter Parameter"
    }
$ContextClose = @'
    }
'@

$SB.AppendLine($ContextClose) | Out-Null
}
$HelpTests = @'
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
'@

Write-Verbose -Message "Added the Closing lines for the Parameters Section"


$SB.AppendLine($HelpTests) | Out-Null

$DescribeClose = @'

 }

'@
    $SB.AppendLine($DescribeClose) | Out-Null
    Write-Verbose -Message "Added the Ending Line to the StringBuilder Variable"

    New-Item $Tests -ItemType File -Force | Out-Null
    Write-Verbose "File $Tests was created"
    Set-Content $Tests -Value $($SB.ToString()) -Force -Encoding UTF8
    Write-Verbose -Message "Added the Content to the $Tests File and Set the Encoding to UTF8"

    New-Item $FunctionalTests -ItemType File -Force | Out-Null
    Write-Verbose "File $FunctionalTests was created"
    }

}
