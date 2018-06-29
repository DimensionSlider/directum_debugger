object dock_isbl_ignorelist: Tdock_isbl_ignorelist
  Left = 0
  Top = 0
  Caption = #1057#1082#1088#1099#1090#1099#1077' '#1092#1091#1085#1082#1094#1080#1080
  ClientHeight = 217
  ClientWidth = 195
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object underpanel: TsPanel
    Left = 0
    Top = 0
    Width = 195
    Height = 217
    Align = alClient
    Caption = 'underpanel'
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object Panel1: TsPanel
      Left = 1
      Top = 1
      Width = 193
      Height = 20
      Align = alTop
      BevelOuter = bvNone
      Caption = #1057#1082#1088#1099#1090#1099#1077' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Visible = False
      SkinData.SkinSection = 'PANEL'
    end
    object ignore_list: TsListBox
      Left = 1
      Top = 21
      Width = 193
      Height = 195
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      PopupMenu = ignore_popup
      TabOrder = 1
      OnKeyUp = ignore_listKeyUp
      OnMouseDown = ignore_listMouseDown
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'Tahoma'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
  end
  object ignore_popup: TPopupMenu
    Left = 32
    Top = 48
    object N2: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1080#1075#1085#1086#1088#1080#1088#1086#1074#1072#1085#1080#1077
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      OnClick = N1Click
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    TopDock = False
    BottomDock = False
    DockStyle = isbl_debugger.JvDockVSNetStyle
    Left = 120
    Top = 104
  end
end