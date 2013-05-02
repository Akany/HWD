unit fronEnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    HWInfo: TMemo;
    Cript: TButton;
    result: TMemo;
    procedure CriptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TKeyBit= (kb128, kb192, kb256);
  
var
  Form1: TForm1;

implementation

{$R *.dfm}

function EncryptString (Value: PChar; Key: PChar;
  KeyBit: TKeyBit = kb128): PChar; stdcall; external 'AESDLL.dll';

procedure TForm1.CriptClick(Sender: TObject);
var
  key: Pchar;
begin
  key := 'test';
  result.Lines.Clear();
  result.Lines.Add(EncryptString(HWInfo.Lines.GetText(), key));
end;

end.
