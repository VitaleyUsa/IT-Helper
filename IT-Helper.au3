#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Ico\icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Comment=Нотариальная палата Свердловской области
#AutoIt3Wrapper_Res_Description=АйТи помощник от НПСО
#AutoIt3Wrapper_Res_Fileversion=2.0.0.102
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Ситников Виталий
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_File_Add=pass.bmp, 2, 200
#AutoIt3Wrapper_Run_Au3Stripper=y
#AutoIt3Wrapper_UseX64=N
#Au3Stripper_Parameters=/SO /sf /sv /rm
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_Res_HiDpi=Y
;~ #AutoIt3Wrapper_Res_Icon_Add=Ico\icon.ico
#pragma compile(UPX, False)

;~ If @OsType="WIN_10" Then
;~     DllCall("Shcore.dll","long","PROCESS_DPI_AWARENESS",1)
;~ Else
;~     If Not (@Compiled ) Then DllCall("User32.dll","bool","SetProcessDPIAware")
;~ EndIf

Opt("TrayMenuMode", 3)

#include "it-functions.au3"
#include "it-password.au3"

If @Compiled Then
	local $title = _update()
 Else
	local $title = "For building purpose only"
 EndIf



; Main application

$width  = 628
$height = 681

#Region ### START Koda GUI section ### Form=it-helper.kxf
$HelperForm = GUICreate($title, $width, $height, -1, -1, $GUI_SS_DEFAULT_GUI)

$menuFile = GUICtrlCreateMenu("Файл")
	;$menuOffline = GUICtrlCreateMenuItem("Offline - режим", $menuFile)
	$menuDelete = GUICtrlCreateMenuItem("Удалить ПО", $menuFile)
$menuHelp = GUICtrlCreateMenu("Помощь")
	;$menuChangelog = GUICtrlCreateMenuItem("Список изменений", $menuHelp)
	$menuAbout = GUICtrlCreateMenuItem("О программе", $menuHelp)
GUISetFont(12, 400, 0, "Segoe UI")
;~  GUISetBkColor(0xBFCDDB)
GUISetBkColor(0xf85252)

Global $DummyStart = GUICtrlCreateDummy() ; get start of control creation control id

;~ Общие размеры
	$horiz_left  = 8
	$horiz_mid   = 216
	$horiz_right = 424

	$vertic_top = 37

	$margin_inside  = 10
	$margin_between = 26
	$margin_outside = 10

	$width_standart = 193
	$width_full		= 609

	$height = 30
;~ /Общие размеры

$Tab1 = GUICtrlCreateTab(0, 0, 628, 601)
GUICtrlSetFont(-1, 10, 400, 0, "Arial")

