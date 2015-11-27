program KuroZora;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, libkz, inifiles
  { you can add units after this };

type

  { TKuroZoraApp }

  TKuroZoraApp = class(TCustomApplication)
  protected
  var
   ConfigFileName:UTF8String;
   AppINI:TINIFile;
   LastGUID:UTF8String;
   KZOBJ:TKZOBJ;
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TKuroZoraApp }

procedure TKuroZoraApp.DoRun;
var
  ErrorMsg: String;
  cmd:TMsg;
begin

  // quick check parameters
  ErrorMsg:=CheckOptions('h','help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  writeln('Welcome to KuroZora2');
  { add your program here }
  Cmd.MsgStr := 'Info';
  KZOBJ.DispatchStr(cmd);
  Cmd.MsgStr := 'Name';
  KZOBJ.DispatchStr(cmd);
  KZObj.NormalMethod;
  write('[Press Enter]');
  readln;
  // stop program loop
  Terminate;
end;

constructor TKuroZoraApp.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
  ConfigFileName := GetAppConfigDir(false) + 'KuroZora'+'.ini';
  AppINI := TINIFile.Create(ConfigFileName, False);
  LastGUID := AppIni.ReadString('General', 'LastGUID', '');
  If LastGUID = '' then
    KZOBJ := TKZObj.create()
  else
    KZOBJ := TKZObj.Load(LastGUID);



end;

destructor TKuroZoraApp.Destroy;
begin
  LastGuid := KZOBJ.GetGUID;
  Appini.WriteString('General', 'LastGUID', LastGuid);
  Appini.WriteDateTime('General', 'LastUpdated', Now);
  Appini.UpdateFile;
  Appini.Free;
  KZOBJ.destroy();

  inherited Destroy;
end;

procedure TKuroZoraApp.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ',ExeName,' -h');
end;

var
  Application: TKuroZoraApp;
begin
  Application:=TKuroZoraApp.Create(nil);
  Application.Title:='Kurozora';
  Application.Run;
  Application.Free;
end.

