(**************************************************)
(*                                                *)
(*     Advanced Encryption Standard (AES)         *)
(*     Interface Unit v1.3                        *)
(*                                                *)
(*                                                *)
(*     Copyright (c) 2002 Jorlen Young            *)
(*                                                *)
(*                                                *)
(*                                                *)
(*说明：                                          *)
(*                                                *)
(*   基于 ElASE.pas 单元封装                      *)
(*                                                *)
(*   这是一个 AES 加密算法的标准接口。            *)
(*                                                *)
(*                                                *)
(*   作者：杨泽晖      2004.12.04                 *)
(*                                                *)
(*   支持 128 / 192 / 256 位的密匙                *)                
(*   默认情况下按照 128 位密匙操作                *)
(*                                                *)
(**************************************************)

unit AES;

interface

uses
  SysUtils, Classes, Math, ElAES;

type
  TKeyBit = (kb128, kb192, kb256);

function StrToHex(Value: string): string;
function HexToStr(Value: string): string;
function EncryptString(Value: PChar; Key: PChar;
  KeyBit: TKeyBit = kb128): PChar;stdcall;
function DecryptString(Value: PChar; Key: PChar;
  KeyBit: TKeyBit = kb128): PChar;stdcall;
function EncryptStream(Stream: TStream; Key: PChar;
  KeyBit: TKeyBit = kb128): TStream;stdcall;
function DecryptStream(Stream: TStream; Key: PChar;
  KeyBit: TKeyBit = kb128): TStream;stdcall;
procedure EncryptFile(SourceFile, DestFile: PChar;
  Key: PChar; KeyBit: TKeyBit = kb128);stdcall;
procedure DecryptFile(SourceFile, DestFile: PChar;
  Key: PChar; KeyBit: TKeyBit = kb128);stdcall;
  
implementation

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

{  --  字符串加密函数 默认按照 128 位密匙加密 --  }
function EncryptString(Value: PChar; Key: PChar;
  KeyBit: TKeyBit = kb128): PChar;
var
  SS, DS: TStringStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  Result := '';
  SS := TStringStream.Create(Value);
  DS := TStringStream.Create('');
  try
    Size := SS.Size;
    DS.WriteBuffer(Size, SizeOf(Size));
    {  --  128 位密匙最大长度为 16 个字符 --  }
    if KeyBit = kb128 then
    begin
      FillChar(AESKey128, SizeOf(AESKey128), 0 );
      Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
      EncryptAESStreamECB(SS, 0, AESKey128, DS);
    end;
    {  --  192 位密匙最大长度为 24 个字符 --  }
    if KeyBit = kb192 then
    begin
      FillChar(AESKey192, SizeOf(AESKey192), 0 );
      Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
      EncryptAESStreamECB(SS, 0, AESKey192, DS);
    end;
    {  --  256 位密匙最大长度为 32 个字符 --  }
    if KeyBit = kb256 then
    begin
      FillChar(AESKey256, SizeOf(AESKey256), 0 );
      Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
      EncryptAESStreamECB(SS, 0, AESKey256, DS);
    end;
    Result := PChar(StrToHex(DS.DataString));
  finally
    SS.Free;
    DS.Free;
  end;
end;

{  --  字符串解密函数 默认按照 128 位密匙解密 --  }
function DecryptString(Value: PChar; Key: PChar;
  KeyBit: TKeyBit = kb128): PChar;
var
  SS, DS: TStringStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  Result := '';
  SS := TStringStream.Create(HexToStr(Value));
  DS := TStringStream.Create('');
  try
    Size := SS.Size;
    SS.ReadBuffer(Size, SizeOf(Size));
    {  --  128 位密匙最大长度为 16 个字符 --  }
    if KeyBit = kb128 then
    begin
      FillChar(AESKey128, SizeOf(AESKey128), 0 );
      Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
      DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey128, DS);
    end;
    {  --  192 位密匙最大长度为 24 个字符 --  }
    if KeyBit = kb192 then
    begin
      FillChar(AESKey192, SizeOf(AESKey192), 0 );
      Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
      DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey192, DS);
    end;
    {  --  256 位密匙最大长度为 32 个字符 --  }
    if KeyBit = kb256 then
    begin
      FillChar(AESKey256, SizeOf(AESKey256), 0 );
      Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
      DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey256, DS);
    end;
    Result := PChar(DS.DataString);
  finally
    SS.Free;
    DS.Free;
  end;
end;

{  --  流加密函数 默认按照 128 位密匙解密 --  }
function EncryptStream(Stream: TStream; Key: PChar;
  KeyBit: TKeyBit = kb128): TStream;
