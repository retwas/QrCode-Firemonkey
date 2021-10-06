program qrcode;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  QrCode.Tools in 'QrCode.Tools.pas',
  DelphiZXingQRCode.FMX in 'DelphiZXingQRCode.FMX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
