object msi_form: Tmsi_form
  Left = 215
  Top = 124
  Caption = 'MSI '#1057#1087#1080#1089#1086#1082' '#1087#1072#1082#1077#1090#1086#1074
  ClientHeight = 346
  ClientWidth = 522
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
  object pnl1: TsPanel
    Left = 0
    Top = 0
    Width = 522
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object lbl1: TsLabel
      Left = 0
      Top = 12
      Width = 96
      Height = 13
      Caption = #1054#1073#1098#1077#1082#1090#1099' '#1080' GUID'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object Panel1: TsPanel
      Left = 0
      Top = 0
      Width = 522
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      SkinData.SkinSection = 'PANEL'
      object Label1: TsLabel
        Left = 8
        Top = 12
        Width = 96
        Height = 13
        Caption = #1054#1073#1098#1077#1082#1090#1099' '#1080' GUID'
        ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
      end
    end
  end
  object tree: TVirtualStringTree
    Left = 9
    Top = 33
    Width = 418
    Height = 215
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
    TabOrder = 2
    OnFocusChanged = treeFocusChanged
    Columns = <
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAutoSpring, coAllowFocus]
        Position = 0
        Width = 168
        WideText = #1055#1072#1082#1077#1090
      end
      item
        Position = 1
        Width = 250
        WideText = #1053#1072#1079#1074#1072#1085#1080#1077
      end>
  end
  object pnl2: TsPanel
    Left = 427
    Top = 33
    Width = 95
    Height = 215
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    SkinData.SkinSection = 'PANEL'
    object btn1: TsButton
      Left = 7
      Top = 3
      Width = 82
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 0
      OnClick = btn1Click
      SkinData.SkinSection = 'BUTTON'
    end
    object btn2: TsButton
      Left = 8
      Top = 32
      Width = 82
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = btn2Click
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object pnl3: TsPanel
    Left = 0
    Top = 33
    Width = 9
    Height = 215
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
  end
  object pnl4: TsPanel
    Left = 0
    Top = 248
    Width = 522
    Height = 98
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    SkinData.SkinSection = 'PANEL'
    object Guid: TsLabel
      Left = 8
      Top = 8
      Width = 21
      Height = 13
      Caption = 'Guid'
    end
    object lbl2: TsLabel
      Left = 8
      Top = 32
      Width = 50
      Height = 13
      Caption = #1059#1076#1072#1083#1077#1085#1080#1077
    end
    object edt1: TsEdit
      Left = 80
      Top = 5
      Width = 349
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      SkinData.SkinSection = 'EDIT'
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'Tahoma'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
    end
    object edt2: TsEdit
      Left = 80
      Top = 30
      Width = 349
      Height = 21
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      SkinData.SkinSection = 'EDIT'
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'Tahoma'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
    end
  end
  object pm1: TPopupMenu
    Left = 387
    Top = 41
  end
end