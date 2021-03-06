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
Global	$ReadKs2Sym, $ReadKs3Sym, $ReadKe1Sym, $ReadKe2Sym, $ReadKe3Sym, $ReadScaleSym, $Room, $Copying, $CurrentFont, $CurrentSymbolFont, $NewDDSfile, $LetterLineWrite1a
Global $NsWingRead, $ReadKa1Wing, $ReadKa2Wing, $ReadKa3Wing, $ReadKd1Wing, $ReadKd2Wing, $ReadKd3Wing, $ReadKs1Wing, $ReadKs2Wing, $ReadKs3Wing, $ReadKe1Wing, $ReadKe2Wing, $ReadKe3Wing, $ReadScaleWing

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

Global $Props = $Toolbox_Dir & "\props\"
Global $Labels = $Props & "Labels\"
Global $LabelsLetter = $Labels & "Letters\"
Global $LabelsSymbol = $Labels & "Symbols\"
Global $SessionRoom = @MyDocumentsDir & "\my games\VR Toolbox\save\SessionRoom.json"
Global $WordRoom = @MyDocumentsDir & "\my games\VR Toolbox\save\Words.room"
Global $XShift = IniRead($config_ini, "Settings_WordMaker", "Xshift", "")
Global $YShift = IniRead($config_ini, "Settings_WordMaker", "Yshift", "")
Global $PeriodShift = IniRead($config_ini, "Settings_WordMaker", "PeriodShift", "")
Global $QuoteShift = IniRead($config_ini, "Settings_WordMaker", "QuoteShift", "")
Global $gShift = IniRead($config_ini, "Settings_WordMaker", "gShift", "")
Global $tShift = IniRead($config_ini, "Settings_WordMaker", "tShift", "")
Global $oShift = IniRead($config_ini, "Settings_WordMaker", "oShift", "")
Global $LetterFiles = $Labels & "Letters\Letters_"
Global $SymbolFiles = $Labels & "Symbols\Symbols_"
Global $WingDingFiles = $Props & "WingDings_"

Global $StartMTLFileLetter = $LetterFiles & "A\CapA.mtl"
Global $StartMTLFileLetter2 = $LetterFiles & "Aa\Smalla.mtl"
Global $StartMTLFileSymbol = $SymbolFiles & "And\And.mtl"
Global $StartMTLFileSymbol2 = $SymbolFiles & "Backtick\Backtick.mtl"
Global $StartMTLFileWingDings = $WingDingFiles & "Arrow\Arrow.mtl"
Global $StartMTLFileWingDings2 = $WingDingFiles & "Frown\Frown.mtl"

Global $LetterDDSfile1 = $LetterFiles & "A\"
Global $LetterDDSfile2 = $LetterFiles & "Aa\"
Global $SymbolDDSfile1 = $SymbolFiles & "And\"
Global $SymbolDDSfile2 = $SymbolFiles & "Backtick\"
Global $WingDDSfile1 = $WingDingFiles & "Arrow\"
Global $WingDDSfile2 = $WingDingFiles & "Frown\"
Global $SwapType = "Caps"
Global $Texture = "diffuse"
Global $dds = "d.dds"
Global $dds_DIR = $LetterDDSfile1
Global $kValue = "Kd"
Global $LineNbr = 11

;Global $StartDescFileWingDings = $WingDingFiles & "Arrow\Description.json"
;Global $StartDescFileLetter = $LetterFiles & "A\Description.json"
;Global $StartDescFileSymbol = $SymbolFiles & "And\Description.json"
Global $FontTest = $LetterFiles & "A\Font.txt"
Global $FontTestSymbol = $SymbolFiles & "And\Font.txt"
Global $FontStateLetter = IniRead($FontTest, "Setting", "Font", "")
Global $FontStateSymbol = IniRead($FontTestSymbol, "Setting", "Font", "")
Global $Stripped = False
Global $Version = "6.0", $Xcoor = $XShift, $Ycoor = 0, $lineNumber = 0, $FontType = "Letter"

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
If FileExists($StartMTLFileLetter) Then
	Global $LetTextureStateOne = FileReadLine($StartMTLFileLetter, 11)
	If $LetTextureStateOne = "" Then $LetTextureStateOne = "none"
	Global $LetTextureStateTwo = FileReadLine($StartMTLFileLetter, 12)
	If $LetTextureStateTwo = "" Then $LetTextureStateTwo = "none"
Else
	Global $LetTextureStateOne = "no file"
	Global $LetTextureStateTwo = "no file"
EndIf
If FileExists($StartMTLFileLetter2) Then
	Global $LetTextureStateThree = FileReadLine($StartMTLFileLetter2, 11)
	If $LetTextureStateThree = "" Then $LetTextureStateThree = "none"
	Global $LetTextureStateFour = FileReadLine($StartMTLFileLetter2, 12)
	If $LetTextureStateFour = "" Then $LetTextureStateFour = "none"
Else
	Global $LetTextureStateThree = "no file"
	Global $LetTextureStateFour = "no file"
EndIf
If FileExists($StartMTLFileSymbol) Then
	Global $SymTextureStateOne = FileReadLine($StartMTLFileSymbol, 11)
	If $SymTextureStateOne = "" Then $SymTextureStateOne = "none"
	Global $SymTextureStateTwo = FileReadLine($StartMTLFileSymbol, 12)
	If $SymTextureStateTwo = "" Then $SymTextureStateTwo = "none"
Else
	Global $SymTextureStateOne = "no file"
	Global $SymTextureStateTwo = "no file"
EndIf
If FileExists($StartMTLFileSymbol2) Then
	Global $SymTextureStateThree = FileReadLine($StartMTLFileSymbol2, 11)
	If $SymTextureStateThree = "" Then $SymTextureStateThree = "none"
	Global $SymTextureStateFour = FileReadLine($StartMTLFileSymbol2, 12)
	If $SymTextureStateFour = "" Then $SymTextureStateFour = "none"
Else
	Global $SymTextureStateThree = "no file"
	Global $SymTextureStateFour = "no file"
EndIf
If FileExists($StartMTLFileWingDings) Then
	Global $WingTextureStateOne = FileReadLine($StartMTLFileWingDings, 11)
	If $WingTextureStateOne = "" Then $WingTextureStateOne = "none"
	Global $WingTextureStateTwo = FileReadLine($StartMTLFileWingDings, 12)
	If $WingTextureStateTwo = "" Then $WingTextureStateTwo = "none"
Else
	Global $WingTextureStateOne = "no file"
	Global $WingTextureStateTwo = "no file"
EndIf
If FileExists($StartMTLFileWingDings2) Then
	Global $WingTextureStateThree = FileReadLine($StartMTLFileWingDings2, 11)
	If $WingTextureStateThree = "" Then $WingTextureStateThree = "none"
	Global $WingTextureStateFour = FileReadLine($StartMTLFileWingDings2, 12)
	If $WingTextureStateFour = "" Then $WingTextureStateFour = "none"
Else
	Global $WingTextureStateThree = "no file"
	Global $WingTextureStateFour = "no file"
EndIf

Opt("GUIOnEventMode", 1)


