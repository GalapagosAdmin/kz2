unit libkz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, INIFiles;

Type
  TMsg = Record
      MsgStr : String[32]; // Arbitrary length up to 255 characters.
      Data : ShortString;
    end;
  TKZObj=class(TObject)
      var
        UUID:TGuid;
        INI:TINIFile;
        _Name:ShortString;
      constructor create;
      constructor Load(GUID:UTF8String);
      procedure info(Var i:TMsg); message 'Info';
      procedure GetName(Var i:TMsg); message 'Name';
      procedure DefaultHandlerStr(var message);  override;
      Procedure NormalMethod;
      Function GetGUID:UTF8String;
      destructor destroy;
    end;

implementation
    constructor TKZObj.create;
      Var
        FileName:UTF8String;
      begin
        CreateGUID(UUID);
        FileName := GetAppConfigDir(false) + GUIDToString(UUID)+'.ini';
        INI := TINIFile.Create(FileName, False);
      end;

    constructor TKZObj.Load(Guid:UTF8String);
      Var
        FileName:UTF8String;
      begin
        UUID := StringToGuid(Guid);
        FileName := GetAppConfigDir(False) + GUIDToString(UUID)+'.ini';
        INI := TINIFile.Create(FileName, False);
      end;

    Procedure TKZObj.GetName(Var i:TMsg);
      begin
        _Name := ini.ReadString('General', 'Name', 'The Basement');
        Writeln(_Name);
      end;

    procedure TKZObj.info(Var i:TMsg);
      begin
        writeln('Information goes here.');
      end;

    procedure TKZObj.DefaultHandlerStr(var message);
      begin
        writeln('Unknown command');
      end;

    procedure TKZObj.NormalMethod;
      begin
        Writeln('This is a normal method call');
      end;

    Function TKZObj.GetGUID:UTF8String;
      begin
        Result := GUIDToString(uuid);
      end;

    destructor TKZObj.destroy;
      begin
        ini.WriteString('General', 'Name', _Name);
        ini.WriteString('General', 'Used', 'No');
        ini.WriteDateTime('General', 'LastUpdated', Now);
        ini.UpdateFile;
        ini.Free;
        inherited Destroy;
      end;

end.

