library Rijndael;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  DECCipher,
  Dialogs;

{$R *.res}
function StrToHex(const Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to length(value) do
    result := result + IntToHex(Ord(Value[I]), 2);
end;

function HexToStr(const Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to length(value) do
  begin
    if ((I mod 2) = 1) then
    begin
      result := result + Chr(StrToInt('0x'+ Copy(Value, I, 2)));
    end;
  end;
end;


function encode (const source: pchar; var out: pchar; key: pchar) : boolean;
var
  aes: TCipher_Rijndael;
begin
  aes := TCipher_Rijndael.Create;
  aes.Init(key);
  out := pchar(StrToHex(aes.EncodeBinary(HexToStr(source))));
end;

function decode (const source: pchar; var out: pchar; key: pchar) : boolean;
var
  aes: TCipher_Rijndael;
begin
  aes := TCipher_Rijndael.Create;
  aes.Init(key);
  out := pchar(StrToHex(aes.DecodeBinary(HexToStr(source))));
end;

exports decode, encode;

begin
end.
