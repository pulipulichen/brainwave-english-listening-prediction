#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstantS.au3>
#include <FontConstants.au3>
#pragma compile(Icon, 'lib\icon\start.ico')

$debug = True

; Read ini file: Brainwave Viewer Path
$extapp_brain_viewer = IniRead ( @ScriptDir & "\config.ini", "config", "extapp_brain_viewer", "false" )

If FileExists($extapp_brain_viewer) == False Then
   MsgBox($MB_SYSTEMMODAL, "Error", "Brainwave Viewer not found: " & $extapp_brain_viewer)
   If $debug == False Then
	  Exit
   EndIf
EndIf

If FileExists($extapp_brain_viewer) Then
   Run($extapp_brain_viewer)
EndIf

; ----------------------------------------------------

; 冒出一個按鈕，這個按鈕要放在最上層，按下去就開始錄
$start_dialog_title = IniRead ( @ScriptDir & "\config.ini", "config", "start_dialog_title", "English Listening Test" )
$start_dialog_button = IniRead ( @ScriptDir & "\config.ini", "config", "start_dialog_button", "Test Start" )
$icon = @ScriptDir &  "\lib\icon\start.ico"
$icon_record = @ScriptDir &  "\lib\icon\start_record.ico"
$button_click_event="start_record.exe"

; Create a GUI with various controls.
 Local $hGUI = GUICreate($start_dialog_title, 250, 50)
 GUISetIcon($icon)

 ; Create a button control.
 Local $idButton = GUICtrlCreateButton(" " & $start_dialog_button, 0, 0, 250, 50,  BitOR($BS_MULTILINE, $BS_CENTER, $BS_VCENTER, $WS_EX_WINDOWEDGE))
 GUICtrlSetFont($idButton, 14, $FW_BOLD )
 ; GUICtrlSetImage(-1, "shell32.dll", 22)
 GUICtrlSetImage(-1, $icon_record, 22)

 ; Display the GUI.
 GUISetState(@SW_SHOW, $hGUI)

 Local $iPID = 0

 ; Loop until the user exits.
 While 1
	 Switch GUIGetMsg()
		 Case $GUI_EVENT_CLOSE
			 ExitLoop
		 Case $idButton
			; Run Notepad with the window maximized.
			;$iPID = Run("notepad.exe", "", @SW_SHOWMAXIMIZED)
			;MsgBox($MB_SYSTEMMODAL, "Error", "Brainwave Viewer not found: " )
			GUIDelete($hGUI)
			RunWait($button_click_event)
	 EndSwitch
 WEnd


