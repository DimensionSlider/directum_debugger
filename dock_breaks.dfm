object dock_steps_form: Tdock_steps_form
  Left = 0
  Top = 0
  Align = alCustom
  Caption = #1064#1072#1075#1080
  ClientHeight = 551
  ClientWidth = 304
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
  object Panel1: TsPanel
    Left = 0
    Top = 0
    Width = 304
    Height = 551
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object steps_tree: TVirtualStringTree
      Left = 0
      Top = 22
      Width = 304
      Height = 503
      Align = alClient
      Ctl3D = True
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Images = isbl_debugger.ImageList1
      ParentCtl3D = False
      TabOrder = 1
      OnChange = steps_treeChange
      OnFocusChanged = steps_treeFocusChanged
      OnFreeNode = steps_treeFreeNode
      OnGetText = steps_treeGetText
      OnGetImageIndex = steps_treeGetImageIndex
      Columns = <
        item
          Position = 0
          Width = 100
          WideText = #8470' '#1096#1072#1075#1072
        end
        item
          Position = 1
          Width = 100
          WideText = #1057#1090#1088#1086#1082#1072
        end>
    end
    object ToolBar2: TsToolBar
      Left = 0
      Top = 0
      Width = 304
      Height = 22
      AutoSize = True
      ButtonWidth = 27
      Caption = 'ToolBar'
      DoubleBuffered = True
      Images = isbl_debugger.ImageList
      ParentDoubleBuffered = False
      TabOrder = 0
      Transparent = False
      SkinData.SkinSection = 'TOOLBAR'
      object button_prev_brake: TToolButton
        Left = 0
        Top = 0
        Caption = 'button_prev_brake'
        ImageIndex = 0
        OnClick = button_prev_brakeClick
      end
      object button_next_brake: TToolButton
        Left = 27
        Top = 0
        Caption = 'button_next_brake'
        ImageIndex = 1
        OnClick = button_next_brakeClick
      end
    end
    object Panel3: TsPanel
      Left = 0
      Top = 525
      Width = 304
      Height = 26
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      SkinData.SkinSection = 'PANEL'
      object box_show_selected: TsCheckBox
        Left = 6
        Top = 6
        Width = 117
        Height = 20
        Caption = #1058#1086#1083#1100#1082#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
        TabOrder = 0
        OnClick = box_show_selectedClick
        SkinData.SkinSection = 'CHECKBOX'
        ImgChecked = 0
        ImgUnchecked = 0
      end
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = isbl_debugger.JvDockVSNetStyle
    Left = 216
    Top = 72
  end
end