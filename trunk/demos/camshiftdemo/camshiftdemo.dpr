program camshiftdemo;

uses
  Forms,
  frmHistogram in 'src\frmHistogram.pas' {fHistogram},
  frmCamshiftdemo in 'src\frmCamshiftdemo.pas' {fCamshiftdemo},
  Ipl in '..\..\opencvdelphi\Ipl.pas',
  OpenCV in '..\..\opencvdelphi\OpenCV.pas',
  OpenCV_CV in '..\..\opencvdelphi\OpenCV_CV.pas',
  OpenCV_CVAUX in '..\..\opencvdelphi\OpenCV_CVAUX.pas',
  OpenCV_CXCORE in '..\..\opencvdelphi\OpenCV_CXCORE.pas',
  OpenCV_HighGUI in '..\..\opencvdelphi\OpenCV_HighGUI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfCamshiftdemo, fCamshiftdemo);
  Application.Run;
end.
