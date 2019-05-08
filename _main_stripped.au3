#RequireAdmin
#pragma compile(UPX, False)
Global Const $BS_DEFPUSHBUTTON = 0x0001
Global Const $BS_LEFT = 0x0100
Global Const $BS_PUSHLIKE = 0x1000
Global Const $BS_FLAT = 0x8000
Global Const $GUI_SS_DEFAULT_CHECKBOX = 0
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $SS_CENTERIMAGE = 0x0200
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_POPUP = 0x80000000
Global Const $GUI_SS_DEFAULT_GUI = BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
Global Const $MEM_COMMIT = 0x00001000
Global Const $MEM_RESERVE = 0x00002000
Global Const $PAGE_READWRITE = 0x00000004
Global Const $MEM_RELEASE = 0x00008000
Global Const $PROCESS_VM_OPERATION = 0x00000008
Global Const $PROCESS_VM_READ = 0x00000010
Global Const $PROCESS_VM_WRITE = 0x00000020
Global Const $SE_PRIVILEGE_ENABLED = 0x00000002
Global Enum $SECURITYANONYMOUS = 0, $SECURITYIDENTIFICATION, $SECURITYIMPERSONATION, $SECURITYDELEGATION
Global Const $TOKEN_QUERY = 0x00000008
Global Const $TOKEN_ADJUST_PRIVILEGES = 0x00000020
Func _WinAPI_GetLastError(Const $_iCurrentError = @error, Const $_iCurrentExtended = @extended)
Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($_iCurrentError, $_iCurrentExtended, $aResult[0])
EndFunc
Func _Security__AdjustTokenPrivileges($hToken, $bDisableAll, $tNewState, $iBufferLen, $tPrevState = 0, $pRequired = 0)
Local $aCall = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $bDisableAll, "struct*", $tNewState, "dword", $iBufferLen, "struct*", $tPrevState, "struct*", $pRequired)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__ImpersonateSelf($iLevel = $SECURITYIMPERSONATION)
Local $aCall = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__IsValidSid($pSID)
Local $aCall = DllCall("advapi32.dll", "bool", "IsValidSid", "struct*", $pSID)
If @error Then Return SetError(@error, @extended, False)
Return Not($aCall[0] = 0)
EndFunc
Func _Security__LookupAccountName($sAccount, $sSystem = "")
Local $tData = DllStructCreate("byte SID[256]")
Local $aCall = DllCall("advapi32.dll", "bool", "LookupAccountNameW", "wstr", $sSystem, "wstr", $sAccount, "struct*", $tData, "dword*", DllStructGetSize($tData), "wstr", "", "dword*", DllStructGetSize($tData), "int*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Local $aAcct[3]
$aAcct[0] = _Security__SidToStringSid(DllStructGetPtr($tData, "SID"))
$aAcct[1] = $aCall[5]
$aAcct[2] = $aCall[7]
Return $aAcct
EndFunc
Func _Security__LookupPrivilegeValue($sSystem, $sName)
Local $aCall = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[3]
EndFunc
Func _Security__OpenThreadToken($iAccess, $hThread = 0, $bOpenAsSelf = False)
If $hThread = 0 Then
Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
If @error Then Return SetError(@error + 10, @extended, 0)
$hThread = $aResult[0]
EndIf
Local $aCall = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread, "dword", $iAccess, "bool", $bOpenAsSelf, "handle*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, 0)
Return $aCall[4]
EndFunc
Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $bOpenAsSelf = False)
Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then
Local Const $ERROR_NO_TOKEN = 1008
If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(20, _WinAPI_GetLastError(), 0)
If Not _Security__ImpersonateSelf() Then Return SetError(@error + 10, _WinAPI_GetLastError(), 0)
$hToken = _Security__OpenThreadToken($iAccess, $hThread, $bOpenAsSelf)
If $hToken = 0 Then Return SetError(@error, _WinAPI_GetLastError(), 0)
EndIf
Return $hToken
EndFunc
Func _Security__SetPrivilege($hToken, $sPrivilege, $bEnable)
Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
If $iLUID = 0 Then Return SetError(@error + 10, @extended, False)
Local Const $tagTOKEN_PRIVILEGES = "dword Count;align 4;int64 LUID;dword Attributes"
Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iCurrState = DllStructGetSize($tCurrState)
Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $iPrevState = DllStructGetSize($tPrevState)
Local $tRequired = DllStructCreate("int Data")
DllStructSetData($tCurrState, "Count", 1)
DllStructSetData($tCurrState, "LUID", $iLUID)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tCurrState, $iCurrState, $tPrevState, $tRequired) Then Return SetError(2, @error, False)
DllStructSetData($tPrevState, "Count", 1)
DllStructSetData($tPrevState, "LUID", $iLUID)
Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
If $bEnable Then
$iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
Else
$iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
EndIf
DllStructSetData($tPrevState, "Attributes", $iAttributes)
If Not _Security__AdjustTokenPrivileges($hToken, False, $tPrevState, $iPrevState, $tCurrState, $tRequired) Then Return SetError(3, @error, False)
Return True
EndFunc
Func _Security__SidToStringSid($pSID)
If Not _Security__IsValidSid($pSID) Then Return SetError(@error + 10, 0, "")
Local $aCall = DllCall("advapi32.dll", "bool", "ConvertSidToStringSidW", "struct*", $pSID, "ptr*", 0)
If @error Or Not $aCall[0] Then Return SetError(@error, @extended, "")
Local $pStringSid = $aCall[2]
Local $aLen = DllCall("kernel32.dll", "int", "lstrlenW", "struct*", $pStringSid)
Local $sSID = DllStructGetData(DllStructCreate("wchar Text[" & $aLen[0] + 1 & "]", $pStringSid), "Text")
DllCall("kernel32.dll", "handle", "LocalFree", "handle", $pStringSid)
Return $sSID
EndFunc
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" &((@OSVersion = "WIN_XP") ? "" : ";" & $tagRECT & ";uint uChevronState")
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"
Func _MemFree(ByRef $tMemMap)
Local $pMemory = DllStructGetData($tMemMap, "Mem")
Local $hProcess = DllStructGetData($tMemMap, "hProc")
Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
If @error Then Return SetError(@error, @extended, False)
Return $bResult
EndFunc
Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
If @error Then Return SetError(@error + 10, @extended, 0)
Local $iProcessID = $aResult[2]
If $iProcessID = 0 Then Return SetError(1, 0, 0)
Local $iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
Local $iAlloc = BitOR($MEM_RESERVE, $MEM_COMMIT)
Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, $PAGE_READWRITE)
If $pMemory = 0 Then Return SetError(2, 0, 0)
$tMemMap = DllStructCreate($tagMEMMAP)
DllStructSetData($tMemMap, "hProc", $hProcess)
DllStructSetData($tMemMap, "Size", $iSize)
DllStructSetData($tMemMap, "Mem", $pMemory)
Return $pMemory
EndFunc
Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "struct*")
If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), "ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func __Mem_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return $aResult[0]
If Not $bDebugPriv Then Return SetError(100, 0, 0)
Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
If @error Then Return SetError(@error + 10, @extended, 0)
_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
Local $iError = @error
Local $iExtended = @extended
Local $iRet = 0
If Not @error Then
$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
$iError = @error
$iExtended = @extended
If $aResult[0] Then $iRet = $aResult[0]
_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
If @error Then
$iError = @error + 20
$iExtended = @extended
EndIf
Else
$iError = @error + 30
EndIf
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
Return SetError($iError, $iExtended, $iRet)
EndFunc
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
If @error Then Return SetError(@error, @extended, "")
If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
Return $aResult
EndFunc
Global Const $__STATUSBARCONSTANT_WM_USER = 0X400
Global Const $SB_GETUNICODEFORMAT = 0x2000 + 6
Global Const $SB_ISSIMPLE =($__STATUSBARCONSTANT_WM_USER + 14)
Global Const $SB_SETPARTS =($__STATUSBARCONSTANT_WM_USER + 4)
Global Const $SB_SETTEXTA =($__STATUSBARCONSTANT_WM_USER + 1)
Global Const $SB_SETTEXTW =($__STATUSBARCONSTANT_WM_USER + 11)
Global Const $SB_SETTEXT = $SB_SETTEXTA
Global Const $SB_SIMPLEID = 0xff
Global Const $UBOUND_COLUMNS = 2
Global Const $_UDF_GlobalIDs_OFFSET = 2
Global Const $_UDF_GlobalID_MAX_WIN = 16
Global Const $_UDF_STARTID = 10000
Global Const $_UDF_GlobalID_MAX_IDS = 55535
Global Const $__UDFGUICONSTANT_WS_VISIBLE = 0x10000000
Global Const $__UDFGUICONSTANT_WS_CHILD = 0x40000000
Global $__g_aUDF_GlobalIDs_Used[$_UDF_GlobalID_MAX_WIN][$_UDF_GlobalID_MAX_IDS + $_UDF_GlobalIDs_OFFSET + 1]
Func __UDF_GetNextGlobalID($hWnd)
Local $nCtrlID, $iUsedIndex = -1, $bAllUsed = True
If Not WinExists($hWnd) Then Return SetError(-1, -1, 0)
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] <> 0 Then
If Not WinExists($__g_aUDF_GlobalIDs_Used[$iIndex][0]) Then
For $x = 0 To UBound($__g_aUDF_GlobalIDs_Used, $UBOUND_COLUMNS) - 1
$__g_aUDF_GlobalIDs_Used[$iIndex][$x] = 0
Next
$__g_aUDF_GlobalIDs_Used[$iIndex][1] = $_UDF_STARTID
$bAllUsed = False
EndIf
EndIf
Next
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] = $hWnd Then
$iUsedIndex = $iIndex
ExitLoop
EndIf
Next
If $iUsedIndex = -1 Then
For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
If $__g_aUDF_GlobalIDs_Used[$iIndex][0] = 0 Then
$__g_aUDF_GlobalIDs_Used[$iIndex][0] = $hWnd
$__g_aUDF_GlobalIDs_Used[$iIndex][1] = $_UDF_STARTID
$bAllUsed = False
$iUsedIndex = $iIndex
ExitLoop
EndIf
Next
EndIf
If $iUsedIndex = -1 And $bAllUsed Then Return SetError(16, 0, 0)
If $__g_aUDF_GlobalIDs_Used[$iUsedIndex][1] = $_UDF_STARTID + $_UDF_GlobalID_MAX_IDS Then
For $iIDIndex = $_UDF_GlobalIDs_OFFSET To UBound($__g_aUDF_GlobalIDs_Used, $UBOUND_COLUMNS) - 1
If $__g_aUDF_GlobalIDs_Used[$iUsedIndex][$iIDIndex] = 0 Then
$nCtrlID =($iIDIndex - $_UDF_GlobalIDs_OFFSET) + 10000
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][$iIDIndex] = $nCtrlID
Return $nCtrlID
EndIf
Next
Return SetError(-1, $_UDF_GlobalID_MAX_IDS, 0)
EndIf
$nCtrlID = $__g_aUDF_GlobalIDs_Used[$iUsedIndex][1]
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][1] += 1
$__g_aUDF_GlobalIDs_Used[$iUsedIndex][($nCtrlID - 10000) + $_UDF_GlobalIDs_OFFSET] = $nCtrlID
Return $nCtrlID
EndFunc
Global Const $tagOSVERSIONINFO = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $__WINVER = __WINVER()
Func _WinAPI_GetModuleHandle($sModuleName)
Local $sModuleNameType = "wstr"
If $sModuleName = "" Then
$sModuleName = 0
$sModuleNameType = "ptr"
EndIf
Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func __WINVER()
Local $tOSVI = DllStructCreate($tagOSVERSIONINFO)
DllStructSetData($tOSVI, 1, DllStructGetSize($tOSVI))
Local $aRet = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $tOSVI)
If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($tOSVI, 2), -8), DllStructGetData($tOSVI, 3))
EndFunc
Global $__g_aInProcess_WinAPI[64][2] = [[0, 0]]
Func _WinAPI_CreateWindowEx($iExStyle, $sClass, $sName, $iStyle, $iX, $iY, $iWidth, $iHeight, $hParent, $hMenu = 0, $hInstance = 0, $pParam = 0)
If $hInstance = 0 Then $hInstance = _WinAPI_GetModuleHandle("")
Local $aResult = DllCall("user32.dll", "hwnd", "CreateWindowExW", "dword", $iExStyle, "wstr", $sClass, "wstr", $sName, "dword", $iStyle, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight, "hwnd", $hParent, "handle", $hMenu, "handle", $hInstance, "struct*", $pParam)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetWindowThreadProcessId($hWnd, ByRef $iPID)
Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
If @error Then Return SetError(@error, @extended, 0)
$iPID = $aResult[2]
Return $aResult[0]
EndFunc
Func _WinAPI_InProcess($hWnd, ByRef $hLastWnd)
If $hWnd = $hLastWnd Then Return True
For $iI = $__g_aInProcess_WinAPI[0][0] To 1 Step -1
If $hWnd = $__g_aInProcess_WinAPI[$iI][0] Then
If $__g_aInProcess_WinAPI[$iI][1] Then
$hLastWnd = $hWnd
Return True
Else
Return False
EndIf
EndIf
Next
Local $iPID
_WinAPI_GetWindowThreadProcessId($hWnd, $iPID)
Local $iCount = $__g_aInProcess_WinAPI[0][0] + 1
If $iCount >= 64 Then $iCount = 1
$__g_aInProcess_WinAPI[0][0] = $iCount
$__g_aInProcess_WinAPI[$iCount][0] = $hWnd
$__g_aInProcess_WinAPI[$iCount][1] =($iPID = @AutoItPID)
Return $__g_aInProcess_WinAPI[$iCount][1]
EndFunc
Global $__g_hSBLastWnd
Global Const $__STATUSBARCONSTANT_ClassName = "msctls_statusbar32"
Global Const $__STATUSBARCONSTANT_WM_SIZE = 0x05
Func _GUICtrlStatusBar_Create($hWnd, $vPartEdge = -1, $vPartText = "", $iStyles = -1, $iExStyles = 0x00000000)
If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)
Local $iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE)
If $iStyles = -1 Then $iStyles = 0x00000000
If $iExStyles = -1 Then $iExStyles = 0x00000000
Local $aPartWidth[1], $aPartText[1]
If @NumParams > 1 Then
If IsArray($vPartEdge) Then
$aPartWidth = $vPartEdge
Else
$aPartWidth[0] = $vPartEdge
EndIf
If @NumParams = 2 Then
ReDim $aPartText[UBound($aPartWidth)]
Else
If IsArray($vPartText) Then
$aPartText = $vPartText
Else
$aPartText[0] = $vPartText
EndIf
If UBound($aPartWidth) <> UBound($aPartText) Then
Local $iLast
If UBound($aPartWidth) > UBound($aPartText) Then
$iLast = UBound($aPartText)
ReDim $aPartText[UBound($aPartWidth)]
Else
$iLast = UBound($aPartWidth)
ReDim $aPartWidth[UBound($aPartText)]
For $x = $iLast To UBound($aPartWidth) - 1
$aPartWidth[$x] = $aPartWidth[$x - 1] + 75
Next
$aPartWidth[UBound($aPartText) - 1] = -1
EndIf
EndIf
EndIf
If Not IsHWnd($hWnd) Then $hWnd = HWnd($hWnd)
If @NumParams > 3 Then $iStyle = BitOR($iStyle, $iStyles)
EndIf
Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
If @error Then Return SetError(@error, @extended, 0)
Local $hWndSBar = _WinAPI_CreateWindowEx($iExStyles, $__STATUSBARCONSTANT_ClassName, "", $iStyle, 0, 0, 0, 0, $hWnd, $nCtrlID)
If @error Then Return SetError(@error, @extended, 0)
If @NumParams > 1 Then
_GUICtrlStatusBar_SetParts($hWndSBar, UBound($aPartWidth), $aPartWidth)
For $x = 0 To UBound($aPartText) - 1
_GUICtrlStatusBar_SetText($hWndSBar, $aPartText[$x], $x)
Next
EndIf
Return $hWndSBar
EndFunc
Func _GUICtrlStatusBar_GetUnicodeFormat($hWnd)
Return _SendMessage($hWnd, $SB_GETUNICODEFORMAT) <> 0
EndFunc
Func _GUICtrlStatusBar_IsSimple($hWnd)
Return _SendMessage($hWnd, $SB_ISSIMPLE) <> 0
EndFunc
Func _GUICtrlStatusBar_Resize($hWnd)
_SendMessage($hWnd, $__STATUSBARCONSTANT_WM_SIZE)
EndFunc
Func _GUICtrlStatusBar_SetParts($hWnd, $vPartEdge = -1, $vPartWidth = 25)
If IsArray($vPartEdge) And IsArray($vPartWidth) Then Return False
Local $tParts, $iParts
If IsArray($vPartEdge) Then
$vPartEdge[UBound($vPartEdge) - 1] = -1
$iParts = UBound($vPartEdge)
$tParts = DllStructCreate("int[" & $iParts & "]")
For $x = 0 To $iParts - 2
DllStructSetData($tParts, 1, $vPartEdge[$x], $x + 1)
Next
DllStructSetData($tParts, 1, -1, $iParts)
Else
If $vPartEdge < -1 Then Return False
If IsArray($vPartWidth) Then
$iParts = UBound($vPartWidth)
$tParts = DllStructCreate("int[" & $iParts & "]")
Local $iPartRightEdge = 0
For $x = 0 To $iParts - 2
$iPartRightEdge += $vPartWidth[$x]
If $vPartWidth[$x] <= 0 Then Return False
DllStructSetData($tParts, 1, $iPartRightEdge, $x + 1)
Next
DllStructSetData($tParts, 1, -1, $iParts)
ElseIf $vPartEdge > 1 Then
$iParts = $vPartEdge
$tParts = DllStructCreate("int[" & $iParts & "]")
For $x = 1 To $iParts - 1
DllStructSetData($tParts, 1, $vPartWidth * $x, $x)
Next
DllStructSetData($tParts, 1, -1, $iParts)
Else
$iParts = 1
$tParts = DllStructCreate("int")
DllStructSetData($tParts, 1, -1)
EndIf
EndIf
If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
_SendMessage($hWnd, $SB_SETPARTS, $iParts, $tParts, 0, "wparam", "struct*")
Else
Local $iSize = DllStructGetSize($tParts)
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
_MemWrite($tMemMap, $tParts)
_SendMessage($hWnd, $SB_SETPARTS, $iParts, $pMemory, 0, "wparam", "ptr")
_MemFree($tMemMap)
EndIf
_GUICtrlStatusBar_Resize($hWnd)
Return True
EndFunc
Func _GUICtrlStatusBar_SetText($hWnd, $sText = "", $iPart = 0, $iUFlag = 0)
Local $bUnicode = _GUICtrlStatusBar_GetUnicodeFormat($hWnd)
Local $iBuffer = StringLen($sText) + 1
Local $tText
If $bUnicode Then
$tText = DllStructCreate("wchar Text[" & $iBuffer & "]")
$iBuffer *= 2
Else
$tText = DllStructCreate("char Text[" & $iBuffer & "]")
EndIf
DllStructSetData($tText, "Text", $sText)
If _GUICtrlStatusBar_IsSimple($hWnd) Then $iPart = $SB_SIMPLEID
Local $iRet
If _WinAPI_InProcess($hWnd, $__g_hSBLastWnd) Then
$iRet = _SendMessage($hWnd, $SB_SETTEXTW, BitOR($iPart, $iUFlag), $tText, 0, "wparam", "struct*")
Else
Local $tMemMap
Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
_MemWrite($tMemMap, $tText)
If $bUnicode Then
$iRet = _SendMessage($hWnd, $SB_SETTEXTW, BitOR($iPart, $iUFlag), $pMemory, 0, "wparam", "ptr")
Else
$iRet = _SendMessage($hWnd, $SB_SETTEXT, BitOR($iPart, $iUFlag), $pMemory, 0, "wparam", "ptr")
EndIf
_MemFree($tMemMap)
EndIf
Return $iRet <> 0
EndFunc
If $CmdLineRaw == "-p" Then
Global $Portable = 1
Else
Global $Portable = 0
EndIf
Global Const $_ARRAYCONSTANT_SORTINFOSIZE = 11
Global $__g_aArrayDisplay_SortInfo[$_ARRAYCONSTANT_SORTINFOSIZE]
Global Const $_ARRAYCONSTANT_tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($nItem1, $nItem2, $hWnd)
If $__g_aArrayDisplay_SortInfo[3] = $__g_aArrayDisplay_SortInfo[4] Then
If Not $__g_aArrayDisplay_SortInfo[7] Then
$__g_aArrayDisplay_SortInfo[5] *= -1
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
Else
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
$__g_aArrayDisplay_SortInfo[6] = $__g_aArrayDisplay_SortInfo[3]
Local $sVal1 = __ArrayDisplay_GetItemText($hWnd, $nItem1, $__g_aArrayDisplay_SortInfo[3])
Local $sVal2 = __ArrayDisplay_GetItemText($hWnd, $nItem2, $__g_aArrayDisplay_SortInfo[3])
If $__g_aArrayDisplay_SortInfo[8] = 1 Then
If(StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
If(StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
EndIf
Local $nResult
If $__g_aArrayDisplay_SortInfo[8] < 2 Then
$nResult = 0
If $sVal1 < $sVal2 Then
$nResult = -1
ElseIf $sVal1 > $sVal2 Then
$nResult = 1
EndIf
Else
$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
EndIf
$nResult = $nResult * $__g_aArrayDisplay_SortInfo[5]
Return $nResult
EndFunc
Func __ArrayDisplay_GetItemText($hWnd, $iIndex, $iSubItem = 0)
Local $tBuffer = DllStructCreate("wchar Text[4096]")
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
DllStructSetData($tItem, "SubItem", $iSubItem)
DllStructSetData($tItem, "TextMax", 4096)
DllStructSetData($tItem, "Text", $pBuffer)
If IsHWnd($hWnd) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1073, "wparam", $iIndex, "struct*", $tItem)
Else
Local $pItem = DllStructGetPtr($tItem)
GUICtrlSendMsg($hWnd, 0x1073, $iIndex, $pItem)
EndIf
Return DllStructGetData($tBuffer, "Text")
EndFunc
Func _TempFile($sDirectoryName = @TempDir, $sFilePrefix = "~", $sFileExtension = ".tmp", $iRandomLength = 7)
If $iRandomLength = Default Or $iRandomLength <= 0 Then $iRandomLength = 7
If $sDirectoryName = Default Or(Not FileExists($sDirectoryName)) Then $sDirectoryName = @TempDir
If $sFileExtension = Default Then $sFileExtension = ".tmp"
If $sFilePrefix = Default Then $sFilePrefix = "~"
If Not FileExists($sDirectoryName) Then $sDirectoryName = @ScriptDir
$sDirectoryName = StringRegExpReplace($sDirectoryName, "[\\/]+$", "")
$sFileExtension = StringRegExpReplace($sFileExtension, "^\.+", "")
$sFilePrefix = StringRegExpReplace($sFilePrefix, '[\\/:*?"<>|]', "")
Local $sTempName = ""
Do
$sTempName = ""
While StringLen($sTempName) < $iRandomLength
$sTempName &= Chr(Random(97, 122, 1))
WEnd
$sTempName = $sDirectoryName & "\" & $sFilePrefix & $sTempName & "." & $sFileExtension
Until Not FileExists($sTempName)
Return $sTempName
EndFunc
Dim $StatusBar1
Global $Distr = "C:\Distr\Notary\"
Global $Tools = $Distr & "Tools\"
Global $Temp = $Tools & 'federal\ppdgr\temp\'
Global $_netFramework = "https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe"
Global $_netFramework47 = "https://download.microsoft.com/download/9/E/6/9E63300C-0941-4B45-A0EC-0008F96DD480/NDP471-KB4033342-x86-x64-AllOS-ENU.exe"
Global $_netFramework35 = "https://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe"
Global $Setup = "http://download.triasoft.com/enot/50/Setup.exe"
Global $MysqlSetup32 = "http://download.triasoft.com/enot/50/SetupDB.exe"
Global $MysqlSetup64 = "http://download.triasoft.com/enot/50/SetupDBx64.exe"
Global $Data = "http://download.triasoft.com/enot/50/Data.zip"
Global $Data_tables = "http://download.triasoft.com/enot/50/Data_tables.zip"
Global $faststone_ds = "http://www.faststonesoft.net/DN/FSViewerSetup66.exe"
Global $xml_ds = "http://download.triasoft.com/msxml6_x86.msi"
Global $ftpServer = '217.24.185.53:8080'
Global $ftpUser = 'ftp-user'
Global $ftpPass = 'Ftp-User'
Global $sZip = "/7za.exe"
Global $wRar = "/Utils/UnRAR.exe"
Global $wget = "https://eternallybored.org/misc/wget/1.19.4/32/wget.exe"
Global $irfanview = "/irfanview.zip"
Global $certsdistr = "/certs.zip"
Global $ieSetup = "/internet_explorer.reg"
Global $pkiSetup32 = "/PKIClient_x32_5.1_SP1.msi"
Global $pkiSetup64 = "/PKIClient_x64_5.1_SP1.msi"
Global $cspSetup = "/CryptoProCSP.exe"
Global $armSetup = "/trusteddesktop.exe"
Global $arm_settings = "/arm_settings.reg"
Global $actxSetup = "/cspcomsetup.msi"
Global $pdfSetup = "/cppdfsetup.exe"
Global $adobeSetup = "/acrobate.exe"
Global $cbpSetup = "/cadesplugin.exe"
Global $cades = "/cades.reg"
Global $gosSetup32 = "/IFCPlugin.msi"
Global $gosSetup64 = "/IFCPlugin-x64.msi"
Global $fedResurs = "/FedresursDSPlugin.msi"
Global $cryptoFF = "/ru.cryptopro.nmcades@cryptopro.ru.xpi"
Global $blitzFF = "/pomekhchngaooffdadfjnghfkaeipoba@reaxoft.ru.xpi"
Global $firefox = "/Firefox.exe"
Global $ff_sets = "/ff-settings.zip"
Global $chrome_sets = "/chrome-settings.zip"
Global $ie_links = "/ie_links.zip"
Global $c_ds = "/MicrosoftVisualC.exe"
Global $hasp_ds = "/hasp.exe"
Global $scp_ds = "/WinSCP.exe"
Global $zip_ds = "/7z.msi"
Global $zip64_ds = "/7z_64.msi"
Global $zip_assoc = "/7z.reg"
Global $zip64_assoc = "/7z_64.reg"
Global $heidi_ds = "/HeidiSQL.zip"
Global $punto_ds = "/PuntoSwitcher.zip"
Global $access97_ds = "/Microsoft_Access_97_SR2.zip"
Global $win2pdf_ds = "/WinScan2PDF.exe"
Global $chromeSetup32 = "/GoogleChromeStandaloneEnterprise.msi"
Global $chromeSetup64 = "/GoogleChromeStandaloneEnterprise64.msi"
Global $tm_ds = "/TeamViewerQS.exe"
Global $anydesk_ds = "/AnyDesk.exe"
Global $trueconf_ds = "/TrueConf.zip"
Global $start_ds = "/Startisback.zip"
Global $line_ds = "/CryptoLine.msi"
Global $pwd_ds = "/pwdcrack.zip"
Global $produkey_ds = "/ProduKey.exe"
Global $share_ds = "/net_share.bat"
Global $ecppass_ds = "/crypto_pass.bat"
Global $sqlBackup_ds = "/Utils/MysqlBackup.exe"
Global $_sleepforwindow = 800
Global $MainApp = "/_main.exe"
Global $VersionsInfo = "/version.ini"
Global $msiErr = ""
Global $NotaryHelper, $checkActx_Browser, $checkARM, $checkBD, $checkIE, $checkCerts, $checkCSP, $checkEnot, $checkFNS, $checkFNS_Print, $checkPDF, $checkPKI, $checkIrfan, $checkFastStone, $checkFF, $checkC, $checkNet_35, $checkHASP, $checkChrome, $checkAdobe, $checkWinSet, $checkSCP, $checkZIP, $checkTM, $checkAnyDesk, $checkTrueConf, $checkMUpdate, $checkSQLBACKUP, $checkXML, $checkStart, $checkLine, $check_pwd, $check_heidi, $checkShare, $checkProduKey, $checkPunto, $checkAccess, $checkWin2PDF, $checkECPPass
Func _install()
WinSetInstall()
eNotInstall()
ecpInstall()
crtInstall()
fedInstall()
softInstall()
expInstall()
If Checked($checkFNS) Then
Status("Установка программ для ФНС")
_PPDGR_Update()
EndIf
If Checked($checkFNS_Print) Then
Status("Проверка наличия установленного ПО ППДГР")
If @OSArch = "X64" Then
Local $ppdgr_dir = "C:\Program Files (x86)\АО ГНИВЦ\ППДГР"
Else
Local $ppdgr_dir = "C:\Program Files\АО ГНИВЦ\ППДГР"
EndIf
If DirGetSize($ppdgr_dir) <> -1 Then
FileChangeDir($ppdgr_dir)
Local $hSearch = FileFindFirstFile("*.msi")
$sFilename = FileFindNextFile($hSearch)
FileClose($hSearch)
Status("Удаление сбойного модуля печати ППДГР")
RunWait("msiexec /x """ & $sFilename & """ /qb")
Status("Установка модуля печати ППДГР")
RunWait("msiexec /i """ & $sFilename & """ /qb REBOOT=ReallySuppress /passive")
FileChangeDir($Distr)
EndIf
EndIf
EndFunc
Func WinSetInstall()
If Checked($checkWinSet) Then
Local $CMD = "netsh advfirewall firewall add rule name=MySQL dir=in action=allow protocol=TCP localport=3306"
RunWait(@ComSpec & " /c " & $CMD)
$CMD = "powercfg -SETACTIVE SCHEME_MIN"
RunWait(@ComSpec & " /c " & $CMD)
$CMD = "powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0"
RunWait(@ComSpec & " /c " & $CMD)
$CMD = "powercfg /SETACVALUEINDEX SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0"
RunWait(@ComSpec & " /c " & $CMD)
RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "HideFileExt", "REG_DWORD", "0")
EndIf
If Checked($checkMUpdate) Then
RunWait(@ComSpec & " /c " & "sc config wuauserv start=disabled & sc stop wuauserv & sc config bits start=disabled & sc stop bits & sc config dosvc start=disabled & sc stop dosvc")
DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
RunWait(@ComSpec & " /c " & 'TAKEOWN /F ' & @WindowsDir & '\System32\UsoClient.exe /a')
RunWait(@ComSpec & " /c " & 'icacls ' & @WindowsDir & "\System32\UsoClient.exe /inheritance:r /remove ''Администраторы'' ''Прошедшие проверку'' ''Пользователи'' ''Система''")
RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR", "AppCaptureEnabled", "REG_DWORD", "0")
RegWrite("HKEY_CURRENT_USER\System\GameConfigStore", "GameDVR_Enabled", "REG_DWORD", "0")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\UpdateOrchestrator")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\WindowsUpdate")
EndIf
If Checked($checkProduKey) Then
Status("Запуск ProduKey")
If Not FileExists($Tools & "software\ProduKey.exe") Or FileGetSize($Tools & "software\ProduKey.exe") = 0 Then _DownloadFTP($produkey_ds, $Tools & "software")
FileChangeDir($Tools & "software\")
RunWait("ProduKey.exe " & "/stext ProduKey.txt")
FileChangeDir($Distr)
If FileExists($Tools & "software\ProduKey.txt") Then Run("notepad.exe " & $Tools & "software\ProduKey.txt")
EndIf
If Checked($checkShare) Then
Status("Настройка общего доступа, подождите")
If FileExists($Tools & "software\net_share.bat") Then FileDelete($Tools & "software\net_share.bat")
_DownloadFTP($share_ds, $Tools & "software")
Local $cmdPath = Chr(34) & $Tools & "software\net_share.bat" & Chr(34)
RunWait(@ComSpec & " /c " & $cmdPath, "")
EndIf
If Checked($checkECPPass) Then
Status("Получение пароля от ЭП")
If FileExists($Tools & "software\crypto_pass.bat") Then FileDelete($Tools & "software\crypto_pass.bat")
_DownloadFTP($ecppass_ds, $Tools & "software")
Local $cmdPath = Chr(34) & $Tools & "software\crypto_pass.bat" & Chr(34)
RunWait(@ComSpec & " /c " & $cmdPath, "")
If FileExists($Tools & "software\CryptoPass.txt") Then
Run($Tools & "software\CryptoPass.txt")
Else
MsgBox("","Ошибка","Сохраненных ключей не найдено")
EndIf
EndIf
EndFunc
Func fedInstall()
If DirGetSize($Tools & "federal\") = -1 Then DirCreate($Tools & "federal\")
If Checked($checkActx_Browser) Then
Status("Установка ActiveX компонентов")
If Not FileExists($Tools & "federal\cspcomsetup.msi") Or FileGetSize($Tools & "federal\cspcomsetup.msi") = 0 Then _DownloadFTP($actxSetup, $Tools & "federal")
If DirGetSize("C:\Program Files (x86)\Interfax\") = -1 And DirGetSize("C:\Program Files\Interfax\") = -1 Then
Run('msiexec /i "' & $Tools & 'federal\cspcomsetup.msi" /qb')
WinWait("Setup - Firefox ActiveX Plugin", "This will install Firefox Acti", $_sleepforwindow)
WinActivate("Setup - Firefox ActiveX Plugin", "This will install Firefox Acti")
ControlClick("Setup - Firefox ActiveX Plugin", "This will install Firefox Acti", "TNewButton1")
WinWait("Setup - Firefox ActiveX Plugin", "Where should Firefox ActiveX P", $_sleepforwindow)
ControlClick("Setup - Firefox ActiveX Plugin", "Where should Firefox ActiveX P", "TNewButton3")
WinWait("Setup - Firefox ActiveX Plugin", "Setup is now ready to begin in", $_sleepforwindow)
ControlClick("Setup - Firefox ActiveX Plugin", "Setup is now ready to begin in", "TNewButton3")
WinWait("Setup - Firefox ActiveX Plugin", "Setup has finished installing ", $_sleepforwindow)
ControlClick("Setup - Firefox ActiveX Plugin", "Setup has finished installing ", "TNewButton3")
EndIf
Status("Установка CryptoPro Browser plugin")
If Not FileExists($Tools & "federal\cadesplugin.exe") Or FileGetSize($Tools & "federal\cadesplugin.exe") = 0 Then _DownloadFTP($cbpSetup, $Tools & "federal")
RunWait($Tools & "federal\cadesplugin.exe -silent -norestart -cadesargs ""/qb REBOOT=ReallySuppress /passive""")
If FileExists($Tools & "federal\cades.reg") Then FileDelete($Tools & "federal\cades.reg")
_DownloadFTP($cades, $Tools & "federal")
Local $hCadesImport = FileOpen($Tools & "federal\cades_import.reg", 2)
Local $hCadesSites = FileOpen($Tools & "federal\cades.reg", 0)
Local $sCadesRead = FileRead($hCadesSites)
FileClose($hCadesSites)
FileWrite($hCadesImport, "Windows Registry Editor Version 5.00")
FileWrite($hCadesImport, @CRLF & "[HKEY_USERS\" & _GetCurrentUserSID() & "\SOFTWARE\Crypto Pro\CAdESplugin]")
FileWrite($hCadesImport, @CRLF & $sCadesRead)
FileClose($hCadesImport)
RunWait("reg.exe IMPORT " & $Tools & "federal\cades_import.reg")
Status("Установка плагина для Госуслуг")
If @OSArch = "X64" Then
If Not FileExists($Tools & "federal\IFCPlugin-x64.msi") Or FileGetSize($Tools & "federal\IFCPlugin-x64.msi") = 0 Then _DownloadFTP($gosSetup64, $Tools & "federal")
RunWait('msiexec /i "' & $Tools & 'federal\IFCPlugin-x64.msi" /qb REBOOT=ReallySuppress /passive')
Else
If Not FileExists($Tools & "federal\IFCPlugin.msi") Or FileGetSize($Tools & "federal\IFCPlugin.msi") = 0 Then _DownloadFTP($gosSetup32, $Tools & "federal")
RunWait('msiexec /i "' & $Tools & 'federal\IFCPlugin.msi" /qb REBOOT=ReallySuppress /passive')
EndIf
Status("Установка плагина для Федресурса")
If Not FileExists($Tools & "federal\FedresursDSPlugin.msi") Or FileGetSize($Tools & "federal\FedresursDSPlugin.msi") = 0 Then _DownloadFTP($fedResurs, $Tools & "federal")
RunWait('msiexec /i "' & $Tools & 'federal\FedresursDSPlugin.msi" /qb REBOOT=ReallySuppress /passive')
EndIf
If Checked($checkARM) Then
Status("Установка CryptoARM")
If Not FileExists($Tools & "federal\trusteddesktop.exe") Or FileGetSize($Tools & "federal\trusteddesktop.exe") = 0 Then _DownloadFTP($armSetup, $Tools & "federal")
RunWait($Tools & "federal\trusteddesktop.exe /qb")
If FileExists($Tools & "federal\arm_settings.reg") Then FileDelete($Tools & "federal\arm_settings.reg")
_DownloadFTP($arm_settings, $Tools & "federal")
RunWait("reg.exe IMPORT " & $Tools & "federal\arm_settings.reg")
EndIf
If Checked($checkPDF) Then
Status("Установка CryptoPro PDF")
If Not FileExists($Tools & "federal\cppdfsetup.exe") Or FileGetSize($Tools & "federal\cppdfsetup.exe") = 0 Then _DownloadFTP($pdfSetup, $Tools & "federal")
RunWait($Tools & "federal\cppdfsetup.exe -silent -args ""/qb REBOOT=ReallySuppress /passive""")
EndIf
If Checked($checkLine) Then
Status("Установка КриптоЛайн")
If Not FileExists($Tools & "federal\CryptoLine.msi") Or FileGetSize($Tools & "federal\CryptoLine.msi") = 0 Then _DownloadFTP($line_ds, $Tools & "federal")
RunWait('msiexec /i "' & $Tools & 'federal\CryptoLine.msi" /qb REBOOT=ReallySuppress /passive')
EndIf
If Checked($checkIE) Then
Status("Настройка Internet Explorer")
_DownloadFTP($ieSetup, $Tools & "federal")
RunWait("reg.exe IMPORT " & $Tools & "federal\internet_explorer.reg")
If Not FileExists($Tools & "7za.exe") Then _DownloadFTP($sZip, $Tools)
_DownloadFTP($ie_links, $Tools)
RunWait($Tools & '7za.exe x -y ' & $Tools & 'ie_links.zip -o' & @UserProfileDir & '\favorites\links\')
EndIf
If Checked($checkFF) Then
Status("Установка Firefox")
ProcessClose("firefox.exe")
If Not FileExists($Tools & "federal\Firefox.exe") Then _DownloadFTP($firefox, $Tools & "federal")
RunWait($Tools & "federal\Firefox.exe -ms")
Local $java_comp = 'user_pref("plugin.state.java", 2);'
Local $npcades_comp = @CRLF & 'user_pref("plugin.state.npcades", 2);'
Local $npffax_comp = @CRLF & 'user_pref("plugin.state.npffax", 2);'
Local $npif_comp = @CRLF & 'user_pref("plugin.state.npifcplugin", 2);'
Local $ff_components = $java_comp & $npcades_comp & $npffax_comp & $npif_comp
Local $path = @AppDataDir & '\Mozilla\Firefox\Profiles\'
Local $randomStr = ""
Local $aSpace[3]
Local $digits = 4
For $i = 1 To $digits
$aSpace[0] = Chr(Random(65, 90, 1))
$aSpace[1] = Chr(Random(97, 122, 1))
$aSpace[2] = Chr(Random(48, 57, 1))
$randomStr &= $aSpace[Random(0, 2, 1)]
Next
DirMove($path, @AppDataDir & '\Mozilla\Firefox\Profiles.' & $randomStr & '.backup')
Local $handle_search = FileFindFirstFile($path & '*.default')
If $handle_search = -1 Then
If FileGetSize("C:\Program Files\Mozilla Firefox\firefox.exe") = 0 Then
RunWait("C:\Program Files (x86)\Mozilla Firefox\firefox.exe -CreateProfile default")
Else
RunWait("C:\Program Files\Mozilla Firefox\firefox.exe -CreateProfile default")
EndIf
EndIf
If FileExists("C:\Program Files\Mozilla Firefox") Then
Local $ff_updates = FileOpen("C:\Program Files\Mozilla Firefox\defaults\pref\channel-prefs.js", 2)
Else
Local $ff_updates = FileOpen("C:\Program Files (x86)\Mozilla Firefox\defaults\pref\channel-prefs.js", 2)
EndIf
FileWrite($ff_updates, "pref(""app.update.channel"", ""no"");")
FileClose($ff_updates)
Run("sc delete MozillaMaintenance")
$handle_search = FileFindFirstFile($path & '*.default')
$folder = FileFindNextFile($handle_search)
If Not @error Then
Local $ff_profile_path = $path & $folder
Local $FFPlugins = $ff_profile_path & '\prefs.js'
Local $file = FileOpen($FFPlugins, 2)
If @error = -1 Then
MsgBox(0, "Error", "Не найден prefs.js, настройки для FF будут не корректны")
Else
FileWrite($file, $ff_components)
EndIf
FileClose($file)
EndIf
FileClose($handle_search)
If Not FileExists($ff_profile_path & "\extensions") Then DirCreate($ff_profile_path & "\extensions")
_DownloadFTP($cryptoFF, $Tools & "federal")
FileCopy($Tools & "federal\ru.cryptopro.nmcades@cryptopro.ru.xpi", $ff_profile_path & "\extensions\ru.cryptopro.nmcades@cryptopro.ru.xpi", 1)
_DownloadFTP($blitzFF, $Tools & "federal")
FileCopy($Tools & "federal\pomekhchngaooffdadfjnghfkaeipoba@reaxoft.ru.xpi", $ff_profile_path & "\extensions\pomekhchngaooffdadfjnghfkaeipoba@reaxoft.ru.xpi", 1)
If Not FileExists($Tools & "7za.exe") Or FileGetSize($Tools & "7za.exe") = 0 Then _DownloadFTP($sZip, $Tools)
If FileExists($Tools & 'federal\ff-settings\ff-settings.zip') Then FileDelete($Tools & 'federal\ff-settings\ff-settings.zip')
_DownloadFTP($ff_sets, $Tools & "federal\ff-settings")
If FileExists($Tools & "federal\ff-settings\places.sqlite") Then FileDelete($Tools & "federal\ff-settings\places.sqlite")
If FileExists($Tools & "federal\ff-settings\xulstore.json") Then FileDelete($Tools & "federal\ff-settings\xulstore.json")
If FileExists($Tools & "federal\ff-settings\prefs.js") Then FileDelete($Tools & "federal\ff-settings\prefs.js")
If FileExists($Tools & "federal\ff-settings\extensions.json") Then FileDelete($Tools & "federal\ff-settings\extensions.json")
RunWait($Tools & '7za.exe x -y ' & $Tools & 'federal\ff-settings\ff-settings.zip ' & '"-o' & $Tools & 'federal\ff-settings\"')
FileCopy($Tools & "federal\ff-settings\places.sqlite", $ff_profile_path & "\places.sqlite", 1)
FileCopy($Tools & "federal\ff-settings\xulstore.json", $ff_profile_path & "\xulstore.json", 1)
FileCopy($Tools & "federal\ff-settings\prefs.js", $ff_profile_path & "\prefs.js", 1)
FileCopy($Tools & "federal\ff-settings\extensions.json", $ff_profile_path & "\extensions.json", 1)
EndIf
If Checked($checkChrome) Then
if ProcessExists("chrome.exe") Then ProcessClose("chrome.exe")
Status("Установка Google Chrome")
ProcessClose("chrome.exe")
If @OSArch = "X64" Then
If Not FileExists($Tools & "federal\GoogleChromeStandaloneEnterprise64.msi") Or FileGetSize($Tools & "federal\GoogleChromeStandaloneEnterprise64.msi") = 0 Then _DownloadFTP($chromeSetup64, $Tools & "federal")
RunWait('msiexec /i "' & $Tools & 'federal\GoogleChromeStandaloneEnterprise64.msi" /qb REBOOT=ReallySuppress /passive')
Else
If Not FileExists($Tools & "federal\GoogleChromeStandaloneEnterprise.msi") Or FileGetSize($Tools & "federal\GoogleChromeStandaloneEnterprise.msi") = 0 Then _DownloadFTP($chromeSetup32, $Tools & "federal")
RunWait('msiexec /i "' & $Tools & 'federal\GoogleChromeStandaloneEnterprise.msi" /qb REBOOT=ReallySuppress /passive')
EndIf
RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist", "1", "REG_SZ", "iifchhfnnmpdbibifmljnfjhpififfog;https://clients2.google.com/service/update2/crx")
RunWait(@ComSpec & " /c " & "gpupdate /force", "", @SW_HIDE)
_DownloadFTP($chrome_sets, $Tools & "federal")
If FileExists(@LocalAppDataDir & "\Google\Chrome\User Data\Default\Preferences") Then FileMove(@LocalAppDataDir & "\Google\Chrome\User Data\Default\Preferences", @LocalAppDataDir & "\Google\Chrome\User Data\Default\Preferences.backup")
If FileExists(@LocalAppDataDir & "\Google\Chrome\User Data\Default\Bookmarks") Then FileMove(@LocalAppDataDir & "\Google\Chrome\User Data\Default\Bookmarks", @LocalAppDataDir & "\Google\Chrome\User Data\Default\Boomarks.backup")
RunWait($Tools & '7za.exe x -y ' & $Tools & 'federal\chrome-settings.zip ' & '"-o' & @LocalAppDataDir & '\Google\Chrome\User Data\Default\"')
EndIf
EndFunc
Func crtInstall()
If Checked($checkCerts) Then
Status("Установка сертификатов")
If Not FileExists($Tools & "7za.exe") Or FileGetSize($Tools & "7za.exe") = 0 Then
_DownloadFTP($sZip, $Tools)
EndIf
If DirGetSize($Tools & "certs") <> -1 Then DirRemove($Tools & "certs", 1)
_DownloadFTP($certsdistr, $Tools)
RunWait($Tools & '7za.exe x ' & $Tools & 'certs.zip -o' & $Tools)
_Download("https://uc.kadastr.ru/revoke/index/revoked3.crl", $Tools & "certs\revoked3.crl")
ShellExecuteWait($Tools & "certs\install.bat", "", $Tools & "certs\")
FileDelete($Tools & "certs.zip")
EndIf
EndFunc
Func ecpInstall()
If DirGetSize($Tools & "ecp\") = -1 Then DirCreate($Tools & "ecp\")
If Checked($checkPKI) Then
Status("Установка etoken pki client")
If @OSArch = "X64" Then
If Not FileExists($Tools & "ecp\PKIClient_x64_5.1_SP1.msi") Or FileGetSize($Tools & "ecp\PKIClient_x64_5.1_SP1.msi") = 0 Then _DownloadFTP($pkiSetup64, $Tools & "ecp")
RunWait('msiexec /i "' & $Tools & 'ecp\PKIClient_x64_5.1_SP1.msi" ET_LANG_NAME=Russian /norestart /qb-')
Else
If Not FileExists($Tools & "ecp\PKIClient_x32_5.1_SP1.msi") Or FileGetSize($Tools & "ecp\PKIClient_x32_5.1_SP1.msi") = 0 Then _DownloadFTP($pkiSetup32, $Tools & "ecp")
RunWait('msiexec /i "' & $Tools & 'ecp\PKIClient_x32_5.1_SP1.msi" ET_LANG_NAME=Russian /norestart /qb-')
EndIf
EndIf
If Checked($checkCSP) Then
Status("Установка CryptoPro CSP")
if FileExists($Tools & "ecp\CryptoProCSP.exe") Then FileDelete($Tools & "ecp\CryptoProCSP.exe")
_DownloadFTP($cspSetup, $Tools & "ecp")
RunWait($Tools & "ecp\CryptoProCSP.exe -gm2 -lang rus -kc kc1 -silent -noreboot -nodlg -args ""/qb""")
EndIf
EndFunc
Func eNotInstall()
If DirGetSize($Tools & "eNot\") = -1 Then DirCreate($Tools & "eNot\")
If Checked($checkEnot) Then
Status('Производится скачивание дистрибутива Енот')
If Not FileExists($Tools & "eNot\Setup.exe") Or FileGetSize($Tools & "eNot\Setup.exe") <> InetGetSize($Setup) Then _Download($Setup, $Tools & "eNot\Setup.exe")
If Not WinExists("eNot") Then Run('explorer ' & $Tools & "eNot\")
EndIf
If Checked($checkBD) Then
Status("Скачиваем базы данных Енот + Mysql - сервер")
If Not FileExists($Tools & "eNot\Data.zip") Or FileGetSize($Tools & "eNot\Data.zip") <> InetGetSize($Data) Then _Download($Data, $Tools & "eNot\Data.zip")
If Not FileExists($Tools & "eNot\Data_tables.zip") Or FileGetSize($Tools & "eNot\Data_tables.zip") <> InetGetSize($Data_tables) Then _Download($Data_tables, $Tools & "eNot\Data_tables.zip")
Switch @OSArch
Case "X64"
If Not FileExists($Tools & "eNot\SetupDB64.exe") Or FileGetSize($Tools & "eNot\SetupDB64.exe") <> InetGetSize($MysqlSetup64) Then _Download($MysqlSetup64, $Tools & "eNot\SetupDB64.exe")
Case "X86"
If Not FileExists($Tools & "eNot\SetupDB32.exe") Or FileGetSize($Tools & "eNot\SetupDB32.exe") <> InetGetSize($MysqlSetup64) Then _Download($MysqlSetup32, $Tools & "eNot\SetupDB32.exe")
EndSwitch
If Not WinExists("eNot") Then Run('explorer ' & $Tools & "eNot\")
EndIf
EndFunc
Func softInstall()
If DirGetSize($Tools & "software") = -1 Then DirCreate($Tools & "software")
If Checked($checkIrfan) Then
Status("Установка IrfanView")
If DirGetSize($Tools & "software\irfanview") = -1 Then
If Not FileExists($Tools & "software\irfanview.zip") Or FileGetSize($Tools & "software\irfanview.zip") = 0 Then _DownloadFTP($irfanview, $Tools & "software")
If Not FileExists($Tools & "7za.exe") Then _DownloadFTP($sZip, $Tools)
RunWait($Tools & '7za.exe x ' & $Tools & 'software\irfanview.zip -o' & $Tools & 'software\')
FileCreateShortcut($Tools & 'software\irfanview\i_view32.exe', @DesktopDir & "\IrfanView.lnk")
EndIf
EndIf
If Checked($checkFastStone) Then
Status("Установка FastStone Image Viewer")
If Not FileExists($Tools & "software\FSViewerSetup66.exe") Or FileGetSize($Tools & "software\FSViewerSetup66.exe") = 0 Then _DownloadRawBar($faststone_ds, $Tools & "software\FSViewerSetup66.exe")
RunWait($Tools & "software\FSViewerSetup66.exe /S")
EndIf
If Checked($checkTM) Then
Status("Закачка и запуск Teamviewer QS 9")
If Not FileExists($Tools & "software\TeamViewerQS.exe") Or FileGetSize($Tools & "software\TeamViewer.exe") = 0 Then _DownloadFTP($tm_ds, $Tools & "software")
FileCreateShortcut($Tools & "software\TeamViewerQS.exe", @DesktopDir & "\TeamViewer.lnk")
_UpdateScreen()
Run($Tools & "software\TeamViewerQS.exe")
EndIf
If Checked($checkAnyDesk) Then
Status("Закачка и запуск AnyDesk")
If Not FileExists($Tools & "software\AnyDesk.exe") Or FileGetSize($Tools & "software\AnyDesk.exe") = 0 Then _DownloadFTP($anydesk_ds, $Tools & "software")
Run($Tools & "software\AnyDesk.exe")
EndIf
If Checked($checkTrueConf) Then
Status("Закачка и установка TrueConf")
If Not FileExists($Tools & "software\TrueConf.zip") Or FileGetSize($Tools & "software\TrueConf.zip") = 0 Then _DownloadFTP($trueconf_ds, $Tools & "software")
If Not FileExists($Tools & "7za.exe") Then _DownloadFTP($sZip, $Tools)
If Not FileExists($Tools & "software\TrueConf") Then DirCreate($Tools & "software\TrueConf")
RunWait($Tools & '7za.exe x -y ' & $Tools & 'software\TrueConf.zip -o' & $Tools & 'software\TrueConf\')
RunWait($Tools & "software\TrueConf\Setup.exe /Silent /NoReboot")
If ProcessExists("trueconf.exe") Then ProcessClose("trueconf.exe")
RegDelete("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "TrueConf Client")
EndIf
If Checked($checkStart) Then
Status("Закачка и установка StartIsBack для Windows 10")
If Not FileExists($Tools & "software\Startisback.zip") Or FileGetSize($Tools & "software\Startisback.zip") = 0 Then _DownloadFTP($start_ds, $Tools & "software")
If Not FileExists($Tools & "7za.exe") Then _DownloadFTP($sZip, $Tools)
If Not FileExists($Tools & "software\StartIsBack") Then DirCreate($Tools & "software\StartIsBack")
RunWait($Tools & '7za.exe x -y ' & $Tools & 'software\Startisback.zip -o' & $Tools & 'software\StartIsBack\')
RunWait($Tools & "software\StartIsBack\Install.cmd")
EndIf
If Checked($checkSQLBACKUP) Then
Status("Закачка и запуск MySQL Backup")
If Not FileExists($Tools & "software\MysqlBackup.exe") Or FileGetSize($Tools & "software\MysqlBackup.exe") = 0 Then _DownloadFTP($sqlBackup_ds, $Tools & "software")
Run($Tools & "software\MysqlBackup.exe")
EndIf
If Checked($check_pwd) Then
Status("Запуск pwdCrack")
If Not FileExists($Tools & "software\pwdcrack") Or DirGetSize($Tools & "software\pwdcrack") = 0 Then
_DownloadFTP($pwd_ds, $Tools & "software")
If Not FileExists($Tools & "7za.exe") Then _DownloadFTP($sZip, $Tools)
RunWait($Tools & '7za.exe x -y ' & $Tools & 'software\pwdcrack.zip -o' & $Tools & 'software\')
EndIf
Run($Tools & "software\pwdcrack\pwdcrack.exe")
EndIf
If Checked($check_heidi) Then
Status("Запуск HeidiSQL")
If Not FileExists($Tools & "software\HeidiSQL") Or DirGetSize($Tools & "software\HeidiSQL") = 0 Then
_DownloadFTP($heidi_ds, $Tools & "software")
If Not FileExists($Tools & "7za.exe") Then _DownloadFTP($sZip, $Tools)
RunWait($Tools & '7za.exe x -y ' & $Tools & 'software\HeidiSQL.zip -o' & $Tools & 'software\')
EndIf
Run($Tools & "software\HeidiSQL\heidisql.exe")
EndIf
If Checked($checkAdobe) Then
Status("Установка Adobe Reader DC")
If Not FileExists($Tools & "software\acrobate.exe") Or FileGetSize($Tools & "software\acrobate.exe") = 0 Then _DownloadFTP($adobeSetup, $Tools & "software")
RunWait($Tools & 'software\acrobate.exe /sALL')
EndIf
If Checked($checkSCP) Then
Status("Установка WinSCP")
If Not FileExists($Tools & "software\WinSCP.exe") Or FileGetSize($Tools & "software\WinSCP.exe") = 0 Then _DownloadFTP($scp_ds, $Tools & "software")
RunWait($Tools & 'software\WinSCP.exe /SILENT')
EndIf
If Checked($checkZIP) Then
Status("Установка 7-Zip")
If @OSArch = "X64" Then
If Not FileExists($Tools & "software\7z_64.msi") Or FileGetSize($Tools & "software\7z_64.msi") = 0 Then _DownloadFTP($zip64_ds, $Tools & "software")
RunWait('msiexec /i "' & $Tools & 'software\7z_64.msi" /qb REBOOT=ReallySuppress /passive')
If Not FileExists($Tools & "software\7z_64.reg") Or FileGetSize($Tools & "software\7z_64.reg") = 0 Then _DownloadFTP($zip64_assoc, $Tools & "software")
RunWait("reg.exe IMPORT " & $Tools & "software\7z_64.reg")
Else
If Not FileExists($Tools & "software\7z.msi") Or FileGetSize($Tools & "software\7z.msi") = 0 Then _DownloadFTP($zip_ds, $Tools & "software")
RunWait('msiexec /i "' & $Tools & 'software\7z.msi" /qb REBOOT=ReallySuppress /passive')
If Not FileExists($Tools & "software\7z.reg") Or FileGetSize($Tools & "software\7z.reg") = 0 Then _DownloadFTP($zip_assoc, $Tools & "software")
RunWait("reg.exe IMPORT " & $Tools & "software\7z.reg")
EndIf
EndIf
If Checked($checkPunto) Then
Status("Закачка PuntoSwitcher")
If Not FileExists($Tools & "software\PuntoSwitcher.zip") Or FileGetSize($Tools & "software\PuntoSwitcher.zip") = 0 Then
If Not FileExists($Tools & "7za.exe") Then _DownloadFTP($sZip, $Tools)
_DownloadFTP($punto_ds, $Tools & "software")
RunWait($Tools & '7za.exe x -y ' & $Tools & 'software\PuntoSwitcher.zip -o' & $Tools & 'software\')
EndIf
Status("Установка PuntoSwitcher")
RunWait($Tools & "software\PuntoSwitcher.exe /Silent")
EndIf
If Checked($checkAccess) Then
Status("Закачка Microsoft Access 97")
If Not FileExists($Tools & "software\Microsoft_Access_97_SR2.zip") Or FileGetSize($Tools & "software\Microsoft_Access_97_SR2.zip") = 0 Then
If Not FileExists($Tools & "7za.exe") Then _DownloadFTP($sZip, $Tools)
_DownloadFTP($access97_ds, $Tools & "software")
RunWait($Tools & '7za.exe x -y ' & $Tools & 'software\Microsoft_Access_97_SR2.zip -o' & $Tools & 'software\')
EndIf
If Not WinExists("software") Then Run('explorer ' & $Tools & "software\")
EndIf
If Checked($checkWin2PDF) Then
Status("Подготовка WinScan2PDF к работе")
If Not FileExists($Tools & "software\WinScan2PDF.exe") Or FileGetSize($Tools & "software\WinScan2PDF.exe") = 0 Then _DownloadFTP($win2pdf_ds, $Tools & "software")
FileCreateShortcut($Tools & 'software\WinScan2PDF.exe', @DesktopDir & "\WinScan2PDF.lnk")
Run($Tools & "software\WinScan2PDF.exe")
EndIf
EndFunc
Func expInstall()
If DirGetSize($Tools & "express\") = -1 Then DirCreate($Tools & "express\")
If Checked($checkC) Then
Status("Устанавливаем Microsoft Visual C++")
If Not FileExists($Tools & "express\MicrosoftVisualC.exe") Or FileGetSize($Tools & "express\MicrosoftVisualC.exe") = 0 Then _DownloadFTP($c_ds, $Tools & "express")
RunWait($Tools & "express\MicrosoftVisualC.exe /s")
EndIf
If Checked($checkNet_35) Then
Status("Устанавливаем .Net Framework 3.5")
If Not FileExists($Tools & "federal\ppdgr") Then DirCreate($Tools & "federal\ppdgr")
If Not FileExists($Tools & "federal\ppdgr\temp") Then DirCreate($Tools & "federal\ppdgr\temp")
RunWait($Tools & "wget.exe -c --tries=0 --read-timeout=5 " & $_netFramework35 & " -P" & $Temp)
RunWait($Temp & 'dotnetfx35.exe /passive /norestart')
EndIf
If Checked($checkXML) Then
If Not FileExists($Tools & "express\msxml6_x86.msi") Or FileGetSize($Tools & "express\msxml6_x86.msi") = 0 Then _Download($xml_ds, $Tools & "express\msxml6_x86.msi")
RunWait('msiexec /i "' & $Tools & 'express\msxml6_x86.msi" /qb REBOOT=ReallySuppress /passive')
EndIf
If Checked($checkHASP) Then
Status("Скачиваем Hasp драйвер")
If Not FileExists($Tools & "express\hasp.exe") Or FileGetSize($Tools & "express\hasp.exe") = 0 Then _DownloadFTP($hasp_ds, $Tools & "express")
Status("Удаляем старые hasp драйверы")
RunWait($Tools & "express\hasp.exe -fr -kp -purge -nomsg")
Status("Устанавливаем новый hasp драйвер")
RunWait($Tools & "express\hasp.exe -i -kp -nomsg")
EndIf
EndFunc
Func _PPDGR_Update()
If Not FileExists($Tools & "UnRAR.exe") Or FileGetSize($Tools & "UnRAR.exe") = 0 Then _DownloadFTP($wRar, $Tools)
If DirGetSize($Tools & "federal\ppdgr") == -1 Then
DirCreate($Tools & "federal\ppdgr")
If Not FileExists($Tools & "federal\ppdgr\temp") Then DirCreate($Tools & "federal\ppdgr\temp")
EndIf
FileChangeDir($Tools & "federal\ppdgr")
If _CheckDotNet4_ppdgr() Then
_CheckWindows()
RunWait($Tools & "wget.exe -c --tries=0 --read-timeout=5 " & $_netFramework47 & " -P" & $Temp)
RunWait($Temp & 'NDP471-KB4033342-x86-x64-AllOS-ENU.exe /passive /norestart')
EndIf
_PPDGR()
FileChangeDir($Distr)
EndFunc
Func _PPDGR()
Local $FnsLink = IniRead($Distr & "version.ini", "ФНС", "Ссылка", "")
If Not FileExists($Temp & "Setup_PPDGR.msi") Then RunWait($Tools & "wget.exe -c --tries=0 --read-timeout=5 --no-check-certificate " & $FnsLink & " -P " & $Temp)
RunWait($Tools & "UnRAR.exe e -y  Temp\Setup_PPDGR_full.exe Temp\")
FileChangeDir($Temp)
$msiErr = RunWait('msiexec /fa Setup_PPDGR.msi /qb /passive /norestart REBOOT=ReallySuppress')
If $msiErr == "1605" Then RunWait("msiexec /i Setup_PPDGR.msi /qb /passive /norestart REBOOT=ReallySuppress")
$msiErr = ""
FileChangeDir($Distr)
$BPrint = WinWait("Печать НД", "", 5)
If WinExists($BPrint) Then
Local $PidActwin = WinGetProcess($BPrint)
ProcessClose($PidActwin)
If @OSArch = "X64" Then
FileChangeDir("C:\Program Files (x86)\АО ГНИВЦ\ППДГР")
Else
FileChangeDir("C:\Program Files\АО ГНИВЦ\ППДГР")
EndIf
Local $hSearch = FileFindFirstFile("*.msi")
$sFilename = FileFindNextFile($hSearch)
FileClose($hSearch)
FileCopy(@WorkingDir & "\" & $sFilename, $Temp & "BPrint.msi")
FileChangeDir($Temp)
$msiErr = RunWait("msiexec /fa BPrint.msi /qb /passive /norestart REBOOT=ReallySuppress")
If $msiErr == "1605" Then RunWait("msiexec /i BPrint.msi /qb /passive /norestart REBOOT=ReallySuppress")
$msiErr = ""
FileChangeDir($Distr)
EndIf
EndFunc
Func Status($Msg)
If GUICtrlGetState($StatusBar1) Then _GUICtrlStatusBar_SetText($StatusBar1, $Msg, 2)
EndFunc
Func Checked($Checkbox)
If GUICtrlGetState($Checkbox) Then
If GUICtrlRead($Checkbox) = $GUI_CHECKED Then
Return(True)
Else
Return(False)
EndIf
EndIf
EndFunc
Func _CheckDotNet4()
RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', '')
If @error > 0 Then
Return False
Else
Return True
EndIf
EndFunc
Func _CheckDotNet4_ppdgr()
Local $s = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Release')
If $s < 460805 Then
Return True
Else
Return False
EndIf
EndFunc
Func _CheckWindows()
Local $status_bits, $status_updates
If @OSVersion = "Win_7" Then
If _Hotfix("4019990") == "0" Then
If _RetrieveServiceState("bits") <> "Running" Then
$status_bits = "1"
RunWait(@ComSpec & ' /c sc config bits start=demand', '', @SW_HIDE)
RunWait(@ComSpec & ' /c net start bits', '', @SW_HIDE)
EndIf
If _RetrieveServiceState("wuauserv") <> "Running" Then
$status_updates = "1"
RunWait(@ComSpec & ' /c sc config wuauserv start=demand', '', @SW_HIDE)
RunWait(@ComSpec & ' /c net start wuauserv', '', @SW_HIDE)
EndIf
If @OSArch = "X86" Then
RunWait($Tools & "wget.exe -c --tries=0 --read-timeout=5 http://download.microsoft.com/download/2/F/4/2F4F48F4-D980-43AA-906A-8FFF40BCB832/Windows6.1-KB4019990-x86.msu -P " & $Temp)
RunWait($Temp & "Windows6.1-KB4019990-x86.msu /passive /norestart")
Else
RunWait($Tools & "wget.exe -c --tries=0 --read-timeout=5 http://download.microsoft.com/download/2/F/4/2F4F48F4-D980-43AA-906A-8FFF40BCB832/Windows6.1-KB4019990-x64.msu -P " & $Temp)
RunWait($Temp & "Windows6.1-KB4019990-x64.msu /passive /norestart")
EndIf
If $status_bits Then
$status_bits = "0"
RunWait(@ComSpec & ' /c sc config bits start=disabled', '', @SW_HIDE)
RunWait(@ComSpec & ' /c net stop bits', '', @SW_HIDE)
EndIf
If $status_updates Then
$status_updates = "0"
RunWait(@ComSpec & ' /c sc config wuauserv start=disabled', '', @SW_HIDE)
RunWait(@ComSpec & ' /c net stop wuauserv', '', @SW_HIDE)
EndIf
EndIf
EndIf
EndFunc
Func _Hotfix($hotfix_name)
Local $iRET = RunWait(@ComSpec & ' /c WMIC qfe get hotfixid | FIND "' & $hotfix_name & '"', @TempDir, @SW_HIDE)
If $iRET Then
Return("0")
Else
Return("1")
EndIf
EndFunc
Func _RetrieveServiceState($s_ServiceName)
Local Const $wbemFlagReturnImmediately = 0x10
Local Const $wbemFlagForwardOnly = 0x20
Local $s_Machine = @ComputerName
Local $colItems = "", $objItem
Local $objWMIService = ObjGet("winmgmts:\\" & $s_Machine & "\root\CIMV2")
If @error Then
MsgBox(16, "_RetrieveServiceState", "ObjGet Error: winmgmts")
Return
EndIf
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Service WHERE Name = '" & $s_ServiceName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
If @error Then
MsgBox(16, "_RetrieveServiceState", "ExecQuery Error: SELECT * FROM Win32_Service")
Return
EndIf
If IsObj($colItems) Then
For $objItem In $colItems
Return $objItem.State
Next
EndIf
EndFunc
Func _UpdateScreen()
Local $Opt = Opt('WinSearchChildren', 1)
Local $List = WinList('[CLASS:SHELLDLL_DefView]')
For $i = 1 To UBound($List) - 1
DllCall('user32.dll', 'long', 'SendMessage', 'hwnd', $List[$i][1], 'int', 0x0111, "int", 0x7103, 'int', 0)
Next
Opt('WinSearchChildren', $Opt)
EndFunc
Func _update()
If $Portable = 1 Then
$Distr = @WorkingDir & "\"
$Tools = $Distr & "Tools\"
$Temp = $Tools & 'federal\ppdgr\temp\'
EndIf
If DirGetSize($Tools) = -1 Then DirCreate($Tools)
If $Portable = 0 Then
If @ScriptDir <> $Distr Then
FileMove(@ScriptName, $Distr, 9)
FileMove("version.ini", $Distr, 9)
FileCreateShortcut($Distr & @ScriptName, @DesktopDir & "\Нотариальный помощник.lnk")
DirMove("Tools", $Distr, 1)
EndIf
If Not FileExists($Tools & "wget.exe") Or FileGetSize($Tools & "wget.exe") <> InetGetSize($wget) Then _DownloadRawBar($wget, $Tools & "wget.exe")
Local $oldVersion = IniRead($Distr & "version.ini", "Version", "Version", "NotFound")
If FileExists("version.ini") Then FileDelete("version.ini")
Local $Ini = _DownloadFTP($VersionsInfo, "/")
If @ScriptDir <> $Distr Then FileMove("version.ini", $Distr, 9)
Local $newVersion = IniRead($Distr & "version.ini", "Version", "Version", "")
If $newVersion <> $oldVersion Then
If FileExists($Distr & "Update\_main.exe") Then FileDelete($Distr & "Update\_main.exe")
_DownloadFTP($MainApp, $Distr & "Update")
FileCopy($Distr & "Update\" & "_main.exe", $Distr & "_main.exe.tmp", 1)
IniWrite($Distr & "version.ini", "version", "version", $newVersion)
_ScriptRestart()
EndIf
_UpdateScreen()
EndIf
EndFunc
Func _ScriptRestart()
$sVbs = _TempFile(@TempDir, '~', '.vbs')
$hFile = FileOpen($sVbs, 2)
FileWriteLine($hFile, 'Set objService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\CIMV2")')
FileWriteLine($hFile, 'Set objRefresher = CreateObject("WbemScripting.SWbemRefresher")')
FileWriteLine($hFile, 'Set colItems = objRefresher.AddEnum(objService, "Win32_Process").objectSet')
FileWriteLine($hFile, 'Set obj = CreateObject("Scripting.FileSystemObject")')
FileWriteLine($hFile, 'Do Until False')
FileWriteLine($hFile, '    WScript.Sleep 500')
FileWriteLine($hFile, '    objRefresher.Refresh')
FileWriteLine($hFile, '    Flag = True')
FileWriteLine($hFile, '    For Each objItem in colItems')
FileWriteLine($hFile, '        If objItem.ProcessID = ' & @AutoItPID & ' Then')
FileWriteLine($hFile, '            Flag = False')
FileWriteLine($hFile, '        End If')
FileWriteLine($hFile, '    Next')
FileWriteLine($hFile, '    If Flag = True Then')
FileWriteLine($hFile, '        Exit Do')
FileWriteLine($hFile, '    End If')
FileWriteLine($hFile, 'Loop')
FileWriteLine($hFile, '		If (obj.FileExists("' & @ScriptName & '")) Then')
FileWriteLine($hFile, '			obj.DeleteFile("' & @ScriptName & '")')
FileWriteLine($hFile, '		Else')
FileWriteLine($hFile, '			obj.DeleteFile("' & $Distr & @ScriptName & '")')
FileWriteLine($hFile, '		End If')
FileWriteLine($hFile, 'Set f = obj.GetFile("' & $Distr & @ScriptName & '.tmp")')
FileWriteLine($hFile, 'Set objFSO = CreateObject("Scripting.FileSystemObject")')
FileWriteLine($hFile, 'objFSO.CopyFile f, "' & $Distr & @ScriptName & '", TRUE')
FileWriteLine($hFile, 'objFSO.DeleteFile f')
FileWriteLine($hFile, 'Set objShell = CreateObject("WScript.Shell")')
FileWriteLine($hFile, 'objShell.Run("' & $Distr & @ScriptName & ' ' & $CmdLineRaw & '")')
FileWriteLine($hFile, 'Set objFSO = CreateObject("Scripting.FileSystemObject")')
FileWriteLine($hFile, 'Set File = objFSO.GetFile("' & FileGetShortName($sVbs) & '")')
FileWriteLine($hFile, 'File.Delete')
FileClose($hFile)
ShellExecute($sVbs)
Exit
EndFunc
Func _Download($url, $folder)
Local $ParentWin_Pos = WinGetPos($NotaryHelper, "")
Local $Form1 = GUICreate("Загрузка файла", 400, 100, $ParentWin_Pos[0] + 100, $ParentWin_Pos[1] + 200, -1, -1, $NotaryHelper)
Local $pb_File = GUICtrlCreateProgress(30, 30, 300, 20, '')
Local $lbl_FilePercent = GUICtrlCreateLabel("0 %", 335, 32, 35, 16, '')
Local $x = 0
Local $sTemp = StringRegExpReplace($folder, '[^\\]*\z', '', 1)
Local $sFilename = StringReplace($folder, $sTemp, "")
Local $lbl_Info = GUICtrlCreateLabel('' & $sFilename, 30, 62, 300, 16, '')
GUISetState(@SW_SHOW, $Form1)
$hInet = InetGet($url, $folder, 1, 16)
$FileSize = InetGetSize($url)
While Not InetGetInfo($hInet, 2)
Sleep(500)
$BytesReceived = InetGetInfo($hInet, 0)
$Pct = Int($BytesReceived / $FileSize * 100)
GUICtrlSetData($pb_File, $Pct)
GUICtrlSetData($lbl_FilePercent, $Pct & " %")
WEnd
InetClose($hInet)
GUIDelete($Form1)
If FileGetSize($folder) Then $x = 1
Return $x
EndFunc
Func _DownloadFTP($file_url, $folder_to)
RunWait($Tools & "wget.exe -q --show-progress -c -nc --tries=0 --read-timeout=5 --no-check-certificate --user=" & $ftpUser & " --password=" & $ftpPass & " http://" & $ftpServer & $file_url & " -P " & $folder_to)
EndFunc
Func _DownloadRawBar($from, $to)
ProgressOn("Загрузка", $to, "0%")
Local $url = $from
$folder = $to
$hInet = InetGet($url, $folder, 1, 1)
$FileSize = InetGetSize($url)
While Not InetGetInfo($hInet, 2)
Sleep(500)
$BytesReceived = InetGetInfo($hInet, 0)
$Pct = Int($BytesReceived / $FileSize * 100)
ProgressSet($Pct, $Pct & "%")
WEnd
ProgressOff()
EndFunc
Func _GetCurrentUser()
Local $result = DllCall("Wtsapi32.dll","int", "WTSQuerySessionInformationW", "Ptr", 0, "int", -1, "int", 5, "ptr*", 0, "dword*", 0)
If @error Or $result[0] = 0 Then Return SetError(1,0,"")
Local $User = DllStructGetData(DllStructCreate("wchar[" & $result[5] & "]" , $result[4]),1)
DllCall("Wtsapi32.dll", "int", "WTSFreeMemory", "ptr", $result[4])
Return $User
EndFunc
Func _GetCurrentUserSID()
Local $User = _Security__LookupAccountName(_GetCurrentUser(),@ComputerName)
If @error Then Return SetError(1,0,"")
Return $User[0]
EndFunc
SplashTextOn("Статус", "Установка необходимых компонентов для запуска программы", 450, 30, 415, 150, 48, "", 10)
If Not _CheckDotNet4() Then
If Not FileExists($Tools & "dotNetFx40_Full_x86_x64.exe") Then _Download($_netFramework, $Tools & 'dotNetFx40_Full_x86_x64.exe')
RunWait($Tools & 'dotNetFx40_Full_x86_x64.exe /q /norestart')
EndIf
ControlSetText("Статус", '', 'Static1', "Производится обновление программы")
_update()
ControlSetText("Статус", '', 'Static1', "Введите пароль для запуска программы")
SplashOff()
$width = 628
$height = 481
$NotaryHelper = GUICreate("IT - Helper v. " & FileGetVersion(@ScriptFullPath), $width, $height, -1, -1, $GUI_SS_DEFAULT_GUI)
$menuFile = GUICtrlCreateMenu("Файл")
$menuOffline = GUICtrlCreateMenuItem("Offline - режим", $menuFile)
$menuDelete = GUICtrlCreateMenuItem("Удалить ПО", $menuFile)
$menuHelp = GUICtrlCreateMenu("Помощь")
$menuAbout = GUICtrlCreateMenuItem("О программе", $menuHelp)
GUISetFont(12, 400, 0, "Segoe UI")
GUISetBkColor(0xBFCDDB)
$Tab1 = GUICtrlCreateTab(1, 0, 625, 401)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")
$TabSheet1 = GUICtrlCreateTabItem("Нотариат")
$group_eis = GUICtrlCreateGroup("ЕИС Енот", 8, 37, 193, 129)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkEnot = GUICtrlCreateCheckbox(" Дистрибутив ЕИС", 17, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
$checkBD = GUICtrlCreateCheckbox(" Дистрибутив MySQL", 17, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Mysql + базы данных еис")
$checkSQLBACKUP = GUICtrlCreateCheckbox(" Бэкап MySQL БД", 17, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetTip(-1, "Утилита для бэкапа MySQL БД Енота")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_fns = GUICtrlCreateGroup("ФНС", 8, 173, 193, 97)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkFNS = GUICtrlCreateCheckbox(" ППДГР", 17, 193, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$checkFNS_Print = GUICtrlCreateCheckbox(" Модуль печати", 17, 226, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Восстанавливает модуль печати для ППДГР")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_express = GUICtrlCreateGroup("Триасофт - Экспресс", 8, 277, 193, 97)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkHasp = GUICtrlCreateCheckbox(" HASP Драйвер", 17, 297, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetTip(-1, "Удаляет старые драйверы для ключа hasp и устанавливает новые")
$checkXML = GUICtrlCreateCheckbox(" MsXML", 17, 330, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetTip(-1, "")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_browser = GUICtrlCreateGroup("Интернет браузеры", 424, 37, 193, 161)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkFF = GUICtrlCreateCheckbox(" Firefox ESR", 433, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetTip(-1, "+ расширения для FF + отключение обновлений")
$checkChrome = GUICtrlCreateCheckbox(" Google Chrome", 433, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetTip(-1, "+ расширения для Chrome")
$checkIE = GUICtrlCreateCheckbox(" Internet Explorer", 433, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetTip(-1, "Настройка Internet Explorer")
$checkActx_Browser = GUICtrlCreateCheckbox(" Плагины и расширения", 433, 156, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetTip(-1, "ЕФРСБ, Госуслуги, Федресурс")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_ecp = GUICtrlCreateGroup("Электронная подпись", 216, 37, 193, 129)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkCSP = GUICtrlCreateCheckbox(" CryptoPro CSP 4.0 R4", 225, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$checkPKI = GUICtrlCreateCheckbox(" eToken pki client", 225, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$checkCerts = GUICtrlCreateCheckbox(" Сертификаты", 225, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Сертификиты + списки отзывов РР и ФЦИИТ")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_crypto = GUICtrlCreateGroup("Крипто утилиты", 216, 173, 193, 121)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkARM = GUICtrlCreateCheckbox(" Крипто ARM", 225, 193, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$checkPDF = GUICtrlCreateCheckbox(" Крипто PDF", 225, 226, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$checkLine = GUICtrlCreateCheckbox(" Крипто Лайн", 225, 259, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Бесплатный аналог КриптоАРМ (не сертифицированная)")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet2 = GUICtrlCreateTabItem("Программы")
$group_view = GUICtrlCreateGroup("Просмотр изображений", 8, 173, 193, 97)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkIrfan = GUICtrlCreateCheckbox(" IrfanView", 17, 193, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$checkFastStone = GUICtrlCreateCheckbox(" FastStone Viewer", 17, 226, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_rdp = GUICtrlCreateGroup("Удаленный доступ", 8, 277, 193, 97)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkTM = GUICtrlCreateCheckbox(" TeamViewer QS", 17, 297, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Teamviewer Quick Support 9")
$checkAnyDesk = GUICtrlCreateCheckbox(" AnyDesk", 17, 330, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_tools = GUICtrlCreateGroup("Начальная настройка ОС", 8, 37, 193, 129)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkAdobe = GUICtrlCreateCheckbox(" Adobe Reader", 17, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$checkZIP = GUICtrlCreateCheckbox(" 7-Zip", 17, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Архиватор (x32/x64)")
$checkNet_35 = GUICtrlCreateCheckbox(" .Net Framework 3.5", 17, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_other = GUICtrlCreateGroup("Разное", 216, 37, 193, 337)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkTrueConf = GUICtrlCreateCheckbox(" TrueConf", 225, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Видеоконференция")
$check_heidi = GUICtrlCreateCheckbox(" HeidiSQL", 225, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Утилита для работы с БД")
$checkSCP = GUICtrlCreateCheckbox(" WinSCP", 225, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Фтп - клиент")
$checkStart = GUICtrlCreateCheckbox(" StartIsBack", 225, 156, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Возвращает стандартный пуск в win10")
$checkPunto = GUICtrlCreateCheckbox(" PuntoSwitcher", 225, 189, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Автоматическое переключение раскладки + улучшенный буфер обмена")
$checkAccess = GUICtrlCreateCheckbox(" Microsoft Access 97 SR2", 225, 222, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Утилита для восстановление баз данных Экспресса")
$checkWin2PDF = GUICtrlCreateCheckbox(" WinScan2PDF", 225, 255, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Утилита для сканирования в ПДФ")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$TabSheet3 = GUICtrlCreateTabItem("Системные настройки")
$group_os = GUICtrlCreateGroup("Операционная система", 8, 37, 193, 193)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkWinSet = GUICtrlCreateCheckbox(" Настройка Windows", 17, 57, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Открывает порт для . Профиль энергосбережения ОС - 'быстродействие'. Отключает выключение жестких дисков и usb")
$checkMUpdate = GUICtrlCreateCheckbox(" Обновления Win10", 17, 90, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Отключение обновлений Windows 10")
$checkShare = GUICtrlCreateCheckbox(" Общий сетевой доступ", 17, 123, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Настройка общего сетевого доступа для локальной сети")
$checkECPPass= GUICtrlCreateCheckbox(" Пароль от ЭП", 17, 156, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Показывает все сохраненные ранее пароли от ЭП")
$checkSysInfo = GUICtrlCreateCheckbox(" Отчет о системе", 17, 189, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Отчет о системных характеристиках и комплектующих")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_os_tools = GUICtrlCreateGroup("Доп. утилиты", 8, 237, 193, 137)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$checkProduKey = GUICtrlCreateCheckbox(" ProduKey", 17, 257, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Утилита для сохранения серийных номеров от различных программ")
$check_pwd = GUICtrlCreateCheckbox(" PasswordCrack", 17, 290, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Показывает скрытый под звездочками пароль")
$checkC_2008 = GUICtrlCreateCheckbox(" Visual C++ 05-17", 17, 323, 178, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetTip(-1, "Microsoft Visual C++ 2005-2008-2010-2012-2013-2017 Redistributable Package Hybrid x86  x64")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$group_folders = GUICtrlCreateGroup("Часто используемые папки", 216, 37, 193, 337)
GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
$L_NotaryFolder = GUICtrlCreateLabel(" Дистрибутив IT - Helper", 227, 56, 178, 33, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetCursor(-1, 0)
$L_eis = GUICtrlCreateLabel(" Дистрибутив ЕИС Енот", 226, 89, 178, 33, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetCursor(-1, 0)
$L_profile = GUICtrlCreateLabel(" Профиль пользователя", 227, 122, 178, 33, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetCursor(-1, 0)
$L_hosts = GUICtrlCreateLabel(" Доменные имена Hosts", 226, 155, 178, 33, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetCursor(-1, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$btnNewPk = GUICtrlCreateButton("Новый ПК", 2, 408, 83, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_DISABLE)
$btnSpecialist = GUICtrlCreateButton("Тех. работник", 90, 408, 83, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetState(-1, $GUI_DISABLE)
$btnInstall = GUICtrlCreateButton("Установить выбранное", 493, 403, 131, 33, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
GUICtrlSetColor(-1, 0x000000)
$StatusBar1 = _GUICtrlStatusBar_Create($NotaryHelper)
Dim $StatusBar1_PartsWidth[3] = [100, 200, -1]
_GUICtrlStatusBar_SetParts($StatusBar1, $StatusBar1_PartsWidth)
_GUICtrlStatusBar_SetText($StatusBar1, @TAB & @IPAddress1, 0)
_GUICtrlStatusBar_SetText($StatusBar1, @TAB & @ComputerName, 1)
_GUICtrlStatusBar_SetText($StatusBar1, "Готовность к установке", 2)
GUISetState(@SW_SHOW)
Global $AllCheckboxes[38] = [$checkActx_Browser, $checkARM, $checkBD, $checkIE, $checkCerts, $checkCSP, $checkEnot, $checkFNS, $checkFNS_Print, $checkPDF, $checkPKI, $checkIrfan, $checkFastStone, $checkFF, $checkC, $checkNet_35, $checkHASP, $checkChrome, $checkAdobe, $checkWinSet, $checkSCP, $checkZIP, $checkTM, $checkAnyDesk, $checkTrueConf, $checkMUpdate, $checkSQLBACKUP, $checkXML, $checkStart, $checkLine, $check_pwd, $check_heidi, $checkShare, $checkProduKey, $checkPunto, $checkAccess, $checkWin2PDF, $checkECPPass]
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Exit
Case $menuOffline
Local $hFile = FileOpen("portable_helper.bat", 2)
FileWrite($hFile, "start """" """ & @ScriptName & """ -p")
FileClose($hFile)
Case $menuDelete
If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
$iMsgBoxAnswer = MsgBox(33,"Удалить ПО","Данное действие приведение к удалению программы, вы согласны?")
Select
Case $iMsgBoxAnswer = 1
FileDelete(@DesktopDir & "\Нотариальный помощник.lnk")
ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & @ScriptDir & '"', @TempDir, "", @SW_HIDE)
Exit
Case $iMsgBoxAnswer = 2
ContinueCase
EndSelect
Case $menuAbout
MsgBox('', "О программе", "Ситников Виталий, Нотариальная палата Свердловской области. it@npso66.ru")
Case $L_NotaryFolder
Run("explorer.exe " & $Distr)
Case $L_eis
Run("explorer.exe " & $Distr & "Tools\eNot")
Case $L_profile
Run("explorer.exe " & @UserProfileDir & "\AppData")
Case $L_hosts
Run("explorer.exe " & @WindowsDir & "\System32\drivers\etc")
Case $btnInstall
WinMinimizeAll()
WinActivate($NotaryHelper)
GUICtrlSetState($btnInstall, $GUI_DISABLE)
GUICtrlSetState($menuHelp, $GUI_DISABLE)
For $i = 0 To UBound($AllCheckboxes) - 1 Step 1
GUICtrlSetState($AllCheckboxes[$i], $GUI_DISABLE)
Next
_install()
For $i = 0 To UBound($AllCheckboxes) - 1 Step 1
GUICtrlSetState($AllCheckboxes[$i], $GUI_UNCHECKED)
GUICtrlSetState($AllCheckboxes[$i], $GUI_ENABLE)
Next
Status("Установка завершена")
GUICtrlSetState($btnInstall, $GUI_ENABLE)
GUICtrlSetState($menuHelp, $GUI_ENABLE)
EndSwitch
WEnd
GUIDelete($NotaryHelper)
SplashOff()
Exit
