## Force Windows to use UTF-8 rather than a legacy locale as UTF-16 fallback

## Changes will not take affect until after reboot. The program makes no attempt
## to notify user of this, let alone force it.

## Users shoud expect to see a UAC prompt allowing program to run as admin
## which is required to update the registry.  

## Note that the program *does not* however try to circumvent restrictions on 
## execution of unsigned code from a remote origin. (Asking you to trust this code is one thing. 
## Asking you trun run *any* code is quite another).  To unblock this script, see:
## https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4#example-7-unblock-a-script-to-run-it-without-changing-the-execution-policy

param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

'running with full privileges'

## NOTES regarding privilege escalation code above:
## -- sourced from https://superuser.com/a/532109 
## -- under terms of the CC BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/
## -- original author https://superuser.com/users/35868/mdmoore313
  
If((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage") -NE $True) {New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Force};
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage' -Name 'ACP' -Value '65001' -PropertyType String -Force;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage' -Name 'OEMCP' -Value '65001' -PropertyType String -Force;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage' -Name 'MACCP' -Value '65001' -PropertyType String -Force;
