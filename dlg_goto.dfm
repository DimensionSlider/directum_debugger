object dialog_goto: Tdialog_goto
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1077#1081#1090#1080' '#1082' '#1089#1090#1088#1086#1082#1077
  ClientHeight = 99
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 15
    Width = 69
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1089#1090#1088#1086#1082#1080
  end
  object ed_string_num: TEdit
    Left = 20
    Top = 34
    Width = 251
    Height = 21
    TabOrder = 0
    OnKeyPress = ed_string_numKeyPress
  end
  object btnGo: TButton
    Left = 196
    Top = 65
    Width = 75
    Height = 25
    Caption = #1055#1077#1088#1077#1081#1090#1080
    TabOrder = 1
    OnClick = btnGoClick
  end
  object btn_cancel: TButton
    Left = 115
    Top = 66
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = btn_cancelClick
  end
end
