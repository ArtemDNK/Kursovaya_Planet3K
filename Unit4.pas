unit Unit4;

{ Окно ввода передаточного отношения и допуска на него }

interface

uses
  SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls;

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
  end;

var
  Form4: TForm4;

implementation

uses Unit1;
{$R *.dfm}

{ Проверка введенного значения при выходе из поля }
procedure TForm4.EditUChange(Sender: TObject);
var
  osh: integer;
  ui: Extended;
begin
  Val(StringReplace(EditU.Text, ',', '.', [rfReplaceAll]), ui, osh);
  if osh <> 0 then
    ShowMessage('Введено не верное значение');
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  EditU.Text := StringReplace(FloatToStr(Input.U), ',', '.', [rfReplaceAll]);
  EditDeltaU.Text := IntToStr(Input.DeltaU);
end;

end.
