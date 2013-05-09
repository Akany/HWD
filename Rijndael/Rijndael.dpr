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
  DECCipher;

{$R *.res}
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


function encode (const source: pchar; var out: pchar) : boolean;
var
  aes: TCipher_Rijndael;
begin
  aes := TCipher_Rijndael.Create;
  aes.Init('acdE2dD5ea1Ff26B');
  out := pchar(StrToHex(aes.EncodeBinary(HexToStr(string(source)))));
  //out := pchar(aes.EncodeBinary(source));
end;

function decode (const source: pchar; var out: pchar) : boolean;
var
  aes: TCipher_Rijndael;
  ss: string;
begin
  aes := TCipher_Rijndael.Create;
  aes.Init('acdE2dD5ea1Ff26B');
  ss := string(source);
  out := pchar(StrToHex(aes.DecodeBinary(HexToStr(string(source)))));
  //out := pchar(aes.DecodeBinary(ss));
end;

exports decode, encode;

begin
end.
