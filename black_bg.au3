#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#pragma compile(Icon, 'lib\icon\black_bg.ico')

$background_image = IniRead ( @ScriptDir & "\config.ini", "brain_viewer", "background_image", "lib\mpv-x86_64-20170423\background_black.gif" )
$extapp_mpv = IniRead ( @ScriptDir & "\config.ini", "brain_viewer", "extapp_mpv", "lib/mpv-x86_64-20170423/mpv.exe" )

; mpv.exe "..\..\media\listening_q1.mp4" --no-osc
$cmd_mpv = '"' & @ScriptDir & "\" & $extapp_mpv & '" "' & @ScriptDir & "\" & $background_image & '" --no-osc  --loop-file=inf --panscan=1.0'
$iPID = Run($cmd_mpv)