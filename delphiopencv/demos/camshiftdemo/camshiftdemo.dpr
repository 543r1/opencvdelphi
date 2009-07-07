program camshiftdemo;

uses
  Forms,
  frmHistogram in 'src\frmHistogram.pas' {fHistogram},
  frmCamshiftdemo in 'src\frmCamshiftdemo.pas' {fCamshiftdemo},
  OpenCV_HighGUI in '..\..\src\OpenCV_HighGUI.pas',
  Ipl in '..\..\src\Ipl.pas',
  OpenCV in '..\..\src\OpenCV.pas',
  OpenCV_CV in '..\..\src\OpenCV_CV.pas',
  OpenCV_CVAUX in '..\..\src\OpenCV_CVAUX.pas',
  OpenCV_CXCORE in '..\..\src\OpenCV_CXCORE.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfCamshiftdemo, fCamshiftdemo);
  Application.Run;
end.
