Function Export-Function {
 <#
    .Synopsis
        Exports a function from a module into a user given path
    .Description
        As synopsis
    .PARAMETER Function
    
    Specifies the name of the parameter. The script returns the
    descriptions of this parameter from the topics of cmdlets 
    that have the parameter. The blank descriptions indicate that
    the cmdlet help topic has the parameter, but the description
    is blank.
    
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


 
$sb = New-Object -TypeName System.Text.StringBuilder
$ResolvedFunction = Get-Command $Function
$code = $ResolvedFunction | Select-Object -ExpandProperty Definition

$ps1 = "$OutPath\$($ResolvedFunction.Verb)\$($ResolvedFunction.Name).ps1"
     

        $sb.AppendLine("function $function {") | Out-Null
        
        foreach ($line in $code -split '\r?\n') {
            $sb.AppendLine('{0}' -f $line) | Out-Null
        }

        $sb.AppendLine('}') | Out-Null

        New-Item $ps1 -ItemType File -Force | Out-Null
        Write-Verbose -Message "Created File $ps1"

        Set-Content -Path $ps1 -Value $($sb.ToString()) -Encoding UTF8
        Write-Verbose -Message "Added the content of function $Function into the file"
        
        New-FunctionPesterTest -Function $Function -OutPath $OutPath -Verbose:$VerbosePreference
        Write-Verbose -Message "Created a Pester Test file for $Function" 
}
