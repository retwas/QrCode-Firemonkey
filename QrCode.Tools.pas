unit QrCode.Tools;

interface

uses
  FMX.Objects;

type
  TQrCodeTools = class
    class procedure Generate(aText: string; aImage: TImage);
  end;

implementation

uses
  DelphiZXingQRCode.FMX,
  System.UITypes,
  FMX.Graphics,
  System.Types,
  UIConsts;

{ TQrCodeTools }

class procedure TQrCodeTools.Generate(aText: string; aImage: TImage);
var
  QRCode: TDelphiZXingQRCode;
  Row, Column : Integer;
  pixelColor  : TAlphaColor;
  vBitMapData : TBitmapData;
  rSrc, rDest : TRectF;
  QRCodeBitmap: TBitmap;
begin
  QRCode := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  try
    QRCode.Data := aText;
    QRCode.Encoding := TQRCodeEncoding.qrAuto;
//    QRCode.QuietZone := StrToIntDef('1234', 4);
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
          pixelColor := StringToAlphaColor('#FF3D4785')
        else
          pixelColor := TAlphaColors.White;

        if QRCodeBitmap.Map(TMapAccess.Write, vBitMapData)  then
        try
          vBitMapData.SetPixel(Column, Row, pixelColor);
        finally
          QRCodeBitmap.Unmap(vBitMapData);
        end;
      end;
    end;

    //-----
    aImage.Bitmap.SetSize(QRCodeBitmap.Width, QRCodeBitmap.Height);

    rSrc := TRectF.Create(0, 0, QRCodeBitmap.Width, QRCodeBitmap.Height);
    rDest := TRectF.Create(0, 0, aImage.Bitmap.Width, aImage.Bitmap.Height);

    if aImage.Bitmap.Canvas.BeginScene then
    try
      aImage.Bitmap.Canvas.Clear(TAlphaColors.White);
      aImage.DisableInterpolation := true;
      aImage.WrapMode := TImageWrapMode.Fit;

      aImage.Bitmap.Canvas.DrawBitmap(QRCodeBitmap, rSrc, rDest, 1);
    finally
      aImage.Bitmap.Canvas.EndScene;
    end;
    //-----
  finally
    QRCodeBitmap.Free;
    QRCode.Free;
  end;
end;

end.
