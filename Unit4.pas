unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, CALCULAT008;

type
  TForm4 = class(TForm)
    Label2: TLabel;
    EditU: TEdit;
    EditDeltaU: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure EditUChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  clas1: CalculateCWheel;

implementation

uses Unit1;
{$R *.dfm}

procedure TForm4.EditUChange(Sender: TObject);
var
  osh: integer;
  ui: Extended;
begin
  // Val понимает только точку как десятичный разделитель
  val(StringReplace(EditU.Text, ',', '.', [rfReplaceAll]), ui, osh);
  if osh <> 0 then
    ShowMessage('Введено не верное значение')
  else
  begin
    clas.U := ui;
    Input.U := ui;
  end;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  EditU.Text := StringReplace(floattostr(Input.U), ',', '.', [rfReplaceAll]);
  EditDeltaU.Text := floattostr(Input.DeltaU);
end;


end.
