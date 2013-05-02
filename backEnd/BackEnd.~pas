unit BackEnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, registry;

type
  TForm1 = class(TForm)
    HWInfo: TMemo;
    addLicense: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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

function init () : Pchar; external 'HardwareInfo.dll';
function setLicense (license: Pchar) : Boolean; external 'HardwareInfo.dll';
//function EncryptString (Value: PChar; Key: PChar;
//  KeyBit: TKeyBit = kb128): PChar; stdcall; external 'AESDLL.dll';

procedure TForm1.FormCreate(Sender: TObject);
var
  //criptValue: Pchar;
  msg: string;
begin
  //key := 'test';
  //criptValue := EncryptString(pansichar(Trim(getHWInfo())), pansichar(key));
  HWInfo.Clear();
  msg := string(init());
  if (msg = '') then msg := 'The license is ok!';
  HWInfo.Lines.Add(msg);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  setLicense(addLicense.Lines.GetText());
  ShowMessage('Restart application');
end;

end.
