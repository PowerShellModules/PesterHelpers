function Get-CommonParameter {


<#
    .SYNOPSIS
        Helper Function to get all Common Parameters
    .DESCRIPTION
        As synopsis
    .EXAMPLE
    $CommonParameters = (Get-Command Get-CommonParameter | Select-Object -ExpandProperty Parameters).Keys

    This gets all Common Parameters into a Varaible to then be able to remove them from any automation of tests on Parameters
#>
[cmdletbinding(SupportsShouldProcess=$true)]
param()
if ($PSCmdlet.ShouldProcess($null,$null)) { }
 


}

