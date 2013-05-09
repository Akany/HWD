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

function init () : pchar; stdcall; external 'HardwareInfo.dll';
function setLicense (license: Pchar) : Boolean; external 'HardwareInfo.dll';

procedure TForm1.FormCreate(Sender: TObject);
var
  msg: string;
begin
  msg := string(init());
  if (msg <> '') then
  begin
    HWInfo.Clear();
    HWInfo.Lines.Add(msg);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  setLicense(addLicense.Lines.GetText());
  ShowMessage('Приложение необходимо перезапустить');
  Form1.Close;
end;

end.
