function New-FunctionFile {
<#
.SYNOPSIS
   This is the Short Description field for $functionName
.DESCRIPTION
   This is the Long Description field for $functionName

.PARAMETER FunctionName

.EXAMPLE
   New-FunctionFile -FunctionName Test-FunctionFile
#>

[Cmdletbinding(SupportsShouldProcess=$true)]
param($FunctionName)


if ($PSCmdlet.ShouldProcess($OutPath,"Creating function & pester test Files for $Function"))
{
$verb = $functionName.split('-')[0]
New-Item .\$verb\$functionName.ps1 -Force | Out-Null

$value = @'
Function $functionName {
<#
.SYNOPSIS
   This is the Short Description field for $functionName

.DESCRIPTION
   This is the Long Description field for $functionName

.PARAMETER FunctionName

.PARAMETER FunctionName

.PARAMETER FunctionName


.EXAMPLE
   $functionName -Param1 -Param2

.EXAMPLE
   Another example of how to use this cmdlet
#>
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    }
    Process
    {
    }
    End
    {
    }
}
'@

$value = $value.Replace('$functionName',$functionName)
Set-Content -Path .\$verb\$functionName.ps1 -Value $value -Encoding UTF8

New-Item .\$verb\$functionName.Tests.ps1 -Force | Out-Null
}

}
