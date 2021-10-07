unit QrCode.Tools;

interface

uses
  FMX.Objects,
  Classes,
  System.UITypes;

type
  TQrCodeTools = class
    class procedure Generate(aText: string; aImage: TImage);
  end;

implementation

uses
  DelphiZXingQRCode.FMX,
  FMX.Graphics,
  System.Types,
  Math,
  UIConsts,
  SysUtils;

{ TQrCodeTools }

class procedure TQrCodeTools.Generate(aText: string; aImage: TImage);
var
  QRCode: TDelphiZXingQRCode;
  Row, Column : Integer;
  QRCodeBitmap: TBitmap;
  Rapport     : integer;
  RowOffset   : integer;
  ColOffset   : integer;
  DoDraw      : boolean;
  BmpSize     : integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  BmpSize      := Min(Round(aImage.Width), Round(aImage.Height));
  QRCodeBitmap := TBitmap.Create(BmpSize, BmpSize);

  try
    QRCode.Data := aText;
    QRCode.Encoding := TQRCodeEncoding.qrAuto;

    // clear canvas and set colors
    QRCodeBitmap.Clear(TAlphaColors.White);

    QRCodeBitmap.Canvas.Stroke.Kind  := TBrushKind.None;

    QRCodeBitmap.Canvas.Fill.Color   := TAlphaColors.Black;
    QRCodeBitmap.Canvas.Fill.Kind    := TBrushKind.Solid;

    // multiply qrcode size to fit with image size
    Rapport := Round(BmpSize / QRCode.Rows);

    RowOffset := 0;
    try
      QRCodeBitmap.Canvas.BeginScene;

      for Row := 0 to QRCode.Rows - 1 do
      begin
        ColOffset := 0;

        for Column := 0 to QRCode.Columns - 1 do
        begin
          DoDraw := QRCode.IsBlack[Row, Column];

          if DoDraw then
          begin
            QRCodeBitmap.Canvas.FillRect(TRectF.Create(RowOffset, ColOffset, RowOffset + Rapport, ColOffset + Rapport), 0,0, [], 1);
          end;

          ColOffset := ColOffset + Rapport;
        end;
        RowOffset := RowOffset + Rapport;
      end;
    finally
      QRCodeBitmap.Canvas.EndScene;
    end;

    aImage.WrapMode := TImageWrapMode.Original;
    aImage.Bitmap.Assign(QRCodeBitmap);
  finally
    QRCodeBitmap.Free;
    QRCode.Free;
  end;
end;

end.
