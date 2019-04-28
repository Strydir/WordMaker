#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\Phantom\OneDrive\Documents\ObjectDock Library\Icons\WordMaker.ico
#AutoIt3Wrapper_Outfile=WordMaker.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <String.au3>


Global $letter, $FirstLetter, $Word_Input, $Title, $ObjectPath, $symb, $NsLetRead, $ReadKa1Let, $ReadKa2Let, $ReadKa3Let, $ReadKd1Let, $ReadKd2Let, $ReadKd3Let, $ReadKs1Let, $ReadKs2Let
Global	$ReadKs3Let, $ReadKe1Let, $ReadKe2Let, $ReadKe3Let, $ReadScaleLet, $NsSymRead, $ReadKa1Sym, $ReadKa2Sym, $ReadKa3Sym, $ReadKd1Sym, $ReadKd2Sym, $ReadKd3Sym, $ReadKs1Sym
Global	$ReadKs2Sym, $ReadKs3Sym, $ReadKe1Sym, $ReadKe2Sym, $ReadKe3Sym, $ReadScaleSym, $ReadIllumLet, $ReadIllumSym, $Room, $Copying, $CurrentFont, $CurrentSymbolFont
Global $NsWingRead, $ReadKa1Wing, $ReadKa2Wing, $ReadKa3Wing, $ReadKd1Wing, $ReadKd2Wing, $ReadKd3Wing, $ReadKs1Wing, $ReadKs2Wing, $ReadKs3Wing, $ReadKe1Wing, $ReadKe2Wing, $ReadKe3Wing, $ReadScaleWing, $ReadIllumWing

Global $config_ini = @ScriptDir & "\config.ini"

Global $Toolbox_Dir = IniRead($config_ini, "Settings", "VRToolbox_Dir", "")
If Not FileExists($Toolbox_Dir) Then
	MsgBox(16, "Error", "This program requires VRToolbox, please select your VRToolbox installation folder.")
	$Toolbox_Dir = FileSelectFolder("VRToolbox Directory", "")
	If Not FileExists($Toolbox_Dir & "\props") Then
		MsgBox(48, "Error", "This program requires VRToolbox, please install it before attempting to run this app.")
		Exit
	Else
		IniWrite($config_ini, "Settings", "VRToolbox_Dir", $Toolbox_Dir)
	EndIf
EndIf


Global $testProps = "H:\Test\Nested\Props\"
Global $Props = $Toolbox_Dir & "\props\"
Global $SessionRoom = @MyDocumentsDir & "\my games\VR Toolbox\save\SessionRoom.json"
Global $WordRoom = @MyDocumentsDir & "\my games\VR Toolbox\save\Words.room"
Global $XShift = IniRead($config_ini, "Settings_WordMaker", "Xshift", "")
Global $YShift = IniRead($config_ini, "Settings_WordMaker", "Yshift", "")

Global $LetterFiles = $Props & "Letters_"
Global $SymbolFiles = $Props & "Symbols_"
Global $WingDingFiles = $Props & "WingDings_"
Global $StartMTLFileLetter = $LetterFiles & "A\CapA.mtl"
Global $StartMTLFileWingDings = $WingDingFiles & "Happy\Happy.mtl"
Global $StartMTLFileSymbol = $SymbolFiles & "And\And.mtl"
Global $StartDescFileWingDings = $WingDingFiles & "Happy\Description.json"
Global $StartDescFileLetter = $LetterFiles & "A\Description.json"
Global $StartDescFileSymbol = $SymbolFiles & "And\Description.json"
Global $FontTest = $LetterFiles & "A\Font.txt"
Global $FontTestSymbol = $SymbolFiles & "Exclamation\Font.txt"
Global $FontStateLetter = IniRead($FontTest, "Setting", "Font", "")
Global $FontStateSymbol = IniRead($FontTestSymbol, "Setting", "Font", "")
Global $Stripped = False


If Not FileExists($StartMTLFileLetter) And Not FileExists($StartMTLFileSymbol) And Not FileExists($StartMTLFileWingDings) Then
	$AlphabetTest = MsgBox(1, "Copy Alphabet", "It appears that you don't have an 'Alphabet' installed.  Please choose one to copy")
	If $AlphabetTest = 1 Then
		$FontType = "Letter"
		_Change_LetterFonts()
		MsgBox(0, "Copy Symbols", "Choose a font to use for the Symbols.  Unless you have a reason not to, I recommend that you use the same font that you selected for your letters.")
		$FontType = "Symbol"
		_Change_SymbolFonts()
		$WingsWriteTest = MsgBox(1, "", "Now to install the WingDings!  Proceed?")
		If $WingsWriteTest = 1 Then
			$FontType = "WingDing"
			_Change_WingDings()
		EndIf
		If Not FileExists($StartMTLFileLetter) And Not FileExists($StartMTLFileSymbol) And Not FileExists($StartMTLFileWingDings) Then
			MsgBox(48, "No Files", "There were no objects copied.  The program will now exit.")
			Exit
		EndIf
	Else
		If Not FileExists($StartMTLFileWingDings) Then
			$WingDingTest = MsgBox(1, "Copy WingDings", "You don't have any WingDings installed either.  Would you like to install them now?")
			If $WingDingTest = 1 Then
				_Change_WingDings()
			Else
				MsgBox(0, "", "You've chosen to cancel. You need an Alphabet or WingDings to use this program, it will now exit.")
				Exit
			EndIf
		EndIf
	EndIf
EndIf


Global $Version = "1.5", $Xcoor = $XShift, $Ycoor = 0, $lineNumber = 0, $FontType = "Letter"

Opt("GUIOnEventMode", 1)

;$aFonts = _FileListToArray($sFontSelectFolder, "Symbols_*", $FLTA_FOLDERS, True)
;$aWings = _FileListToArray(@ScriptDir & "\WingDings", "WingDings_*", $FLTA_FOLDERS, True)
;$aWings = _FileListToArray(@ScriptDir & "\WingDings", "*", $FLTA_FOLDERS, True)
;_ArrayDisplay($aWings)
;If @error Then MsgBox(0, "", "no array")




