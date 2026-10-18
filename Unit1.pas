unit Unit1;

{ Главная форма: ввод исходных данных и вывод вариантов передачи }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, CALCULAT008, constants, Unit4, Unit5;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    EditP1: TEdit;
    Label2: TLabel;
    EditN1: TEdit;
    Label3: TLabel;
    EditU: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Label9: TLabel;
    Edit4: TEdit;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    Label15: TLabel;
    Label16: TLabel;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    Label18: TLabel;
    Label19: TLabel;
    CheckBox1: TCheckBox;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    CheckBox3: TCheckBox;
    Label23: TLabel;
    CheckBox4: TCheckBox;
    Label24: TLabel;
    Label25: TLabel;
    Label28: TLabel;
    CheckBox2: TCheckBox;
    PageControl1: TPageControl;
    StatusBar1: TStatusBar;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ButtonNom_Sx: TButton;
    SpinEditZw: TSpinEdit;
    ComboBox5: TComboBox;
    Label26: TLabel;
    Edit5: TEdit;
    ComboBox6: TComboBox;
    ComboBox13: TComboBox;
    Label27: TLabel;
    Label29: TLabel;
    ComboBox15: TComboBox;
    ComboBox16: TComboBox;
    Label30: TLabel;
    CheckBox7: TCheckBox;
    Label31: TLabel;
    ComboBox14: TComboBox;
    Label32: TLabel;
    ComboBox17: TComboBox;
    Label33: TLabel;
    ComboBox18: TComboBox;
    Label34: TLabel;
    ComboBox19: TComboBox;
    Label17: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    ComboBox20: TComboBox;
    ComboBox21: TComboBox;
    CheckBox8: TCheckBox;
    ComboBox22: TComboBox;
    ComboBox23: TComboBox;
    ComboBox24: TComboBox;
    ComboBox25: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure EditP1Exit(Sender: TObject);
    procedure EditN1Exit(Sender: TObject);
    procedure EditUExit(Sender: TObject);
    procedure Editp1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure SpinEditZwExit(Sender: TObject);
    procedure EditUKeyPress(Sender: TObject; var Key: Char);
    procedure EditUClick(Sender: TObject);
    procedure ButtonNom_SxClick(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
  private
    function ReadInput: boolean;
    procedure ShowVariant(N: integer);
  end;

var
  Form1: TForm1;
  clas: CalculateCWheel;
  Input: TMyInput; { исходные данные, общие с Unit4 }

implementation

{$R *.dfm}

const
  MatName: array [1 .. 4] of string = ('шестерни a', 'сателлита (g, f)',
    'колеса b', 'колеса e');

{ Номер выбранного элемента списка; исключение, если текст не из списка }
function ComboIndex(C: TComboBox; const Name: string): integer;
begin
  Result := C.Items.IndexOf(C.Text);
  if Result < 0 then
    raise Exception.CreateFmt('Неверное значение поля "%s": %s',
      [Name, C.Text]);
end;

{ Число из поля ввода; допускается и точка, и запятая }
function ReadFloat(E: TEdit; const Name: string): Extended;
var
  osh: integer;
begin
  Val(StringReplace(Trim(E.Text), ',', '.', [rfReplaceAll]), Result, osh);
  if osh <> 0 then
    raise Exception.CreateFmt('Введено не верное значение поля "%s": %s',
      [Name, E.Text]);
end;

{ Число с точкой в качестве разделителя (для полей ввода) }
function DotStr(x: Extended): string;
begin
  Result := StringReplace(FloatToStr(x), ',', '.', [rfReplaceAll]);
end;

function F(x: Extended): string;
begin
  Result := FormatFloat('0.###', x);
end;

procedure AddItems(const Combos: array of TComboBox; const S: string);
var
  i: integer;
begin
  for i := Low(Combos) to High(Combos) do
    Combos[i].Items.Add(S);
end;

function TForm1.ReadInput: boolean;
var
  n: integer;
  Mat, HT, Ra, Zag, Wk, Tool: array [1 .. 4] of TComboBox;
  Upr: array [1 .. 4] of TCheckBox;
begin
  Result := False;
  Mat[1] := ComboBox1;  HT[1] := ComboBox2;  Ra[1] := ComboBox7;
  Mat[2] := ComboBox3;  HT[2] := ComboBox4;  Ra[2] := ComboBox8;
  Mat[3] := ComboBox15; HT[3] := ComboBox16; Ra[3] := ComboBox14;
  Mat[4] := ComboBox20; HT[4] := ComboBox21; Ra[4] := ComboBox22;
  Zag[1] := ComboBox9;  Wk[1] := ComboBox11; Tool[1] := ComboBox6;
  Zag[2] := ComboBox10; Wk[2] := ComboBox12; Tool[2] := ComboBox13;
  Zag[3] := ComboBox17; Wk[3] := ComboBox18; Tool[3] := ComboBox19;
  Zag[4] := ComboBox23; Wk[4] := ComboBox24; Tool[4] := ComboBox25;
  Upr[1] := CheckBox5;  Upr[2] := CheckBox6;
  Upr[3] := CheckBox7;  Upr[4] := CheckBox8;
  try
    Input.P1 := ReadFloat(EditP1, 'Мощность');
    Input.n1 := ReadFloat(EditN1, 'Частота вращения');
    Input.U := ReadFloat(EditU, 'Передаточное отношение');
    Input.Lh := ReadFloat(Edit4, 'Срок службы');
    Input.Ka := ReadFloat(Edit5, 'Коэффициент внешней динамики');
    Input.mc1 := Mat[1].Text;
    Input.mc2 := Mat[2].Text;
    Input.mc3 := Mat[3].Text;
    Input.mc5 := Mat[4].Text;
    Input.Termobr1 := ComboIndex(HT[1], 'Термообработка шестерни');
    Input.Termobr2 := ComboIndex(HT[2], 'Термообработка сателлита');
    Input.Termobr3 := ComboIndex(HT[3], 'Термообработка колеса');
    Input.Termobr5 := ComboIndex(HT[4], 'Термообработка второго колеса');
    Input.Ra1 := ComboIndex(Ra[1], 'Шероховатость');
    Input.Ra2 := ComboIndex(Ra[2], 'Шероховатость');
    Input.Ra3 := ComboIndex(Ra[3], 'Шероховатость');
    Input.Ra5 := ComboIndex(Ra[4], 'Шероховатость');
    for n := 1 to 4 do
    begin
      Input.ImprovStrength[n] := Upr[n].Checked;
      Input.Zagotowka[n] := ComboIndex(Zag[n], 'Заготовка') + 1;
      Input.Wikrugka[n] := ComboIndex(Wk[n], 'Обработка выкружки');
      Input.motw[n] := ComboIndex(Tool[n], 'Зуборезный инструмент');
    end;
    Input.BISTR := CheckBox1.Checked;
    Input.otw1 := CheckBox2.Checked;
    Input.rewers := CheckBox3.Checked;
    Input.Nagr := not CheckBox4.Checked; { снята галочка - циклограмма }
    Input.Loading.GraphBar := ComboIndex(ComboBox5, 'Режим нагружения');
    with Input.Loading do
    begin
      x := 2; { Tmax / T }
      y := 0.3;
      z := 0.2;
      i := 0.6;
      j := 0.2;
      k := 0.2;
    end;
    Input.Zw := SpinEditZw.Value;
    Input.Nom_sx := StrToInt(ButtonNom_Sx.Caption);
    Input.Tipz := 1; { прямозубая передача }
    Input.betg := 0;
    Input.kanavka := 0;
    Result := True;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TForm1.ShowVariant(N: integer);
var
  R: TMyOutput;
  Inp: TMyInput;
  Sheet: TTabSheet;
  M: TMemo;
  i: integer;
  HT: array [1 .. 4] of byte;
  Ra: array [1 .. 4] of word;
  Mc: array [1 .. 4] of string;

  procedure Add(const S: string);
  begin
    M.Lines.Add(S);
  end;

begin
  MasOutputOnForm(N, R, Inp);
  Sheet := TTabSheet.Create(Self);
  Sheet.Caption := 'Вариант ' + IntToStr(N + 1);
  Sheet.PageControl := PageControl1;
  M := TMemo.Create(Self);
  M.Parent := Sheet;
  M.Align := alClient;
  M.ReadOnly := True;
  M.ScrollBars := ssVertical;
  M.Lines.BeginUpdate;
  try
    HT[1] := Inp.Termobr1;  Ra[1] := Inp.Ra1;  Mc[1] := string(Inp.mc1);
    HT[2] := Inp.Termobr2;  Ra[2] := Inp.Ra2;  Mc[2] := string(Inp.mc2);
    HT[3] := Inp.Termobr3;  Ra[3] := Inp.Ra3;  Mc[3] := string(Inp.mc3);
    HT[4] := Inp.Termobr5;  Ra[4] := Inp.Ra5;  Mc[4] := string(Inp.mc5);

    Add('          Исходные данные');
    Add('Мощность на ведущем валу, кВт  ' + F(Inp.P1));
    Add('Частота вращения шестерни a, об/мин  ' + F(Inp.n1));
    Add('Требуемое передаточное отношение  ' + F(Inp.U));
    Add('Расчетный срок службы, ч  ' + F(Inp.Lh));
    Add('Число сателлитов  ' + IntToStr(R.zw));
    Add('Тип зубьев  ' + string(CogType[R.Tipz]));
    for i := 1 to 4 do
    begin
      Add('Материал ' + MatName[i] + '  ' + Mc[i] + ', ' +
        string(HandleStr[HT[i]]));
      Add('   заготовка: ' + string(PatternProcess[Inp.Zagotowka[i] - 1]) +
        ', выкружка: ' + string(Finish[Inp.Wikrugka[i]]) + ', инструмент: ' +
        string(ToolStr[Inp.motw[i]]) + ', ' + string(roughness[Ra[i]]));
    end;
    Add('');
    Add('          Кинематика и моменты');
    Add('Фактическое передаточное отношение  ' + F(R.Uf) + '  (отклонение ' +
      F((R.Uf - Inp.U) / Inp.U * 100) + ' %)');
    Add('КПД передачи  ' + F(R.Eta));
    Add('Частота вращения колеса e, об/мин  ' + F(R.n2));
    Add('Частота вращения водила, об/мин  ' + F(R.nh));
    Add('Момент на ведущем валу, Н*м  ' + F(R.T1));
    Add('Момент на ведомом валу, Н*м  ' + F(R.T2));
    Add('');
    Add('          Параметры передачи');
    Add('Модуль, мм  ' + F(R.Mn));
    Add('Межосевое расстояние, мм  ' + F(R.aw));
    Add('Коэффициент ширины венца Psi_ba  ' + F(R.Psi_ba));
    Add('Угол наклона зуба, град  ' + F(R.Bet * 180 / Pi));
    Add('Степень точности  ' + IntToStr(R.St));
    Add('Коэффициенты смещения  0 (передача без смещения)');
    Add('');
    Add('          Размеры колес, мм');
    for i := 1 to 5 do
      Add(WheelName[i] + ':  z = ' + IntToStr(R.z[i]) + ',  d = ' + F(R.d[i])
        + ',  da = ' + F(R.da[i]) + ',  df = ' + F(R.df[i]) + ',  b = ' +
        F(R.b[i]));
    Add('');
    Add('          Зацепления (силы - на один сателлит)');
    for i := 1 to 3 do
    begin
      Add('Зацепление ' + MeshName[i] + ':');
      Add('   контактное напряжение, МПа  ' + F(R.SigH[i]) +
        '  (допускаемое ' + F(R.SigHP[i]) + ')');
      Add('   при пиковой нагрузке, МПа  ' + F(R.SigHmax[i]) +
        '  (допускаемое ' + F(R.SigHPmax[i]) + ')');
      Add('   Ft = ' + F(R.Ft[i]) + ' Н,  Fr = ' + F(R.Fr[i]) + ' Н,  Fx = ' +
        F(R.Fx[i]) + ' Н');
      Add('   скорость, м/с  ' + F(R.V[i]) + ',  коэф. перекрытия  ' +
        F(R.EpsA[i] + R.EpsB[i]));
    end;
    Add('');
    Add('          Напряжения изгиба, МПа');
    for i := 1 to 5 do
      Add(WheelName[i] + ':  ' + F(R.SigF[i]) + ' (доп. ' + F(R.SigFP[i]) +
        '),  пиковое ' + F(R.SigFmax[i]) + ' (доп. ' + F(R.SigFPmax[i]) + ')');
    Add('');
    Add('Масса зубчатых колес, кг  ' + F(R.Massa));
    Add('Габаритный объем, дм^3  ' + F(R.V_p));
  finally
    M.Lines.EndUpdate;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  while PageControl1.PageCount > 0 do
    PageControl1.Pages[0].Free;
  if not ReadInput then
    Exit;
  try
    clas.MakeVersionss(Input);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;
  if mascount = 0 then
  begin
    ShowMessage('Не найдено ни одного варианта: ' +
      ErrorText(clas.LastError));
    Exit;
  end;
  ShowMessage('Всего вариантов = ' + IntToStr(mascount));
  for i := 0 to mascount - 1 do
    ShowVariant(i);
end;

procedure TForm1.ButtonNom_SxClick(Sender: TObject);
begin
  TForm5.Create(Self).Show;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked then
    CheckBox4.Caption := 'Типовой'
  else
    CheckBox4.Caption := 'Циклограмма';
end;

procedure TForm1.Edit4Exit(Sender: TObject);
begin
  try
    clas.Lh := ReadFloat(Edit4, 'Срок службы');
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TForm1.EditN1Exit(Sender: TObject);
begin
  try
    clas.n1 := ReadFloat(EditN1, 'Частота вращения');
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TForm1.EditP1Exit(Sender: TObject);
begin
  try
    clas.P1 := ReadFloat(EditP1, 'Мощность');
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TForm1.EditUExit(Sender: TObject);
begin
  try
    clas.U := ReadFloat(EditU, 'Передаточное отношение');
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

{ В числовые поля можно вводить только цифры и одну точку }
procedure TForm1.Editp1KeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0' .. '9', '.', #8]) then
    Key := #0
  else if (Key = '.') and (Pos('.', (Sender as TEdit).Text) > 0) then
    Key := #0;
end;

{ Передаточное отношение и допуск вводятся в отдельном окне }
procedure TForm1.EditUClick(Sender: TObject);
var
  Dlg: TForm4;
  osh: integer;
  ui: Extended;
  du: integer;
begin
  Dlg := TForm4.Create(Self);
  try
    if Dlg.ShowModal = mrOK then
    begin
      Val(StringReplace(Dlg.EditU.Text, ',', '.', [rfReplaceAll]), ui, osh);
      if osh = 0 then
        Val(Dlg.EditDeltaU.Text, du, osh);
      if (osh <> 0) or (du < DeltaUMin) or (du > DeltaUMax) then
        ShowMessage('Введено не верное значение')
      else
        try
          clas.U := ui;
          Input.U := ui;
          Input.DeltaU := du;
          EditU.Text := DotStr(ui);
        except
          on E: Exception do
            ShowMessage(E.Message);
        end;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TForm1.EditUKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  i: integer;
begin
  if clas <> nil then
    Exit;
  clas := CalculateCWheel.Create;
  Input.DeltaU := 2;
  Input.U := clas.U;
  EditU.Text := DotStr(clas.U);
  for i := Low(marca1) to High(marca1) do
    AddItems([ComboBox1, ComboBox3, ComboBox15, ComboBox20], string(marca1[i]));
  for i := Low(HandleStr) to High(HandleStr) do
    AddItems([ComboBox2, ComboBox4, ComboBox16, ComboBox21],
      string(HandleStr[i]));
  for i := Low(roughness) to High(roughness) do
    AddItems([ComboBox7, ComboBox8, ComboBox14, ComboBox22],
      string(roughness[i]));
  for i := Low(PatternProcess) to High(PatternProcess) do
    AddItems([ComboBox9, ComboBox10, ComboBox17, ComboBox23],
      string(PatternProcess[i]));
  for i := Low(Finish) to High(Finish) do
    AddItems([ComboBox11, ComboBox12, ComboBox18, ComboBox24],
      string(Finish[i]));
  for i := Low(ToolStr) to High(ToolStr) do
    AddItems([ComboBox6, ComboBox13, ComboBox19, ComboBox25],
      string(ToolStr[i]));
  for i := Low(LoadStr) to High(LoadStr) do
    ComboBox5.Items.Add(string(LoadStr[i]));
end;

procedure TForm1.SpinEditZwExit(Sender: TObject);
begin
  try
    clas.Zw := SpinEditZw.Value;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

end.
