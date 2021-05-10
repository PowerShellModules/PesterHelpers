function New-ModulePesterTest {
<#
.SYNOPSIS
Creates a ps1 file that includes a subset of basic pester tests

.DESCRIPTION
As synopsis

.PARAMETER ModuleName

.PARAMETER OutPath

.EXAMPLE
New-ModulePesterTests -ModuleName SPCSPS

This will get the SPCSPS module and the path that is asocciated with it and then create a ps1 file that contains a base level of Pester Tests
#>
[CmdletBinding(SupportsShouldProcess=$true)]
Param (
            [String]$ModuleName,
            [String]$OutPath
          )
    if ($PSCmdlet.ShouldProcess($OutPath,"Creating Module Pester test File for $ModuleName"))
{
    $FullModulePesterTests = Get-Content -Path "$(Split-path -Path ((Get-Module PesterHelpers).Path) -Parent)\Full-ModuleTests.txt"
    $NormModulePesterTests = Get-Content -Path "$(Split-path -Path ((Get-Module PesterHelpers).Path) -Parent)\Norm-ModuleTests.txt"
    $MinModulePesterTests = Get-Content -Path "$(Split-path -Path ((Get-Module PesterHelpers).Path) -Parent)\Min-ModuleTests.txt"

    New-Item -Path "$OutPath\$ModuleName.Full.Tests.ps1" -ItemType File -Force | Out-Null
    Set-Content -Path "$OutPath\$ModuleName.Full.Tests.ps1" -Value $FullModulePesterTests -Encoding UTF8 | Out-Null

    New-Item -Path "$OutPath\$ModuleName.Norm.Tests.ps1" -ItemType File -Force | Out-Null
    Set-Content -Path "$OutPath\$ModuleName.Norm.Tests.ps1" -Value $NormModulePesterTests -Encoding UTF8 | Out-Null

    New-Item -Path "$OutPath\$ModuleName.Min.Tests.ps1" -ItemType File -Force | Out-Null
    Set-Content -Path "$OutPath\$ModuleName.Min.Tests.ps1" -Value $MinModulePesterTests -Encoding UTF8 | Out-Null
    }

}

