Set-Location "HKCU:\Control Panel\Accessibility\Keyboard Response"
Set-ItemProperty -Path . -Name AutoRepeatDelay       -Value 170
Set-ItemProperty -Path . -Name AutoRepeatRate        -Value 15
Set-ItemProperty -Path . -Name DelayBeforeAcceptance -Value 0
Set-ItemProperty -Path . -Name BounceTime            -Value 0
Set-ItemProperty -Path . -Name Flags                 -Value 47  # Disables Filter Keys

Set-Location "HKCU:\Control Panel\Accessibility\StickyKeys"
Set-ItemProperty -Path . -Name Flags        -Value 506
Set-ItemProperty -Path . -Name HotKeyActive -Value 0

Set-Location "HKCU:\Control Panel\Accessibility\ToggleKeys"
Set-ItemProperty -Path . -Name Flags        -Value 58
Set-ItemProperty -Path . -Name HotKeyActive -Value 0

Set-Location "HKCU:\Control Panel\Accessibility\Keyboard Response"
Set-ItemProperty -Path . -Name HotKeyActive -Value 0

Write-Output "Accessibility settings cleaned up. Sticky/Toggle/Filter keys disabled. Key repeat optimized."

