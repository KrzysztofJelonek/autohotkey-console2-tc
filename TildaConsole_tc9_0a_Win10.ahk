;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win10
; Author:         Wojciech 'KosciaK' Pietrzok <kosciak1@gmail.com>
;		          Krzysztof Jelonek <krzysztof.jelonek@gmail.com> (total commander integration)
;
; Script Function:
;	Based on: http://www.instructables.com/id/%22Drop-Down%22%2c-Quake-style-command-prompt-for-Window/
;	Opens Console in a Quake style (at the top of the screen using Win+Tilda)
;	
; Script Version: 0.4
;
; Changelog:
;	0.4		- Option for creating new tab in Console Here
;	0.3		- Enabled Ctrl-V por pasting
;			- Added closing #IfWinActive directives
;			- Simplified Path pasting in Ctrl-Tilda
;	0.2		- Ctrl+Tilda for Explorer window acts as Console Here
;	0.1		- Initial Release, same as http://www.instructables.com/id/%22Drop-Down%22%2c-Quake-style-command-prompt-for-Window/
;
; Additional Info:
;	Change "Console2_hidden" to what you get after inspecting Console's window
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

SetUp:
	DEFAULT_SLEEP = 0
	CONSOLE_PASTE_SLEEP = 200
	CLEAR_SCREEN_AFTER := false
	CONSOLE_APP_PATH := "c:\Software\Console2\Console.exe"
	CONSOLE_CONFIG := "console.xml"
return

; -----------------------------------
; Launch console if necessary; hide/show on Win+`
; -----------------------------------
#`::GoSub, ShowHide

; hide console on "esc".
#IfWinActive Console2_hidden
esc::GoSub, Hide

; Enable Ctrl-V shortcut for pasting
^v::Send {Shift Down}{Insert}{Shift Up}

#IfWinActive

; Ctrl+Tilda works as Console Here
#IfWinActive ahk_class TTOTAL_CMD
^`::
	prevClipboard = %clipboard%
	path := getTCCurrentPath()
	;MsgBox, %prevClipboard%
	GoSub, ShowHide
	WinWait, Console2_hidden
	consoleOperation("pushd " . path)
	if CLEAR_SCREEN_AFTER {
		consoleOperation("cls")
	}
	clipboard = %prevClipboard%
	prevClipboard = 
return
#IfWinActive

#IfWinActive ahk_class CabinetWClass
^`::
	path := getExplorerCurrentPath()
	GoSub, ShowHide
	WinWait, Console2_hidden
	Send {Ctrl Down}{F1}{Ctrl Up}
	operationSleep()
	consoleOperation("pushd " . path)
	if CLEAR_SCREEN_AFTER {
		consoleOperation("cls")
	}
return
#IfWinActive

Hide:
	WinHide Console2_hidden
	WinActivate ahk_class Shell_TrayWnd
return

ShowHide:
	DetectHiddenWindows, on
	IfWinExist Console2_hidden
	{
		IfWinActive Console2_hidden
			GoSub, Hide
		else {
			WinShow Console2_hidden
			WinActivate Console2_hidden
		}
	} else {
		GoSub, SetUp
		Run "%CONSOLE_APP_PATH%" -c %CONSOLE_CONFIG% -w Console2_hidden
	}
	DetectHiddenWindows, off
return

consoleOperation(cmd) {
	clipboard := cmd
	consolePaste()
}

consolePaste() {
	global CONSOLE_PASTE_SLEEP
	Sleep, %CONSOLE_PASTE_SLEEP%
	Send, {Shift Down}{Insert}{Shift Up}{Enter}
	Sleep, %CONSOLE_PASTE_SLEEP%
}

operationSleep() {
	global DEFAULT_SLEEP
	if (DEFAULT_SLEEP > 0) {
		Sleep, %DEFAULT_SLEEP%
	}
}

;Return Windows 10 explorer current path
getExplorerCurrentPath() {
	ControlGetText, text, ToolbarWindow323
	path := SubStr(text, 8)
	return path
}

;Return Total Commander 9.0a current path
getTCCurrentPath() {
	ControlGetText, text, Window6
	position := InStr(text, "`n")
	path := SubStr(text, 1, position - 1)
	position := ""
	return path
}

#IfWinActive, ahk_class TTOTAL_CMD
$BS::
  ControlGetFocus, tcFocus
  ControlGetText, tcStatus1, TMyPanel9
  ControlGetText, tcStatus2, TMyPanel5
  SendInput, {BS}

  ; only when the actual TC panels are active
  If(  RegExMatch( tcFocus, "^TMyListBox1$" )  )
    tcStatus := tcStatus1
  Else
  If(  RegExMatch( tcFocus, "^TMyListBox2$" )  )
    tcStatus := tcStatus2
  Else
    Return

  If(  RegExMatch( tcStatus, "^.:\\\*\.\*$" )  )
    PostMessage, 1075, 2122  ; cm_OpenDrives
Return

#IfWinExist, ahk_class TTOTAL_CMD

; Default shortcut is Win-A
$#a::

	; Read current TC dir from the panel left of the command line
	;ControlGetText, Path, Edit1
	Path:= getTCCurrentPath()
	; Replace the trailing > with a \
	;StringReplace, Path, Path, >, \
	StringReplace, Path, Path, ",,1

	; Type it
	SendRaw, %Path%
Return