Global $WordMakerGUI = GUICreate("WordMaker", 440, 560, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_SYSMENU, $WS_EX_CLIENTEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Close")

Global $Label_Title = GUICtrlCreateLabel("WordMaker for VR Toolbox", 65, 3, 350, 30)
GUICtrlSetFont($Label_Title, 14, 600, 4)

Global $WordInput_Ctrl = GUICtrlCreateEdit("", 25, 35, 325, 100)
GUICtrlSetFont($WordInput_Ctrl, 14)

Global $ClearRoom_Button = GUICtrlCreateButton("Clear Room", 365, 35, 65, 30)
GUICtrlSetOnEvent($ClearRoom_Button, "_Clear_Room")
GuiCtrlSetTip($ClearRoom_Button, "Caution: clears the room and resets it to a 'desktop' and a default 'skymap'")

Global $Modify_Button = GUICtrlCreateButton("Modify Fonts Colors", 50, 150, 50, 50, $BS_MULTILINE)
GUICtrlSetOnEvent($Modify_Button, "_Modify_Objects")
GuiCtrlSetTip($Modify_Button, "Modify your Letters color and intensity." & @CRLF & "Note: changes won't take effect until VRToolbox is restarted." & @CRLF & _
			"Note: since all words use the same letter objects, all changes are 'Universal'.")

Global $Group_Spacing = GUICtrlCreateGroup("", 140, 145, 118, 60)

Global $Spacing_Button = GUICtrlCreateButton("Set Letter Spacing", 145, 150, 50, 50, $BS_MULTILINE)
GUICtrlSetOnEvent($Spacing_Button, "_Spacing")
GuiCtrlSetTip($Spacing_Button, "Set spacing between letters.")

Global $SpacingX_Label = GUICtrlCreateLabel("X:", 205, 156, 20, 20)

Global $SpacingX = GUICtrlCreateInput("X", 223, 153, 30, 20)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetData($SpacingX, $XShift)

Global $SpacingY_Label = GUICtrlCreateLabel("Y:", 205, 180, 20, 20)

Global $SpacingY = GUICtrlCreateInput("Y", 223, 177, 30, 20)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetData($SpacingY, $YShift)

Global $WriteWord_Button = GUICtrlCreateButton("Write to Words Room", 290, 150, 60, 50, $BS_MULTILINE)
GUICtrlSetOnEvent($WriteWord_Button, "_Write_WordRoom")
GuiCtrlSetTip($WriteWord_Button, "Writes your text to the Words.room file")

Global $WriteSession_Button = GUICtrlCreateButton("Write to Session Room", 370, 150, 60, 50, $BS_MULTILINE)
GUICtrlSetOnEvent($WriteSession_Button, "_Write_SessionRoom")
GuiCtrlSetTip($WriteSession_Button, "Writes your text to the current Session.room file" & @CRLF & "Note that VRToolbox must NOT be running or your changes will be ignored.")

Global $Clear_Button = GUICtrlCreateButton("Clear Text", 365, 105, 65, 30)
GUICtrlSetOnEvent($Clear_Button, "_Clear_Edit")
GuiCtrlSetTip($Clear_Button, "Clears the text field")

Global $Label_Usage = GUICtrlCreateLabel("Usage", 170, 220, 70, 30)
GUICtrlSetFont($Label_Usage, 16, 600, 4)

Global $Label_UsageText = GUICtrlCreateLabel("       This allows you to add 3D text to the 'Words.room' file." & @CRLF & _
										"You can add as much as you'd like, but each time that you press the 'Write' button, " & _
										"it starts your text at the beginning coordinates.  You will need to drag the strings off of each other in VR*." & @CRLF & @CRLF & _
										"To see your Words, load the 'Words.room' file: go to the 'Rooms' tab of the main VRToolbox Settings window and click 'Load'.  " & _
										"Navigate to 'Documents\My Games\VR Toolbox\save\Words.room'." & @CRLF & @CRLF & _
										"Arrange things how you'd like and then save it back to the room, overwriting the Words.room file.  " & _
										"Always save your room over the existing Words.room file before Writing, in order to add your new Words to your active room." & @CRLF & @CRLF & _
										"If VRToolbox is NOT running, you can write directly to the Session Room so that your Words will be there the next time that you enter VRToolbox.", 25, 250, 395, 290)
GUICtrlSetFont($Label_UsageText, 10)
Global $Label_Note = GUICtrlCreateLabel("*Note: you can only interact with the first character. Use it to move or resize your Words.", 10, 535, 395, 30)
GUICtrlSetFont($Label_Note, 8)

Global $Exit_Button = GUICtrlCreateButton("Exit", 400, 530, 40, 30)
GUICtrlSetOnEvent($Exit_Button, "_Close")
GUICtrlSetBkColor($Exit_Button, $COLOR_RED)
GUICtrlSetColor($Exit_Button, $COLOR_WHITE)

GUISetState(@SW_SHOW)




While 1
	Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
	EndSwitch
	Sleep(250)
WEnd




Func _Clear_Edit()
	GUICtrlSetData($WordInput_Ctrl, "")
EndFunc

Func _Write_WordRoom()
	If FileExists($StartMTLFileLetter) Then
		$Room = $WordRoom
		_WordStripper()
		If $Stripped = True Then
			MsgBox(0, "Complete", "Text written to 'Documents\My Games\VR Toolbox\save\Words.room'", 2)
			$Stripped = False
		EndIf
	Else
		MsgBox(48, "Missing Letters", "You need to write the Letters to the Props directory first." & @CRLF & "Click the 'Modify Fonts Colors' button.  In the window that appears, click 'Change Font'." & @CRLF & _
					"Browse to the Letter Font that you would like.")
	EndIf
EndFunc

Func _Write_SessionRoom()
	If FileExists($StartMTLFileLetter) Then
		$Room = $SessionRoom
		_WordStripper()
		If $Stripped = True Then
			MsgBox(0, "Complete", "Text written to your current Session Room'", 1)
			$Stripped = False
		EndIf
	Else
		MsgBox(48, "Missing Letters", "You need to write the Letters to the Props directory first." & @CRLF & "Click the 'Modify Fonts Colors' button.  In the window that appears, click 'Change Font'." & @CRLF & _
					"Browse to the Letter Font that you would like.")
	EndIf

EndFunc

Func _WordStripper()
	$Word_Input = GUICtrlRead($WordInput_Ctrl)
	$Word_Input = StringStripWS($Word_Input, 1)
	If $Word_Input <> "" Then

		$FirstRun = True
;		$aLetters = _FileListToArray($Props, "Letters_*")
		$Input_Length = StringLen($Word_Input)
		$lineCount = _FileCountLines($Room) - 2
		$letter = StringTrimRight($Word_Input, $Input_Length - 1)
		If $letter <> Chr(13)  And $letter <> " " Then
			$FirstLetter = $letter
			_Letter_Test()
			$FirstObject = $ObjectPath
			_FileWriteToLine($Room, $lineCount - 1, "  },", True)
			_FileWriteToLine($Room, $lineCount, '"' & $Title & '_001103' & Random(0, 99, 1) & Random(0, 99, 1) & 'L": {' & @CRLF & _
							'	"AltSkin": false,' & @CRLF & _
							'	"Children": {', False)
			For $x = 2 to $Input_Length
				$letter = StringTrimRight($Word_Input, $Input_Length - $x)
				$letter = StringTrimLeft($letter, $x - 1)
				If $letter <> Chr(13) Then
					If $letter <> " " Then
						$Xcoor1 = $Xcoor
						$Ycoor1 = $Ycoor
						_Letter_Test()
						If StringIsLower($letter) Then
							If $letter <> "b" And $letter <> "d" And $letter <> "f" And $letter <> "h" And $letter <> "k" And $letter <> "l" Then
								If $letter = "g" Or $letter = "j" Or $letter = "p" Or $letter = "q" Or $letter = "y" Then
									$Ycoor = $Ycoor - .11
								ElseIf $letter = "i" Or $letter = "t" Then
									$Ycoor = $Ycoor - .01
								Else
									$Ycoor = $Ycoor - .05
								EndIf
							EndIf
						EndIf
						_Write_Letter_2_Room()
						$Xcoor = $Xcoor1 + $XShift
						$Ycoor = $Ycoor1
					Else
						$Xcoor = $Xcoor + $XShift
					EndIf
				Else
					$Ycoor = $Ycoor - $YShift
					$Xcoor = $XShift - $XShift
					$x = $x + 1
				EndIf
			Next

			Local $lineCountE = _FileCountLines($Room) - 2
			_FileWriteToLine($Room, $lineCountE - 1, "    }", True)
			_FileWriteToLine($Room, $lineCountE, "  }," & @CRLF & _
							'   "ClassID": "PropMesh",' & @CRLF & _
							'   "Flags": 33042,' & @CRLF & _
							'   "ObjectPath": "' & $FirstObject & '",' & @CRLF & _
							'   "WorldMatrix": [' & @CRLF & _
							'    0.0598060451447964,' & @CRLF & _
							'    -0.000479801237815991,' & @CRLF & _
							'    0.0143819330260158,' & @CRLF & _
							'    -0.4,' & @CRLF & _    ; X
							'    0.0,' & @CRLF & _
							'    0.0614808574318886,' & @CRLF & _
							'    -0.0019843284972012,' & @CRLF & _
							'    1.0,' & @CRLF & _    ;Y
							'    -0.014389923773706,' & @CRLF & _
							'    0.00192551489453763,' & @CRLF & _
							'    0.0597750432789326,' & @CRLF & _
							'    -1.0,' & @CRLF & _    ;Z
							'    0.0,' & @CRLF & _
							'    0.0,' & @CRLF & _
							'    0.0,' & @CRLF & _
							'    1' & @CRLF & _
							'   ]' & @CRLF & _
							'  }', False)

				$Word_Input = ""
			$Ycoor = 0
			$Xcoor = $XShift
			$Stripped = True
		Else
			MsgBox(48, "Error", "You can't have a space or carriage return as the first character")
		EndIf
	EndIf
EndFunc


Func _Letter_Test()
	If StringIsLower($letter) Then
		$ObjectPath = "props/Letters_" & $letter & $letter & "/Small" & $letter & ".obj"
		$Title = "Small_" & $letter
	ElseIf StringIsUpper($letter) Then
		$ObjectPath = "props/Letters_" & $letter & "/Cap" & $letter & ".obj"
		$Title = "Capital_" & $letter
	ElseIf StringIsAlNum($letter) Then
		$ObjectPath = "props/Letters_" & $letter & "/" & $letter & ".obj"
		$Title = "Number_" & $letter
	Else
		Switch $letter
			Case "&"
				$symb = "And"
			Case "*"
				$symb = "Asterisk"
			Case "@"
				$symb = "At"
			Case "\"
				$symb = "Backslash"
			Case "{"
				$symb = "BracesL"
			Case "}"
				$symb = "BracesR"
			Case "["
				$symb = "BracketsL"
			Case "]"
				$symb = "BracketsR"
			Case ":"
				$symb = "Colon"
			Case ","
				$symb = "Comma"
			Case "-"
				$symb = "Dash"
			Case "$"
				$symb = "Dollar"
			Case "="
				$symb = "Equals"
			Case "!"
				$symb = "Exclamation"
			Case ">"
				$symb = "Greater"
			Case "<"
				$symb = "Lesser"
			Case "%"
				$symb = "Percent"
			Case "."
				$symb = "Period"
			Case "("
				$symb = "Pleft"
			Case "+"
				$symb = "Plus"
			Case "#"
				$symb = "Pound"
			Case ")"
				$symb = "Pright"
			Case "?"
				$symb = "Question"
			Case "'"
				$symb = "Quote"
			Case ";"
				$symb = "sColon"
			Case "/"
				$symb = "Slash"
			Case "_"
				$symb = "Underscore"
			Case Else
				$symb = "Question"
			EndSwitch
		$ObjectPath = "props/Symbols_" & $symb & "/" & $symb & ".obj"
		$Title = "Symbol_" & $symb
	EndIf

EndFunc

Func _Spacing()
	$XShift = GUICtrlRead($SpacingX)
	If StringLeft($XShift, 1) = "." Then $XShift = "0" & $XShift
	$YShift = GUICtrlRead($SpacingY)
	If StringLeft($YShift, 1) = "." Then $YShift = "0" & $YShift
	IniWrite($config_ini, "Settings_WordMaker", "Xshift", $XShift)
	IniWrite($config_ini, "Settings_WordMaker", "Yshift", $YShift)
	MsgBox(0, "", "Letter spacing set", 1)
EndFunc

Func _Write_Letter_2_Room()
	Local $lineCountW = _FileCountLines($Room) - 2
	_FileWriteToLine($Room, $lineCountW, '    "' & $Title & '_001103c' & Random(0, 99, 1) & Random(0, 99, 1) & Random(0, 99, 1) & '": {' & @CRLF & _
					'	  "AltSkin": false,' & @CRLF & _
					'	  "ClassID": "PropMesh",' & @CRLF & _
					'	  "Flags": 33040,' & @CRLF & _
					'	  "ObjectPath": "' & $ObjectPath & '",' & @CRLF & _
					'	  "WorldMatrix": [' & @CRLF & _
					'	   1,' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   ' & $Xcoor & ',' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   1,' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   ' & $Ycoor & ',' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   1,' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   0.0,' & @CRLF & _
					'	   1' & @CRLF & _
					'	  ]' & @CRLF & _
					'   },', False)
EndFunc

Func _Clear_Room()
;#cs
	Local $Clearing = MsgBox(1, "Caution", "Are you sure that you want to reset the Room?")
	If $Clearing = 1 Then
		FileDelete($Room)
		_Write_base_room()
		MsgBox(0, "", "Cleared", 1)
	EndIf
;#ce
EndFunc

Func _Write_base_room()
	FileWriteLine($Room, '{' & @CRLF & _
								' "TopContainer": {'	 & @CRLF & _
								' "Screen0": {' & @CRLF & _
								'  "Capture": {' & @CRLF & _
								'   "ClassID": "CaptureDesktop",' & @CRLF & _
								'   "OutputIndex": 0' & @CRLF & _
								'  },' & @CRLF & _
								'  "ClassID": "Window",' & @CRLF & _
								'  "Settings": {' & @CRLF & _
								'  "CylRadius": 2.55000019073486,' & @CRLF & _
								'  "Flags": 1298,' & @CRLF & _
								'  "Stereo": 0,' & @CRLF & _
								'  "Transparency": 0' & @CRLF & _
								' },' & @CRLF & _
								' "WorldMatrix": [' & @CRLF & _
								'  0.998128831386566,' & @CRLF & _
								'  0.0,' & @CRLF & _
								'  -0.0611462481319904,' & @CRLF & _
								'  0.155922949314117,' & @CRLF & _
								'  0.0,' & @CRLF & _
								'  1,' & @CRLF & _
								'  0.0,' & @CRLF & _
								'  1.31126499176025,' & @CRLF & _
								'  0.0611462481319904,' & @CRLF & _
								'  0.0,' & @CRLF & _
								'  0.998128831386566,' & @CRLF & _
								'  -2.5452287197113,' & @CRLF & _
								'  0.0,' & @CRLF & _
								'  0.0,' & @CRLF & _
								'  0.0,' & @CRLF & _
								'  1' & @CRLF & _
								' ]' & @CRLF & _
								' },' & @CRLF & _
								' "SkyBox": {' & @CRLF & _
								'  "ClassID": "SkyBox",' & @CRLF & _
								'  "Flags": 768,' & @CRLF & _
								'  "Texture": "Misty Mountains",' & @CRLF & _
								'  "WorldMatrix": [' & @CRLF & _
								'   1,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   1,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   1,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   0.0,' & @CRLF & _
								'   1' & @CRLF & _
								'  ]' & @CRLF & _
								' }' & @CRLF & _
								'},' & @CRLF & _
								' "Version": 1' & @CRLF & _
								'}')


EndFunc

Func _Modify_Objects()
If Not WinExists("ModifyWordsForm") Then
	Global $ModifyWordsForm = GUICreate("ModifyWordsForm", 955, 500)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Close_Modify")
	GUISetBkColor(0xEFEFEF)

	$Letters = GUICtrlCreateGroup("Letters", 15, 20, 295, 440)
	GUICtrlSetFont(-1, 16, 400, 4, "MS Sans Serif")

	$Symbols = GUICtrlCreateGroup("Symbols", 330, 20, 295, 440)
	GUICtrlSetFont(-1, 16, 400, 4, "MS Sans Serif")

	$WingDings = GUICtrlCreateGroup("WingDings", 645, 20, 295, 360)
	GUICtrlSetFont(-1, 16, 400, 4, "MS Sans Serif")


	$Ns = GUICtrlCreateLabel("Ns", 40, 108, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Ka = GUICtrlCreateLabel("Ka", 40, 155, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Kd = GUICtrlCreateLabel("Kd", 40, 190, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Ks = GUICtrlCreateLabel("Ks", 40, 224, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Ke = GUICtrlCreateLabel("Ke", 40, 258, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Colors = GUICtrlCreateLabel("Colors", 155, 60, 58, 28)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
	$Label19 = GUICtrlCreateLabel("Illum", 40, 310, 49, 24)
	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")
	$Scale = GUICtrlCreateLabel("Scale", 40, 350, 49, 24)
	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")

	$WriteLet = GUICtrlCreateButton("Write", 182, 312, 113, 57)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GuiCtrlSetTip($WriteLet, "Write values to Letters")
	GUICtrlSetOnEvent($WriteLet, "_Write_Letters_stub")

	$WriteSym = GUICtrlCreateButton("Write", 500, 312, 113, 57)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GuiCtrlSetTip($WriteSym, "Write values to Symbols")
	GUICtrlSetOnEvent($WriteSym, "_Write_Symbols_stub")

	$ChangeLetterFont = GUICtrlCreateButton("Change Font",40, 390, 113, 57)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GUICtrlSetOnEvent($ChangeLetterFont, "_Change_LetterFonts")

	$LabelLetterFont = GUICtrlCreateLabel("Current Font", 170, 400, 100, 24)
	GUICtrlSetFont(-1, 10, 600, 4, "MS Sans Serif")
	Global $CurrentFont = GUICtrlCreateLabel($FontStateLetter, 175, 420, 100, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$ChangeSymbolFont = GUICtrlCreateButton("Change Font", 356, 390, 113, 57)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GUICtrlSetOnEvent($ChangeSymbolFont, "_Change_SymbolFonts")

	$LabelSymbolFont = GUICtrlCreateLabel("Current Font", 485, 400, 100, 24)
	GUICtrlSetFont(-1, 10, 600, 4, "MS Sans Serif")
	Global $CurrentSymbolFont = GUICtrlCreateLabel($FontStateSymbol, 490, 420, 100, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$ReadKa1Let = GUICtrlCreateInput("Ka1", 85, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa2Let = GUICtrlCreateInput("Ka2", 160, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa3Let = GUICtrlCreateInput("Ka3", 235, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$NsLetRead = GUICtrlCreateInput("Ns", 85, 108, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd1Let = GUICtrlCreateInput("Kd1", 85, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd2Let = GUICtrlCreateInput("Kd2", 160, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd3Let = GUICtrlCreateInput("Kd3", 235, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs1Let = GUICtrlCreateInput("Ks1", 85, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs2Let = GUICtrlCreateInput("Ks2", 160, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs3Let = GUICtrlCreateInput("Ks3", 235, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe1Let = GUICtrlCreateInput("Ke1", 85, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe2Let = GUICtrlCreateInput("Ke2", 160, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe3Let = GUICtrlCreateInput("Ke3", 235, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadIllumLet = GUICtrlCreateInput("Illum", 105, 310, 40, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadScaleLet = GUICtrlCreateInput("Scale", 105, 350, 40, 20)
	GUICtrlSetColor(-1, 0xFF0000)

	$Label7 = GUICtrlCreateLabel("Ns", 356, 108, 23, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label1 = GUICtrlCreateLabel("Ka", 356, 155, 22, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label2 = GUICtrlCreateLabel("Kd", 356, 190, 22, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label3 = GUICtrlCreateLabel("Ks", 356, 224, 22, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label4 = GUICtrlCreateLabel("Ke", 356, 258, 22, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label18 = GUICtrlCreateLabel("Illum", 356, 310, 49, 20)
	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")
	$Label5 = GUICtrlCreateLabel("Scale", 356, 350, 49, 20)
	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")
	$Label6 = GUICtrlCreateLabel("Colors", 462, 59, 58, 20)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
	$NsSymRead = GUICtrlCreateInput("Ns", 400, 108, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa1Sym = GUICtrlCreateInput("Ka1", 400, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa2Sym = GUICtrlCreateInput("Ka2", 475, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa3Sym = GUICtrlCreateInput("Ka3", 550, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd1Sym = GUICtrlCreateInput("Kd1", 400, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd2Sym = GUICtrlCreateInput("Kd2", 475, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd3Sym = GUICtrlCreateInput("Kd3", 550, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs1Sym = GUICtrlCreateInput("Ks1", 400, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs2Sym = GUICtrlCreateInput("Ks2", 475, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs3Sym = GUICtrlCreateInput("Ks3", 550, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe1Sym = GUICtrlCreateInput("Ke1", 400, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe2Sym = GUICtrlCreateInput("Ke2", 475, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe3Sym = GUICtrlCreateInput("Ke3", 550, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadIllumSym = GUICtrlCreateInput("Illum", 420, 310, 40, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadScaleSym = GUICtrlCreateInput("Scale", 420, 350, 40, 20)
	GUICtrlSetColor(-1, 0xFF0000)


	$NsWing = GUICtrlCreateLabel("Ns", 670, 108, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$KaWing = GUICtrlCreateLabel("Ka", 670, 155, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$KdWing = GUICtrlCreateLabel("Kd", 670, 190, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$KsWing = GUICtrlCreateLabel("Ks", 670, 224, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$KeWing = GUICtrlCreateLabel("Ke", 670, 258, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$ColorsWing = GUICtrlCreateLabel("Colors", 775, 60, 58, 28)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
	$CopyWingFiles = GUICtrlCreateButton("Write WingDings", 837, 34, 100, 20)
	GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GuiCtrlSetTip($CopyWingFiles, "Copy WingDing files to Props Directory")
	GUICtrlSetOnEvent($CopyWingFiles, "_Change_WingDings")
	$IllumWing = GUICtrlCreateLabel("Illum", 670, 310, 49, 24)
	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")
	$ScaleWing = GUICtrlCreateLabel("Scale", 670, 350, 49, 24)
	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")


	$NsWingRead = GUICtrlCreateInput("Ns", 715, 108, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa1Wing = GUICtrlCreateInput("Ka1", 715, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa2Wing = GUICtrlCreateInput("Ka2", 790, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa3Wing = GUICtrlCreateInput("Ka3", 865, 156, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd1Wing = GUICtrlCreateInput("Kd1", 715, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd2Wing = GUICtrlCreateInput("Kd2", 790, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd3Wing = GUICtrlCreateInput("Kd3", 865, 190, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs1Wing = GUICtrlCreateInput("Ks1", 715, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs2Wing = GUICtrlCreateInput("Ks2", 790, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs3Wing = GUICtrlCreateInput("Ks3", 865, 224, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe1Wing = GUICtrlCreateInput("Ke1", 715, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe2Wing = GUICtrlCreateInput("Ke2", 790, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe3Wing = GUICtrlCreateInput("Ke3", 865, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadIllumWing = GUICtrlCreateInput("Illum", 735, 310, 40, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadScaleWing = GUICtrlCreateInput("Scale", 735, 350, 40, 20)
	GUICtrlSetColor(-1, 0xFF0000)

	$WriteWing = GUICtrlCreateButton("Write", 815, 312, 113, 57)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GuiCtrlSetTip($WriteWing, "Write values to WingDings")
	GUICtrlSetOnEvent($WriteWing, "_Write_WingDings_stub")

	$Exit = GUICtrlCreateButton("Exit", 887, 440, 65, 57)
	GUICtrlSetOnEvent($Exit, "_Close_Modify")
	GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0xFF0000)



	_Read_Letters()
	_Read_Symbols()
	_Read_WingDings()

	GUISetState()
Else
	WinActivate("ModifyWordsForm")
EndIf

EndFunc


Func _Read_Letters()
	If FileExists($StartMTLFileLetter) Then
		$NsStart_Let = FileReadLine($StartMTLFileLetter, 5)
				$aNsStart_Let = StringSplit($NsStart_Let, " ")
				$NsStart_Let = $aNsStart_Let[2]
				GUICtrlSetData($NsLetRead, $NsStart_Let)
		$Ka1Start_Let = FileReadLine($StartMTLFileLetter, 6)
				$aKa1Start_Let = StringSplit($Ka1Start_Let, " ")
				$Ka1Start_Let = $aKa1Start_Let[2]
				GUICtrlSetData($ReadKa1Let, $Ka1Start_Let)
		$Ka2Start_Let = FileReadLine($StartMTLFileLetter, 6)
				$aKa2Start_Let = StringSplit($Ka2Start_Let, " ")
				$Ka2Start_Let = $aKa2Start_Let[3]
				GUICtrlSetData($ReadKa2Let, $Ka2Start_Let)
		$Ka3Start_Let = FileReadLine($StartMTLFileLetter, 6)
				$aKa3Start_Let = StringSplit($Ka3Start_Let, " ")
				$Ka3Start_Let = $aKa3Start_Let[4]
				GUICtrlSetData($ReadKa3Let, $Ka3Start_Let)
		$Kd1Start_Let = FileReadLine($StartMTLFileLetter, 7)
				$aKd1Start_Let = StringSplit($Kd1Start_Let, " ")
				$Kd1Start_Let = $aKd1Start_Let[2]
				GUICtrlSetData($ReadKd1Let, $Kd1Start_Let)
		$Kd2Start_Let = FileReadLine($StartMTLFileLetter, 7)
				$aKd2Start_Let = StringSplit($Kd2Start_Let, " ")
				$Kd2Start_Let = $aKd2Start_Let[3]
				GUICtrlSetData($ReadKd2Let, $Kd2Start_Let)
		$Kd3Start_Let = FileReadLine($StartMTLFileLetter, 7)
				$aKd3Start_Let = StringSplit($Kd3Start_Let, " ")
				$Kd3Start_Let = $aKd3Start_Let[4]
				GUICtrlSetData($ReadKd3Let, $Kd3Start_Let)
		$Ks1Start_Let = FileReadLine($StartMTLFileLetter, 8)
				$aKs1Start_Let = StringSplit($Ks1Start_Let, " ")
				$Ks1Start_Let = $aKs1Start_Let[2]
				GUICtrlSetData($ReadKs1Let, $Ks1Start_Let)
		$Ks2Start_Let = FileReadLine($StartMTLFileLetter, 8)
				$aKs2Start_Let = StringSplit($Ks2Start_Let, " ")
				$Ks2Start_Let = $aKs2Start_Let[3]
				GUICtrlSetData($ReadKs2Let, $Ks2Start_Let)
		$Ks3Start_Let = FileReadLine($StartMTLFileLetter, 8)
				$aKs3Start_Let = StringSplit($Ks3Start_Let, " ")
				$Ks3Start_Let = $aKs3Start_Let[4]
				GUICtrlSetData($ReadKs3Let, $Ks3Start_Let)
		$Ke1Start_Let = FileReadLine($StartMTLFileLetter, 9)
				$aKe1Start_Let = StringSplit($Ke1Start_Let, " ")
				$Ke1Start_Let = $aKe1Start_Let[2]
				GUICtrlSetData($ReadKe1Let, $Ke1Start_Let)
		$Ke2Start_Let = FileReadLine($StartMTLFileLetter, 9)
				$aKe2Start_Let = StringSplit($Ke2Start_Let, " ")
				$Ke2Start_Let = $aKe2Start_Let[3]
				GUICtrlSetData($ReadKe2Let, $Ke2Start_Let)
		$Ke3Start_Let = FileReadLine($StartMTLFileLetter, 9)
				$aKe3Start_Let = StringSplit($Ke3Start_Let, " ")
				$Ke3Start_Let = $aKe3Start_Let[4]
				GUICtrlSetData($ReadKe3Let, $Ke3Start_Let)
		$IllumStart_Let = FileReadLine($StartMTLFileLetter, 12)
				$aIllum_Let = StringSplit($IllumStart_Let, " ")
				$IllumStart_Let = $aIllum_Let[0]
				GUICtrlSetData($ReadIllumLet, $IllumStart_Let)
		$ScaleStart_Let = FileReadLine($StartDescFileLetter, 8)
				$aScaleStart_Let = StringSplit($ScaleStart_Let, " ")
	;			_ArrayDisplay($aScaleStart_Let)
				$ScaleStart_Let = $aScaleStart_Let[7]
				$ScaleStart_Let = StringTrimRight($ScaleStart_Let, 1)
				GUICtrlSetData($ReadScaleLet, $ScaleStart_Let)
	EndIf
EndFunc

Func _Read_Symbols()
	If FileExists($StartMTLFileSymbol) Then
		$NsStart_Sym = FileReadLine($StartMTLFileSymbol, 5)
				$aNsStart_Sym = StringSplit($NsStart_Sym, " ")
				$NsStart_Sym = $aNsStart_Sym[2]
				GUICtrlSetData($NsSymRead, $NsStart_Sym)
		$Ka1Start_Sym = FileReadLine($StartMTLFileSymbol, 6)
				$aKa1Start_Sym = StringSplit($Ka1Start_Sym, " ")
				$Ka1Start_Sym = $aKa1Start_Sym[2]
				GUICtrlSetData($ReadKa1Sym, $Ka1Start_Sym)
		$Ka2Start_Sym = FileReadLine($StartMTLFileSymbol, 6)
				$aKa2Start_Sym = StringSplit($Ka2Start_Sym, " ")
				$Ka2Start_Sym = $aKa2Start_Sym[3]
				GUICtrlSetData($ReadKa2Sym, $Ka2Start_Sym)
		$Ka3Start_Sym = FileReadLine($StartMTLFileSymbol, 6)
				$aKa3Start_Sym = StringSplit($Ka3Start_Sym, " ")
				$Ka3Start_Sym = $aKa3Start_Sym[4]
				GUICtrlSetData($ReadKa3Sym, $Ka3Start_Sym)
		$Kd1Start_Sym = FileReadLine($StartMTLFileSymbol, 7)
				$aKd1Start_Sym = StringSplit($Kd1Start_Sym, " ")
				$Kd1Start_Sym = $aKd1Start_Sym[2]
				GUICtrlSetData($ReadKd1Sym, $Kd1Start_Sym)
		$Kd2Start_Sym = FileReadLine($StartMTLFileSymbol, 7)
				$aKd2Start_Sym = StringSplit($Kd2Start_Sym, " ")
				$Kd2Start_Sym = $aKd2Start_Sym[3]
				GUICtrlSetData($ReadKd2Sym, $Kd2Start_Sym)
		$Kd3Start_Sym = FileReadLine($StartMTLFileSymbol, 7)
				$aKd3Start_Sym = StringSplit($Kd3Start_Sym, " ")
				$Kd3Start_Sym = $aKd3Start_Sym[4]
				GUICtrlSetData($ReadKd3Sym, $Kd3Start_Sym)
		$Ks1Start_Sym = FileReadLine($StartMTLFileSymbol, 8)
				$aKs1Start_Sym = StringSplit($Ks1Start_Sym, " ")
				$Ks1Start_Sym = $aKs1Start_Sym[2]
				GUICtrlSetData($ReadKs1Sym, $Ks1Start_Sym)
		$Ks2Start_Sym = FileReadLine($StartMTLFileSymbol, 8)
				$aKs2Start_Sym = StringSplit($Ks2Start_Sym, " ")
				$Ks2Start_Sym = $aKs2Start_Sym[3]
				GUICtrlSetData($ReadKs2Sym, $Ks2Start_Sym)
		$Ks3Start_Sym = FileReadLine($StartMTLFileSymbol, 8)
				$aKs3Start_Sym = StringSplit($Ks3Start_Sym, " ")
				$Ks3Start_Sym = $aKs3Start_Sym[4]
				GUICtrlSetData($ReadKs3Sym, $Ks3Start_Sym)
		$Ke1Start_Sym = FileReadLine($StartMTLFileSymbol, 9)
				$aKe1Start_Sym = StringSplit($Ke1Start_Sym, " ")
				$Ke1Start_Sym = $aKe1Start_Sym[2]
				GUICtrlSetData($ReadKe1Sym, $Ke1Start_Sym)
		$Ke2Start_Sym = FileReadLine($StartMTLFileSymbol, 9)
				$aKe2Start_Sym = StringSplit($Ke2Start_Sym, " ")
				$Ke2Start_Sym = $aKe2Start_Sym[3]
				GUICtrlSetData($ReadKe2Sym, $Ke2Start_Sym)
		$Ke3Start_Sym = FileReadLine($StartMTLFileSymbol, 9)
				$aKe3Start_Sym = StringSplit($Ke3Start_Sym, " ")
				$Ke3Start_Sym = $aKe3Start_Sym[4]
				GUICtrlSetData($ReadKe3Sym, $Ke3Start_Sym)
		$IllumStart_Sym = FileReadLine($StartMTLFileSymbol, 12)
				$aIllum_Sym = StringSplit($IllumStart_Sym, " ")
				$IllumStart_Sym = $aIllum_Sym[0]
				GUICtrlSetData($ReadIllumSym, $IllumStart_Sym)
		$ScaleStart_Sym = FileReadLine($StartDescFileSymbol, 8)
				$aScaleStart_Sym = StringSplit($ScaleStart_Sym, " ")
				$ScaleStart_Sym = $aScaleStart_Sym[7]
				$ScaleStart_Sym = StringTrimRight($ScaleStart_Sym, 1)
				GUICtrlSetData($ReadScaleSym, $ScaleStart_Sym)
	EndIf
EndFunc

Func _Read_WingDings()
	If FileExists($StartMTLFileWingDings) Then
		$NsStart_Wing = FileReadLine($StartMTLFileWingDings, 5)
				$aNsStart_Wing = StringSplit($NsStart_Wing, " ")
				$NsStart_Wing = $aNsStart_Wing[2]
				GUICtrlSetData($NsWingRead, $NsStart_Wing)
		$Ka1Start_Wing = FileReadLine($StartMTLFileWingDings, 6)
				$aKa1Start_Wing = StringSplit($Ka1Start_Wing, " ")
				$Ka1Start_Wing = $aKa1Start_Wing[2]
				GUICtrlSetData($ReadKa1Wing, $Ka1Start_Wing)
		$Ka2Start_Wing = FileReadLine($StartMTLFileWingDings, 6)
				$aKa2Start_Wing = StringSplit($Ka2Start_Wing, " ")
				$Ka2Start_Wing = $aKa2Start_Wing[3]
				GUICtrlSetData($ReadKa2Wing, $Ka2Start_Wing)
		$Ka3Start_Wing = FileReadLine($StartMTLFileWingDings, 6)
				$aKa3Start_Wing = StringSplit($Ka3Start_Wing, " ")
				$Ka3Start_Wing = $aKa3Start_Wing[4]
				GUICtrlSetData($ReadKa3Wing, $Ka3Start_Wing)
		$Kd1Start_Wing = FileReadLine($StartMTLFileWingDings, 7)
				$aKd1Start_Wing = StringSplit($Kd1Start_Wing, " ")
				$Kd1Start_Wing = $aKd1Start_Wing[2]
				GUICtrlSetData($ReadKd1Wing, $Kd1Start_Wing)
		$Kd2Start_Wing = FileReadLine($StartMTLFileWingDings, 7)
				$aKd2Start_Wing = StringSplit($Kd2Start_Wing, " ")
				$Kd2Start_Wing = $aKd2Start_Wing[3]
				GUICtrlSetData($ReadKd2Wing, $Kd2Start_Wing)
		$Kd3Start_Wing = FileReadLine($StartMTLFileWingDings, 7)
				$aKd3Start_Wing = StringSplit($Kd3Start_Wing, " ")
				$Kd3Start_Wing = $aKd3Start_Wing[4]
				GUICtrlSetData($ReadKd3Wing, $Kd3Start_Wing)
		$Ks1Start_Wing = FileReadLine($StartMTLFileWingDings, 8)
				$aKs1Start_Wing = StringSplit($Ks1Start_Wing, " ")
				$Ks1Start_Wing = $aKs1Start_Wing[2]
				GUICtrlSetData($ReadKs1Wing, $Ks1Start_Wing)
		$Ks2Start_Wing = FileReadLine($StartMTLFileWingDings, 8)
				$aKs2Start_Wing = StringSplit($Ks2Start_Wing, " ")
				$Ks2Start_Wing = $aKs2Start_Wing[3]
				GUICtrlSetData($ReadKs2Wing, $Ks2Start_Wing)
		$Ks3Start_Wing = FileReadLine($StartMTLFileWingDings, 8)
				$aKs3Start_Wing = StringSplit($Ks3Start_Wing, " ")
				$Ks3Start_Wing = $aKs3Start_Wing[4]
				GUICtrlSetData($ReadKs3Wing, $Ks3Start_Wing)
		$Ke1Start_Wing = FileReadLine($StartMTLFileWingDings, 9)
				$aKe1Start_Wing = StringSplit($Ke1Start_Wing, " ")
				$Ke1Start_Wing = $aKe1Start_Wing[2]
				GUICtrlSetData($ReadKe1Wing, $Ke1Start_Wing)
		$Ke2Start_Wing = FileReadLine($StartMTLFileWingDings, 9)
				$aKe2Start_Wing = StringSplit($Ke2Start_Wing, " ")
;			_ArrayDisplay($aKe2Start_Wing)
				$Ke2Start_Wing = $aKe2Start_Wing[3]
				GUICtrlSetData($ReadKe2Wing, $Ke2Start_Wing)
		$Ke3Start_Wing = FileReadLine($StartMTLFileWingDings, 9)
				$aKe3Start_Wing = StringSplit($Ke3Start_Wing, " ")
				$Ke3Start_Wing = $aKe3Start_Wing[4]
				GUICtrlSetData($ReadKe3Wing, $Ke3Start_Wing)
		$IllumStart_Wing = FileReadLine($StartMTLFileWingDings, 12)
				$aIllum_Wing = StringSplit($IllumStart_Wing, " ")
				$IllumStart_Wing = $aIllum_Wing[0]
				GUICtrlSetData($ReadIllumWing, $IllumStart_Wing)
		$ScaleStart_Wing = FileReadLine($StartDescFileWingDings, 8)
				$aScaleStart_Wing = StringSplit($ScaleStart_Wing, " ")
				$ScaleStart_Wing = $aScaleStart_Wing[7]
				$ScaleStart_Wing = StringTrimRight($ScaleStart_Wing, 1)
				GUICtrlSetData($ReadScaleWing, $ScaleStart_Wing)
	EndIf
EndFunc

Func _Write_Letters_stub()
	If FileExists($StartMTLFileLetter) Then
		_Write_Letters()
		MsgBox(0, "", "Values written!", 1)
	Else
		MsgBox(48, "Missing Files", "You need to write the WingDings to the Props Folder first")
	EndIf
EndFunc

Func _Write_Symbols_stub()
	If FileExists($StartMTLFileSymbol) Then
		_Write_Symbols()
		MsgBox(0, "", "Values written!", 1)
	Else
		MsgBox(48, "Missing Files", "You need to write the Symbols to the Props Folder first")
	EndIf
EndFunc

Func _Write_WingDings_stub()
	If FileExists($StartMTLFileWingDings) Then
		_Write_WingDings()
		MsgBox(0, "", "Values written!", 1)
	Else
		MsgBox(48, "Missing Files", "You need to write the WingDings to the Props Folder first")
	EndIf
EndFunc





Func _Write_Letters()
		$NsLetRead1 = GUICtrlRead($NsLetRead)
		$ReadKa1Let1 = GUICtrlRead($ReadKa1Let)
		$ReadKa2Let1 = GUICtrlRead($ReadKa2Let)
		$ReadKa3Let1 = GUICtrlRead($ReadKa3Let)
		$ReadKd1Let1 = GUICtrlRead($ReadKd1Let)
		$ReadKd2Let1 = GUICtrlRead($ReadKd2Let)
		$ReadKd3Let1 = GUICtrlRead($ReadKd3Let)
		$ReadKs1Let1 = GUICtrlRead($ReadKs1Let)
		$ReadKs2Let1 = GUICtrlRead($ReadKs2Let)
		$ReadKs3Let1 = GUICtrlRead($ReadKs3Let)
		$ReadKe1Let1 = GUICtrlRead($ReadKe1Let)
		$ReadKe2Let1 = GUICtrlRead($ReadKe2Let)
		$ReadKe3Let1 = GUICtrlRead($ReadKe3Let)
		$ReadIllumLet1 = GUICtrlRead($ReadIllumLet)
		$ReadScaleLet1 = GUICtrlRead($ReadScaleLet)

		$aLetters = _FileListToArray($Props, "Letters_*")
		For $L = 1 To $aLetters[0]
			$CapLetPath = $aLetters[$L] & "\"
			$CapLetPathsub = StringTrimRight($CapLetPath, 1)
			$CapLetPathsub = StringTrimLeft($CapLetPathsub, 8)
			If StringIsLower(StringRight($CapLetPathsub, 1)) Then
				$TestMtlPath = $Props & $CapLetPath & "Small" & StringRight($CapLetPathsub, 1) & ".mtl"
				$TestDescPath = $Props & $CapLetPath & "Description.json"
			Elseif StringIsUpper($CapLetPathsub) Then
				$TestMtlPath = $Props & $CapLetPath & "Cap" & $CapLetPathsub & ".mtl"
				$TestDescPath = $Props & $CapLetPath & "Description.json"
			Else
				$TestMtlPath = $Props & $CapLetPath & $CapLetPathsub & ".mtl"
				$TestDescPath = $Props & $CapLetPath & "Description.json"
			EndIf

			If FileExists($TestDescPath) Then
				_FileWriteToLine($TestMtlPath, 5, "Ns " & $NsLetRead1, True)
				_FileWriteToLine($TestMtlPath, 6, "Ka " & $ReadKa1Let1 & " " & $ReadKa2Let1 & " " & $ReadKa3Let1, True)
				_FileWriteToLine($TestMtlPath, 7, "Kd " & $ReadKd1Let1 & " " & $ReadKd2Let1 & " " & $ReadKd3Let1, True)
				_FileWriteToLine($TestMtlPath, 8, "Ks " & $ReadKs1Let1 & " " & $ReadKs2Let1 & " " & $ReadKs3Let1, True)
				_FileWriteToLine($TestMtlPath, 9, "Ke " & $ReadKe1Let1 & " " & $ReadKe2Let1 & " " & $ReadKe3Let1, True)
				_FileWriteToLine($TestMtlPath, 12, 'illum ' & $ReadIllumLet1, True)
				_FileWriteToLine($TestDescPath, 8, '    "scale" : ' & $ReadScaleLet1 & ",", True)
			Else
				MsgBox(0, "Error", "Error: file does not exist")
			EndIf
		Next
EndFunc



Func _Write_Symbols()
		$NsSymRead1 = GUICtrlRead($NsSymRead)
		$ReadKa1Sym1 = GUICtrlRead($ReadKa1Sym)
		$ReadKa2Sym1 = GUICtrlRead($ReadKa2Sym)
		$ReadKa3Sym1 = GUICtrlRead($ReadKa3Sym)
		$ReadKd1Sym1 = GUICtrlRead($ReadKd1Sym)
		$ReadKd2Sym1 = GUICtrlRead($ReadKd2Sym)
		$ReadKd3Sym1 = GUICtrlRead($ReadKd3Sym)
		$ReadKs1Sym1 = GUICtrlRead($ReadKs1Sym)
		$ReadKs2Sym1 = GUICtrlRead($ReadKs2Sym)
		$ReadKs3Sym1 = GUICtrlRead($ReadKs3Sym)
		$ReadKe1Sym1 = GUICtrlRead($ReadKe1Sym)
		$ReadKe2Sym1 = GUICtrlRead($ReadKe2Sym)
		$ReadKe3Sym1 = GUICtrlRead($ReadKe3Sym)
		$ReadIllumSym1 = GUICtrlRead($ReadIllumSym)
		$ReadScaleSym1 = GUICtrlRead($ReadScaleSym)

		$aSymbols = _FileListToArray($Props, "Symbols_*")
		For $s = 1 To $aSymbols[0]
			$SymbolPath = $Props & $aSymbols[$s] & "\"
			$testSym1 = $aSymbols[$s]
			$testSym = _StringBetween($testSym1, "_", "")
			$SymbolMtlPath = $SymbolPath & $testSym[0] & ".mtl"
			$SymbolDescPath = $SymbolPath & "Description.json"

			If FileExists($SymbolMtlPath) And FileExists($SymbolDescPath) Then
				_FileWriteToLine($SymbolMtlPath, 5, "Ns " & $NsSymRead1, True)
				_FileWriteToLine($SymbolMtlPath, 6, "Ka " & $ReadKa1Sym1 & " " & $ReadKa2Sym1 & " " & $ReadKa3Sym1, True)
				_FileWriteToLine($SymbolMtlPath, 7, "Kd " & $ReadKd1Sym1 & " " & $ReadKd2Sym1 & " " & $ReadKd3Sym1, True)
				_FileWriteToLine($SymbolMtlPath, 8, "Ks " & $ReadKs1Sym1 & " " & $ReadKs2Sym1 & " " & $ReadKs3Sym1, True)
				_FileWriteToLine($SymbolMtlPath, 9, "Ke " & $ReadKe1Sym1 & " " & $ReadKe2Sym1 & " " & $ReadKe3Sym1, True)
				_FileWriteToLine($SymbolMtlPath, 12, 'illum ' & $ReadIllumSym1, True)
				_FileWriteToLine($SymbolDescPath, 8, '    "scale" : ' & $ReadScaleSym1 & ",", True)
			Else
				MsgBox(48, "Error", "Error, either mtl or description file missing")
			EndIf
		Next
EndFunc

Func _Write_WingDings()
		$NsWingReadD = GUICtrlRead($NsWingRead)
		$ReadKa1WingD = GUICtrlRead($ReadKa1Wing)
		$ReadKa2WingD = GUICtrlRead($ReadKa2Wing)
		$ReadKa3WingD = GUICtrlRead($ReadKa3Wing)
		$ReadKd1WingD = GUICtrlRead($ReadKd1Wing)
		$ReadKd2WingD = GUICtrlRead($ReadKd2Wing)
		$ReadKd3WingD = GUICtrlRead($ReadKd3Wing)
		$ReadKs1WingD = GUICtrlRead($ReadKs1Wing)
		$ReadKs2WingD = GUICtrlRead($ReadKs2Wing)
		$ReadKs3WingD = GUICtrlRead($ReadKs3Wing)
		$ReadKe1WingD = GUICtrlRead($ReadKe1Wing)
		$ReadKe2WingD = GUICtrlRead($ReadKe2Wing)
		$ReadKe3WingD = GUICtrlRead($ReadKe3Wing)
		$ReadIllumWingD = GUICtrlRead($ReadIllumWing)
		$ReadScaleWingD = GUICtrlRead($ReadScaleWing)
		$aWingDings = _FileListToArray($Props, "WingDings_*")

		For $w = 1 To $aWingDings[0]
			$WingPath = $Props & $aWingDings[$w] & "\"
			$WingName = $aWingDings[$w]
			$aWingName = _StringBetween($WingName, "_", "")
			$WingDingMTLfile_Path = $WingPath & $aWingName[0] & ".mtl"
			$WingDingDescfile_Path = $WingPath & "Description.json"
			If FileExists($WingDingDescfile_Path) And FileExists($WingDingMTLfile_Path) Then
				_FileWriteToLine($WingDingMTLfile_Path, 5, "Ns " & $NsWingReadD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 6, "Ka " & $ReadKa1WingD & " " & $ReadKa2WingD & " " & $ReadKa3WingD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 7, "Kd " & $ReadKd1WingD & " " & $ReadKd2WingD & " " & $ReadKd3WingD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 8, "Ks " & $ReadKs1WingD & " " & $ReadKs2WingD & " " & $ReadKs3WingD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 9, "Ke " & $ReadKe1WingD & " " & $ReadKe2WingD & " " & $ReadKe3WingD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 12, 'illum ' & $ReadIllumWingD, True)
				_FileWriteToLine($WingDingDescfile_Path, 8, '    "scale" : ' & $ReadScaleWingD & ",", True)
			Else
				MsgBox(48, "Error", "Error, either mtl or description file missing")
			EndIf
		Next
EndFunc


Func _Change_LetterFonts()
	$FontType = "Letter"
	_Change_Fonts()
	$GuiTest = GUICtrlRead($NsLetRead)
	If $GuiTest = "Ns" Then
		_Read_Letters()
	Else
		_Write_Letters()
	EndIf
EndFunc


Func _Change_SymbolFonts()
	$FontType = "Symbol"
	_Change_Fonts()
	$GuiTest = GUICtrlRead($NsSymRead)
	If $GuiTest = "Ns" Then
		_Read_Symbols()
	Else
		_Write_Symbols()
	EndIf
EndFunc

Func _Change_WingDings()
	$FontType = "WingDing"
	_Change_Fonts()
	$GuiTest = GUICtrlRead($NsWingRead)
	If $GuiTest = "Ns" Then
		_Read_WingDings()
	Else
		_Write_WingDings()
	EndIf
EndFunc


Func _Change_Fonts()
	Local $sMessage = "Select a folder"
	Local $sFontSelectFolder = FileSelectFolder($sMessage, @ScriptDir & "\Fonts")
    If Not @error Then
		If $FontType = "Letter" Then
			$aFonts = _FileListToArray($sFontSelectFolder, "Letters_*", $FLTA_FOLDERS, True)
		ElseIf $FontType = "Symbol" Then
			$aFonts = _FileListToArray($sFontSelectFolder, "Symbols_*", $FLTA_FOLDERS, True)
		ElseIf $FontType = "WingDing" Then
			$aFonts = _FileListToArray($sFontSelectFolder, "WingDings_*", $FLTA_FOLDERS, True)
		EndIf
		If Not @error Then
			_Copying()
			Local $aTemp
			For $a = 1 To $aFonts[0]
				$aTemp = StringSplit($aFonts[$a], "\")
				DirCopy($aFonts[$a], $Props & $aTemp[$aTemp[0]], $FC_OVERWRITE)
			Next
			If $FontType = "Letter" Then
				$FontState = IniRead($FontTest, "Setting", "Font", "")
				GUICtrlSetData($CurrentFont, $FontState)
			ElseIf $FontType = "Symbol" Then
				$FontState = IniRead($FontTestSymbol, "Setting", "Font", "")
;				MsgBox(0, "", "fontstate: " & $FontState)
				GUICtrlSetData($CurrentSymbolFont, $FontState)
			EndIf
			GUIDelete($Copying)
		Else
			MsgBox($MB_SYSTEMMODAL, "", "No Fonts found in selected folder.")
		EndIf
    EndIf

EndFunc

Func _Copying()
	Global $Copying = GUICreate("GUIcopying", 200, 100)
	$CopyingLabel = GUICtrlCreateLabel("Copying, please wait...", 45, 35)
	GUISetState(@SW_SHOW, $Copying)
EndFunc

Func _Close_Modify()
	GUIDelete($ModifyWordsForm)
EndFunc


Func _Close()
	GUIDelete()
	Exit
EndFunc
