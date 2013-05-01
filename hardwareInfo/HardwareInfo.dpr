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
  StdCtrls, md5, hddId;

{$R *.res}

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

function convertHashToPchar (hashArray: MD5Digest) : Pchar;
var
  i: integer;
  c: String;
begin
  for  i := 0 to Length(hashArray) - 1 do
    c := c + IntToHex(hashArray[i], 2);
  Result := pansichar(c);
end;

{exported function
getting HardWare info}
function getHWInfo () : Pchar;
var
  HWInfo: String;
begin
  HWInfo := Trim(concatHWInfo(_getComputerName(), getHddId(), _getUserName()));
  Result := convertHashToPchar(md5String(HWInfo));
end;

exports getHWInfo;

begin
end.
