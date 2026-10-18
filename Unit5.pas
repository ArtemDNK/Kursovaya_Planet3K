unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls;

type
  TForm5 = class(TForm)
    TreeView1: TTreeView;
    Button10: TButton;
    Button11: TButton;
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

  // form1: TForm1;
implementation

uses Unit1;
{$R *.dfm}

procedure TForm5.Button10Click(Sender: TObject);
begin
  if TreeView1.Selected = nil then
    Exit;
  case TreeView1.Selected.AbsoluteIndex of

    2:
      begin
        Form1.buttonNom_sx.Caption := '1';
        close;
      end;
    3:
      begin
        Form1.buttonNom_sx.Caption := '2';
        close;
      end;
    5:
      begin
        Form1.buttonNom_sx.Caption := '7';
        close;
      end;
    8:
      begin
        Form1.buttonNom_sx.Caption := '3';
        close;
      end;
    9:
      begin
        Form1.buttonNom_sx.Caption := '8';
        close;
      end;
    10:
      begin
        Form1.buttonNom_sx.Caption := '5';
        close;
      end;
    12:
      begin
        Form1.buttonNom_sx.Caption := '5';
        close;
      end;
    13:
      begin
        Form1.buttonNom_sx.Caption := '6';
        close;
      end;
    14:
      begin
        Form1.buttonNom_sx.Caption := '4';
        close;
      end;
  end;

end;

procedure TForm5.Button11Click(Sender: TObject);
begin
  close;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  TreeView1.FullCollapse;
end;

end.
