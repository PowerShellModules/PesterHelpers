function New-ModulePesterTest {
    
     <#
        .SYNOPSIS
            Creates a ps1 file that includes a subset of basic pester tests
        .DESCRIPTION
            As synopsis
        .EXAMPLE
            New-ModulePesterTests -ModuleName SPCSPS
            
            This will get the SPCSPS module and the path that is asocciated with it and then create a ps1 file that contains a base level of Pester Tests         
        #>
        [CmdletBinding()]
    Param (
            [String]$ModuleName
          )
    $DefaultModulePesterTests = Get-Content -Path "$(Split-path -Path ((Get-Module PesterHelpers).Path) -Parent)\ModuleTests.txt"
    
    $ModulePath = "$(Get-Module $ModuleName | Select-Object -ExpandProperty ModuleBase)\"
    New-Item -Path "$ModulePath$ModuleName.Tests.ps1" -ItemType File -Force | Out-Null
    Set-Content -Path "$ModulePath$ModuleName.Tests.ps1" -Value $DefaultModulePesterTests | Out-Null
    
}
