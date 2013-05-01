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

implementation

{$R *.dfm}

function getHWInfo () : Pchar; external 'HardwareInfo.dll';
//function EncryptString (Value: PChar; Key: PChar;
//  KeyBit: TKeyBit = kb128): PChar; stdcall; external 'AESDLL.dll';

procedure TForm1.FormCreate(Sender: TObject);
var
  key: String;
  //criptValue: Pchar;
begin
  //key := 'test';
  //criptValue := EncryptString(pansichar(Trim(getHWInfo())), pansichar(key));
  HWInfo.Clear();
  HWInfo.Lines.Add(getHWInfo());
end;

end.
