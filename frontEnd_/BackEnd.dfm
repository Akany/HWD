object Form1: TForm1
  Left = 192
  Top = 124
  Width = 252
  Height = 339
  Caption = #1050#1083#1080#1077#1085#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object HWInfo: TMemo
    Left = 24
    Top = 24
    Width = 185
    Height = 89
    Hint = #1050#1083#1102#1095' '#1082#1086#1088#1077#1082#1090#1085#1099#1081
    Lines.Strings = (
      #1050#1083#1102#1095' '#1082#1086#1088#1077#1082#1090#1085#1099#1081)
    ReadOnly = True
    TabOrder = 0
  end
  object addLicense: TMemo
    Left = 24
    Top = 152
    Width = 185
    Height = 89
    Hint = #1042#1089#1090#1072#1074#1090#1077' '#1083#1080#1094#1077#1085#1079#1080#1086#1085#1099#1081' '#1082#1083#1102#1095' '#1090#1091#1090
    Lines.Strings = (
      #1042#1089#1090#1072#1074#1090#1077' '#1083#1080#1094#1077#1085#1079#1080#1086#1085#1099#1081' '#1082#1083#1102#1095' '#1090#1091#1090)
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 24
    Top = 256
    Width = 185
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1083#1080#1094#1077#1085#1079#1080#1102
    TabOrder = 2
    OnClick = Button1Click
  end
end