#Region ### Начало - Вкладка - Нотариат ###
$TabSheet1 = GUICtrlCreateTabItem("Нотариат")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 8 ; Кол-во элементов $check
		
		$left_of_group = $horiz_left
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_eis = GUICtrlCreateGroup("ЕИС Енот", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkEnotUpdated = GUICtrlCreateCheckbox(" ЕИС Енот | Обновленный", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Дистрибутив ЕИС с интегрированными обновлениями. Собрал Александр Кротов (Архангельск)")

		$checkEnot = GUICtrlCreateCheckbox(" Дистрибутив ЕИС", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkBD = GUICtrlCreateCheckbox(" Дистрибутив MySQL", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Mysql + базы данных еис")

		$checkSQLBACKUP = GUICtrlCreateCheckbox(" Бэкап баз данных ЕИС", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для бэкапа MySQL БД Енота")

		$checkCleanUpdates = GUICtrlCreateCheckbox(" Очистка обновлений", $left, $top_5, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Удаление старых обновлений ЕИС")

		$checkLibReg = GUICtrlCreateCheckbox(" Регистрация библиотек", $left, $top_6, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "vstwain, activetree, capicom, enotddb2, eNotTXres + папки tx/tx23/tx25")

		$checkFindRND = GUICtrlCreateCheckbox(" Пропущ. действия РНД", $left, $top_7, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для поиск пропущенных значений в РНД ЕИС")

		$checkFonts = GUICtrlCreateCheckbox(" Шрифты для ЕИС", $left, $top_8, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Исправление кракозябр в ЕИС")

		#cs
 $checkCapicom = GUICtrlCreateCheckbox(" Компонент Capicom", $left, $top_9, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Необходимый компонент для работы ЕИС")
	
		$checkFeedbackTP = GUICtrlCreateCheckbox(" Обратная связь", $left, $top_10, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Программа для написаний обращений в службы тех. поддержки") 
#ce

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 7 ; Кол-во элементов $check
		
		$left_of_group = $horiz_mid
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_ecp = GUICtrlCreateGroup("Электронная подпись", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkCSP5 = GUICtrlCreateCheckbox(" CryptoPro CSP 5.0", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "КриптоПро CSP 5.0.11455 (Fury) от 8.05.2019")

		$checkCerts = GUICtrlCreateCheckbox(" Сертификаты | общие", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Корневые и промежуточные сертификаты + списки отзывов")

		$checkCertsKey = GUICtrlCreateCheckbox(" Сертификаты | ключ ЭП", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Установка сертификатов с ключевого носителя")

		$checkCertsClean = GUICtrlCreateCheckbox(" Сертификаты | очистка", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Удаление сертификатов с истекшим сроком действия и выпущенных до 6 мая 2022 года")

		$checkJacarta = GUICtrlCreateCheckbox(" Единый Клиент JaCarta", $left, $top_5, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Программный комплекс предназначен для настройки и работы со всеми моделями USB-токенов и смарт-карт JaCarta")

		$checkRutoken = GUICtrlCreateCheckbox(" Драйвер Rutoken", $left, $top_6, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Программный комплекс предназначен для настройки и работы со всеми моделями USB-токенов и смарт-карт Rutoken")

		$checkEsmart = GUICtrlCreateCheckbox(" Драйвер ESmart", $left, $top_7, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Программный комплекс предназначен для настройки и работы со всеми моделями USB-токенов и смарт-карт Esmart")


	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top - 7 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 2 ; Кол-во элементов $check
		
		$left_of_group = $horiz_mid
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_fns = GUICtrlCreateGroup("ФНС", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkFNS2 = GUICtrlCreateCheckbox(" ППДГР", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Обновленная версия ППДГР")

		$checkFNS_Print = GUICtrlCreateCheckbox(" Модуль печати", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Восстанавливает модуль печати для ППДГР")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 3 ; Кол-во элементов $check
		
		$left_of_group = $horiz_right
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_browser = GUICtrlCreateGroup("Веб - браузеры", $left_of_group, $top_of_group, $width_of_group , $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		;~ $checkFF = GUICtrlCreateCheckbox(" Firefox ESR", $left, 57, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		;~ GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		;~ GUICtrlSetTip(-1, "+ расширения для FF + отключение обновлений")

		$checkChrome = GUICtrlCreateCheckbox(" Google Chrome", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "+ расширения для Chrome")

		$checkIE = GUICtrlCreateCheckbox(" Internet Explorer", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Настройка Internet Explorer")

		$checkActx_Browser = GUICtrlCreateCheckbox(" Плагины и расширения", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "ЕФРСБ, Госуслуги, Федресурс")
	
	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top - 7 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 4 ; Кол-во элементов $check
		
		$left_of_group = $horiz_right
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_crypto = GUICtrlCreateGroup("Крипто - утилиты", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkARM = GUICtrlCreateCheckbox(" Крипто ARM", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkPDF = GUICtrlCreateCheckbox(" Крипто PDF", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkLine = GUICtrlCreateCheckbox(" Крипто Лайн", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Бесплатный аналог КриптоАРМ (несертифицированная)")

		$checkNGate = GUICtrlCreateCheckbox(" Крипто NGate - клиент", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Защищенное VPN - соединение")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 1 ; Кол-во элементов $check
		
		$left_of_group = $horiz_right
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_palata = GUICtrlCreateGroup("Нотариальная палата", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
		
		$check_palata = GUICtrlCreateCheckbox(" Отчеты ЕИС 'Енот'", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Отчеты ЕИС 'Енот' для палат | (разраб. Артём Поляков, Уфа)")
	
	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top - 7 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 6 ; Кол-во элементов $check
		
		$left_of_group = $horiz_left
		$width_of_group = $width_full

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_kleis = GUICtrlCreateGroup("Клиент ЕИС", $left_of_group , $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
		
		$checkKLEIS_Main = GUICtrlCreateCheckbox(" Основное рабочее место Клиента ЕИС", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Клиент ЕИС для основного ПК")

		$checkKLEIS_Sec = GUICtrlCreateCheckbox(" Второстепенное рабочее место Клиента ЕИС", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Клиент ЕИС для второстепенного рабочего места")

		$checkKLEIS_Helper = GUICtrlCreateCheckbox(" Помощник КЛЕИС | решение распространенных проблем", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Помощник по КЛЕИС | решение распространенных проблем")

		$checkKLEIS_Diagnostic = GUICtrlCreateCheckbox(" Диагностика клиента ЕИС (разраб. Артём Поляков, Уфа)", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Позволяет диагностировать состояние, а также исправлять ошибки: «Клиент ЕИС», «Служба Синхронизации с ЕИС», «БД EisDB». А так же осуществлять резервное копирование/восстановление БД.")

		$check_heidi = GUICtrlCreateCheckbox(" HeidiSQL | работа с бд клеис", $left, $top_5, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		;GUICtrlSetTip(-1, "Утилита для работы с БД")

		$checkKLEIS_RNP = GUICtrlCreateCheckbox(" КЛЕИС для Палат (только!)", $left, $top_6, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

#EndRegion ### Конец - Вкладка - Нотариат ###

#Region ### Начало - Вкладка - Программы ###

$TabSheet2 = GUICtrlCreateTabItem("Программы")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 6 ; Кол-во элементов $check
		
		$left_of_group = $horiz_left
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_tools = GUICtrlCreateGroup("Начальная настройка ОС", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkAdobe = GUICtrlCreateCheckbox(" Adobe Reader", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkZIP = GUICtrlCreateCheckbox(" 7-Zip", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Архиватор (x32/x64)")

		$checkNet_48 = GUICtrlCreateCheckbox(" .Net Framework 4.8", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkStart = GUICtrlCreateCheckbox(" StartIsBack", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Возвращает стандартный пуск в win10")

		$checkOpenShell = GUICtrlCreateCheckbox(" OpenShell", $left, $top_5, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Бесплатная версия классического меню пуск для Windows10")

		$checkPunto = GUICtrlCreateCheckbox(" PuntoSwitcher", $left, $top_6, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Автоматическое переключение раскладки + улучшенный буфер обмена")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top - 7 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 5 ; Кол-во элементов $check
		
		$left_of_group = $horiz_left
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_office = GUICtrlCreateGroup("Офисные программы", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
		
		$check_libre = GUICtrlCreateCheckbox(" LibreOffice ", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Бесплатная альтернатива Microsoft Office")

		$checkPDF24 = GUICtrlCreateCheckbox(" DOC -> PDF24 ", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Программа для преобразования офисных файлов в PDF")

		$checkNaps2 = GUICtrlCreateCheckbox(" NAPS2", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Бесплатная программа для сканирования в разные форматы")

		$checkWin2PDF = GUICtrlCreateCheckbox(" WinScan2PDF", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для сканирования в ПДФ")

		$checkXMLPad = GUICtrlCreateCheckbox(" XML Notepad", $left, $top_5, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Блокнот для визуализации XML-файлов")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 4 ; Кол-во элементов $check
		
		$left_of_group = $horiz_mid
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_crypto_others = GUICtrlCreateGroup("КриптоПро (не актуальные)", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkCSP5R2 = GUICtrlCreateCheckbox(" CryptoPro CSP 5.0 R2", $left, $top_1, $width, $height)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "КриптоПро для Windows 11 | ключи от 4 версии не совместимы")

		$checkCSP = GUICtrlCreateCheckbox(" CryptoPro CSP 4.0 R4", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma") 

		$checkCSPclean = GUICtrlCreateCheckbox(" CSP Clean", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита очистки следов установки продуктов КриптоПро")

		$checkPKI = GUICtrlCreateCheckbox(" Драйвер eToken pki client", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma") 
		GUICtrlSetTip(-1, "Программный комплекс предназначен для настройки и работы со всеми моделями USB-токенов и смарт-карт Etoken")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top - 7 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 4 ; Кол-во элементов $check
		
		$left_of_group = $horiz_mid
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_express = GUICtrlCreateGroup("Экспресс", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkHasp = GUICtrlCreateCheckbox(" HASP Драйвер", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Удаляет старые драйверы для ключа hasp и устанавливает новые")

		$checkXPSPrinter = GUICtrlCreateCheckbox(" XPS - принтер", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Установка xps - принтера для Экспресс")

		$checkAccess = GUICtrlCreateCheckbox(" Microsoft Access 97 SR2", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для восстановление баз данных Экспресса")

		$checkWebKit = GUICtrlCreateCheckbox(" Chrome 4 Express", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Осмотр страниц в экспрессе будет работать на движке chrome")

		;$checkXML = GUICtrlCreateCheckbox(" MsXML", $left, 123, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top - 7 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 5 ; Кол-во элементов $check
		
		$left_of_group = $horiz_mid
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_rdp = GUICtrlCreateGroup("Удаленный доступ", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkTM = GUICtrlCreateCheckbox(" TeamViewer QS", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Teamviewer Quick Support")

		$checkAnyDesk = GUICtrlCreateCheckbox(" AnyDesk", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkAssistant = GUICtrlCreateCheckbox(" Assistant", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkAssistantNotariusIT = GUICtrlCreateCheckbox(" Ассистент нотариуса IT", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Предназначен для облегчения работы нотариусов и ИТ специалистов")

		$checkKonturDostup = GUICtrlCreateCheckbox(" Контур.Доступ", $left, $top_5, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Контур.Доступ - удаленный доступ")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 3 ; Кол-во элементов $check
		
		$left_of_group = $horiz_right
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_other2 = GUICtrlCreateGroup("Инфо о системе", $left_of_group, $top_of_group , $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkSpaceSniffer = GUICtrlCreateCheckbox(" SpaceSniffer", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Программа для определения оставшегося свободного места")

		$checkDiskInfo = GUICtrlCreateCheckbox(" CrystalDiskInfo", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Программа для определения состояния жесткого диска")

		$checkHWInfo = GUICtrlCreateCheckbox(" HWInfo", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Информация о системе")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top - 7 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 2 ; Кол-во элементов $check
		
		$left_of_group = $horiz_right
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_view = GUICtrlCreateGroup("Просмотрщики фото", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkIrfan = GUICtrlCreateCheckbox(" IrfanView", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$checkFastStone = GUICtrlCreateCheckbox(" FastStone Viewer", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top - 7 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 3 ; Кол-во элементов $check
		
		$left_of_group = $horiz_right
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_other = GUICtrlCreateGroup("Сетевые программы", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkTrueConf = GUICtrlCreateCheckbox(" TrueConf", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Видеоконференция")

		$checkSCP = GUICtrlCreateCheckbox(" WinSCP", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Фтп - клиент")

		$checkIPScanner = GUICtrlCreateCheckbox(" Advanced IP Scanner", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT,$BS_FLAT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Сканер локальных сетей")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $height_of_group + $top + 120 ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 2 ; Кол-во элементов $check
		
		$left_of_group = $horiz_left
		$width_of_group = $width_full

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_av = GUICtrlCreateGroup("Антивирусное ПО", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")
		
		$check_kes = GUICtrlCreateCheckbox(" Kaspersky SECURITY ДЛЯ БИЗНЕСА | Сертифицированная защита для ФЗ 152", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		$check_ksc = GUICtrlCreateCheckbox(" Kaspersky Security Cloud Free | Бесплатный антивирус", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

#EndRegion ### Конец - Вкладка - Программы ###

#Region ### Начало - Вкладка - Системные настройки ###

$TabSheet3 = GUICtrlCreateTabItem("Системные настройки")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 9 ; Кол-во элементов $check
		
		$left_of_group = $horiz_left
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_os = GUICtrlCreateGroup("Операционная система", $left_of_group, $top_of_group, $width_of_group, $height_of_group)
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkWinSet = GUICtrlCreateCheckbox(" Настройка Windows", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Открывает порт для MySQL. Профиль энергосбережения ОС - 'быстродействие'. Отключает выключение жестких дисков и usb. Добавляет в исключения антивируса папки Triasoft")
		
		$checkMUpdate = GUICtrlCreateCheckbox(" Обновления Win10", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Отключение / включение обновлений Windows 10")
		
		$checkShare = GUICtrlCreateCheckbox(" Общий сетевой доступ", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Настройка общего сетевого доступа для локальной сети")
		
		$checkECPPass= GUICtrlCreateCheckbox(" Пароль от ЭП", $left, $top_4, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Показывает все сохраненные ранее пароли от ЭП")
		
		$checkSysInfo = GUICtrlCreateCheckbox(" Отчет о системе", $left, $top_5, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Отчет о системных характеристиках и комплектующих")

		$checkEvent292 = GUICtrlCreateCheckbox(" Событие CproCtrl", $left, $top_6, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
			GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
			GUICtrlSetTip(-1, "Исправление для ошибки 256 и 292 (CproCtrl) возникающей после обновления ОС")

		$checkCleanTask = GUICtrlCreateCheckbox(" Очистка журналов", $left, $top_7, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
			GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
			GUICtrlSetTip(-1, "Очищает все журналы операционной системы")
		
		$checkPhotoViewer = GUICtrlCreateCheckbox(" Просмотр фотографий", $left, $top_8, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
			GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
			GUICtrlSetTip(-1, "Возвращает классическое средство Просмотра фотографий в Windows 10")

		$checkMetrics = GUICtrlCreateCheckbox(" Метрика VPN Ngate", $left, $top_9, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
			GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
			GUICtrlSetTip(-1, "Устанавливает метрику 1 для Ngate. VPN Ngate должен быть запущен и подключен.")

	
	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 3 ; Кол-во элементов $check
		
		$left_of_group = $horiz_mid
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_os_tools = GUICtrlCreateGroup("Доп. утилиты", $left_of_group, $top_of_group, $width_of_group, $height_of_group) 
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$checkProduKey = GUICtrlCreateCheckbox(" Серийные номера", $left, $top_1, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Утилита для сохранения серийных номеров от различных программ (криптопро, арм, офис, ос)")
		
		$check_pwd = GUICtrlCreateCheckbox(" PasswordCrack", $left, $top_2, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Показывает скрытый под звездочками пароль")
		
		$checkC = GUICtrlCreateCheckbox(" Visual C++ 05-19", $left, $top_3, $width, $height, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_LEFT))
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetTip(-1, "Microsoft Visual C++ 2005-2008-2010-2012-2013-2017-2019 Redistributable Package Hybrid x86  x64")

	;~ Тупое задание размеров блоков
		;~ Явно заданные размеры
		$top_of_group = $vertic_top ; Отступ по вертикали
		$height_of_group = $margin_outside + $margin_between + $margin_between * 5 ; Кол-во элементов $check
		
		$left_of_group = $horiz_right
		$width_of_group = $width_standart

		;~ Пересчитываемые значения
		
		$top = $top_of_group + 10
		$left = $left_of_group + $margin_inside
		$width = $width_of_group - 11
		
		$top_1 = $top + 10
		$top_2 = $top_1 + $margin_between
		$top_3 = $top_2 + $margin_between
		$top_4 = $top_3 + $margin_between
		$top_5 = $top_4 + $margin_between
		$top_6 = $top_5 + $margin_between
		$top_7 = $top_6 + $margin_between
		$top_8 = $top_7 + $margin_between
		$top_9 = $top_8 + $margin_between
		$top_10 = $top_9 + $margin_between
	;~ /Тупое задание размеров блоков

	$group_folders = GUICtrlCreateGroup("Часто используемые папки", $left_of_group, $top_of_group, $width_of_group, $height_of_group) 
		GUICtrlSetFont(-1, 10, 800, 0, "Arial Narrow")

		$L_NotaryFolder = GUICtrlCreateLabel(" Дистрибутив помощника", $left, $top_1, $width, $height, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetCursor (-1, 0)
		
		$L_eis = GUICtrlCreateLabel(" Дистрибутив ЕИС Енот", $left, $top_2, $width, $height, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetCursor (-1, 0)
		
		$L_profile = GUICtrlCreateLabel(" Профиль пользователя", $left, $top_3, $width, $height, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetCursor (-1, 0)
		
		$L_hosts = GUICtrlCreateLabel(" Доменные имена Hosts", $left, $top_4, $width, $height, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
		GUICtrlSetCursor (-1, 0)
		
		$L_Logs = GUICtrlCreateLabel(" Журнал операций", $left, $top_5, $width, $height, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

		GUICtrlSetCursor (-1, 0)
	
	GUICtrlCreateTabItem("")
#EndRegion ### Конец - Вкладка - Системные настройки ###

Global $DummyEnd = GUICtrlCreateDummy()

#Region ### Начало - Кнопки ###
	;$btnNewPk = GUICtrlCreateButton("Новый ПК", 2, 608, 83, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
	;GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
	;GUICtrlSetColor(-1, 0x000000)

	;$btnSpecialist = GUICtrlCreateButton("Тех. работник", 90, 608, 83, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
	;GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
	;GUICtrlSetColor(-1, 0x000000)

	;$btnDownloadOnly = GUICtrlCreateButton("Скачать", 178, 608, 83, 25, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
	;GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
	;GUICtrlSetColor(-1, 0x000000)

	$btnInstall = GUICtrlCreateButton("Установить", 493, 604, 131, 33, BitOR($BS_DEFPUSHBUTTON,$BS_PUSHLIKE))
	GUICtrlSetFont(-1, 10, 400, 0, "Arial Narrow")
	GUICtrlSetColor(-1, 0x000000)
#EndRegion ### Конец - Кнопки ###

#Region ### Начало - Tray ###
Local $iSettings = TrayCreateMenu("Настройки") ; Создаем трей меню
;Local $iOffline = TrayCreateItem("Offline - режим", $iSettings)
Local $iRemove = TrayCreateItem("Удалить ПО", $iSettings)
TrayCreateItem("")
;Local $iChangelog = TrayCreateItem("Изменения")
;Local $iAbout = TrayCreateItem("О программе")
TrayCreateItem("")
Local $iExit = TrayCreateItem("Выйти")

TraySetState($TRAY_ICONSTATE_SHOW) ; Показываем трей меню
#Region ### Конец - Tray ###

#Region ### Начало - Строка состояния ###
$StatusBar1 = _GUICtrlStatusBar_Create($HelperForm)
Dim $StatusBar1_PartsWidth[3] = [100, 200, -1]
_GUICtrlStatusBar_SetParts($StatusBar1, $StatusBar1_PartsWidth)
_GUICtrlStatusBar_SetText($StatusBar1, @TAB & @IPAddress1, 0)
_GUICtrlStatusBar_SetText($StatusBar1, @TAB & @ComputerName, 1)
_GUICtrlStatusBar_SetText($StatusBar1, "Готовность к установке", 2)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY") ; определяем статус бар
#Region ### Конец - Строка состояния ###


GUISetState(@SW_SHOW)

;~ $HelperChild = GUICreate($title, $width, $height, -1, -1, $GUI_SS_DEFAULT_GUI)
;~ 	GUISetFont(12, 400, 0, "Segoe UI")
;~ 	GUISetBkColor(0xf85252)
;~ 	GUISetState($GUI_HIDE, $HelperChild)

;~ $ListView = GUICtrlCreateList("", 0, 0, 628, 421, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_NOSEL), 0)


;~ $StatusBar2 = _GUICtrlStatusBar_Create($HelperChild)
;~ Dim $StatusBar2_PartsWidth[3] = [100, 200, -1]
;~ _GUICtrlStatusBar_SetParts($StatusBar2, $StatusBar2_PartsWidth)
;~ _GUICtrlStatusBar_SetText($StatusBar2, @TAB & @IPAddress1, 0)
;~ _GUICtrlStatusBar_SetText($StatusBar2, @TAB & @ComputerName, 1)
;~ _GUICtrlStatusBar_SetText($StatusBar2, "Готовность к установке", 2)
;~ GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY") ; определяем статус бар


#EndRegion ### END Koda GUI section ###

; _______________________Открытие формы_______________________

Global $AllCheckboxes[78] = [$checkActx_Browser, $checkARM, $checkBD, _
		$checkIE, $checkCerts, $checkCertsClean, $checkCertsKey, $checkCSP, _
		$checkEnot, $checkFNS2, $checkFNS_Print, _
		$checkPDF, $checkPKI, $checkIrfan, $checkFastStone, _
		$checkFF, $checkC, $checkNet_48, _
		$checkHASP, $checkChrome, $checkAdobe, $checkWinSet, $checkSCP, $checkZIP, _
		$checkTM, $checkAnyDesk, $checkAssistant, $checkAssistantNotariusIT, $checkKonturDostup, $checkTrueConf, $checkMUpdate, $checkSQLBACKUP, $checkOpenShell, _
		$checkStart, $checkLine, $check_pwd, $check_heidi, $checkKLEIS_RNP, $checkShare, $checkProduKey, _
		$checkPunto, $checkAccess, $checkWin2PDF, $checkECPPass, $checkSysInfo, $checkIPScanner, _
		$checkXMLPad, $checkLibReg, $checkCleanUpdates, $checkFindRND, $checkEvent292, _
		$checkCleanTask, $checkCSPclean, $checkCSP5, $checkJacarta, $checkRutoken, $checkEsmart, _ 
		$checkPhotoViewer, $checkFonts, _
		$checkNaps2, $checkSpaceSniffer, $checkDiskInfo, $checkHWInfo, $checkWebKit, $checkEnotUpdated, _
		$checkNGate, $checkPDF24, _
		$checkKLEIS_Main, $checkKLEIS_Sec, $checkKLEIS_Helper, $checkKLEIS_Diagnostic, $check_palata, _ 
		$check_libre, $check_kes, $check_ksc, $checkCSP5R2, $checkXPSPrinter, $checkMetrics] ; Массив из чекбоксов

; Сертификаты
If $Start_param_certs Then
	GUISetState(@SW_HIDE)
	GUICtrlSetState($checkCerts, $GUI_CHECKED)
	_Next()
	;SplashTextOn("Статус", "Сертификаты успешно установлены ", 480, 45, -1, -1, 1, "", 16)
	;Sleep(4000)
	Exit
EndIf

; РНД
If $Start_param_MissedRND Then
	GUISetState(@SW_HIDE)
	GUICtrlSetState($checkFindRND, $GUI_CHECKED)
	_Next()
	Exit
EndIf

If $Start_param_FNS Then
	GUISetState(@SW_HIDE)
	GUICtrlSetState($checkFNS2, $GUI_CHECKED)
	_Next()
	Exit
EndIf

While 1
	$nMsg = GUIGetMsg()

	 If _IsPressed("01") Then ToolTip("")

	Switch $nMsg
		Case $GUI_EVENT_CLOSE ; Выход
			Exit

		#comments-start
		; Оффлайн - режим
		Case $menuOffline
			$offline = IniRead($dir_distr & $VersionInfo, "MODE", "Offline", "0")
			Switch $offline
				Case 1
					$offline = 0
					$title = StringTrimRight($title, 16)
				Case 0
					$title = $title & " | Оффлайн режим"
					$offline = 1
			EndSwitch
			WinSetTitle($HelperForm,"",$title)
			IniWrite($dir_distr & $VersionInfo, "MODE", "Offline", $offline)
		#comments-end

		; Самоуничтожение программы
		Case $menuDelete
			If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(33,"Удалить ПО","Данное действие приведёт к удалению программы, вы уверены?")
			Select
				Case $iMsgBoxAnswer = 1 ;OK
					FileDelete(@DesktopDir & "\" & $HelperName)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_enot & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_tools & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_logs & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_update & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_ecp & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_express & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_federal & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_software & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_certs & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_ppdgr & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f "' & $dir_distr & "_main.exe" & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f "' & $dir_distr & $MainApp & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f /Q "' & $dir_distr & $VersionInfo & '"', @TempDir, "", @SW_HIDE)
					Exit

			   Case $iMsgBoxAnswer = 2 ;Cancel
				ContinueCase
			EndSelect

		; О программе
		Case $menuAbout
			MsgBox($MB_SYSTEMMODAL, "", "" & @CRLF & _
					"Ситников Виталий" & @CRLF & _
					"Нотариальная палата Свердловской области" & @CRLF & _
					"it@npso66.ru" & @CRLF & _
					"Внесли вклад в разработку:" & @CRLF & _
					"Поляков Артем | Уфа" & @CRLF & _
					"Кротов Александр | Архангельск")

		; История изменений
		;~ Case $menuChangelog
		;~ 	ShellExecute("http://" & $User & ":" &$Pass & "@" & $Server & "/Statistic/index.html")

		; Часто используемые папки
		Case $L_NotaryFolder
			Run("explorer.exe " & $dir_distr)

		Case $L_eis
			Run("explorer.exe " & $dir_enot)

		Case $L_profile
			Run("explorer.exe " & @UserProfileDir & "\AppData")

		Case $L_hosts
			Run("explorer.exe " & @WindowsDir & "\System32\drivers\etc")

		Case $L_Logs
			Run("explorer.exe " & $dir_logs)

		; Кнопки

		;Case $btnNewPk ; Кнопка Новый ПК
		;	_Next("Настройка ПК завершена", False, "NewPK")

		;Case $btnSpecialist ; Кнопка Тех. работник
		;	_Next("Рабочее место тех. работника настроено", False, "Specialist")

		;Case $btnDownloadOnly ; Кнопка СКАЧАТЬ
		;	_Next("Загрузка завершена", True)
;~ 		;	test()

		Case $btnInstall ; Кнопка УСТАНОВИТЬ
			_Next()

	EndSwitch

	Switch TrayGetMsg()
		#comments-start
		Case $iOffline
			$offline = IniRead($dir_distr & $VersionInfo, "MODE", "Offline", "0")
			Switch $offline
				Case 1
					$offline = 0
					$title = StringTrimRight($title, 16)
				Case 0
					$title = $title & " | Оффлайн режим"
					$offline = 1
			EndSwitch
			WinSetTitle($HelperForm,"",$title)
			IniWrite($dir_distr & $VersionInfo, "MODE", "Offline", $offline)
		#comments-end

		Case $iRemove
			If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(33,"Удалить ПО","Данное действие приведёт к удалению программы, вы уверены?")
			Select
				Case $iMsgBoxAnswer = 1 ;OK
					FileDelete(@DesktopDir & "\" & $HelperName)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_enot & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_tools & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_logs & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_update & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_ecp & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_express & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_federal & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_software & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_certs & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & RmDir /S /Q "' & $dir_ppdgr & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f "' & $dir_distr & "_main.exe" & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f "' & $dir_distr & $MainApp & '"', @TempDir, "", @SW_HIDE)
					ShellExecute(@ComSpec, ' /c TimeOut 3 & Del /f /Q "' & $dir_distr & $VersionInfo & '"', @TempDir, "", @SW_HIDE)
					Exit

			   Case $iMsgBoxAnswer = 2 ;Cancel
				ContinueCase
			EndSelect

		#comments-start
		Case $iAbout 
			MsgBox($MB_SYSTEMMODAL, "", @CRLF & _
					"Ситников Виталий" & @CRLF & _
					"Нотариальная палата Свердловской области" & @CRLF & _
					"it@npso66.ru")
		#comments-end

		;~ Case $iChangelog
		;~ 	ShellExecute("http://" & $User & ":" &$Pass & "@" & $Server & "/Statistic/index.html")

		Case $iExit ; выход
			Exit
	EndSwitch
WEnd
GUIDelete($HelperForm)
Exit

Func test()
;~ 	Local Static $toggle = True
;~     $toggle = Not $toggle

;~ 	If $toggle Then
;~ 		GUISetState(@SW_HIDE, $HelperForm)

;~ 	Else

;~ 	For $Loop = $DummyStart + 1 To $DummyEnd - 1
;~ 		If GUICtrlRead($Loop) = $GUI_CHECKED Then GUICtrlCreateListViewItem(GUICtrlRead($Loop, $GUI_READ_EXTENDED), $ListView)
;~     Next

;~ 		GUISetState(@SW_HIDE, $HelperForm)
;~ 		GUISetState(@SW_SHOW, $HelperChild)
;~ 			While 1
;~                 Switch GUIGetMsg()
;~                     Case $GUI_EVENT_CLOSE
;~                         GUISetState(@SW_HIDE, $HelperChild)
;~                         GUISetState(@SW_SHOW, $HelperForm)
;~ 						_GUICtrlListView_DeleteAllItems($ListView)
;~                         ExitLoop
;~                 EndSwitch
;~             WEnd
;~ 	EndIf

;~ 	If Not $toggle Then
;~ 		GUICtrlSetState($ListView, $GUI_SHOW)
;~ 	EndIf
;~ 	If $toggle Then
;~ 		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView))
;~ 		GUICtrlSetState($ListView, $GUI_HIDE)
;~ 	EndIf

EndFunc   ;==>Button1Click