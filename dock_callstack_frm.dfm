object dock_isbl_callstack: Tdock_isbl_callstack
  Left = 0
  Top = 0
  Caption = #1057#1090#1077#1082' '#1074#1099#1079#1086#1074#1086#1074
  ClientHeight = 384
  ClientWidth = 256
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
  PixelsPerInch = 96
  TextHeight = 13
  object underpanel: TsPanel
    Left = 0
    Top = 0
    Width = 256
    Height = 384
    Align = alClient
    Caption = 'underpanel'
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object Panel1: TsPanel
      Left = 1
      Top = 1
      Width = 254
      Height = 20
      Align = alTop
      BevelOuter = bvNone
      Caption = #1057#1090#1077#1082' '#1074#1099#1079#1086#1074#1086#1074
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
    object stack_text: TSynEdit
      Left = 1
      Top = 21
      Width = 254
      Height = 362
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TabOrder = 1
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.Gradient = True
      Gutter.GradientEndColor = clSkyBlue
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = isbl_debugger.JvDockVSNetStyle
    Left = 64
    Top = 56
  end
end