object dock_isbl_tree: Tdock_isbl_tree
  Left = 0
  Top = 0
  Caption = 'dock_isbl_tree'
  ClientHeight = 514
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object underpanel: TsPanel
    Left = 0
    Top = 20
    Width = 426
    Height = 494
    Align = alClient
    Caption = 'underpanel'
    TabOrder = 0
    object Panel1: TsPanel
      Left = 4
      Top = 1
      Width = 421
      Height = 492
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 0
      object tree: TVirtualStringTree
        Left = 0
        Top = 70
        Width = 421
        Height = 396
        Align = alClient
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        Images = DIRAssistant.ImageList
        PopupMenu = tree_PopupMenu
        TabOrder = 0
        OnContextPopup = treeContextPopup
        OnFocusChanged = treeFocusChanged
        OnGetText = treeGetText
        OnGetImageIndex = treeGetImageIndex
        Columns = <>
      end
      object filter_panel: TsPanel
        Left = 0
        Top = 0
        Width = 421
        Height = 48
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object filter_label: TsLabel
          Left = 2
          Top = 5
          Width = 106
          Height = 14
          Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
          ParentFont = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = 3484708
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
        end
        object filter_ed: TsEdit
          Left = -3
          Top = 25
          Width = 266
          Height = 22
          Color = clWhite
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = filter_edChange
        end
      end
      object Panel3: TsPanel
        Left = 0
        Top = 466
        Width = 421
        Height = 26
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object box_dont_show_hidden: TsCheckBox
          Left = 6
          Top = 6
          Width = 147
          Height = 17
          Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1089#1082#1088#1099#1090#1099#1077
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = box_dont_show_hiddenClick
        end
      end
      object ToolBar2: TsToolBar
        Left = 0
        Top = 48
        Width = 421
        Height = 22
        AutoSize = True
        ButtonWidth = 27
        Caption = 'ToolBar'
        DoubleBuffered = True
        Images = DIRAssistant.ImageList
        ParentDoubleBuffered = False
        TabOrder = 3
        Transparent = False
        object ToolButton1: TToolButton
          Left = 0
          Top = 0
          Caption = 'ToolButton1'
          ImageIndex = 19
          OnClick = ToolButton1Click
        end
        object ToolButton2: TToolButton
          Left = 27
          Top = 0
          Caption = 'ToolButton2'
          ImageIndex = 18
          OnClick = ToolButton2Click
        end
      end
    end
    object Panel2: TsPanel
      Left = 1
      Top = 1
      Width = 3
      Height = 492
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object title_panel: TsPanel
    Left = 0
    Top = 0
    Width = 426
    Height = 20
    Align = alTop
    Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object tree_PopupMenu: TPopupMenu
    Left = 40
    Top = 96
    object N1: TMenuItem
      Caption = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100' '#1086#1073#1088#1072#1073#1086#1090#1082#1091' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
      OnClick = N1Click
    end
    object N4: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
      OnClick = N4Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1077#1088#1077#1074#1086
      OnClick = N3Click
    end
  end