var
  Count: Int64;
  OutStrm: TStream;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  OutStrm := TStream.Create;
  Stream.Position := 0;
  Count := Stream.Size;
  OutStrm.Write(Count, SizeOf(Count));
  try
    {  --  128 位密匙最大长度为 16 个字符 --  }
    if KeyBit = kb128 then
    begin
      FillChar(AESKey128, SizeOf(AESKey128), 0 );
      Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
      EncryptAESStreamECB(Stream, 0, AESKey128, OutStrm);
    end;
    {  --  192 位密匙最大长度为 24 个字符 --  }
    if KeyBit = kb192 then
    begin
      FillChar(AESKey192, SizeOf(AESKey192), 0 );
      Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
      EncryptAESStreamECB(Stream, 0, AESKey192, OutStrm);
    end;
    {  --  256 位密匙最大长度为 32 个字符 --  }
    if KeyBit = kb256 then
    begin
      FillChar(AESKey256, SizeOf(AESKey256), 0 );
      Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
      EncryptAESStreamECB(Stream, 0, AESKey256, OutStrm);
    end;
    Result := OutStrm;
  finally
    OutStrm.Free;
  end;
end;

{  --  流解密函数 默认按照 128 位密匙解密 --  }
function DecryptStream(Stream: TStream; Key: PChar;
  KeyBit: TKeyBit = kb128): TStream;
var
  Count, OutPos: Int64;
  OutStrm: TStream;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  OutStrm := TStream.Create;
  Stream.Position := 0;
  OutPos :=OutStrm.Position;
  Stream.ReadBuffer(Count, SizeOf(Count));
  try
    {  --  128 位密匙最大长度为 16 个字符 --  }
    if KeyBit = kb128 then
    begin
      FillChar(AESKey128, SizeOf(AESKey128), 0 );
      Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
      DecryptAESStreamECB(Stream, Stream.Size - Stream.Position,
        AESKey128, OutStrm);
    end;
    {  --  192 位密匙最大长度为 24 个字符 --  }
    if KeyBit = kb192 then
    begin
      FillChar(AESKey192, SizeOf(AESKey192), 0 );
      Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
      DecryptAESStreamECB(Stream, Stream.Size - Stream.Position,
        AESKey192, OutStrm);
    end;
    {  --  256 位密匙最大长度为 32 个字符 --  }
    if KeyBit = kb256 then
    begin
      FillChar(AESKey256, SizeOf(AESKey256), 0 );
      Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
      DecryptAESStreamECB(Stream, Stream.Size - Stream.Position,
        AESKey256, OutStrm);
    end;
    OutStrm.Size := OutPos + Count;
    OutStrm.Position := OutPos;
    Result := OutStrm;
  finally
    OutStrm.Free;
  end;
end;

{  --  文件加密函数 默认按照 128 位密匙解密 --  }
procedure EncryptFile(SourceFile, DestFile: PChar;
  Key: PChar; KeyBit: TKeyBit = kb128);
var
  SFS, DFS: TFileStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  SFS := TFileStream.Create(SourceFile, fmOpenRead);
  try
    DFS := TFileStream.Create(DestFile, fmCreate);
    try
      Size := SFS.Size;
      DFS.WriteBuffer(Size, SizeOf(Size));
      {  --  128 位密匙最大长度为 16 个字符 --  }
      if KeyBit = kb128 then
      begin
        FillChar(AESKey128, SizeOf(AESKey128), 0 );
        Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
        EncryptAESStreamECB(SFS, 0, AESKey128, DFS);
      end;
      {  --  192 位密匙最大长度为 24 个字符 --  }
      if KeyBit = kb192 then
      begin
        FillChar(AESKey192, SizeOf(AESKey192), 0 );
        Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
        EncryptAESStreamECB(SFS, 0, AESKey192, DFS);
      end;
      {  --  256 位密匙最大长度为 32 个字符 --  }
      if KeyBit = kb256 then
      begin
        FillChar(AESKey256, SizeOf(AESKey256), 0 );
        Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
        EncryptAESStreamECB(SFS, 0, AESKey256, DFS);
      end;
    finally
      DFS.Free;
    end;
  finally
    SFS.Free;
  end;
end;

{  --  文件解密函数 默认按照 128 位密匙解密 --  }
procedure DecryptFile(SourceFile, DestFile: PChar;
  Key: PChar; KeyBit: TKeyBit = kb128);
var
  SFS, DFS: TFileStream;
  Size: Int64;
  AESKey128: TAESKey128;
  AESKey192: TAESKey192;
  AESKey256: TAESKey256;
begin
  SFS := TFileStream.Create(SourceFile, fmOpenRead);
  try
    SFS.ReadBuffer(Size, SizeOf(Size));
    DFS := TFileStream.Create(DestFile, fmCreate);
    try
      {  --  128 位密匙最大长度为 16 个字符 --  }
      if KeyBit = kb128 then
      begin
        FillChar(AESKey128, SizeOf(AESKey128), 0 );
        Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
        DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey128, DFS);
      end;
      {  --  192 位密匙最大长度为 24 个字符 --  }
      if KeyBit = kb192 then
      begin
        FillChar(AESKey192, SizeOf(AESKey192), 0 );
        Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
        DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey192, DFS);
      end;
      {  --  256 位密匙最大长度为 32 个字符 --  }
      if KeyBit = kb256 then
      begin
        FillChar(AESKey256, SizeOf(AESKey256), 0 );
        Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
        DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey256, DFS);
      end;
      DFS.Size := Size;
    finally
      DFS.Free;
    end;
  finally
    SFS.Free;
  end;
end;
end. 
