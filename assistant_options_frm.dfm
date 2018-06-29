object dock_assistant_options: Tdock_assistant_options
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 196
  ClientWidth = 354
  Color = clBtnFace
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object tool_panel: TsPanel
    Left = 0
    Top = 0
    Width = 354
    Height = 196
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object Label1: TsLabel
      Left = 16
      Top = 164
      Width = 74
      Height = 14
      Caption = #1043#1086#1088'. '#1082#1083#1072#1074#1080#1096#1072
      ParentFont = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
    end
    object group_1: TsGroupBox
      Left = 8
      Top = 6
      Width = 337
      Height = 89
      Caption = #1042#1089#1090#1072#1074#1082#1072' '#1087#1086' '#1076#1074#1086#1081#1085#1086#1084#1091' '#1085#1072#1078#1072#1090#1080#1102
      TabOrder = 0
      SkinData.SkinSection = 'GROUPBOX'
      object preproc_mode_rbtn: TsRadioButton
        Left = 11
        Top = 15
        Width = 211
        Height = 20
        Caption = 'Prepro'#1089' '#1055#1086#1083#1085#1086#1077' !'#1056#1050#1050'!.!'#1056#1050#1050'.'#1056#1077#1082#1074#1080#1079#1080#1090'!'
        TabOrder = 0
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object name_mode_rbtn: TsRadioButton
        Left = 10
        Top = 50
        Width = 39
        Height = 20
        Caption = #1048#1084#1103
        TabOrder = 2
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object full_bdfield_rbtn: TsRadioButton
        Left = 10
        Top = 66
        Width = 105
        Height = 20
        Caption = #1058#1072#1073#1083#1080#1094#1072'.'#1055#1086#1083#1077#1041#1044
        TabOrder = 4
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object preproc_mode_short_rbtn: TsRadioButton
        Left = 10
        Top = 33
        Width = 181
        Height = 20
        Caption = 'Preproc '#1082#1088#1072#1090#1082#1086'  !'#1056#1050#1050'.'#1056#1077#1082#1074#1080#1079#1080#1090'!'
        Checked = True
        TabOrder = 1
        TabStop = True
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object bdfield_rbtn: TsRadioButton
        Left = 120
        Top = 66
        Width = 62
        Height = 20
        Caption = #1055#1086#1083#1077' '#1041#1044
        TabOrder = 5
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object Button1: TsButton
        Left = 259
        Top = 59
        Width = 75
        Height = 23
        Caption = 'Button1'
        TabOrder = 3
        SkinData.SkinSection = 'BUTTON'
      end
    end
    object group_2: TsGroupBox
      Left = 9
      Top = 101
      Width = 336
      Height = 57
      Caption = #1054#1092#1086#1088#1084#1083#1077#1085#1080#1077' '#1074#1089#1090#1072#1074#1082#1080
      TabOrder = 1
      SkinData.SkinSection = 'GROUPBOX'
      object quotes_mode_rbtn: TsRadioButton
        Left = 8
        Top = 34
        Width = 83
        Height = 20
        Caption = #1042' '#1086#1076#1080#1085'. '#1082#1072#1074'.'
        TabOrder = 2
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object double_quotes_mode_rbtn: TsRadioButton
        Left = 49
        Top = 16
        Width = 99
        Height = 20
        Caption = #1042' '#1076#1074#1086#1081#1085#1099#1093' '#1082#1072#1074'.'
        TabOrder = 1
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object noquotes_mode_rbtn: TsRadioButton
        Left = 8
        Top = 16
        Width = 37
        Height = 20
        Caption = #1041#1077#1079
        Checked = True
        TabOrder = 0
        TabStop = True
        SkinData.SkinSection = 'RADIOBUTTON'
      end
    end
    object HotKey1: THotKey
      Left = 96
      Top = 161
      Width = 129
      Height = 19
      HotKey = 32833
      InvalidKeys = [hcNone]
      TabOrder = 2
      OnChange = HotKey1Change
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    Left = 296
    Top = 200
  end
end
