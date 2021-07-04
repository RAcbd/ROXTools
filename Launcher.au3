#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\ralph\Pictures\TeeyoTV\Team 55 - Logo\Main - OrangeWhite.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===============================================================================
; Name...........: Ragnarok X - EXP PER HOUR Calculator
; Description ...: Tool to calculate:

;					1) Exp per hour
;					2) Exp Gains

; Coded By: Raff - Odin Valhalla
;===============================================================================

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <StatusBarConstants.au3>
#include <WindowsConstants.au3>
#include <INet.au3>
#include <Constants.au3>

Global $GUI_NAME = "rHelper Launcher"

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate($GUI_NAME, 300, 80, 406, 324)
$Button1 = GUICtrlCreateButton("EXP Calculator", -1, -1, -1, -1, 0)
$Button2 = GUICtrlCreateButton("Exp Per Hour", -1, 30, -1, -1, 0)
$Label1 = GUICtrlCreateLabel("Coded By: Raff", 210, 20, 96, 17)

$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

WinSetOnTop($GUI_NAME, "", 1)

While 1
	$nMsg = GUIGetMsg()
	Sleep(20)
	Switch $nMsg

		Case $GUI_EVENT_CLOSE
		AdlibUnregister()
		Exit

		Case $Button2
			If WinExists("rHelper - Exp Per Hour") Then
			WinActivate("rHelper - Exp Per Hour")
			WinWaitActive("rHelper - Exp Per Hour")
			Else
			Run("exphour.exe")
			EndIf

		Case $Button1
			If WinExists("rHelper - EXP Calculator") Then
			WinActivate("rHelper - EXP Calculator")
			WinWaitActive("rHelper - EXP Calculator")
			Else
			Run("expcalc.exe")
			EndIf
EndSwitch
WEnd

;===============================================================================