Global $WordMakerGUI = GUICreate("WordMaker", 950, 620, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_SYSMENU, $WS_EX_CLIENTEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Close")

Global $Label_Title = GUICtrlCreateLabel("WordMaker for VR Toolbox", 350, 3, 350, 30)
GUICtrlSetFont($Label_Title, 14, 600, 4)

Global $Group_Spacing = GUICtrlCreateGroup("", 10, 2, 250, 150)

Global $SpacingX_Label = GUICtrlCreateLabel("Horizontal spacing between letters  X:", 28, 11, 190, 20)
Global $SpacingX = GUICtrlCreateInput("X", 220, 9, 30, 18)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetData($SpacingX, $XShift)

Global $SpacingY_Label = GUICtrlCreateLabel("Vertical spacing between lines  Y:", 47, 32, 165, 20)
Global $SpacingY = GUICtrlCreateInput("Y", 220, 29, 30, 18)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetData($SpacingY, $YShift)

Global $SpacingY_Period = GUICtrlCreateLabel("Vertical alignment of Period, etc:", 54, 52, 165, 20)
GuiCtrlSetTip(-1, "Vertical alignment of Period, Comma and Underscore. The higer the number, the lower character gets.")
Global $SpacingYPeriod = GUICtrlCreateInput("period", 220, 49, 30, 18)
GUICtrlSetColor(-1, 0xFF0000)
;GuiCtrlSetTip(-1, "Vertical alignment of Period, Comma and Underscore. The higer the number, the lower character gets.")
GUICtrlSetData($SpacingYPeriod, $PeriodShift)

Global $SpacingY_Quote = GUICtrlCreateLabel("Vertical alignment of Quotes, etc:", 50, 72, 165, 20)
GuiCtrlSetTip(-1, "Vertical alignment of Caret, Backtick, Asterisk, single Quotes and double Quotes. The higer the number, the higher character gets.")
Global $SpacingYQuote = GUICtrlCreateInput("quote", 220, 69, 30, 18)
GUICtrlSetColor(-1, 0xFF0000)
;GuiCtrlSetTip(-1, "Vertical alignment of lower case letters g, j, p, y, and q. The higer the number, the lower character gets.")
GUICtrlSetData($SpacingYQuote, $QuoteShift)

Global $SpacingY_Smallg = GUICtrlCreateLabel("Vertical alignment of lower case g, etc:", 24, 91, 195, 20)
GuiCtrlSetTip(-1, "Vertical alignment of lower case letters g, j, p, y, and q. The higer the number, the lower character gets.")
Global $SpacingYSmallg = GUICtrlCreateInput("g", 220, 89, 30, 18)
GUICtrlSetColor(-1, 0xFF0000)
;GuiCtrlSetTip(-1, "Vertical alignment of lower case letters g, j, p, y, and q. The higer the number, the lower character gets.")
GUICtrlSetData($SpacingYSmallg, $gShift)


Global $SpacingY_Smallt = GUICtrlCreateLabel("Vertical alignment of lower case i and t:", 22, 112, 195, 20)
GuiCtrlSetTip(-1, "Vertical alignment of lower case letters i and t. The higer the number, the lower character gets.")
Global $SpacingYSmallt = GUICtrlCreateInput("t", 220, 109, 30, 18)
GUICtrlSetColor(-1, 0xFF0000)
;GuiCtrlSetTip(-1, "Vertical alignment of lower case letters i and t. The higer the number, the lower character gets.")
GUICtrlSetData($SpacingYSmallt, $tShift)


Global $Spacing_YSmallo = GUICtrlCreateLabel("Vertical alignment of lower case o etc:", 27, 131, 195, 20)
GuiCtrlSetTip(-1, "Vertical alignment of all lower case letters like o and e. The higer the number, the lower character gets.")
Global $SpacingYSmallo = GUICtrlCreateInput("o", 220, 129, 30, 18)
GUICtrlSetColor(-1, 0xFF0000)
;GuiCtrlSetTip(-1, "Vertical alignment of all lower case letters like o and e. The higer the number, the lower character gets.")
GUICtrlSetData($SpacingYSmallo, $oShift)


Global $WordInput_Ctrl = GUICtrlCreateEdit("", 300, 35, 360, 100)
GUICtrlSetFont($WordInput_Ctrl, 14)

Global $ClearRoom_Button = GUICtrlCreateButton("Clear Words Room", 700, 40, 80, 40, $BS_MULTILINE)
GUICtrlSetOnEvent($ClearRoom_Button, "_Clear_Room")
GuiCtrlSetTip($ClearRoom_Button, "Caution: clears the Words Room and resets it to a 'desktop' and a default 'skymap'")


#cs
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
#ce

	Global $Clear_Button = GUICtrlCreateButton("Clear Text", 435, 135, 80, 18)
	GUICtrlSetOnEvent($Clear_Button, "_Clear_Edit")
	GuiCtrlSetTip($Clear_Button, "Clears the text field")

	Global $WriteWord_Button = GUICtrlCreateButton("Write to Words Room", 700, 87, 80, 40, $BS_MULTILINE)
	GUICtrlSetOnEvent($WriteWord_Button, "_Write_WordRoom")
	GuiCtrlSetTip($WriteWord_Button, "Writes your text to the Words.room file")

	Global $WriteSession_Button = GUICtrlCreateButton("Write to Session Room", 810, 87, 80, 40, $BS_MULTILINE)
	GUICtrlSetOnEvent($WriteSession_Button, "_Write_SessionRoom")
	GuiCtrlSetTip($WriteSession_Button, "Writes your text to the Current Session.room file" & @CRLF & "Note that VRToolbox must NOT be running or your changes will be ignored.")

	Global $ClearSession_Button = GUICtrlCreateButton("Clear Session Room", 810, 40, 80, 40, $BS_MULTILINE)
	GUICtrlSetOnEvent($ClearSession_Button, "_Clear_SessionRoom")
	GuiCtrlSetTip($ClearSession_Button, "Caution: clears the current Session Room and resets it to a 'desktop' and a default 'skymap'" & @CRLF & "VRToolbox must not be running...")

	$Letters = GUICtrlCreateGroup("Restart VRToolbox to see changes to these fields:", 5, 155, 937, 456, $BS_CENTER)
	GUICtrlSetFont(-1, 14, 400, 4, "MS Sans Serif")
	$Letters = GUICtrlCreateGroup("Letters", 15, 190, 295, 415)
	GUICtrlSetFont(-1, 16, 400, "MS Sans Serif")
	$Symbols = GUICtrlCreateGroup("Symbols", 330, 190, 295, 415)
	GUICtrlSetFont(-1, 16, 400, "MS Sans Serif")
	$WingDings = GUICtrlCreateGroup("WingDings", 645, 190, 285, 368)
	GUICtrlSetFont(-1, 16, 400, "MS Sans Serif")

	$CopyWingFiles = GUICtrlCreateButton("Write WingDings", 825, 178, 100, 20)
	GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GuiCtrlSetTip($CopyWingFiles, "Copy WingDing files to Props Directory")
	GUICtrlSetOnEvent($CopyWingFiles, "_Change_WingDings")

	$ColorsLetter = GUICtrlCreateLabel("Colors", 145, 220, 58, 28)
	GUICtrlSetFont(-1, 14, 300, 0, "MS Sans Serif")
	$ColorsSymbol = GUICtrlCreateLabel("Colors", 462, 220, 58, 20)
	GUICtrlSetFont(-1, 14, 300, 0, "MS Sans Serif")
	$ColorsWing = GUICtrlCreateLabel("Colors", 775, 220, 58, 28)
	GUICtrlSetFont(-1, 14, 300, 0, "MS Sans Serif")

	$Ns = GUICtrlCreateLabel("Ns", 40, 258, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save value")
;	$Scale = GUICtrlCreateLabel("Scale", 170, 258, 49, 24)
;	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
;	$dLetters = GUICtrlCreateLabel("d", 167, 258, 22, 24)
;	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Ka = GUICtrlCreateLabel("Ka", 40, 305, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ka")
	$Kd = GUICtrlCreateLabel("Kd", 40, 340, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Kd")
	$Ks = GUICtrlCreateLabel("Ks", 40, 374, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ks")
	$Ke = GUICtrlCreateLabel("Ke", 40, 408, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ke")
;	$Label19 = GUICtrlCreateLabel("Illum", 40, 460, 49, 24)
;	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")
;	$Scale = GUICtrlCreateLabel("Scale", 40, 460, 49, 24)
;	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")

	$Label7 = GUICtrlCreateLabel("Ns", 356, 258, 23, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save value")
;	$Label5 = GUICtrlCreateLabel("Scale", 485, 258, 49, 20)
;	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
;	$dSymbol = GUICtrlCreateLabel("d", 483, 258, 23, 24)
;	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label1 = GUICtrlCreateLabel("Ka", 356, 305, 22, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ka")
	$Label2 = GUICtrlCreateLabel("Kd", 356, 340, 22, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Kd")
	$Label3 = GUICtrlCreateLabel("Ks", 356, 374, 22, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ks")
	$Label4 = GUICtrlCreateLabel("Ke", 356, 408, 22, 20)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ke")
;	$Label18 = GUICtrlCreateLabel("Illum", 356, 460, 49, 20)
;	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")
;	$Label5 = GUICtrlCreateLabel("Scale", 356, 460, 49, 20)
;	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")

	$NsWing = GUICtrlCreateLabel("Ns", 670, 258, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save value")
;	$ScaleWing = GUICtrlCreateLabel("Scale", 800, 258, 49, 24)
;	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
;	$dWing = GUICtrlCreateLabel("d", 796, 258, 22, 24)
;	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$KaWing = GUICtrlCreateLabel("Ka", 670, 305, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ka")
	$KdWing = GUICtrlCreateLabel("Kd", 670, 340, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Kd")
	$KsWing = GUICtrlCreateLabel("Ks", 670, 374, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ks")
	$KeWing = GUICtrlCreateLabel("Ke", 670, 408, 22, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Press enter to save values for Ke")
;	$IllumWing = GUICtrlCreateLabel("Illum", 670, 460, 49, 24)
;	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")
;	$ScaleWing = GUICtrlCreateLabel("Scale", 670, 460, 49, 24)
;	GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")

	$NsLetRead = GUICtrlCreateInput("Ns", 75, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadScaleLet = GUICtrlCreateInput("Scale", 225, 258, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	$dLetRead = GUICtrlCreateInput("d", 188, 258, 60, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	GuiCtrlSetTip(-1, "Transparency")
	$ReadKa1Let = GUICtrlCreateInput("Ka1", 75, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa2Let = GUICtrlCreateInput("Ka2", 150, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa3Let = GUICtrlCreateInput("Ka3", 225, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd1Let = GUICtrlCreateInput("Kd1", 75, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd2Let = GUICtrlCreateInput("Kd2", 150, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd3Let = GUICtrlCreateInput("Kd3", 225, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs1Let = GUICtrlCreateInput("Ks1", 75, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs2Let = GUICtrlCreateInput("Ks2", 150, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs3Let = GUICtrlCreateInput("Ks3", 225, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe1Let = GUICtrlCreateInput("Ke1", 75, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe2Let = GUICtrlCreateInput("Ke2", 150, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe3Let = GUICtrlCreateInput("Ke3", 225, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadIllumLet = GUICtrlCreateInput("Illum", 100, 460, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadScaleLet = GUICtrlCreateInput("Scale", 100, 460, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)

	$NsSymRead = GUICtrlCreateInput("Ns", 390, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadScaleSym = GUICtrlCreateInput("Scale", 540, 258, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	$dSymRead = GUICtrlCreateInput("d", 504, 258, 60, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	GuiCtrlSetTip(-1, "Transparency")
	$ReadKa1Sym = GUICtrlCreateInput("Ka1", 390, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa2Sym = GUICtrlCreateInput("Ka2", 465, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa3Sym = GUICtrlCreateInput("Ka3", 540, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd1Sym = GUICtrlCreateInput("Kd1", 390, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd2Sym = GUICtrlCreateInput("Kd2", 465, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd3Sym = GUICtrlCreateInput("Kd3", 540, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs1Sym = GUICtrlCreateInput("Ks1", 390, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs2Sym = GUICtrlCreateInput("Ks2", 465, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs3Sym = GUICtrlCreateInput("Ks3", 540, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe1Sym = GUICtrlCreateInput("Ke1", 390, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe2Sym = GUICtrlCreateInput("Ke2", 465, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe3Sym = GUICtrlCreateInput("Ke3", 540, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadIllumSym = GUICtrlCreateInput("Illum", 415, 460, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadScaleSym = GUICtrlCreateInput("Scale", 415, 460, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)

	$NsWingRead = GUICtrlCreateInput("Ns", 705, 258, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadScaleWing = GUICtrlCreateInput("Scale", 855, 258, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	$dWingRead = GUICtrlCreateInput("d", 819, 258, 60, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	GuiCtrlSetTip(-1, "Transparency")
	$ReadKa1Wing = GUICtrlCreateInput("Ka1", 705, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa2Wing = GUICtrlCreateInput("Ka2", 780, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKa3Wing = GUICtrlCreateInput("Ka3", 855, 305, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd1Wing = GUICtrlCreateInput("Kd1", 705, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd2Wing = GUICtrlCreateInput("Kd2", 780, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKd3Wing = GUICtrlCreateInput("Kd3", 855, 340, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs1Wing = GUICtrlCreateInput("Ks1", 705, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs2Wing = GUICtrlCreateInput("Ks2", 780, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKs3Wing = GUICtrlCreateInput("Ks3", 855, 374, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe1Wing = GUICtrlCreateInput("Ke1", 705, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe2Wing = GUICtrlCreateInput("Ke2", 780, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
	$ReadKe3Wing = GUICtrlCreateInput("Ke3", 855, 408, 60, 20)
	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadIllumWing = GUICtrlCreateInput("Illum", 730, 460, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)
;	$ReadScaleWing = GUICtrlCreateInput("Scale", 730, 460, 40, 20)
;	GUICtrlSetColor(-1, 0xFF0000)

#cs
	$WriteLet = GUICtrlCreateButton("Write", 183, 490, 102, 55)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GuiCtrlSetTip($WriteLet, "Write values to Letters")
	GUICtrlSetOnEvent($WriteLet, "_Write_Letters_stub")

	$WriteSym = GUICtrlCreateButton("Write", 498, 490, 102, 55)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GuiCtrlSetTip($WriteSym, "Write values to Symbols")
	GUICtrlSetOnEvent($WriteSym, "_Write_Symbols_stub")

	$WriteWing = GUICtrlCreateButton("Write", 813, 443, 102, 55)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GuiCtrlSetTip($WriteWing, "Write values to WingDings")
	GUICtrlSetOnEvent($WriteWing, "_Write_WingDings_stub")
#ce

	$ChangeLetterFont = GUICtrlCreateButton("Change Font", 183, 443, 102, 30)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GUICtrlSetOnEvent($ChangeLetterFont, "_Change_LetterFonts")

	$LabelLetterFont = GUICtrlCreateLabel("Current Font", 75, 440, 100, 24)
	GUICtrlSetFont(-1, 10, 600, 4, "MS Sans Serif")
	Global $CurrentFont = GUICtrlCreateLabel($FontStateLetter, 80, 460, 100, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$ChangeSymbolFont = GUICtrlCreateButton("Change Font", 498, 443, 102, 30)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x008000)
	GUICtrlSetOnEvent($ChangeSymbolFont, "_Change_SymbolFonts")

	$LabelSymbolFont = GUICtrlCreateLabel("Current Font", 390, 440, 100, 24)
	GUICtrlSetFont(-1, 10, 600, 4, "MS Sans Serif")
	Global $CurrentSymbolFont = GUICtrlCreateLabel($FontStateSymbol, 395, 460, 100, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$LabelTexture1 = GUICtrlCreateButton("Diffuse1", 20, 497, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Diffuse map file for Capital letters and numbers: Kd")

	Global $CurrentTexture1 = GUICtrlCreateLabel($LetTextureStateOne, 105, 500, 195, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$LabelTexture2 = GUICtrlCreateButton("Specular1", 20, 520, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Specular map file for Capital letters and numbers: Ks")

	Global $CurrentTexture2 = GUICtrlCreateLabel($LetTextureStateTwo, 105, 522, 195, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$LabelTexture3 = GUICtrlCreateButton("Diffuse2", 20, 552, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Diffuse map file for lower case letters: Kd")

	Global $CurrentTexture3 = GUICtrlCreateLabel($LetTextureStateThree, 105, 555, 195, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$LabelTexture4 = GUICtrlCreateButton("Specular2", 20, 575, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Specular map file for lower case Letters: Ks")

	Global $CurrentTexture4 = GUICtrlCreateLabel($LetTextureStateFour, 105, 578, 195, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")



	$LabelSymTexture1 = GUICtrlCreateButton("Diffuse1", 336, 497, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Diffuse map file for most Symbols: Kd")

	Global $CurrentSymTexture1 = GUICtrlCreateLabel($SymTextureStateOne, 426, 500, 195, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$LabelSymTexture2 = GUICtrlCreateButton("Specular1 ", 336, 520, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Specular map file for most Symbols: Ks")

	Global $CurrentSymTexture2 = GUICtrlCreateLabel($SymTextureStateTwo, 426, 522, 195, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")


	$LabelSymTexture3 = GUICtrlCreateButton("Diffuse2 ", 336, 552, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Diffuse map file for Backtick, Caret, Colon, Coma, Dollar, dQuote, Greater, Lesser, sColon, sQuote: Kd")

	Global $CurrentSymTexture3 = GUICtrlCreateLabel($SymTextureStateThree, 426, 555, 195, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")


	$LabelSymTexture4 = GUICtrlCreateButton("Specular2 ", 336, 575, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Specular map file for Backtick, Caret, Colon, Coma, Dollar, dQuote, Greater, Lesser, sColon, sQuote: Ks")

	Global $CurrentSymTexture4 = GUICtrlCreateLabel($SymTextureStateFour, 426, 578, 195, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")


$LabelWingTexture1 = GUICtrlCreateButton("Diffuse1", 650, 452, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Diffuse map file for All WingDings except the Smiley Face and Frown: Kd")

	Global $CurrentWingTexture1 = GUICtrlCreateLabel($WingTextureStateOne, 740, 452, 185, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$LabelWingTexture2 = GUICtrlCreateButton("Specular1", 650, 474, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Specular map file for All WingDings except the Smiley Face and Frown: Ks")

	Global $CurrentWingTexture2 = GUICtrlCreateLabel($WingTextureStateTwo, 740, 476, 165, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$LabelWingTexture3 = GUICtrlCreateButton("Diffuse2", 650, 505, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Diffuse map file for the WingDings Smiley Face and Frown: Kd")

	Global $CurrentWingTexture3 = GUICtrlCreateLabel($WingTextureStateThree, 740, 507, 185, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	$LabelWingTexture4 = GUICtrlCreateButton("Specular2", 650, 528, 80, 22)
	GUICtrlSetFont(-1, 10, 600, 1, "MS Sans Serif")
	GuiCtrlSetTip(-1, "Set Specular map file for the WingDings Smiley Face and Frown: Ks")

	Global $CurrentWingTexture4 = GUICtrlCreateLabel($WingTextureStateFour, 740, 530, 185, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")


	Global $Exit_Button = GUICtrlCreateButton("Exit", 883, 562, 55, 45)
	GUICtrlSetOnEvent($Exit_Button, "_Close")
	GUICtrlSetBkColor($Exit_Button, $COLOR_RED)
	GUICtrlSetColor($Exit_Button, $COLOR_WHITE)
	GUICtrlSetFont(-1, 14, 600, 4, "MS Sans Serif")

	$LabelVersion = GUICtrlCreateLabel("Version", 1, 609, 60, 14)
	GUICtrlSetFont(-1, 7, 500, 1, "Comic Sans MS")
	GUICtrlSetData($LabelVersion, "Ver: " & $Version)



	_Read_Letters()
	_Read_Symbols()
	_Read_WingDings()

	GUICtrlSetOnEvent($SpacingX, "_Spacing_X")
	GUICtrlSetOnEvent($SpacingY, "_Spacing_Y")
	GUICtrlSetOnEvent($SpacingYPeriod, "_Spacing_Period")
	GUICtrlSetOnEvent($SpacingYQuote, "_Spacing_Quote")
	GUICtrlSetOnEvent($SpacingYSmallg, "_Spacing_Smallg")
	GUICtrlSetOnEvent($SpacingYSmallt, "_Spacing_Smallt")
	GUICtrlSetOnEvent($SpacingYSmallo, "_Spacing_Smallo")
	GUICtrlSetOnEvent($NsLetRead, "_Read_NsLetter")
	GUICtrlSetOnEvent($NsSymRead, "_Read_NsSymbol")
	GUICtrlSetOnEvent($NsWingRead, "_Read_NsWing")
	GUICtrlSetOnEvent($ReadKa1Let, "_Read_KaLetter")
	GUICtrlSetOnEvent($ReadKa2Let, "_Read_KaLetter")
	GUICtrlSetOnEvent($ReadKa3Let, "_Read_KaLetter")
	GUICtrlSetOnEvent($ReadKa1Sym, "_Read_KaSymbol")
	GUICtrlSetOnEvent($ReadKa2Sym, "_Read_KaSymbol")
	GUICtrlSetOnEvent($ReadKa3Sym, "_Read_KaSymbol")
	GUICtrlSetOnEvent($ReadKa1Wing, "_Read_KaWing")
	GUICtrlSetOnEvent($ReadKa2Wing, "_Read_KaWing")
	GUICtrlSetOnEvent($ReadKa3Wing, "_Read_KaWing")
	GUICtrlSetOnEvent($ReadKd1Let, "_Read_KdLetter")
	GUICtrlSetOnEvent($ReadKd2Let, "_Read_KdLetter")
	GUICtrlSetOnEvent($ReadKd3Let, "_Read_KdLetter")
	GUICtrlSetOnEvent($ReadKd1Sym, "_Read_KdSymbol")
	GUICtrlSetOnEvent($ReadKd2Sym, "_Read_KdSymbol")
	GUICtrlSetOnEvent($ReadKd3Sym, "_Read_KdSymbol")
	GUICtrlSetOnEvent($ReadKd1Wing, "_Read_KdWing")
	GUICtrlSetOnEvent($ReadKd2Wing, "_Read_KdWing")
	GUICtrlSetOnEvent($ReadKd3Wing, "_Read_KdWing")
	GUICtrlSetOnEvent($ReadKs1Let, "_Read_KsLetter")
	GUICtrlSetOnEvent($ReadKs2Let, "_Read_KsLetter")
	GUICtrlSetOnEvent($ReadKs3Let, "_Read_KsLetter")
	GUICtrlSetOnEvent($ReadKs1Sym, "_Read_KsSymbol")
	GUICtrlSetOnEvent($ReadKs2Sym, "_Read_KsSymbol")
	GUICtrlSetOnEvent($ReadKs3Sym, "_Read_KsSymbol")
	GUICtrlSetOnEvent($ReadKs1Wing, "_Read_KsWing")
	GUICtrlSetOnEvent($ReadKs2Wing, "_Read_KsWing")
	GUICtrlSetOnEvent($ReadKs3Wing, "_Read_KsWing")
	GUICtrlSetOnEvent($ReadKe1Let, "_Read_KeLetter")
	GUICtrlSetOnEvent($ReadKe2Let, "_Read_KeLetter")
	GUICtrlSetOnEvent($ReadKe3Let, "_Read_KeLetter")
	GUICtrlSetOnEvent($ReadKe1Sym, "_Read_KeSymbol")
	GUICtrlSetOnEvent($ReadKe2Sym, "_Read_KeSymbol")
	GUICtrlSetOnEvent($ReadKe3Sym, "_Read_KeSymbol")
	GUICtrlSetOnEvent($ReadKe1Wing, "_Read_KeWing")
	GUICtrlSetOnEvent($ReadKe2Wing, "_Read_KeWing")
	GUICtrlSetOnEvent($ReadKe3Wing, "_Read_KeWing")
	GUICtrlSetOnEvent($LabelTexture1, "_Letter_Texture_Swap1a")
	GUICtrlSetOnEvent($LabelTexture2, "_Letter_Texture_Swap1b")
	GUICtrlSetOnEvent($LabelTexture3, "_Letter_Texture_Swap2a")
	GUICtrlSetOnEvent($LabelTexture4, "_Letter_Texture_Swap2b")
	GUICtrlSetOnEvent($LabelSymTexture1, "_Symbol_Texture_Swap1a")
	GUICtrlSetOnEvent($LabelSymTexture2, "_Symbol_Texture_Swap1b")
	GUICtrlSetOnEvent($LabelSymTexture3, "_Symbol_Texture_Swap2a")
	GUICtrlSetOnEvent($LabelSymTexture4, "_Symbol_Texture_Swap2b")
	GUICtrlSetOnEvent($LabelWingTexture1, "_Wing_Texture_Swap1a")
	GUICtrlSetOnEvent($LabelWingTexture2, "_Wing_Texture_Swap1b")
	GUICtrlSetOnEvent($LabelWingTexture3, "_Wing_Texture_Swap2a")
	GUICtrlSetOnEvent($LabelWingTexture4, "_Wing_Texture_Swap2b")

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
									$Ycoor = $Ycoor - $gShift
								ElseIf $letter = "i" Or $letter = "t" Then
									$Ycoor = $Ycoor - $tShift
								Else
									$Ycoor = $Ycoor - $oShift
								EndIf
							EndIf
						EndIf
						If $letter = "." Or $letter = "," Or $letter = "_" Then $Ycoor = $Ycoor - $PeriodShift
						If $letter = "`" Or $letter = "^" Or $letter = "*" Or $letter = "'" Or $letter = '"' Then $Ycoor = $Ycoor + $QuoteShift

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
		$ObjectPath = "props/Labels/Letters/Letters_" & $letter & $letter & "/Small" & $letter & ".obj"
		$Title = "Small_" & $letter
	ElseIf StringIsUpper($letter) Then
		$ObjectPath = "props/Labels/Letters/Letters_" & $letter & "/Cap" & $letter & ".obj"
		$Title = "Capital_" & $letter
	ElseIf StringIsDigit($letter) Then
		$ObjectPath = "props/Labels/Letters/Letters_" & $letter & "/" & $letter & ".obj"
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
			Case "`"
				$symb = "Backtick"
			Case "{"
				$symb = "BracesL"
			Case "}"
				$symb = "BracesR"
			Case "["
				$symb = "BracketsL"
			Case "]"
				$symb = "BracketsR"
			Case "^"
				$symb = "Caret"
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
			Case "|"
				$symb = "Pipe"
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
			Case '"'
				$symb = "dQuote"
			Case "'"
				$symb = "sQuote"
			Case ";"
				$symb = "sColon"
			Case "/"
				$symb = "Slash"
			Case "~"
				$symb = "Tilde"
			Case "_"
				$symb = "Underscore"
			Case Else
				$symb = "Question"
			EndSwitch
		$ObjectPath = "props/Labels/Symbols/Symbols_" & $symb & "/" & $symb & ".obj"
		$Title = "Symbol_" & $symb
	EndIf

EndFunc

Func _Spacing_X()
	$XShift = GUICtrlRead($SpacingX)
	If StringLeft($XShift, 1) = "." Then
		$XShift = "0" & $XShift
		GUICtrlSetData($SpacingX, $XShift)
	EndIf
	IniWrite($config_ini, "Settings_WordMaker", "Xshift", $XShift)
	MsgBox(0, "", "Letter spacing set", 1)
EndFunc

Func _Spacing_Y()
	$YShift = GUICtrlRead($SpacingY)
	If StringLeft($YShift, 1) = "." Then
		$YShift = "0" & $YShift
		GUICtrlSetData($SpacingY, $YShift)
	EndIf
	IniWrite($config_ini, "Settings_WordMaker", "Yshift", $YShift)
	MsgBox(0, "", "Letter spacing set", 1)
EndFunc

Func _Spacing_Period()
	$PeriodShift = GUICtrlRead($SpacingYPeriod)
	If StringLeft($PeriodShift, 1) = "." Then
		$PeriodShift = "0" & $PeriodShift
		GUICtrlSetData($SpacingYPeriod, $PeriodShift)
	EndIf
	IniWrite($config_ini, "Settings_WordMaker", "PeriodShift", $PeriodShift)
	MsgBox(0, "", "Letter spacing set", 1)
EndFunc

Func _Spacing_Quote()
	$QuoteShift = GUICtrlRead($SpacingYQuote)
	If StringLeft($QuoteShift, 1) = "." Then
		$QuoteShift = "0" & $QuoteShift
		GUICtrlSetData($SpacingYQuote, $QuoteShift)
	EndIf
	IniWrite($config_ini, "Settings_WordMaker", "QuoteShift", $QuoteShift)
	MsgBox(0, "", "Letter spacing set", 1)
EndFunc

Func _Spacing_Smallg()
	$gShift = GUICtrlRead($SpacingYSmallg)
	If StringLeft($gShift, 1) = "." Then
		$gShift = "0" & $gShift
		GUICtrlSetData($SpacingYSmallg, $gShift)
	EndIf
	IniWrite($config_ini, "Settings_WordMaker", "gShift", $gShift)
	MsgBox(0, "", "Letter spacing set", 1)
EndFunc

Func _Spacing_Smallt()
	$tShift = GUICtrlRead($SpacingYSmallt)
	If StringLeft($tShift, 1) = "." Then
		$tShift = "0" & $tShift
		GUICtrlSetData($SpacingYSmallt, $tShift)
	EndIf
	IniWrite($config_ini, "Settings_WordMaker", "tShift", $tShift)
	MsgBox(0, "", "Letter spacing set", 1)
EndFunc

Func _Spacing_Smallo()
	$oShift = GUICtrlRead($SpacingYSmallo)
	If StringLeft($oShift, 1) = "." Then
		$oShift = "0" & $oShift
		GUICtrlSetData($SpacingYSmallo, $oShift)
	EndIf
	IniWrite($config_ini, "Settings_WordMaker", "oShift", $oShift)
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
	Local $Clearing = MsgBox(1, "Caution", "Are you sure that you want to reset the Words Room?")
	If $Clearing = 1 Then
		$Room = $WordRoom
		FileDelete($Room)
		_Write_base_room()
		MsgBox(0, "", "Cleared", 1)
	EndIf
EndFunc

Func _Clear_SessionRoom()
	Local $Clearing = MsgBox(1, "Caution", "Are you sure that you want to reset the Sessions Room?" & @CRLF & "Note: remember that you can't reset the room if VRToolbox is running!")
	If $Clearing = 1 Then
		$Room = $SessionRoom
		FileDelete($Room)
		_Write_base_room()
		MsgBox(0, "", "Cleared", 1)
	EndIf

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


Func _Read_Letters()
	If FileExists($StartMTLFileLetter) Then
		$NsStart_Let = FileReadLine($StartMTLFileLetter, 2)
				$aNsStart_Let = StringSplit($NsStart_Let, " ")
				$NsStart_Let = $aNsStart_Let[2]
				GUICtrlSetData($NsLetRead, $NsStart_Let)
;		$dStart_Let = FileReadLine($StartMTLFileLetter, 8)
;				$adStart_Let = StringSplit($dStart_Let, " ")
;				$dStart_Let = $adStart_Let[2]
;				GUICtrlSetData($dLetRead, $dStart_Let)
		$Ka1Start_Let = FileReadLine($StartMTLFileLetter, 3)
				$aKa1Start_Let = StringSplit($Ka1Start_Let, " ")
				$Ka1Start_Let = $aKa1Start_Let[2]
				GUICtrlSetData($ReadKa1Let, $Ka1Start_Let)
		$Ka2Start_Let = FileReadLine($StartMTLFileLetter, 3)
				$aKa2Start_Let = StringSplit($Ka2Start_Let, " ")
				$Ka2Start_Let = $aKa2Start_Let[3]
				GUICtrlSetData($ReadKa2Let, $Ka2Start_Let)
		$Ka3Start_Let = FileReadLine($StartMTLFileLetter, 3)
				$aKa3Start_Let = StringSplit($Ka3Start_Let, " ")
				$Ka3Start_Let = $aKa3Start_Let[4]
				GUICtrlSetData($ReadKa3Let, $Ka3Start_Let)
		$Kd1Start_Let = FileReadLine($StartMTLFileLetter, 4)
				$aKd1Start_Let = StringSplit($Kd1Start_Let, " ")
				$Kd1Start_Let = $aKd1Start_Let[2]
				GUICtrlSetData($ReadKd1Let, $Kd1Start_Let)
		$Kd2Start_Let = FileReadLine($StartMTLFileLetter, 4)
				$aKd2Start_Let = StringSplit($Kd2Start_Let, " ")
				$Kd2Start_Let = $aKd2Start_Let[3]
				GUICtrlSetData($ReadKd2Let, $Kd2Start_Let)
		$Kd3Start_Let = FileReadLine($StartMTLFileLetter, 4)
				$aKd3Start_Let = StringSplit($Kd3Start_Let, " ")
				$Kd3Start_Let = $aKd3Start_Let[4]
				GUICtrlSetData($ReadKd3Let, $Kd3Start_Let)
		$Ks1Start_Let = FileReadLine($StartMTLFileLetter, 5)
				$aKs1Start_Let = StringSplit($Ks1Start_Let, " ")
				$Ks1Start_Let = $aKs1Start_Let[2]
				GUICtrlSetData($ReadKs1Let, $Ks1Start_Let)
		$Ks2Start_Let = FileReadLine($StartMTLFileLetter, 5)
				$aKs2Start_Let = StringSplit($Ks2Start_Let, " ")
				$Ks2Start_Let = $aKs2Start_Let[3]
				GUICtrlSetData($ReadKs2Let, $Ks2Start_Let)
		$Ks3Start_Let = FileReadLine($StartMTLFileLetter, 5)
				$aKs3Start_Let = StringSplit($Ks3Start_Let, " ")
				$Ks3Start_Let = $aKs3Start_Let[4]
				GUICtrlSetData($ReadKs3Let, $Ks3Start_Let)
		$Ke1Start_Let = FileReadLine($StartMTLFileLetter, 6)
				$aKe1Start_Let = StringSplit($Ke1Start_Let, " ")
				$Ke1Start_Let = $aKe1Start_Let[2]
				GUICtrlSetData($ReadKe1Let, $Ke1Start_Let)
		$Ke2Start_Let = FileReadLine($StartMTLFileLetter, 6)
				$aKe2Start_Let = StringSplit($Ke2Start_Let, " ")
				$Ke2Start_Let = $aKe2Start_Let[3]
				GUICtrlSetData($ReadKe2Let, $Ke2Start_Let)
		$Ke3Start_Let = FileReadLine($StartMTLFileLetter, 6)
				$aKe3Start_Let = StringSplit($Ke3Start_Let, " ")
				$Ke3Start_Let = $aKe3Start_Let[4]
				GUICtrlSetData($ReadKe3Let, $Ke3Start_Let)
;		$IllumStart_Let = FileReadLine($StartMTLFileLetter, 9)
;				$aIllum_Let = StringSplit($IllumStart_Let, " ")
;				$IllumStart_Let = $aIllum_Let[0]
;				GUICtrlSetData($ReadIllumLet, $IllumStart_Let)
;		$ScaleStart_Let_pre = FileReadLine($StartDescFileLetter, 8)
;				$ScaleStart_Let = StringStripWS($ScaleStart_Let_pre, 8)
;				$aScaleStart_Let = StringSplit($ScaleStart_Let, ":")
;				$ScaleStart_Let = $aScaleStart_Let[2]
;				$ScaleStart_Let = StringTrimRight($ScaleStart_Let, 1)
;				GUICtrlSetData($ReadScaleLet, $ScaleStart_Let)
	EndIf
EndFunc

Func _Read_Symbols()
	If FileExists($StartMTLFileSymbol) Then
		$NsStart_Sym = FileReadLine($StartMTLFileSymbol, 2)
				$aNsStart_Sym = StringSplit($NsStart_Sym, " ")
				$NsStart_Sym = $aNsStart_Sym[2]
				GUICtrlSetData($NsSymRead, $NsStart_Sym)
;		$dStart_Sym = FileReadLine($StartMTLFileSymbol, 8)
;				$adStart_Sym = StringSplit($dStart_Sym, " ")
;				$dStart_Sym = $adStart_Sym[2]
;				GUICtrlSetData($dSymRead, $dStart_Sym)
		$Ka1Start_Sym = FileReadLine($StartMTLFileSymbol, 3)
				$aKa1Start_Sym = StringSplit($Ka1Start_Sym, " ")
				$Ka1Start_Sym = $aKa1Start_Sym[2]
				GUICtrlSetData($ReadKa1Sym, $Ka1Start_Sym)
		$Ka2Start_Sym = FileReadLine($StartMTLFileSymbol, 3)
				$aKa2Start_Sym = StringSplit($Ka2Start_Sym, " ")
				$Ka2Start_Sym = $aKa2Start_Sym[3]
				GUICtrlSetData($ReadKa2Sym, $Ka2Start_Sym)
		$Ka3Start_Sym = FileReadLine($StartMTLFileSymbol, 3)
				$aKa3Start_Sym = StringSplit($Ka3Start_Sym, " ")
				$Ka3Start_Sym = $aKa3Start_Sym[4]
				GUICtrlSetData($ReadKa3Sym, $Ka3Start_Sym)
		$Kd1Start_Sym = FileReadLine($StartMTLFileSymbol, 4)
				$aKd1Start_Sym = StringSplit($Kd1Start_Sym, " ")
				$Kd1Start_Sym = $aKd1Start_Sym[2]
				GUICtrlSetData($ReadKd1Sym, $Kd1Start_Sym)
		$Kd2Start_Sym = FileReadLine($StartMTLFileSymbol, 4)
				$aKd2Start_Sym = StringSplit($Kd2Start_Sym, " ")
				$Kd2Start_Sym = $aKd2Start_Sym[3]
				GUICtrlSetData($ReadKd2Sym, $Kd2Start_Sym)
		$Kd3Start_Sym = FileReadLine($StartMTLFileSymbol, 4)
				$aKd3Start_Sym = StringSplit($Kd3Start_Sym, " ")
				$Kd3Start_Sym = $aKd3Start_Sym[4]
				GUICtrlSetData($ReadKd3Sym, $Kd3Start_Sym)
		$Ks1Start_Sym = FileReadLine($StartMTLFileSymbol, 5)
				$aKs1Start_Sym = StringSplit($Ks1Start_Sym, " ")
				$Ks1Start_Sym = $aKs1Start_Sym[2]
				GUICtrlSetData($ReadKs1Sym, $Ks1Start_Sym)
		$Ks2Start_Sym = FileReadLine($StartMTLFileSymbol, 5)
				$aKs2Start_Sym = StringSplit($Ks2Start_Sym, " ")
				$Ks2Start_Sym = $aKs2Start_Sym[3]
				GUICtrlSetData($ReadKs2Sym, $Ks2Start_Sym)
		$Ks3Start_Sym = FileReadLine($StartMTLFileSymbol, 5)
				$aKs3Start_Sym = StringSplit($Ks3Start_Sym, " ")
				$Ks3Start_Sym = $aKs3Start_Sym[4]
				GUICtrlSetData($ReadKs3Sym, $Ks3Start_Sym)
		$Ke1Start_Sym = FileReadLine($StartMTLFileSymbol, 6)
				$aKe1Start_Sym = StringSplit($Ke1Start_Sym, " ")
				$Ke1Start_Sym = $aKe1Start_Sym[2]
				GUICtrlSetData($ReadKe1Sym, $Ke1Start_Sym)
		$Ke2Start_Sym = FileReadLine($StartMTLFileSymbol, 6)
				$aKe2Start_Sym = StringSplit($Ke2Start_Sym, " ")
				$Ke2Start_Sym = $aKe2Start_Sym[3]
				GUICtrlSetData($ReadKe2Sym, $Ke2Start_Sym)
		$Ke3Start_Sym = FileReadLine($StartMTLFileSymbol, 6)
				$aKe3Start_Sym = StringSplit($Ke3Start_Sym, " ")
				$Ke3Start_Sym = $aKe3Start_Sym[4]
				GUICtrlSetData($ReadKe3Sym, $Ke3Start_Sym)
;		$IllumStart_Sym = FileReadLine($StartMTLFileSymbol, 9)
;				$aIllum_Sym = StringSplit($IllumStart_Sym, " ")
;				$IllumStart_Sym = $aIllum_Sym[0]
;				GUICtrlSetData($ReadIllumSym, $IllumStart_Sym)
;		$ScaleStart_Sym_pre = FileReadLine($StartDescFileSymbol, 8)
;		$ScaleStart_Sym = StringStripWS($ScaleStart_Sym_pre, 8)
;				$aScaleStart_Sym = StringSplit($ScaleStart_Sym, ":")
;				$ScaleStart_Sym = $aScaleStart_Sym[2]
;				$ScaleStart_Sym = StringTrimRight($ScaleStart_Sym, 1)
;				GUICtrlSetData($ReadScaleSym, $ScaleStart_Sym)
	EndIf
EndFunc

Func _Read_WingDings()
	If FileExists($StartMTLFileWingDings) Then
		$NsStart_Wing = FileReadLine($StartMTLFileWingDings, 2)
				$aNsStart_Wing = StringSplit($NsStart_Wing, " ")
				$NsStart_Wing = $aNsStart_Wing[2]
				GUICtrlSetData($NsWingRead, $NsStart_Wing)
;		$dStart_Wing = FileReadLine($StartMTLFileWingDings, 8)
;				$adStart_Wing = StringSplit($dStart_Wing, " ")
;				$dStart_Wing = $adStart_Wing[2]
;				GUICtrlSetData($dWingRead, $dStart_Wing)
		$Ka1Start_Wing = FileReadLine($StartMTLFileWingDings, 3)
				$aKa1Start_Wing = StringSplit($Ka1Start_Wing, " ")
				$Ka1Start_Wing = $aKa1Start_Wing[2]
				GUICtrlSetData($ReadKa1Wing, $Ka1Start_Wing)
		$Ka2Start_Wing = FileReadLine($StartMTLFileWingDings, 3)
				$aKa2Start_Wing = StringSplit($Ka2Start_Wing, " ")
				$Ka2Start_Wing = $aKa2Start_Wing[3]
				GUICtrlSetData($ReadKa2Wing, $Ka2Start_Wing)
		$Ka3Start_Wing = FileReadLine($StartMTLFileWingDings, 3)
				$aKa3Start_Wing = StringSplit($Ka3Start_Wing, " ")
				$Ka3Start_Wing = $aKa3Start_Wing[4]
				GUICtrlSetData($ReadKa3Wing, $Ka3Start_Wing)
		$Kd1Start_Wing = FileReadLine($StartMTLFileWingDings, 4)
				$aKd1Start_Wing = StringSplit($Kd1Start_Wing, " ")
				$Kd1Start_Wing = $aKd1Start_Wing[2]
				GUICtrlSetData($ReadKd1Wing, $Kd1Start_Wing)
		$Kd2Start_Wing = FileReadLine($StartMTLFileWingDings, 4)
				$aKd2Start_Wing = StringSplit($Kd2Start_Wing, " ")
				$Kd2Start_Wing = $aKd2Start_Wing[3]
				GUICtrlSetData($ReadKd2Wing, $Kd2Start_Wing)
		$Kd3Start_Wing = FileReadLine($StartMTLFileWingDings, 4)
				$aKd3Start_Wing = StringSplit($Kd3Start_Wing, " ")
				$Kd3Start_Wing = $aKd3Start_Wing[4]
				GUICtrlSetData($ReadKd3Wing, $Kd3Start_Wing)
		$Ks1Start_Wing = FileReadLine($StartMTLFileWingDings, 5)
				$aKs1Start_Wing = StringSplit($Ks1Start_Wing, " ")
				$Ks1Start_Wing = $aKs1Start_Wing[2]
				GUICtrlSetData($ReadKs1Wing, $Ks1Start_Wing)
		$Ks2Start_Wing = FileReadLine($StartMTLFileWingDings, 5)
				$aKs2Start_Wing = StringSplit($Ks2Start_Wing, " ")
				$Ks2Start_Wing = $aKs2Start_Wing[3]
				GUICtrlSetData($ReadKs2Wing, $Ks2Start_Wing)
		$Ks3Start_Wing = FileReadLine($StartMTLFileWingDings, 5)
				$aKs3Start_Wing = StringSplit($Ks3Start_Wing, " ")
				$Ks3Start_Wing = $aKs3Start_Wing[4]
				GUICtrlSetData($ReadKs3Wing, $Ks3Start_Wing)
		$Ke1Start_Wing = FileReadLine($StartMTLFileWingDings, 6)
				$aKe1Start_Wing = StringSplit($Ke1Start_Wing, " ")
				$Ke1Start_Wing = $aKe1Start_Wing[2]
				GUICtrlSetData($ReadKe1Wing, $Ke1Start_Wing)
		$Ke2Start_Wing = FileReadLine($StartMTLFileWingDings, 6)
				$aKe2Start_Wing = StringSplit($Ke2Start_Wing, " ")
;			_ArrayDisplay($aKe2Start_Wing)
				$Ke2Start_Wing = $aKe2Start_Wing[3]
				GUICtrlSetData($ReadKe2Wing, $Ke2Start_Wing)
		$Ke3Start_Wing = FileReadLine($StartMTLFileWingDings, 6)
				$aKe3Start_Wing = StringSplit($Ke3Start_Wing, " ")
				$Ke3Start_Wing = $aKe3Start_Wing[4]
				GUICtrlSetData($ReadKe3Wing, $Ke3Start_Wing)
;		$IllumStart_Wing = FileReadLine($StartMTLFileWingDings, 9)
;				$aIllum_Wing = StringSplit($IllumStart_Wing, " ")
;				$IllumStart_Wing = $aIllum_Wing[0]
;				GUICtrlSetData($ReadIllumWing, $IllumStart_Wing)
;		$ScaleStart_Wing_pre = FileReadLine($StartDescFileWingDings, 8)
;		$ScaleStart_Wing = StringStripWS($ScaleStart_Wing_pre, 8)
;				$aScaleStart_Wing = StringSplit($ScaleStart_Wing, ":")
;				$ScaleStart_Wing = $aScaleStart_Wing[2]
;				$ScaleStart_Wing = StringTrimRight($ScaleStart_Wing, 1)
;				GUICtrlSetData($ReadScaleWing, $ScaleStart_Wing)
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
;		$dLetRead1 = GUICtrlRead($dLetRead)
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
;		$ReadIllumLet1 = GUICtrlRead($ReadIllumLet)
;		$ReadScaleLet1 = GUICtrlRead($ReadScaleLet)

		$aLetters = _FileListToArray($LabelsLetter, "Letters_*")
		For $L = 1 To $aLetters[0]
			$CapLetPath = $aLetters[$L] & "\"
			$CapLetPathsub = StringTrimRight($CapLetPath, 1)
			$CapLetPathsub = StringTrimLeft($CapLetPathsub, 8)
			If StringIsLower(StringRight($CapLetPathsub, 1)) Then
				$TestMtlPath = $LabelsLetter & $CapLetPath & "Small" & StringRight($CapLetPathsub, 1) & ".mtl"
;				$TestDescPath = $LabelsLetter & $CapLetPath & "Description.json"
			Elseif StringIsUpper($CapLetPathsub) Then
				$TestMtlPath = $LabelsLetter & $CapLetPath & "Cap" & $CapLetPathsub & ".mtl"
;				$TestDescPath = $LabelsLetter & $CapLetPath & "Description.json"
			Else
				$TestMtlPath = $LabelsLetter & $CapLetPath & $CapLetPathsub & ".mtl"
;				$TestDescPath = $LabelsLetter & $CapLetPath & "Description.json"
			EndIf

			If FileExists($TestMtlPath) Then
				_FileWriteToLine($TestMtlPath, 2, "Ns " & $NsLetRead1, True)
				_FileWriteToLine($TestMtlPath, 3, "Ka " & $ReadKa1Let1 & " " & $ReadKa2Let1 & " " & $ReadKa3Let1, True)
				_FileWriteToLine($TestMtlPath, 4, "Kd " & $ReadKd1Let1 & " " & $ReadKd2Let1 & " " & $ReadKd3Let1, True)
				_FileWriteToLine($TestMtlPath, 5, "Ks " & $ReadKs1Let1 & " " & $ReadKs2Let1 & " " & $ReadKs3Let1, True)
				_FileWriteToLine($TestMtlPath, 6, "Ke " & $ReadKe1Let1 & " " & $ReadKe2Let1 & " " & $ReadKe3Let1, True)
;				_FileWriteToLine($TestMtlPath, 8, "d " & $dLetRead1, True)
;				_FileWriteToLine($TestMtlPath, 9, 'illum ' & $ReadIllumLet1, True)
;				_FileWriteToLine($TestDescPath, 8, '    "scale" : ' & $ReadScaleLet1 & ",", True)
			Else
				MsgBox(0, "Error", "Error: file does not exist")
			EndIf
		Next
EndFunc



Func _Write_Symbols()
		$NsSymRead1 = GUICtrlRead($NsSymRead)
;		$dSymRead1 = GUICtrlRead($dSymRead)
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
;		$ReadIllumSym1 = GUICtrlRead($ReadIllumSym)
;		$ReadScaleSym1 = GUICtrlRead($ReadScaleSym)

		$aSymbols = _FileListToArray($LabelsSymbol, "Symbols_*")
		For $s = 1 To $aSymbols[0]
			$SymbolPath = $LabelsSymbol & $aSymbols[$s] & "\"
			$testSym1 = $aSymbols[$s]
			$testSym = _StringBetween($testSym1, "_", "")
			$SymbolMtlPath = $SymbolPath & $testSym[0] & ".mtl"
;			$SymbolDescPath = $SymbolPath & "Description.json"

			If FileExists($SymbolMtlPath) Then
				_FileWriteToLine($SymbolMtlPath, 2, "Ns " & $NsSymRead1, True)
				_FileWriteToLine($SymbolMtlPath, 3, "Ka " & $ReadKa1Sym1 & " " & $ReadKa2Sym1 & " " & $ReadKa3Sym1, True)
				_FileWriteToLine($SymbolMtlPath, 4, "Kd " & $ReadKd1Sym1 & " " & $ReadKd2Sym1 & " " & $ReadKd3Sym1, True)
				_FileWriteToLine($SymbolMtlPath, 5, "Ks " & $ReadKs1Sym1 & " " & $ReadKs2Sym1 & " " & $ReadKs3Sym1, True)
				_FileWriteToLine($SymbolMtlPath, 6, "Ke " & $ReadKe1Sym1 & " " & $ReadKe2Sym1 & " " & $ReadKe3Sym1, True)
;				_FileWriteToLine($SymbolMtlPath, 8, "d " & $dSymRead1, True)
;				_FileWriteToLine($SymbolMtlPath, 9, 'illum ' & $ReadIllumSym1, True)
;				_FileWriteToLine($SymbolDescPath, 8, '    "scale" : ' & $ReadScaleSym1 & ",", True)
			Else
				MsgBox(48, "Error", "Error, either mtl or description file missing")
			EndIf
		Next
EndFunc

Func _Write_WingDings()
		$NsWingReadD = GUICtrlRead($NsWingRead)
;		$dWingReadD = GUICtrlRead($dWingRead)
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
;		$ReadIllumWingD = GUICtrlRead($ReadIllumWing)
;		$ReadScaleWingD = GUICtrlRead($ReadScaleWing)
		$aWingDings = _FileListToArray($Props, "WingDings_*")

		For $w = 1 To $aWingDings[0]
			$WingPath = $Props & $aWingDings[$w] & "\"
			$WingName = $aWingDings[$w]
			$aWingName = _StringBetween($WingName, "_", "")
			$WingDingMTLfile_Path = $WingPath & $aWingName[0] & ".mtl"
;			$WingDingDescfile_Path = $WingPath & "Description.json"
			If FileExists($WingDingMTLfile_Path) Then
				_FileWriteToLine($WingDingMTLfile_Path, 2, "Ns " & $NsWingReadD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 3, "Ka " & $ReadKa1WingD & " " & $ReadKa2WingD & " " & $ReadKa3WingD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 4, "Kd " & $ReadKd1WingD & " " & $ReadKd2WingD & " " & $ReadKd3WingD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 5, "Ks " & $ReadKs1WingD & " " & $ReadKs2WingD & " " & $ReadKs3WingD, True)
				_FileWriteToLine($WingDingMTLfile_Path, 6, "Ke " & $ReadKe1WingD & " " & $ReadKe2WingD & " " & $ReadKe3WingD, True)
;				_FileWriteToLine($WingDingMTLfile_Path, 8, "d " & $dWingReadD, True)
;				_FileWriteToLine($WingDingMTLfile_Path, 9, 'illum ' & $ReadIllumWingD, True)
;				_FileWriteToLine($WingDingDescfile_Path, 8, '    "scale" : ' & $ReadScaleWingD & ",", True)
			Else
				MsgBox(48, "Error", "Error, either mtl or description file missing")
			EndIf
		Next
EndFunc


Func _Read_NsLetter()
	GUICtrlSetColor($NsLetRead, 0x00FF00)
	$NsLetRead1 = GUICtrlRead($NsLetRead)
	$aLetters = _FileListToArray($LabelsLetter, "Letters_*")
		For $L = 1 To $aLetters[0]
			$CapLetPath = $aLetters[$L] & "\"
			$CapLetPathsub = StringTrimRight($CapLetPath, 1)
			$CapLetPathsub = StringTrimLeft($CapLetPathsub, 8)
			If StringIsLower(StringRight($CapLetPathsub, 1)) Then
				$TestMtlPath = $LabelsLetter & $CapLetPath & "Small" & StringRight($CapLetPathsub, 1) & ".mtl"
			Elseif StringIsUpper($CapLetPathsub) Then
				$TestMtlPath = $LabelsLetter & $CapLetPath & "Cap" & $CapLetPathsub & ".mtl"
			Else
				$TestMtlPath = $LabelsLetter & $CapLetPath & $CapLetPathsub & ".mtl"
			EndIf

			If FileExists($TestMtlPath) Then
				_FileWriteToLine($TestMtlPath, 2, "Ns " & $NsLetRead1, True)
			Else
				MsgBox(0, "Error", "Error: file does not exist")
			EndIf
		Next
	GUICtrlSetColor($NsLetRead, 0xFF0000)
EndFunc


Func _Read_NsSymbol()
	GUICtrlSetColor($NsSymRead, 0x00FF00)
	$NsSymRead1 = GUICtrlRead($NsSymRead)
	$aSymbols = _FileListToArray($LabelsSymbol, "Symbols_*")
	For $s = 1 To $aSymbols[0]
		$SymbolPath = $LabelsSymbol & $aSymbols[$s] & "\"
		$testSym1 = $aSymbols[$s]
		$testSym = _StringBetween($testSym1, "_", "")
		$SymbolMtlPath = $SymbolPath & $testSym[0] & ".mtl"
		If FileExists($SymbolMtlPath) Then
			_FileWriteToLine($SymbolMtlPath, 2, "Ns " & $NsSymRead1, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($NsSymRead, 0xFF0000)
EndFunc



Func _Read_NsWing()
	GUICtrlSetColor($NsWingRead, 0x00FF00)
	$NsWingReadD = GUICtrlRead($NsWingRead)
	$aWingDings = _FileListToArray($Props, "WingDings_*")
	For $w = 1 To $aWingDings[0]
		$WingPath = $Props & $aWingDings[$w] & "\"
		$WingName = $aWingDings[$w]
		$aWingName = _StringBetween($WingName, "_", "")
		$WingDingMTLfile_Path = $WingPath & $aWingName[0] & ".mtl"
		If FileExists($WingDingMTLfile_Path) Then
			_FileWriteToLine($WingDingMTLfile_Path, 2, "Ns " & $NsWingReadD, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($NsWingRead, 0xFF0000)
EndFunc


Func _Read_KaLetter()
	GUICtrlSetColor($ReadKa1Let, 0x00FF00)
	GUICtrlSetColor($ReadKa2Let, 0x00FF00)
	GUICtrlSetColor($ReadKa3Let, 0x00FF00)
	$ReadKa1Let1 = GUICtrlRead($ReadKa1Let)
	$ReadKa2Let1 = GUICtrlRead($ReadKa2Let)
	$ReadKa3Let1 = GUICtrlRead($ReadKa3Let)
	$aLetters = _FileListToArray($LabelsLetter, "Letters_*")
	For $L = 1 To $aLetters[0]
		$CapLetPath = $aLetters[$L] & "\"
		$CapLetPathsub = StringTrimRight($CapLetPath, 1)
		$CapLetPathsub = StringTrimLeft($CapLetPathsub, 8)
		If StringIsLower(StringRight($CapLetPathsub, 1)) Then
			$TestMtlPath = $LabelsLetter & $CapLetPath & "Small" & StringRight($CapLetPathsub, 1) & ".mtl"
		Elseif StringIsUpper($CapLetPathsub) Then
			$TestMtlPath = $LabelsLetter & $CapLetPath & "Cap" & $CapLetPathsub & ".mtl"
		Else
			$TestMtlPath = $LabelsLetter & $CapLetPath & $CapLetPathsub & ".mtl"
		EndIf

		If FileExists($TestMtlPath) Then
			_FileWriteToLine($TestMtlPath, 3, "Ka " & $ReadKa1Let1 & " " & $ReadKa2Let1 & " " & $ReadKa3Let1, True)
		Else
			MsgBox(0, "Error", "Error: file does not exist")
		EndIf
	Next
	GUICtrlSetColor($ReadKa1Let, 0xFF0000)
	GUICtrlSetColor($ReadKa2Let, 0xFF0000)
	GUICtrlSetColor($ReadKa3Let, 0xFF0000)
EndFunc

Func _Read_KaSymbol()
	GUICtrlSetColor($ReadKa1Sym, 0x00FF00)
	GUICtrlSetColor($ReadKa2Sym, 0x00FF00)
	GUICtrlSetColor($ReadKa3Sym, 0x00FF00)
	$ReadKa1Sym1 = GUICtrlRead($ReadKa1Sym)
	$ReadKa2Sym1 = GUICtrlRead($ReadKa2Sym)
	$ReadKa3Sym1 = GUICtrlRead($ReadKa3Sym)
	$aSymbols = _FileListToArray($LabelsSymbol, "Symbols_*")
	For $s = 1 To $aSymbols[0]
		$SymbolPath = $LabelsSymbol & $aSymbols[$s] & "\"
		$testSym1 = $aSymbols[$s]
		$testSym = _StringBetween($testSym1, "_", "")
		$SymbolMtlPath = $SymbolPath & $testSym[0] & ".mtl"
		If FileExists($SymbolMtlPath) Then
			_FileWriteToLine($SymbolMtlPath, 3, "Ka " & $ReadKa1Sym1 & " " & $ReadKa2Sym1 & " " & $ReadKa3Sym1, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($ReadKa1Sym, 0xFF0000)
	GUICtrlSetColor($ReadKa2Sym, 0xFF0000)
	GUICtrlSetColor($ReadKa3Sym, 0xFF0000)
EndFunc

Func  _Read_KaWing()
	GUICtrlSetColor($ReadKa1Wing, 0x00FF00)
	GUICtrlSetColor($ReadKa2Wing, 0x00FF00)
	GUICtrlSetColor($ReadKa3Wing, 0x00FF00)
	$ReadKa1WingD = GUICtrlRead($ReadKa1Wing)
	$ReadKa2WingD = GUICtrlRead($ReadKa2Wing)
	$ReadKa3WingD = GUICtrlRead($ReadKa3Wing)
	$aWingDings = _FileListToArray($Props, "WingDings_*")
	For $w = 1 To $aWingDings[0]
		$WingPath = $Props & $aWingDings[$w] & "\"
		$WingName = $aWingDings[$w]
		$aWingName = _StringBetween($WingName, "_", "")
		$WingDingMTLfile_Path = $WingPath & $aWingName[0] & ".mtl"
		If FileExists($WingDingMTLfile_Path) Then
			_FileWriteToLine($WingDingMTLfile_Path, 3, "Ka " & $ReadKa1WingD & " " & $ReadKa2WingD & " " & $ReadKa3WingD, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($ReadKa1Wing, 0xFF0000)
	GUICtrlSetColor($ReadKa2Wing, 0xFF0000)
	GUICtrlSetColor($ReadKa3Wing, 0xFF0000)
EndFunc


Func _Read_KdLetter()
	GUICtrlSetColor($ReadKd1Let, 0x00FF00)
	GUICtrlSetColor($ReadKd2Let, 0x00FF00)
	GUICtrlSetColor($ReadKd3Let, 0x00FF00)
	$ReadKd1Let1 = GUICtrlRead($ReadKd1Let)
	$ReadKd2Let1 = GUICtrlRead($ReadKd2Let)
	$ReadKd3Let1 = GUICtrlRead($ReadKd3Let)
	$aLetters = _FileListToArray($LabelsLetter, "Letters_*")
	For $L = 1 To $aLetters[0]
		$CapLetPath = $aLetters[$L] & "\"
		$CapLetPathsub = StringTrimRight($CapLetPath, 1)
		$CapLetPathsub = StringTrimLeft($CapLetPathsub, 8)
		If StringIsLower(StringRight($CapLetPathsub, 1)) Then
			$TestMtlPath = $LabelsLetter & $CapLetPath & "Small" & StringRight($CapLetPathsub, 1) & ".mtl"
		Elseif StringIsUpper($CapLetPathsub) Then
			$TestMtlPath = $LabelsLetter & $CapLetPath & "Cap" & $CapLetPathsub & ".mtl"
		Else
			$TestMtlPath = $LabelsLetter & $CapLetPath & $CapLetPathsub & ".mtl"
		EndIf

		If FileExists($TestMtlPath) Then
			_FileWriteToLine($TestMtlPath, 4, "Kd " & $ReadKd1Let1 & " " & $ReadKd2Let1 & " " & $ReadKd3Let1, True)
		Else
			MsgBox(0, "Error", "Error: file does not exist")
		EndIf
	Next
	GUICtrlSetColor($ReadKd1Let, 0xFF0000)
	GUICtrlSetColor($ReadKd2Let, 0xFF0000)
	GUICtrlSetColor($ReadKd3Let, 0xFF0000)
EndFunc

Func _Read_KdSymbol()
	GUICtrlSetColor($ReadKd1Sym, 0x00FF00)
	GUICtrlSetColor($ReadKd2Sym, 0x00FF00)
	GUICtrlSetColor($ReadKd3Sym, 0x00FF00)
	$ReadKd1Sym1 = GUICtrlRead($ReadKd1Sym)
	$ReadKd2Sym1 = GUICtrlRead($ReadKd2Sym)
	$ReadKd3Sym1 = GUICtrlRead($ReadKd3Sym)
	$aSymbols = _FileListToArray($LabelsSymbol, "Symbols_*")
	For $s = 1 To $aSymbols[0]
		$SymbolPath = $LabelsSymbol & $aSymbols[$s] & "\"
		$testSym1 = $aSymbols[$s]
		$testSym = _StringBetween($testSym1, "_", "")
		$SymbolMtlPath = $SymbolPath & $testSym[0] & ".mtl"
		If FileExists($SymbolMtlPath) Then
			_FileWriteToLine($SymbolMtlPath, 4, "Kd " & $ReadKd1Sym1 & " " & $ReadKd2Sym1 & " " & $ReadKd3Sym1, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($ReadKd1Sym, 0xFF0000)
	GUICtrlSetColor($ReadKd2Sym, 0xFF0000)
	GUICtrlSetColor($ReadKd3Sym, 0xFF0000)
EndFunc

Func  _Read_KdWing()
	GUICtrlSetColor($ReadKd1Wing, 0x00FF00)
	GUICtrlSetColor($ReadKd2Wing, 0x00FF00)
	GUICtrlSetColor($ReadKd3Wing, 0x00FF00)
	$ReadKd1WingD = GUICtrlRead($ReadKd1Wing)
	$ReadKd2WingD = GUICtrlRead($ReadKd2Wing)
	$ReadKd3WingD = GUICtrlRead($ReadKd3Wing)
	$aWingDings = _FileListToArray($Props, "WingDings_*")
	For $w = 1 To $aWingDings[0]
		$WingPath = $Props & $aWingDings[$w] & "\"
		$WingName = $aWingDings[$w]
		$aWingName = _StringBetween($WingName, "_", "")
		$WingDingMTLfile_Path = $WingPath & $aWingName[0] & ".mtl"
		If FileExists($WingDingMTLfile_Path) Then
			_FileWriteToLine($WingDingMTLfile_Path, 4, "Kd " & $ReadKd1WingD & " " & $ReadKd2WingD & " " & $ReadKd3WingD, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($ReadKd1Wing, 0xFF0000)
	GUICtrlSetColor($ReadKd2Wing, 0xFF0000)
	GUICtrlSetColor($ReadKd3Wing, 0xFF0000)
EndFunc


Func _Read_KsLetter()
	GUICtrlSetColor($ReadKs1Let, 0x00FF00)
	GUICtrlSetColor($ReadKs2Let, 0x00FF00)
	GUICtrlSetColor($ReadKs3Let, 0x00FF00)
	$ReadKs1Let1 = GUICtrlRead($ReadKs1Let)
	$ReadKs2Let1 = GUICtrlRead($ReadKs2Let)
	$ReadKs3Let1 = GUICtrlRead($ReadKs3Let)
	$aLetters = _FileListToArray($LabelsLetter, "Letters_*")
	For $L = 1 To $aLetters[0]
		$CapLetPath = $aLetters[$L] & "\"
		$CapLetPathsub = StringTrimRight($CapLetPath, 1)
		$CapLetPathsub = StringTrimLeft($CapLetPathsub, 8)
		If StringIsLower(StringRight($CapLetPathsub, 1)) Then
			$TestMtlPath = $LabelsLetter & $CapLetPath & "Small" & StringRight($CapLetPathsub, 1) & ".mtl"
		Elseif StringIsUpper($CapLetPathsub) Then
			$TestMtlPath = $LabelsLetter & $CapLetPath & "Cap" & $CapLetPathsub & ".mtl"
		Else
			$TestMtlPath = $LabelsLetter & $CapLetPath & $CapLetPathsub & ".mtl"
		EndIf

		If FileExists($TestMtlPath) Then
			_FileWriteToLine($TestMtlPath, 5, "Ks " & $ReadKs1Let1 & " " & $ReadKs2Let1 & " " & $ReadKs3Let1, True)
		Else
			MsgBox(0, "Error", "Error: file does not exist")
		EndIf
	Next
	GUICtrlSetColor($ReadKs1Let, 0xFF0000)
	GUICtrlSetColor($ReadKs2Let, 0xFF0000)
	GUICtrlSetColor($ReadKs3Let, 0xFF0000)
EndFunc

Func _Read_KsSymbol()
	GUICtrlSetColor($ReadKs1Sym, 0x00FF00)
	GUICtrlSetColor($ReadKs2Sym, 0x00FF00)
	GUICtrlSetColor($ReadKs3Sym, 0x00FF00)
	$ReadKs1Sym1 = GUICtrlRead($ReadKs1Sym)
	$ReadKs2Sym1 = GUICtrlRead($ReadKs2Sym)
	$ReadKs3Sym1 = GUICtrlRead($ReadKs3Sym)
	$aSymbols = _FileListToArray($LabelsSymbol, "Symbols_*")
	For $s = 1 To $aSymbols[0]
		$SymbolPath = $LabelsSymbol & $aSymbols[$s] & "\"
		$testSym1 = $aSymbols[$s]
		$testSym = _StringBetween($testSym1, "_", "")
		$SymbolMtlPath = $SymbolPath & $testSym[0] & ".mtl"
		If FileExists($SymbolMtlPath) Then
			_FileWriteToLine($SymbolMtlPath, 5, "Ks " & $ReadKs1Sym1 & " " & $ReadKs2Sym1 & " " & $ReadKs3Sym1, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($ReadKs1Sym, 0xFF0000)
	GUICtrlSetColor($ReadKs2Sym, 0xFF0000)
	GUICtrlSetColor($ReadKs3Sym, 0xFF0000)
EndFunc

Func  _Read_KsWing()
	GUICtrlSetColor($ReadKs1Wing, 0x00FF00)
	GUICtrlSetColor($ReadKs2Wing, 0x00FF00)
	GUICtrlSetColor($ReadKs3Wing, 0x00FF00)
	$ReadKs1WingD = GUICtrlRead($ReadKs1Wing)
	$ReadKs2WingD = GUICtrlRead($ReadKs2Wing)
	$ReadKs3WingD = GUICtrlRead($ReadKs3Wing)
	$aWingDings = _FileListToArray($Props, "WingDings_*")
	For $w = 1 To $aWingDings[0]
		$WingPath = $Props & $aWingDings[$w] & "\"
		$WingName = $aWingDings[$w]
		$aWingName = _StringBetween($WingName, "_", "")
		$WingDingMTLfile_Path = $WingPath & $aWingName[0] & ".mtl"
		If FileExists($WingDingMTLfile_Path) Then
			_FileWriteToLine($WingDingMTLfile_Path, 5, "Ks " & $ReadKs1WingD & " " & $ReadKs2WingD & " " & $ReadKs3WingD, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($ReadKs1Wing, 0xFF0000)
	GUICtrlSetColor($ReadKs2Wing, 0xFF0000)
	GUICtrlSetColor($ReadKs3Wing, 0xFF0000)
EndFunc

Func _Read_KeLetter()
	GUICtrlSetColor($ReadKe1Let, 0x00FF00)
	GUICtrlSetColor($ReadKe2Let, 0x00FF00)
	GUICtrlSetColor($ReadKe3Let, 0x00FF00)
	$ReadKe1Let1 = GUICtrlRead($ReadKe1Let)
	$ReadKe2Let1 = GUICtrlRead($ReadKe2Let)
	$ReadKe3Let1 = GUICtrlRead($ReadKe3Let)
	$aLetters = _FileListToArray($LabelsLetter, "Letters_*")
	For $L = 1 To $aLetters[0]
		$CapLetPath = $aLetters[$L] & "\"
		$CapLetPathsub = StringTrimRight($CapLetPath, 1)
		$CapLetPathsub = StringTrimLeft($CapLetPathsub, 8)
		If StringIsLower(StringRight($CapLetPathsub, 1)) Then
			$TestMtlPath = $LabelsLetter & $CapLetPath & "Small" & StringRight($CapLetPathsub, 1) & ".mtl"
		Elseif StringIsUpper($CapLetPathsub) Then
			$TestMtlPath = $LabelsLetter & $CapLetPath & "Cap" & $CapLetPathsub & ".mtl"
		Else
			$TestMtlPath = $LabelsLetter & $CapLetPath & $CapLetPathsub & ".mtl"
		EndIf
		If FileExists($TestMtlPath) Then
			_FileWriteToLine($TestMtlPath, 6, "Ke " & $ReadKe1Let1 & " " & $ReadKe2Let1 & " " & $ReadKe3Let1, True)
		Else
			MsgBox(0, "Error", "Error: file does not exist")
		EndIf
	Next
	GUICtrlSetColor($ReadKe1Let, 0xFF0000)
	GUICtrlSetColor($ReadKe2Let, 0xFF0000)
	GUICtrlSetColor($ReadKe3Let, 0xFF0000)
EndFunc

Func _Read_KeSymbol()
	GUICtrlSetColor($ReadKe1Sym, 0x00FF00)
	GUICtrlSetColor($ReadKe2Sym, 0x00FF00)
	GUICtrlSetColor($ReadKe3Sym, 0x00FF00)
	$ReadKe1Sym1 = GUICtrlRead($ReadKe1Sym)
	$ReadKe2Sym1 = GUICtrlRead($ReadKe2Sym)
	$ReadKe3Sym1 = GUICtrlRead($ReadKe3Sym)
	$aSymbols = _FileListToArray($LabelsSymbol, "Symbols_*")
	For $s = 1 To $aSymbols[0]
		$SymbolPath = $LabelsSymbol & $aSymbols[$s] & "\"
		$testSym1 = $aSymbols[$s]
		$testSym = _StringBetween($testSym1, "_", "")
		$SymbolMtlPath = $SymbolPath & $testSym[0] & ".mtl"
		If FileExists($SymbolMtlPath) Then
			_FileWriteToLine($SymbolMtlPath, 6, "Ke " & $ReadKe1Sym1 & " " & $ReadKe2Sym1 & " " & $ReadKe3Sym1, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($ReadKe1Sym, 0xFF0000)
	GUICtrlSetColor($ReadKe2Sym, 0xFF0000)
	GUICtrlSetColor($ReadKe3Sym, 0xFF0000)
EndFunc

Func  _Read_KeWing()
	GUICtrlSetColor($ReadKe1Wing, 0x00FF00)
	GUICtrlSetColor($ReadKe2Wing, 0x00FF00)
	GUICtrlSetColor($ReadKe3Wing, 0x00FF00)
	$ReadKe1WingD = GUICtrlRead($ReadKe1Wing)
	$ReadKe2WingD = GUICtrlRead($ReadKe2Wing)
	$ReadKe3WingD = GUICtrlRead($ReadKe3Wing)
	$aWingDings = _FileListToArray($Props, "WingDings_*")
	For $w = 1 To $aWingDings[0]
		$WingPath = $Props & $aWingDings[$w] & "\"
		$WingName = $aWingDings[$w]
		$aWingName = _StringBetween($WingName, "_", "")
		$WingDingMTLfile_Path = $WingPath & $aWingName[0] & ".mtl"
		If FileExists($WingDingMTLfile_Path) Then
			_FileWriteToLine($WingDingMTLfile_Path, 6, "Ke " & $ReadKe1WingD & " " & $ReadKe2WingD & " " & $ReadKe3WingD, True)
		Else
			MsgBox(48, "Error", "Error, either mtl or description file missing")
		EndIf
	Next
	GUICtrlSetColor($ReadKe1Wing, 0xFF0000)
	GUICtrlSetColor($ReadKe2Wing, 0xFF0000)
	GUICtrlSetColor($ReadKe3Wing, 0xFF0000)
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
			If $FontType = "Letter" Then
				DirRemove($labels & "Letters", 1)
				Sleep(200)  ; to allow user's hd to catch up to operations
			ElseIf $FontType = "Symbol" Then
				DirRemove($labels & "Symbols", 1)
				Sleep(200)  ; to allow user's hd to catch up to operations
			ElseIf $FontType = "WingDing" Then
				$aWingDel = _FileListToArray($Props, "WingDings_*")
				If Not @error Then
					For $d = 1 to $aWingDel[0]
						DirRemove($Props & $aWingDel[$d], 1)
					Next
				EndIf
			EndIf
			For $a = 1 To $aFonts[0]
				$aTemp = StringSplit($aFonts[$a], "\")
				If $FontType = "WingDing" Then
					DirCopy($aFonts[$a], $Props & $aTemp[$aTemp[0]], $FC_OVERWRITE)
				ElseIf $FontType = "Symbol" Then
					DirCopy($aFonts[$a], $LabelsSymbol & $aTemp[$aTemp[0]], $FC_OVERWRITE)
				Else
					DirCopy($aFonts[$a], $LabelsLetter & $aTemp[$aTemp[0]], $FC_OVERWRITE)
				EndIf
			Next
			If $FontType = "Letter" Then
				$FontStateLetter = IniRead($FontTest, "Setting", "Font", "")
				GUICtrlSetData($CurrentFont, $FontStateLetter)
			ElseIf $FontType = "Symbol" Then
				$FontStateSymbol = IniRead($FontTestSymbol, "Setting", "Font", "")
				GUICtrlSetData($CurrentSymbolFont, $FontStateSymbol)
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

Func _Letter_Texture_Swap1a()
	$NewDDSfile = GUICtrlRead($CurrentTexture1)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Caps"
	$Texture = "diffuse"
	$dds = "d.dds"
	$dds_DIR = $LetterDDSfile1
	$kValue = "Kd"
	$LineNbr = 11
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentTexture1, "map_Kd " & $NewDDSfile)
EndFunc

Func _Letter_Texture_Swap1b()
	$NewDDSfile = GUICtrlRead($CurrentTexture2)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Caps"
	$Texture = "specular"
	$dds = "s.dds"
	$dds_DIR = $LetterDDSfile1
	$kValue = "Ks"
	$LineNbr = 12
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentTexture2, "map_Ks " & $NewDDSfile)
EndFunc

Func _Letter_Texture_Swap2a()
	$NewDDSfile = GUICtrlRead($CurrentTexture3)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Lower"
	$Texture = "diffuse"
	$dds = "d.dds"
	$dds_DIR = $LetterDDSfile2
	$kValue = "Kd"
	$LineNbr = 11
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentTexture3, "map_Kd " & $NewDDSfile)
EndFunc

Func _Letter_Texture_Swap2b()
	$NewDDSfile = GUICtrlRead($CurrentTexture4)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Lower"
	$Texture = "specular"
	$dds = "s.dds"
	$dds_DIR = $LetterDDSfile2
	$kValue = "Ks"
	$LineNbr = 12
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentTexture4, "map_Ks " & $NewDDSfile)
EndFunc

Func _Symbol_Texture_Swap1a()
	$NewDDSfile = GUICtrlRead($CurrentSymTexture1)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Most"
	$Texture = "diffuse"
	$dds = "d.dds"
	$dds_DIR = $SymbolDDSfile1
	$kValue = "Kd"
	$LineNbr = 11
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentSymTexture1, "map_Kd " & $NewDDSfile)
EndFunc

Func _Symbol_Texture_Swap1b()
	$NewDDSfile = GUICtrlRead($CurrentSymTexture2)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Most"
	$Texture = "specular"
	$dds = "s.dds"
	$dds_DIR = $SymbolDDSfile1
	$kValue = "Ks"
	$LineNbr = 12
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentSymTexture2, "map_Ks " & $NewDDSfile)
EndFunc

Func _Symbol_Texture_Swap2a()
	$NewDDSfile = GUICtrlRead($CurrentSymTexture3)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Rest"
	$Texture = "diffuse"
	$dds = "d.dds"
	$dds_DIR = $SymbolDDSfile2
	$kValue = "Kd"
	$LineNbr = 11
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentSymTexture3, "map_Kd " & $NewDDSfile)
EndFunc

Func _Symbol_Texture_Swap2b()
	$NewDDSfile = GUICtrlRead($CurrentSymTexture4)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Rest"
	$Texture = "specular"
	$dds = "s.dds"
	$dds_DIR = $SymbolDDSfile2
	$kValue = "Ks"
	$LineNbr = 12
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentSymTexture4, "map_Ks " & $NewDDSfile)
EndFunc

Func _Wing_Texture_Swap1a()
	$NewDDSfile = GUICtrlRead($CurrentWingTexture1)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Wing"
	$Texture = "diffuse"
	$dds = "d.dds"
	$dds_DIR = $WingDDSfile1
	$kValue = "Kd"
	$LineNbr = 11
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentWingTexture1, "map_Kd " & $NewDDSfile)
EndFunc

Func _Wing_Texture_Swap1b()
	$NewDDSfile = GUICtrlRead($CurrentWingTexture2)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Wing"
	$Texture = "specular"
	$dds = "s.dds"
	$dds_DIR = $WingDDSfile1
	$kValue = "Ks"
	$LineNbr = 12
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentWingTexture2, "map_Ks " & $NewDDSfile)
EndFunc

Func _Wing_Texture_Swap2a()
	$NewDDSfile = GUICtrlRead($CurrentWingTexture3)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Face"
	$Texture = "diffuse"
	$dds = "d.dds"
	$dds_DIR = $WingDDSfile2
	$kValue = "Kd"
	$LineNbr = 11
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentWingTexture3, "map_Kd " & $NewDDSfile)
EndFunc

Func _Wing_Texture_Swap2b()
	$NewDDSfile = GUICtrlRead($CurrentWingTexture4)
	$NewDDSfile = StringTrimLeft($NewDDSfile, 7)
	$SwapType = "Face"
	$Texture = "specular"
	$dds = "s.dds"
	$dds_DIR = $WingDDSfile2
	$kValue = "Ks"
	$LineNbr = 12
	_Letter_Texture_Swap()
	GUICtrlSetData($CurrentWingTexture4, "map_Ks " & $NewDDSfile)
EndFunc

Func _Letter_Texture_Swap()
	$ddsFileSelect = FileOpenDialog("Select the " & $Texture & " texture file that you want to use", @ScriptDir & "\", "Texture  file (*" & $dds & ")", $FD_FILEMUSTEXIST)
	If $ddsFileSelect <> "" Then
		If StringRight($ddsFileSelect, 5) <> $dds Then
			MsgBox(48, "Wrong Type of Texture file", "Non-" & $Texture & " file selected, please select a " & $Texture & " texture file." & @CRLF & "Note: the file needs to end in '" & $dds & "'")
			Return
		Else
			$aDDSfileSelect = StringSplit($ddsFileSelect, "\")
			$File = $aDDSfileSelect[0]
			$NewDDSfile = $aDDSfileSelect[$File]
;		MsgBox(0, "", "NewDDSFile: " & $NewDDSfile)
;		MsgBox(0, "", "dds_DIR: " & $dds_DIR)
			If FileExists($dds_DIR & $NewDDSfile) Then
;				MsgBox(0, "", "File Exists: " & $dds_DIR & $NewDDSfile)
				$Overwrite = MsgBox(36, "Overwrite file?", "There is a " & $Texture & " Texture file with the same name already in place, do you want to replace it?")
				If $Overwrite = 6 Then
					FileCopy($ddsFileSelect, $dds_DIR & $NewDDSfile, 1)
				EndIf
			Else
;				MsgBox(0, "", "About to copy file")
				FileCopy($ddsFileSelect, $dds_DIR & $NewDDSfile)
			EndIf

			$LetterLineWrite1a = "map_" & $kValue & " " & $NewDDSfile

			If $SwapType = "Caps" Then
				$LetterLineWrite1b = "map_" & $kValue & " ../Letters_A/" & $NewDDSfile
				$aLetterList = _FileListToArray($LabelsLetter, "Letters_*")
			ElseIf $SwapType = "Lower" Then
				$LetterLineWrite1b = "map_" & $kValue & " ../Letters_Aa/" & $NewDDSfile
				$aLetterList = _FileListToArray($LabelsLetter, "Letters_*")
			ElseIf $SwapType = "Most" Then
				$LetterLineWrite1b = "map_" & $kValue & " ../Symbols_And/" & $NewDDSfile
				$aLetterList = _FileListToArray($LabelsSymbol, "Symbols_*")
			ElseIf $SwapType = "Rest" Then
				$LetterLineWrite1b = "map_" & $kValue & " ../Symbols_Backtick/" & $NewDDSfile
				$aLetterList = _FileListToArray($LabelsSymbol, "Symbols_*")
			ElseIf $SwapType = "Wing" Then
				$LetterLineWrite1b = "map_" & $kValue & " ../WingDings_Arrow/" & $NewDDSfile
				$aLetterList = _FileListToArray($Props, "WingDings_*")
			ElseIf $SwapType = "Face" Then
				$LetterLineWrite1b = "map_" & $kValue & " ../WingDings_Frown/" & $NewDDSfile
				$aLetterList = _FileListToArray($Props, "WingDings_*")
			EndIf

			For $m = 1 To $aLetterList[0]
				$MTLdir = $aLetterList[$m]
				If $SwapType = "Caps" Or $SwapType = "Lower" Then
					$dirTEST = StringRight($MTLdir, 1)
					If $SwapType = "Caps" Then
						If StringIsDigit($dirTEST) Then
							$tempMTL = $LetterFiles & $dirTEST & "\" & $dirTEST & ".mtl"
							_FileWriteToLine($tempMTL, $LineNbr, $LetterLineWrite1b, True, True)
						ElseIf StringIsUpper($dirTEST) Then
							If $dirTEST = "A" Then
								_FileWriteToLine($StartMTLFileLetter, $LineNbr, $LetterLineWrite1a, True, True)
							Else
								$tempMTL = $LetterFiles & $dirTEST & "\Cap" & $dirTEST & ".mtl"
								_FileWriteToLine($tempMTL, $LineNbr, $LetterLineWrite1b, True, True)
							EndIf
						EndIf
					ElseIf $SwapType = "Lower" Then
						If StringIsLower($dirTEST) Then
							If $dirTEST = "a" Then
								_FileWriteToLine($StartMTLFileLetter2, $LineNbr, $LetterLineWrite1a, True, True)
							Else
								$tempMTL = $LetterFiles & $dirTEST & $dirTEST & "\Small" & $dirTEST &  ".mtl"
								_FileWriteToLine($tempMTL, $LineNbr, $LetterLineWrite1b, True, True)
							EndIf
						EndIf
					EndIf
				ElseIf $SwapType = "Most" Then
					$tempMTLfile = StringTrimLeft($MTLdir, 8)
					If $tempMTLfile = "And" Then
						_FileWriteToLine($StartMTLFileSymbol, $LineNbr, $LetterLineWrite1a, True, True)
					ElseIf $tempMTLfile <> "Backtick" And $tempMTLfile <> "Caret" And $tempMTLfile <> "Colon" And $tempMTLfile <> "Comma" And $tempMTLfile <> "Dollar" And $tempMTLfile <> "dQuote" And $tempMTLfile <> "Greater" And $tempMTLfile <> "Lesser" And $tempMTLfile <> "sColon" And $tempMTLfile <> "sQuote" Then
						$tempMTL = $SymbolFiles & $tempMTLfile & "\" & $tempMTLfile & ".mtl"
						_FileWriteToLine($tempMTL, $LineNbr, $LetterLineWrite1b, True, True)
					EndIf
				ElseIf $SwapType = "Rest" Then
					$tempMTLfile = StringTrimLeft($MTLdir, 8)
					If $tempMTLfile = "Backtick" Then
						_FileWriteToLine($StartMTLFileSymbol2, $LineNbr, $LetterLineWrite1a, True, True)
					ElseIf $tempMTLfile = "Caret" Or $tempMTLfile = "Colon" Or $tempMTLfile = "Comma" Or $tempMTLfile = "Dollar" Or $tempMTLfile = "dQuote" Or $tempMTLfile = "Greater" Or $tempMTLfile = "Lesser" Or $tempMTLfile = "sColon" Or $tempMTLfile = "sQuote" Then
						$tempMTL = $SymbolFiles & $tempMTLfile & "\" & $tempMTLfile & ".mtl"
						_FileWriteToLine($tempMTL, $LineNbr, $LetterLineWrite1b, True, True)
					EndIf
				ElseIf $SwapType = "Wing" Then
					$tempMTLfile = StringTrimLeft($MTLdir, 10)
					If $tempMTLfile = "Arrow" Then
						_FileWriteToLine($StartMTLFileWingDings, $LineNbr, $LetterLineWrite1a, True, True)
					ElseIf $tempMTLfile <> "Frown" And $tempMTLfile <> "Smiley" Then
						$tempMTL = $WingDingFiles & $tempMTLfile & "\" & $tempMTLfile & ".mtl"
						_FileWriteToLine($tempMTL, $LineNbr, $LetterLineWrite1b, True, True)
					EndIf
				ElseIf $SwapType = "Face" Then
					$tempMTLfile = StringTrimLeft($MTLdir, 10)
					If $tempMTLfile = "Frown" Then
						_FileWriteToLine($StartMTLFileWingDings2, $LineNbr, $LetterLineWrite1a, True, True)
					ElseIf $tempMTLfile = "Smiley" Then
						$tempMTL = $WingDingFiles & $tempMTLfile & "\" & $tempMTLfile & ".mtl"
						_FileWriteToLine($tempMTL, $LineNbr, $LetterLineWrite1b, True, True)
					EndIf
				EndIf
			Next
			MsgBox(0, "", "Lines written", 1)
		EndIf
	EndIf
EndFunc
















Func _Close()
	GUIDelete()
	Exit
EndFunc
