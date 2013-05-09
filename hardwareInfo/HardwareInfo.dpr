library HardwareInfo;

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  StdCtrls, md5, hddId, registry;

type
  TKeyBit= (kb128, kb192, kb256);

{$R *.res}

function encode (const source: pchar; var out: pchar): boolean; external 'Rijndael.dll';
function decode (const source: pchar; var out: pchar): boolean; external 'Rijndael.dll';

{Getting computer name}
function _getComputerName: String;
var
 Buffer: array[0..255] of Char;
 Size: DWORD;
begin
 size := 256;
 if GetComputerName(Buffer, Size) then
   Result := Buffer
 else
   Result := ''
end;

{Getting user name}
function _getUserName: String;
var
 Size: Cardinal;
 PRes: PChar;
 BRes: Boolean;
begin
 Size := MAX_COMPUTERNAME_LENGTH + 1;
 PRes := StrAlloc(Size);
 BRes := GetUserName(PRes, Size);
 if BRes then
   Result := StrPas(PRes)
 else
   Result := '';
end;

function concatHWInfo (hddInfo, compName, userName : String) : String;
begin
  Result := hddInfo + '-' + compName + '-' + userName;
end;

{concatenate hardware unique info}
function convertHashToPchar (hashArray: MD5Digest) : String;
var
  i: integer;
  c: String;
begin
  for  i := 0 to Length(hashArray) - 1 do
    c := c + IntToHex(hashArray[i], 2);
  Result := c;
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

{getting HardWare info}
function getHWInfo () : PChar;
var
  HWInfo: String;
begin
  HWInfo := Trim(concatHWInfo(_getComputerName(), getHddId(), _getUserName()));
  HWInfo := convertHashToPchar(md5String(HWInfo));
  SetLength(HWInfo, 32);
  Result := PAnsiChar(HWInfo);
end;

{exported function}
{allow user to set license}
function setLicense (license: Pchar) : Boolean;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  Registry.RootKey := hkey_current_user;
  Result := Registry.OpenKey('software\HWD',true);
  Registry.WriteString('license', license);
  Registry.CloseKey;
  Registry.Free;
end;

{controller}
function init () : pchar; stdcall;
var
  Registry: TRegistry;
  license, p, date: pchar;
//  date: string;
begin
  Registry := TRegistry.Create;
  Registry.RootKey := hkey_current_user;
  Registry.OpenKey('software\HWD',true);
  if Registry.ValueExists('license') then
  begin
    //p := StringReplace(Registry.ReadString('license'), #13#10, '', [rfReplaceAll]);
    p := pchar(Registry.ReadString('license'));
    p[32] := #0;
    encode(getHWInfo(), license);
    if AnsiSameText(string(p), string(license)) then
      result := pchar('')
    else result := getHWInfo()
  end
  else result := getHWInfo();
  Registry.CloseKey;
  Registry.Free;
  //decode(p, p);
  //result := date;
end;

//  encode(license, license);
//  out := pchar(copy(license, 1, length(license)));
//  decode(out, out);

exports init, setLicense;

begin
end.
