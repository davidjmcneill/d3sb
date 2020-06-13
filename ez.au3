#include <functions.au3>
#include <Array.au3>
#NoTrayIcon
Global $Paused
Global $dir
Global $dir_parent
HotKeySet("{F1}","Quit2") ;closes script
HotKeySet("{F2}", "Pause") ;pauses script
;If Not ProcessExists("gui.exe") Then
  ; Run("gui.exe")
 ;  Sleep(500)
;EndIf
$i = 0
If $i = 0 Then
   Login()
   $i = $i + 1
EndIf
WinActivate("[CLASS:D3 Main Window Class]")
Prep()