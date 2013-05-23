unit fronEnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Cript: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit5: TEdit;
    Label3: TLabel;
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

function StrToHex(Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
    Result := Result + IntToHex(Ord(Value[I]), 2);
end;

function HexToStr(Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
  begin
    if ((I mod 2) = 1) then
      Result := Result + Chr(StrToInt('0x'+ Copy(Value, I, 2)));
  end;
end;

function encode (const source: pchar; var out: pchar; const key: pchar): boolean; external 'Rijndael.dll';
function decode (const source: pchar; var out: pchar; const key: pchar): boolean; external 'Rijndael.dll';

procedure TForm1.CriptClick(Sender: TObject);
var
  license,test: pchar;
begin
  license := pchar(Edit1.Text + strToHex(edit5.Text));
  test := pchar(strToHex(edit5.Text));
  encode(license, license, 'acdE2dD5ea1Ff26B');
  edit2.Text := license;
  decode(pchar(edit2.Text), license, 'acdE2dD5ea1Ff26B');
  license:= test;
end;

end.
