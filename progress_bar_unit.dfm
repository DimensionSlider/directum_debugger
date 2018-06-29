object progress_bar_form: Tprogress_bar_form
  Left = 783
  Top = 342
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1055#1086#1076#1086#1078#1076#1080#1090#1077'...'
  ClientHeight = 109
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object title: TsLabel
    Left = 16
    Top = 24
    Width = 134
    Height = 13
    Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1087#1088#1086#1094#1077#1076#1091#1088#1099
    ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
  end
  object detail_text: TsLabel
    Left = 16
    Top = 88
    Width = 50
    Height = 13
    Caption = #1044#1077#1090#1072#1083#1100#1085#1086
    Visible = False
  end
  object ammount_done: TsLabel
    Left = 16
    Top = 69
    Width = 29
    Height = 13
    Caption = '0 '#1080#1079' 0'
  end
  object progress: TsProgressBar
    Left = 16
    Top = 48
    Width = 281
    Height = 17
    TabOrder = 0
    SkinData.SkinSection = 'GAUGE'
  end
end