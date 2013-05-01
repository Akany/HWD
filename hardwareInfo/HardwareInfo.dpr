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
  StdCtrls;

{$R *.res}
{getting HDD serial number}
const
  SMART_GET_VERSION = $074080;
  SMART_SEND_DRIVE_COMMAND = $07C084;
  SMART_RCV_DRIVE_DATA = $07C088;
  // Values of ds_bDriverError
  DRVERR_NO_ERROR = 0;
  DRVERR_IDE_ERROR = 1;
  DRVERR_INVALID_FLAG = 2;
  DRVERR_INVALID_COMMAND = 3;
  DRVERR_INVALID_BUFFER = 4;
  DRVERR_INVALID_DRIVE = 5;
  DRVERR_INVALID_IOCTL = 6;
  DRVERR_ERROR_NO_MEM = 7;
  DRVERR_INVALID_REGISTER = 8;
  DRVERR_NOT_SUPPORTED = 9;
  DRVERR_NO_IDE_DEVICE = 10;
  // Values of ir_bCommandReg
  ATAPI_ID_CMD = $A1;
  ID_CMD = $EC;
  SMART_CMD = $B0;

type
  TIdeRegs	= packed record
    bFeaturesReg,
    bSectorCountReg,
    bSectorNumberReg,
    bCylLowReg,
    bCylHighReg,
    bDriveHeadReg,
    bCommandReg,
    bReserved	: Byte;
  end;

  TDriverStatus = packed record
    bDriverError: Byte;
    bIDEError: Byte;
    bReserved: array[1..2] of Byte;
    dwReserved: array[1..2] of DWORD;
  end;

  TSendCmdInParams = packed record
    dwBufferSize: DWORD;
    irDriveRegs: TIdeRegs;
    bDriveNumber: Byte;
    bReserved: array[1..3] of Byte;
    dwReserved: array[1..4] of DWORD;
    bBuffer: Byte;
  end;

  TSendCmdOutParams = packed record
    dwBufferSize: DWORD;
    dsDriverStatus: TDriverStatus;
    bBuffer: array[1..512] of Byte;
  end;

  TGetVersionInParams = packed record
    bVersion,
    bRevision,
    bReserved,
    bIDEDeviceMap: Byte;
    dwCapabilities: DWORD;
    dwReserved: array[1..4] of DWORD;
  end;

procedure CorrectDevInfo(var _params: TSendCmdOutParams);
asm
  lea   edi, _params.bBuffer
  add   edi, 14h
  mov   ecx, 0Ah

@@SerNumLoop:

  mov   ax, [edi]
  xchg  al, ah
  stosw
  loop  @@SerNumLoop
  add   edi, 6
  mov   cl, 18h

@@ModelNumLoop:

  mov   ax, [edi]
  xchg  al, ah
  stosw
  loop  @@ModelNumLoop
end;

function getHddId() : String;
var
  tmp  : String;
  dev  : THandle;
  scip : TSendCmdInParams;
  scop : TSendCmdOutParams;
  gvip : TGetVersionInParams;
  ret  : DWORD;
begin
  dev := CreateFile('\\.\PhysicalDrive0', GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if dev <> INVALID_HANDLE_VALUE then
  begin
    if DeviceIoControl(dev, SMART_GET_VERSION, nil, 0, @gvip, SizeOf(gvip), ret, nil) then
    begin
      scip.dwBufferSize := 512;
      scip.bDriveNumber := 0;
      scip.irDriveRegs.bSectorCountReg := 1;
      scip.irDriveRegs.bSectorNumberReg := 1;
      scip.irDriveRegs.bDriveHeadReg := $A0;
      scip.irDriveRegs.bCommandReg := ID_CMD;
      if not DeviceIoControl(dev, SMART_RCV_DRIVE_DATA, @scip, SizeOf(scip), @scop, SizeOf(scop), ret, nil) then
        Result := SysErrorMessage(GetLastError)
      else if scop.dsDriverStatus.bDriverError = DRVERR_NO_ERROR then
      begin
        CorrectDevInfo(scop);
        SetLength(tmp, 20);
        Move(scop.bBuffer[21], tmp[1], 20);
        Result := tmp;
      end
      else
        Result := SysErrorMessage(GetLastError)
    end
    else
      Result := SysErrorMessage(GetLastError);
    CloseHandle(dev);
  end;
end;

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

{exported function
getting HardWare info}
function getHWInfo () : String;
begin
  Result := concatHWInfo(getHddId(), _getComputerName(), _getUserName());
end;

exports getHWInfo;

begin
end.
