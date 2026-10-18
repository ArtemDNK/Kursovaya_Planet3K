object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 105
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 178
    Height = 13
    Caption = #1044#1086#1087#1091#1089#1082' '#1085#1072' '#1087#1077#1088#1077#1076#1072#1090#1086#1095#1085#1086#1077' '#1095#1080#1089#1083#1086', %'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 163
    Height = 13
    Caption = #1055#1077#1088#1077#1076#1072#1090#1086#1095#1085#1086#1077' '#1086#1090#1085#1086#1096#1077#1085#1080#1077
  end
  object EditU: TEdit
    Left = 215
    Top = 8
    Width = 33
    Height = 21
    TabOrder = 0
    Text = '40'
    OnExit = EditUChange
  end
  object EditDeltaU: TEdit
    Left = 215
    Top = 35
    Width = 33
    Height = 21
    TabOrder = 1
    Text = '2'
  end
  object Button1: TButton
    Left = 8
    Top = 72
    Width = 113
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 173
    Top = 72
    Width = 75
    Height = 25
    Caption = #1054#1090#1082#1072#1079
    ModalResult = 2
    TabOrder = 3
  end
end
