unit BackEnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, registry;

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
  //criptValue: Pchar;
  Registry: TRegistry;
  license: String;
begin
  //key := 'test';
  //criptValue := EncryptString(pansichar(Trim(getHWInfo())), pansichar(key));
  HWInfo.Clear();
  HWInfo.Lines.Add(getHWInfo());

   Registry := TRegistry.Create;
   Registry.RootKey := hkey_current_user;
   Registry.OpenKey('software\HWD',true);
   if Registry.ValueExists('license') then
    license := Registry.ReadString('license')
   else Registry.WriteString('license', 'test');
   Registry.CloseKey;
   Registry.Free;
end;

end.
