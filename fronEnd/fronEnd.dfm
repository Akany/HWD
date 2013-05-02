object Form1: TForm1
  Left = 301
  Top = 140
  Width = 264
  Height = 338
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object HWInfo: TMemo
    Left = 32
    Top = 24
    Width = 185
    Height = 89
    Lines.Strings = (
      'HWInfo')
    TabOrder = 0
  end
  object Cript: TButton
    Left = 32
    Top = 136
    Width = 185
    Height = 25
    Caption = 'Cript'
    TabOrder = 1
    OnClick = CriptClick
  end
  object result: TMemo
    Left = 32
    Top = 192
    Width = 185
    Height = 89
    Lines.Strings = (
      'result')
    TabOrder = 2
  end
end
