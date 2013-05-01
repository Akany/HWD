unit BackEnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    HWInfo: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TKeyBit= (kb128, kb192, kb256);

var
  Form1: TForm1;
//  TKeyBit: (kb128, kb192, kb256);

implementation

{$R *.dfm}

function getHWInfo () : String; external 'HardwareInfo.dll';
function EncryptString (Value: PChar; Key: PChar;
  KeyBit: TKeyBit = kb128): PChar; stdcall; external 'AESDLL.dll';

procedure TForm1.FormCreate(Sender: TObject);
var
  key: String;
  criptValue : Pchar;
begin
  key := 'test';
  criptValue := EncryptString(pansichar(Trim(getHWInfo())), pansichar(key), kb256);
  HWInfo.Clear();
  HWInfo.Lines.Add(criptValue);
end;

end.
