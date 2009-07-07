object fCamshiftdemo: TfCamshiftdemo
  Left = 321
  Top = 186
  Caption = 'CAMshift demo'
  ClientHeight = 430
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 118
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 20
      Width = 30
      Height = 16
      Caption = 'Vmin'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 20
      Top = 52
      Width = 34
      Height = 16
      Caption = 'Vmax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 20
      Top = 89
      Width = 30
      Height = 16
      Caption = 'Smin'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object tbVmin: TTrackBar
      Left = 65
      Top = 20
      Width = 287
      Height = 20
      Max = 256
      PageSize = 8
      Frequency = 16
      TabOrder = 0
    end
    object tbVmax: TTrackBar
      Left = 65
      Top = 52
      Width = 287
      Height = 20
      Max = 256
      PageSize = 8
      Frequency = 16
      TabOrder = 1
    end
    object tbSmin: TTrackBar
      Left = 65
      Top = 85
      Width = 287
      Height = 20
      Max = 256
      PageSize = 8
      Frequency = 16
      TabOrder = 2
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 118
    Width = 393
    Height = 312
    Align = alClient
    TabOrder = 1
    object formImage: TImage
      Left = 1
      Top = 1
      Width = 391
      Height = 310
      Align = alClient
      Stretch = True
      OnMouseDown = formImageMouseDown
      OnMouseMove = formImageMouseMove
      OnMouseUp = formImageMouseUp
      ExplicitWidth = 370
      ExplicitHeight = 277
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5
    OnTimer = Timer1Timer
    Left = 352
    Top = 8
  end
end
