#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <AutoItConstants.au3>
#pragma compile(Icon, 'lib\icon\weka-icon.ico')

$extapp_weka = IniRead ( @ScriptDir & "\config.ini", "weka", "extapp_weka", "lib\weka-3-8\weka.jar" )
$weka_classifier = IniRead ( @ScriptDir & "\config.ini", "weka", "weka_classifier", "weka.classifiers.functions.SMO" )
$weka_model = IniRead ( @ScriptDir & "\config.ini", "weka", "weka_model", "lib\weka\smo.model" )
$brainwave_arff = IniRead ( @ScriptDir & "\config.ini", "matlab", "brainwave_arff", "data\brainwave_test_set.arff" )
;$predict_result = IniRead ( @ScriptDir & "\config.ini", "config", "weka_predict_result", "data\predict_result.txt" )

$cmd_weka = @comspec & ' /C Java -cp "' & @ScriptDir & "\" & $extapp_weka & '" ' & $weka_classifier & ' -T "' & @ScriptDir & "\" & $brainwave_arff & '" -l "' & @ScriptDir & "\" & $weka_model & '" -p 0'

;MsgBox(0, "weka_predict.au3", $cmd_weka)
$DOS = Run($cmd_weka,  @SystemDir, Default, $STDOUT_CHILD)
ProcessWaitClose($DOS)
Local $predict_result = StdoutRead($DOS)
$predict_result = StringStripWS($predict_result, $STR_STRIPLEADING + $STR_STRIPTRAILING)

Local $aArray = StringSplit($predict_result, @CRLF)
$predict_result = $aArray[($aArray[0])]
$predict_result = StringStripWS($predict_result, $STR_STRIPLEADING + $STR_STRIPTRAILING)
; 1        1:? 3:Iris-virginica       0.667

$aArray = StringSplit($predict_result, ':')
$predict_result = $aArray[($aArray[0])]
$predict_result = StringStripWS($predict_result, $STR_STRIPLEADING + $STR_STRIPTRAILING)
; Iris-virginica       0.667

;MsgBox(0, "weka_predict.au3", $predict_result)
; ------------------------------------

$aArray = StringSplit($predict_result, ' ')
Local $predict_class = $aArray[1]
$predict_class = StringStripWS($predict_class, $STR_STRIPLEADING + $STR_STRIPTRAILING)

Local $predict_prop = $aArray[($aArray[0])]
$predict_prop = StringStripWS($predict_prop, $STR_STRIPLEADING + $STR_STRIPTRAILING)
$predict_prop = Number($predict_prop)
$predict_prop = $predict_prop * 100

;MsgBox(0, "weka_predict.au3", $predict_class & @CRLF & $predict_prop)

; ------------------------------------
; 顯示預測訊息
$weka_predict_title = IniRead ( @ScriptDir & "\config.ini", "weka", "weka_predict_title", "預測結果" )
$weka_predict_message = IniRead ( @ScriptDir & "\config.ini", "weka", "weka_predict_message", "人工智慧預測您剛剛聽完的結果有{prob}%是{predictclass}。您覺得這個預測是否正確？" )

$weka_predict_message = StringReplace($weka_predict_message, "{predictclass}", $predict_class)
$weka_predict_message = StringReplace($weka_predict_message, "{prob}", $predict_prop)
$weka_predict_message = StringReplace($weka_predict_message, "\n", @CRLF)

$confirm_predict = MsgBox($MB_YESNO + 262144 , $weka_predict_title, $weka_predict_message)
; Yes: 6
; No: 7
;MsgBox(0, "weka_predict.au3", $confirm_predict)

Local $form_predictclass=$predict_class
Local $form_response="Yes"
If $confirm_predict == 7 Then
   $form_response="No"
EndIf

; -------------------------
; 開啟網址
Local $form_url = IniRead ( @ScriptDir & "\config.ini", "media", "form_url", "https://docs.google.com/forms/d/e/1FAIpQLSfKkm5WUkKViB8XRnwNPIMyAszVyZeQq2So-B7TpnQ6U6qCwQ/viewform?usp=pp_url&entry.610432172={predictclass}&entry.1010189533={response}" )
$form_url = StringReplace($form_url, "{predictclass}", $form_predictclass)
$form_url = StringReplace($form_url, "{response}", $form_response)

Local $extapp_iexplore = IniRead ( @ScriptDir & "\config.ini", "form", "extapp_iexplore", "C:\Program Files\Internet Explorer\iexplore.exe" )
Local $cmd_open_form = '"' & $extapp_iexplore & '" -k ' & $form_url
;MsgBox(0, "weka_predict.au3", $cmd_open_form)
Run($cmd_open_form)