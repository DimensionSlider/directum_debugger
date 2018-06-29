object dock_isbl_tree: Tdock_isbl_tree
  Left = 0
  Top = 0
  Align = alCustom
  Caption = #1044#1077#1088#1077#1074#1086' '#1086#1073#1088#1072#1073#1086#1090#1086#1082
  ClientHeight = 408
  ClientWidth = 295
  Color = clWindow
  Ctl3D = False
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
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object underpanel: TsPanel
    Left = 0
    Top = 20
    Width = 295
    Height = 388
    Align = alClient
    BevelOuter = bvNone
    Caption = 'underpanel'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    object Panel1: TsPanel
      Left = 3
      Top = 0
      Width = 292
      Height = 388
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 1
      SkinData.SkinSection = 'PANEL'
      object tree: TVirtualStringTree
        Left = 0
        Top = 118
        Width = 292
        Height = 210
        Align = alClient
        Ctl3D = True
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        Images = isbl_debugger.ImageList1
        ParentCtl3D = False
        PopupMenu = tree_PopupMenu
        TabOrder = 2
        OnBeforeCellPaint = treeBeforeCellPaint
        OnContextPopup = treeContextPopup
        OnFocusChanged = treeFocusChanged
        OnFreeNode = treeFreeNode
        OnGetText = treeGetText
        OnGetImageIndex = treeGetImageIndex
        Columns = <>
      end
      object filter_panel: TsPanel
        Left = 0
        Top = 0
        Width = 292
        Height = 48
        Align = alTop
        BevelOuter = bvNone
        Ctl3D = False
        ParentBackground = False
        ParentCtl3D = False
        TabOrder = 0
        SkinData.SkinSection = 'TOOLBUTTON'
        object filter_label: TsLabel
          Left = 0
          Top = 4
          Width = 3
          Height = 14
          ParentFont = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
        end
        object filter_ed: TsEdit
          Left = 4
          Top = 22
          Width = 285
          Height = 22
          Ctl3D = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          OnChange = filter_edChange
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Active = True
          BoundLabel.Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
          BoundLabel.Indent = 3
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclTopLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = False
        end
      end
      object Panel3: TsPanel
        Left = 0
        Top = 328
        Width = 292
        Height = 60
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 3
        SkinData.SkinSection = 'PANEL'
        object box_dont_show_hidden: TsCheckBox
          Left = 0
          Top = 56
          Width = 145
          Height = 20
          Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1089#1082#1088#1099#1090#1099#1077
          TabOrder = 2
          Visible = False
          OnClick = box_dont_show_hiddenClick
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object box_tree: TsCheckBox
          Left = 0
          Top = 6
          Width = 69
          Height = 20
          Caption = #1048#1077#1088#1072#1088#1093#1080#1103
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = box_treeClick
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object box_finished: TsCheckBox
          Left = 0
          Top = 24
          Width = 201
          Height = 20
          Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1085#1099#1077' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
          TabOrder = 1
          OnClick = box_finishedClick
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object box_show_code: TsCheckBox
          Left = 0
          Top = 41
          Width = 197
          Height = 20
          Caption = #1042#1099#1074#1086#1076#1080#1090#1100' '#1082#1086#1076' '#1089#1080#1089#1090#1077#1084#1099' '#1074' '#1085#1072#1079#1074#1072#1085#1080#1080
          TabOrder = 3
          OnClick = box_show_codeClick
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
      end
      object ToolBar2: TsToolBar
        Left = 0
        Top = 96
        Width = 292
        Height = 22
        AutoSize = True
        ButtonWidth = 27
        Caption = 'ToolBar'
        DoubleBuffered = True
        Images = nonvisual.ImageList
        ParentDoubleBuffered = False
        TabOrder = 1
        Transparent = False
        SkinData.SkinSection = 'TOOLBAR'
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
        object ToolButton3: TToolButton
          Left = 54
          Top = 0
          Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
          Caption = 'ToolButton3'
          ImageIndex = 48
          OnClick = ToolButton3Click
        end
      end
      object panel_search: TsPanel
        Left = 0
        Top = 48
        Width = 292
        Height = 48
        Align = alTop
        BevelOuter = bvNone
        Ctl3D = False
        ParentBackground = False
        ParentCtl3D = False
        TabOrder = 4
        SkinData.SkinSection = 'TOOLBUTTON'
        object sLabel1: TsLabel
          Left = 0
          Top = 4
          Width = 3
          Height = 14
          ParentFont = False
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
        end
        object ed_search: TsEdit
          Left = 4
          Top = 20
          Width = 239
          Height = 22
          Ctl3D = True
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          OnChange = ed_searchChange
          OnKeyPress = ed_searchKeyPress
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Active = True
          BoundLabel.Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
          BoundLabel.Indent = 3
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'Tahoma'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclTopLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = False
        end
        object bar_search: TsToolBar
          AlignWithMargins = True
          Left = 243
          Top = 20
          Width = 46
          Height = 25
          Margins.Left = 7
          Margins.Top = 20
          Align = alRight
          AutoSize = True
          Caption = 'ToolBar'
          DoubleBuffered = True
          Images = nonvisual.ImageList
          List = True
          ParentDoubleBuffered = False
          TabOrder = 1
          Transparent = False
          SkinData.SkinSection = 'COLHEADER'
          object ToolButton4: TToolButton
            Left = 0
            Top = 0
            Caption = 'ToolButton1'
            ImageIndex = 109
            OnClick = ToolButton4Click
          end
          object ToolButton5: TToolButton
            Left = 23
            Top = 0
            Caption = 'ToolButton2'
            ImageIndex = 108
            OnClick = ToolButton5Click
          end
        end
      end
    end
    object Panel2: TsPanel
      Left = 0
      Top = 0
      Width = 3
      Height = 388
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      SkinData.SkinSection = 'PANEL'
    end
  end
  object title_panel: TsPanel
    Left = 0
    Top = 0
    Width = 295
    Height = 20
    Align = alTop
    Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    Visible = False
    SkinData.SkinSection = 'PANEL'
  end
  object tree_PopupMenu: TPopupMenu
    Left = 35
    Top = 151
    object N1: TMenuItem
      Caption = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100' '#1086#1073#1088#1072#1073#1086#1090#1082#1091' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1102
      OnClick = N1Click
    end
    object N4: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1091#1079#1077#1083
      OnClick = N5Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1077#1088#1077#1074#1086
      OnClick = N3Click
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = isbl_debugger.JvDockVSNetStyle
    Left = 142
    Top = 151
  end
end
