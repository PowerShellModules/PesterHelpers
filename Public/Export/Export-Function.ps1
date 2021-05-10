function Export-Function {
 <#
.Synopsis
    Exports a function from a module into a user given path

.Description
    As synopsis

.PARAMETER Function
    This Parameter takes a String input and is used in Both Parameter Sets

.PARAMETER ResolvedFunction
    This should be passed the Function that you want to work with as an object making use of the following
    $ResolvedFunction = Get-Command "Command"

.PARAMETER OutPath
    This is the location that you want to output all the module files to. It is recommended not to use the same location as where the module is installed.
    Also always check the files output what you expect them to.

.PARAMETER PrivateFunction
    This is a switch that is used to correctly export Private Functions and is used internally in Export-AllModuleFunction

.EXAMPLE
    Export-Function -Function Get-TwitterTweet -OutPath C:\TextFile\

    This will export the function into the C:\TextFile\Get\Get-TwitterTweet.ps1 file and also create a basic test file C:\TextFile\Get\Get-TwitterTweet.Tests.ps1

.EXAMPLE
    Get-Command -Module SPCSPS | Where-Object {$_.CommandType -eq 'Function'}  | ForEach-Object { Export-Function -Function $_.Name -OutPath C:\TextFile\SPCSPS\ }

    This will get all the Functions in the SPCSPS module (if it is loaded into memory or in a $env:PSModulePath as required by ModuleAutoLoading) and will export all the Functions into the C:\TextFile\SPCSPS\ folder under the respective Function Verbs. It will also create a basic Tests.ps1 file just like the prior example
#>
[cmdletbinding(DefaultParameterSetName='Basic')]

Param(
    [Parameter(Mandatory=$true,ParameterSetName='Basic',ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
    [Parameter(Mandatory=$true,ParameterSetName='Passthru',ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateNotNull()]
    [Alias('Command')]
    [Alias('Name')]
    [String]
    $Function,

    [Parameter(Mandatory=$true,ParametersetName='Passthru')]
    $ResolvedFunction,

    [Parameter(Mandatory=$true,ParameterSetName='Basic')]
    [Parameter(Mandatory=$true,ParameterSetName='Passthru')]
    [Alias('Path')]
    [String]
    $OutPath,

    [Parameter(Mandatory=$false,ParametersetName='Passthru')]
    [Alias('Private')]
    [Switch]
    $PrivateFunction

    )

$sb = New-Object -TypeName System.Text.StringBuilder

 If (!($ResolvedFunction)) { $ResolvedFunction = Get-Command $function}
 $code = $ResolvedFunction | Select-Object -ExpandProperty Definition

        If (!($PrivateFunction)) {
            $PublicOutPath = "$OutPath\Public\"
            $ps1 = "$PublicOutPath$($ResolvedFunction.Verb)\$($ResolvedFunction.Name).ps1"
        }
        ElseIf ($PrivateFunction) {
            $ps1 = "$OutPath\Private\$function.ps1"
        }

        $sb.AppendLine("function $function {") | Out-Null

        foreach ($line in $code -split '\r?\n') {
            $sb.AppendLine('{0}' -f $line) | Out-Null
        }

        $sb.AppendLine('}') | Out-Null

        New-Item $ps1 -ItemType File -Force | Out-Null
        Write-Verbose -Message "Created File $ps1"

        Set-Content -Path $ps1 -Value $($sb.ToString()) -Encoding UTF8
        Write-Verbose -Message "Added the content of function $Function into the file"

        If(!($PrivateFunction)) {
        New-FunctionPesterTest -Function $Function -ResolvedFunction $ResolvedFunction -OutPath $PublicOutPath -Verbose:$VerbosePreference
        Write-Verbose -Message "Created a Pester Test file for $Function Under the Basic ParamaterSet"
        }
        ElseIf ($PrivateFunction) {
        New-FunctionPesterTest -Function $Function -ResolvedFunction $ResolvedFunction -PrivateFunction -OutPath $OutPath -Verbose:$VerbosePreference
        Write-Verbose -Message "Created a Pester Test file for $Function Under the Passthru ParamaterSet"
        }

}
