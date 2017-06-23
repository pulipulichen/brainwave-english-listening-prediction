#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#pragma compile(Icon, 'start.ico')

$debug = True

; Read ini file: Brainwave Viewer Path
$extapp_brainwave_viewer = IniRead ( @ScriptDir & "\config.ini", "config", "extapp_brainwave_viewer", "false" )

If FileExists($extapp_brainwave_viewer) == False Then
   MsgBox($MB_SYSTEMMODAL, "Error", "Brainwave Viewer not found: " & $extapp_brainwave_viewer)
   If $debug == False Then
	  Exit
   EndIf
EndIf

If FileExists($extapp_brainwave_viewer) Then
   Run($extapp_brainwave_viewer)
EndIf

; 冒出一個按鈕，這個按鈕要放在最上層，按下去就開始錄
$start_dialog_title = IniRead ( @ScriptDir & "\config.ini", "config", "start_dialog_title", "English Listening Test" )
$start_dialog_button = IniRead ( @ScriptDir & "\config.ini", "config", "start_dialog_button", "Test Start" )

   ; Create a GUI with various controls.
    Local $hGUI = GUICreate($start_dialog_title, 300, 200)

    ; Create a button control.
    Local $idNotepad = GUICtrlCreateButton($start_dialog_button, 120, 170, 85, 25)

    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    Local $iPID = 0

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $idNotepad
                ; Run Notepad with the window maximized.
                $iPID = Run("notepad.exe", "", @SW_SHOWMAXIMIZED)

        EndSwitch
    WEnd

    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)

    ; Close the Notepad process using the PID returned by Run.
    If $iPID Then ProcessClose($iPID)



