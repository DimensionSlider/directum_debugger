object dock_variables_list: Tdock_variables_list
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1099#1077
  ClientHeight = 457
  ClientWidth = 307
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
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object variable_tree: TVirtualStringTree
    Left = 0
    Top = 115
    Width = 307
    Height = 316
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible, hoAutoSpring]
    Images = isbl_debugger.ImageList
    PopupMenu = variablestree_popup
    TabOrder = 2
    OnBeforeCellPaint = variable_treeBeforeCellPaint
    OnContextPopup = variable_treeContextPopup
    OnDblClick = variable_treeDblClick
    OnFreeNode = variable_treeFreeNode
    OnGetText = variable_treeGetText
    OnGetImageIndex = variable_treeGetImageIndex
    OnKeyDown = variable_treeKeyDown
    Columns = <
      item
        MaxWidth = 400
        MinWidth = 50
        Position = 0
        Width = 165
        WideText = #1053#1072#1079#1074#1072#1085#1080#1077
      end
      item
        MaxWidth = 400
        MinWidth = 50
        Position = 1
        Width = 300
        WideText = #1047#1085#1072#1095#1077#1085#1080#1077
      end>
  end
  object Группа: TsPanel
    Left = 0
    Top = 0
    Width = 307
    Height = 93
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object filter_panel: TsPanel
      Left = 0
      Top = 0
      Width = 307
      Height = 43
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      SkinData.SkinSection = 'PANEL'
      object filter_ed_variable: TsEdit
        Left = 3
        Top = 19
        Width = 288
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = filter_ed_variableChange
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
        BoundLabel.UseSkinColor = True
      end
    end
    object sPanel3: TsPanel
      Left = 0
      Top = 43
      Width = 307
      Height = 73
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      SkinData.SkinSection = 'PANEL'
      object filter_ed_value: TsEdit
        Left = 3
        Top = 18
        Width = 288
        Height = 22
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = filter_ed_valueChange
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Active = True
        BoundLabel.Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1079#1085#1072#1095#1077#1085#1080#1102
        BoundLabel.Indent = 3
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclTopLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
      end
    end
  end
  object Инструменты: TsToolBar
    Left = 0
    Top = 93
    Width = 307
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
    object tool_collapse: TToolButton
      Left = 0
      Top = 0
      Caption = 'tool_collapse'
      ImageIndex = 19
      OnClick = tool_collapseClick
    end
    object tool_expand: TToolButton
      Left = 27
      Top = 0
      Caption = 'tool_expand'
      ImageIndex = 18
      OnClick = tool_expandClick
    end
    object tool_variables: TToolButton
      Left = 54
      Top = 0
      Caption = 'tool_variables'
      Down = True
      ImageIndex = 55
      Style = tbsCheck
      OnClick = tool_variablesClick
    end
    object tool_enviroment_variables: TToolButton
      Left = 81
      Top = 0
      Caption = 'tool_enviroment_variables'
      Down = True
      ImageIndex = 56
      Style = tbsCheck
      OnClick = tool_enviroment_variablesClick
    end
    object tool_copy_pseudo: TToolButton
      Left = 108
      Top = 0
      Caption = 'tool_copy_pseudo'
      ImageIndex = 119
      OnClick = tool_copy_pseudoClick
    end
  end
  object Panel3: TsPanel
    Left = 0
    Top = 431
    Width = 307
    Height = 26
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    SkinData.SkinSection = 'PANEL'
    object box_show_current: TsCheckBox
      Left = 9
      Top = 6
      Width = 104
      Height = 20
      Caption = #1058#1086#1083#1100#1082#1086' '#1090#1077#1082#1091#1097#1080#1077
      TabOrder = 0
      OnClick = box_show_currentClick
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = isbl_debugger.JvDockVSNetStyle
    Left = 40
    Top = 144
  end
  object variablestree_popup: TPopupMenu
    Left = 152
    Top = 146
    object popup_value_copy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1073#1091#1092#1077#1088
      OnClick = popup_value_copyClick
    end
    object popup_value_show_in_window: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1086#1082#1085#1077
      OnClick = popup_value_show_in_windowClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popup_variable_monitor: TMenuItem
      Caption = #1054#1090#1089#1083#1077#1078#1080#1074#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1085#1085#1091#1102
      OnClick = popup_variable_monitorClick
    end
    object popup_variable_copy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1073#1091#1092#1077#1088
      OnClick = popup_variable_copyClick
    end
    object popup_variable_copy_ps: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1087#1089#1077#1074#1076#1086#1082#1086#1076#1077
      OnClick = popup_variable_copy_psClick
    end
    object popup_variable_show_value: TMenuItem
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1086#1082#1085#1077
      OnClick = popup_variable_show_valueClick
    end
  end
end
