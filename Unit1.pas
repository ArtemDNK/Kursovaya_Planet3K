unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CALCULAT008, Spin, Grids,
  Materials, Unit2, constants, unit4, unit5, ComCtrls;

// type
// PDBFile = ^TDBFile;
// TDBFile = object(TObject)
// HeaderLen: word;
// RecordLen: word;
// CurrentRec: longint;
// end;
type
  // PCogWheelTransCAD = ^TCogWheelTransCAD;
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
    procedure Edit5Click(Sender: TObject);

  private
    { Private declarations }
  public
    // procedure  picat;
    { Public declarations }
  published
    property TabOrder;
  end;

var
  clas: CalculateCWheel;
  FChild: TForm2;
  FChild1: TForm4;
  FChild2: TForm5;
  mascount1, oo: integer;
  masOutput1: array of TMyOutput;
  masInput1: array of TMyInput;
  Form1: TForm1;
  FileName: string;
  i, k: integer;
  // MaterialsDB: PDBFile;
  Input, Input1: TMyInput;
  Output: TMyOutput;
  // Loading:TLoading;
  // P1,               {Мощность, передаваемая быстроходным валом}
  // n1,               {Частота вращения быстроходного вала}
  // U:real;           {Передаточное число передачи}
  // DeltaU: byte;
  // Lh:longint;          {Расчетный ресурс передачи}
  // Tipz:word;        {тип зубьев колес: 1 - прямые
  // 2 - косые
  // 3 - шевронные
  // 0 - автовыбор}
  // betg:byte;        {угол наклона зуба в градусах;
  // при Tipz= 0 становится варьируемым
  // параметром со знчениями 0, 10, 25 }
  // kanavka: word;    {Для шевронных колес при наличии канавки = 1,
  // при отсутствии канавки =0}
  // mc1:TSteelMark;   {марка стали для шестерни}   {????????????????}
  // mc2:TSteelMark;   {марка стали для колеса}     {??????????????????}
  // Termobr1,         {термообработка зуба шестерни, номер}
  // Termobr2:byte;    {термообработка зуба колеса, номер}
  // ImprovStrength: array [1..2] of boolean;
  // Zagotowka:TTwoWord;
  // {Способ получения заготовки шестерни и колеса
  // = 1 для поковок
  // = 2 для штамповок
  // = 3 для проката
  // = 4 для отливок  }
  // Ra1,              {Шероховатость боковой поверхности зуба шестерни}
  // Ra2:word;         {Шероховатость боковой поверхности зуба колеса}
  // Wikrugka:TTwoWord;
  // {Финишная обработка выкружки зуба
  // = 0 выкружка зубофрезерована или шлифована
  // = 1 при полировании выкружки}
  //
  // Nom_sx: byte;     {Номер схемы расположения колес}
  // Zw:byte;          {Число колес находящихся в одновремен-
  // ном контакте с шестерней}
  // Psi_ba:real;      {Коффициент ширины венца,
  // при фиксированном значении вводится из стандартного
  // ряда в зависимости от схемы передачи;
  // при вводе АВТОВЫБОР становится варьируемым
  // параметром также в зависимости от схемы передачи}
  // Nagr,             {=1 для типового режима,
  // = 0 для циклограммы}
  // rewers:boolean;   {При реверсировании = 1;
  // без реверсирования = 0}
  // Ka:real;          {Коэффициент внешней динамики}
  // otw1:boolean;     {При стандартном межосевом расстоянии = 'Y',
  // при нестандартном межосевом расстоянии ='n'}
  // BISTR:boolean;    { "0", если передача является тихоходной ступенью}
  // { "1", если передача является быстроходной ступенью}
  // motw:TTwoWord;
  // {Выбор инструмента:
  // 1   при нарезании долбяком
  // 0   при нарезании фрезой
  // 2   при нарезании старым долбякоми}
  // H_HRcs1,          {Твердость сердцевины зуба шестерни по Роквеллу}
  // H_HRcs2,          {Твердость сердцевины зуба колеса по Роквеллу}
  // H_HRcp1,          {Твердость поверхности зуба шестерни по Роквеллу}
  // H_HRcp2,          {Твердость поверхности зуба колеса по Роквеллу}
  // H_HBs1,           {Твердость сердцевины зуба шестерни по Бринелю}
  // H_HBs2,           {Твердость сердцевины зуба колеса по Бринелю}
  // H_HBp1,           {Твердость поверхности зуба шестерни по Бринелю}
  // H_HBp2,           {Твердость поверхности зуба колеса по Бринелю}
  // H_HVs1,           {Твердость сердцевины зуба шестерни по Виккерсу}
  // H_HVs2,           {Твердость сердцевины зуба колеса по Виккерсу}
  // H_HVp1,           {Твердость поверхности зуба шестерни по Виккерсу}
  // H_HVp2 : integer; {Твердость поверхности зуба колеса по Виккерсу}
  // S_f1,             { Коэффициент выносливости по изгибу для шестерни}
  // S_f2,             { Коэффициент выносливости по изгибу для колеса}
  // Y_d1,             {Коэффициент деформационного упрочнения для шестерни}
  // Y_d2,             {Коэффициент деформационного упрочнения для колеса}
  // Y_g1,             {Коэффициент, учитывающий шлифование  для шестерни}
  // Y_g2 : real;      {Коэффициент, учитывающий шлифование  для колеса}
  // Sigma_t1,         {Предел текучести материала шестерни}
  // Sigma_t2,         {Предел текучести материала колеса}
  // Sigma_Flim01,     {Предел выносливости по изгибу для шестерни}
  // Sigma_Flim02,     {Предел выносливости по изгибу для колеса}
  // Sigma_Fst01,      {Предельное напряжение для шестерни}
  // Sigma_Fst02: real; {Предельное напряжение для колеса}
  // Mn: real;                {Нормальный модуль }
  // {-------------------------------------------------------------------}
  // {--------------------- Критерии качества ---------------------------------}
  // Massa,                   {Суммарная масса зубчатых колес}
  // V_p,                     {Объём занимаемый передачей}
  // B1,
  // aw,                      {межосевое расстояние передачи}
  // Da2: real;
  // {-------------------------------------------------------------------------}
  // b2: real;                {ширина венца}
  // z1, z2 : word;           {Числа зубьев}
  // St : integer;            {Степень точности}
  // Fv : real ;              {Суммарное давление на вал}
  // epsias:real;             {суммарный к-т перекрытия}
  // alfatw:Real;             {угол зацепления зубчатых колес}
  // Uf,                      {Фактическое передаточное число передачи}
  // n2 : real;               {Частота вращения колеса}
  // V : real;                 { Скорость, м/с}
  // Da1,                {Диаметр окружности вершин }
  // d1,  d2,                 {Делительный диаметр}
  // x1,  x2:real;            {Коэффициент смещения исходного контура}
  // Dw1,                      {Начальный диаметр }
  // Df1,                      {Диаметр окружности впадин }
  // Dw2,                      {Начальный диаметр }
  // Df2,                      {Диаметр окружности впадин }
  // Bet: real;
  // Sigma_H,                  {Контактное напряжение }
  // T1,                     {Момент, передаваемый быстроходным валом}
  // T2,                     {Момент, передаваемый тихоходным валом}
  // Ft1,                      { Окружное усилие   }
  // Fr1,                      {Радиальное усилие}
  // Fx1,                      {Осевое усилие  }
  // Ft2,                      { Окружное усилие}
  // Fr2,                      { Радиальное усилие}
  //
  //
  // Fx2 : real;
  // Sigma_F1,                 {Напряжения изгиба в зубе шестерни}
  // Sigma_F2,                 {Напряжения изгиба в зубе колеса}
  // Sigma_Fp1,
  // Sigma_Fp2,               {Допускаемые напряжения изгиба }
  // Sigma_Hp :real;          {Допускаемое контактное напряжение}
  f: TextFile;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Error: byte;
  p, osh: integer;
  TabSheet1: TTabSheet;
begin
  while PageControl1.PageCount > 0 do
    PageControl1.Pages[0].Free;
  Input.TipZ := 1;
  val(EditP1.Text, Input.p1, osh);
  val(EditN1.Text, Input.N1, osh);
  val(EditU.Text, Input.U, osh);
  val(Edit4.Text, Input.Lh, osh);
  Input.mc1 := ComboBox1.Text;

  if ComboBox2.Text = 'AUTO' then
    Input.Termobr1 := 0; { 1 .. 8 }
  if ComboBox2.Text = 'Улучшение' then
    Input.Termobr1 := 1;
  if ComboBox2.Text = 'Нормализация' then
    Input.Termobr1 := 2;
  if ComboBox2.Text = 'Объемная закалка' then
    Input.Termobr1 := 3;
  if ComboBox2.Text = 'Эакалка ТВЧ' then
    Input.Termobr1 := 4;
  if ComboBox2.Text = 'Цементация' then
    Input.Termobr1 := 5;
  if ComboBox2.Text = 'Нитроцементация' then
    Input.Termobr1 := 6;
  if ComboBox2.Text = 'Азотирование' then
    Input.Termobr1 := 7;
  if ComboBox2.Text = 'Отжиг' then
    Input.Termobr1 := 8;
  Input.mc2 := ComboBox3.Text;
  Input.mc3 := ComboBox15.Text;
  Input.mc5 := ComboBox20.Text;

  if ComboBox4.Text = 'AUTO' then
    Input.Termobr2 := 0; { 1 .. 8 }
  if ComboBox4.Text = 'Улучшение' then
    Input.Termobr2 := 1;
  if ComboBox4.Text = 'Нормализация' then
    Input.Termobr2 := 2;
  if ComboBox4.Text = 'Объемная закалка' then
    Input.Termobr2 := 3;
  if ComboBox4.Text = 'Эакалка ТВЧ' then
    Input.Termobr2 := 4;
  if ComboBox4.Text = 'Цементация' then
    Input.Termobr2 := 5;
  if ComboBox4.Text = 'Нитроцементация' then
    Input.Termobr2 := 6;
  if ComboBox4.Text = 'Азотирование' then
    Input.Termobr2 := 7;
  if ComboBox4.Text = 'Отжиг' then
    Input.Termobr2 := 8;

  if ComboBox16.Text = 'AUTO' then
    Input.Termobr3 := 0; { 1 .. 8 }
  if ComboBox16.Text = 'Улучшение' then
    Input.Termobr3 := 1;
  if ComboBox16.Text = 'Нормализация' then
    Input.Termobr3 := 2;
  if ComboBox16.Text = 'Объемная закалка' then
    Input.Termobr3 := 3;
  if ComboBox16.Text = 'Эакалка ТВЧ' then
    Input.Termobr3 := 4;
  if ComboBox16.Text = 'Цементация' then
    Input.Termobr3 := 5;
  if ComboBox16.Text = 'Нитроцементация' then
    Input.Termobr3 := 6;
  if ComboBox16.Text = 'Азотирование' then
    Input.Termobr3 := 7;
  if ComboBox16.Text = 'Отжиг' then
    Input.Termobr3 := 8;

  if ComboBox21.Text = 'AUTO' then
    Input.Termobr5 := 0; { 1 .. 8 }
  if ComboBox21.Text = 'Улучшение' then
    Input.Termobr5 := 1;
  if ComboBox21.Text = 'Нормализация' then
    Input.Termobr5 := 2;
  if ComboBox21.Text = 'Объемная закалка' then
    Input.Termobr5 := 3;
  if ComboBox21.Text = 'Эакалка ТВЧ' then
    Input.Termobr5 := 4;
  if ComboBox21.Text = 'Цементация' then
    Input.Termobr5 := 5;
  if ComboBox21.Text = 'Нитроцементация' then
    Input.Termobr5 := 6;
  if ComboBox21.Text = 'Азотирование' then
    Input.Termobr5 := 7;
  if ComboBox21.Text = 'Отжиг' then
    Input.Termobr5 := 8;

  Input.ImprovStrength[1] := CheckBox5.Checked; { TODO : Добавить в запись }
  Input.ImprovStrength[2] := CheckBox6.Checked;
  Input.ImprovStrength[3] := CheckBox7.Checked;
  Input.ImprovStrength[4] := CheckBox8.Checked;

  if ComboBox7.Text = 'Ra1.6' then
    Input.Ra1 := 0;
  if ComboBox7.Text = 'Ra3.2' then
    Input.Ra1 := 1;
  if ComboBox7.Text = 'Ra6.3' then
    Input.Ra1 := 2;

  if ComboBox8.Text = 'Ra1.6' then
    Input.Ra2 := 0;
  if ComboBox8.Text = 'Ra3.2' then
    Input.Ra2 := 1;
  if ComboBox8.Text = 'Ra6.3' then
    Input.Ra2 := 2;

  if ComboBox14.Text = 'Ra1.6' then
    Input.Ra3 := 0;
  if ComboBox14.Text = 'Ra3.2' then
    Input.Ra3 := 1;
  if ComboBox14.Text = 'Ra6.3' then
    Input.Ra3 := 2;

  if ComboBox22.Text = 'Ra1.6' then
    Input.Ra5 := 0;
  if ComboBox22.Text = 'Ra3.2' then
    Input.Ra5 := 1;
  if ComboBox22.Text = 'Ra6.3' then
    Input.Ra5 := 2;

  if ComboBox9.Text = 'Поковка' then
    Input.Zagotowka[1] := 1;
  if ComboBox9.Text = 'Штамповка' then
    Input.Zagotowka[1] := 2;
  if ComboBox9.Text = 'Прокат' then
    Input.Zagotowka[1] := 3;
  if ComboBox9.Text = 'Отливка' then
    Input.Zagotowka[1] := 4;

  if ComboBox10.Text = 'Поковка' then
    Input.Zagotowka[2] := 1;
  if ComboBox10.Text = 'Штамповка' then
    Input.Zagotowka[2] := 2;
  if ComboBox10.Text = 'Прокат' then
    Input.Zagotowka[2] := 3;
  if ComboBox10.Text = 'Отливка' then
    Input.Zagotowka[2] := 4;

  if ComboBox17.Text = 'Поковка' then
    Input.Zagotowka[3] := 1;
  if ComboBox17.Text = 'Штамповка' then
    Input.Zagotowka[3] := 2;
  if ComboBox17.Text = 'Прокат' then
    Input.Zagotowka[3] := 3;
  if ComboBox17.Text = 'Отливка' then
    Input.Zagotowka[3] := 4;

  if ComboBox23.Text = 'Поковка' then
    Input.Zagotowka[4] := 1;
  if ComboBox23.Text = 'Штамповка' then
    Input.Zagotowka[4] := 2;
  if ComboBox23.Text = 'Прокат' then
    Input.Zagotowka[4] := 3;
  if ComboBox23.Text = 'Отливка' then
    Input.Zagotowka[4] := 4;

  if ComboBox11.Text = 'Фрезерование' then
    Input.motw[1] := 0;
  if ComboBox11.Text = 'Шлифование' then
    Input.motw[1] := 1;
  if ComboBox11.Text = 'Полирование' then
    Input.motw[1] := 2;

  if ComboBox12.Text = 'Фрезерование' then
    Input.motw[2] := 0;
  if ComboBox12.Text = 'Шлифование' then
    Input.motw[2] := 1;
  if ComboBox12.Text = 'Полирование' then
    Input.motw[2] := 2;

  if ComboBox18.Text = 'Фрезерование' then
    Input.motw[3] := 0;
  if ComboBox18.Text = 'Шлифование' then
    Input.motw[3] := 1;
  if ComboBox18.Text = 'Полирование' then
    Input.motw[3] := 2;

  if ComboBox24.Text = 'Фрезерование' then
    Input.motw[4] := 0;
  if ComboBox24.Text = 'Шлифование' then
    Input.motw[4] := 1;
  if ComboBox24.Text = 'Полирование' then
    Input.motw[4] := 2;

  Input.Bistr := CheckBox1.Checked;
  if oo = 1 then
  begin
    Input.TipZ := FChild.RadioGroup1.ItemIndex;
    val(FChild.EditBetg.Text, Input.Betg, osh);
    if FChild.CheckBox1.Checked then
      Input.Kanavka := 1
    else
      Input.Kanavka := 0;
  end
  else
    Input.TipZ := 1;
  Input.Zw := SpinEditZw.Value;
  Input.Rewers := CheckBox3.Checked;
  val(Edit5.Text, Input.Ka, osh);
  Input.otw1 := CheckBox2.Checked;

  if ((ComboBox6.Text = 'Фреза') or (ComboBox6.Text = 'Долбяк старый')) then
    Input.Wikrugka[1] := 0
  else
    Input.Wikrugka[1] := 1;

  if ((ComboBox13.Text = 'Фреза') or (ComboBox13.Text = 'Долбяк старый')) then
    Input.Wikrugka[2] := 0
  else
    Input.Wikrugka[2] := 1;

  if ((ComboBox19.Text = 'Фреза') or (ComboBox19.Text = 'Долбяк старый')) then
    Input.Wikrugka[3] := 0
  else
    Input.Wikrugka[3] := 1;

  if ((ComboBox25.Text = 'Фреза') or (ComboBox25.Text = 'Долбяк старый')) then
    Input.Wikrugka[4] := 0
  else
    Input.Wikrugka[4] := 1;

  Input.nagr := False;
  Input.Loading.GraphBar := 0;
  with Input.Loading do
  begin
    x := 2;
    y := 0.3;
    z := 0.2;
    i := 0.6;
    j := 0.2;
    k := 0.2;
  end;

  // Input.DeltaU:=2;
  Output.mn := 0;
  Input.Nom_Sx := strtoint(ButtonNom_Sx.Caption);
  // Input.p1:=10;    { 0.2..300  }
  // Input.N1:=750;       { 1 .. 5000 об/мин }
  // Input.U:=3.58;       { 1 .. 8 }
  // Input.mc1:='45 ГОСТ 1050-74';
  // Input.mc2:='45 ГОСТ 1050-74';
  // Input.Termobr1:=2;        {1 .. 8 }
  // Input.Termobr2:=2;        {1 .. 8 }
  // ImprovStrength[1]:=False;
  // ImprovStrength[2]:=False;
  // Input.Lh:=6300;           {10 ... 100000 ч}
  // Input.Betg:=0;            { 0 .. 45}
  // Input.Kanavka:=0;
  // Input.Ka:=1.0;
  // Input.Wikrugka[1]:=0;
  // Input.Wikrugka[2]:=0;
  // Input.Ra1:=2;
  // Input.Ra2:=2;
  // Input.Zw:=1;
  // Input.TipZ:=1;
  // Input.Rewers:=False;
  // Input.Bistr:=True;
  // Input.Zagotowka[1]:=1;
  // Input.Zagotowka[2]:=1;
  // val( edit5.Text,Input.Nom_Sx,osh);
  // Input.motw[1] := 0;
  // Input.motw[2] := 0;
  // Input.otw1 := True;
  // MaterialsDB:=nil;
  clas.MakeVersionss(Input);
  ShowMessage('Всего вариантов =   ' + inttostr(mascount));
  SetLength(masOutput1, mascount);
  SetLength(masInput1, mascount);
  for i := 0 to mascount - 1 do
  begin
    CALCULAT008.MasOutputOnForm(i, Output, Input1);
    masOutput1[i] := Output;
    masInput1[i] := Input1;
    // Создаем первую страницу и связываем ее с PageControl
    TabSheet1 := TTabSheet.Create(Self);
    TabSheet1.Caption := 'Вариант' + inttostr(i + 1);
    TabSheet1.PageControl := PageControl1;
    // Создаем первую страницу
    with Tmemo.Create(Self) do
    begin
      width := 465;
      Height := 717;
      Parent := TabSheet1;
      ScrollBars := ssVertical;
      Lines.Append('         Исходные данные');
      Lines.Append('Мощность на ведущем валу, кВт  ' + floattostr(Input1.p1));
      Lines.Append('Частота вращения шестерни, об/мин  ' +
        floattostr(Input1.N1));
      Lines.Append('Проектное передаточное число  ' + floattostr(Input1.U));
      Lines.Append('Расчетный срок службы, час  ' + floattostr(Input1.Lh));

      Lines.Append('Материал шестерни  ' + (Input1.mc1));

      Lines.Append('Термообработка шестерни ' + (HandleStr[Input1.Termobr1]));

      Lines.Append('Материал сателлита  ' + (Input1.mc2));
      Lines.Append('Термообработка сателлита  ' + (HandleStr[Input1.Termobr2]));

      Lines.Append('Материал колеса  ' + (Input1.mc3));
      Lines.Append('Термообработка колеса  ' + (HandleStr[Input1.Termobr3]));

      Lines.Append('Материал второго колеса  ' + (Input1.mc5));
      Lines.Append('Термообработка второго колеса  ' + (HandleStr[Input1.Termobr5]));

      Lines.Append('Заготовка шестерни  ' + floattostr(Input1.Zagotowka[1]));
      Lines.Append('Заготовка сателлита  ' + floattostr(Input1.Zagotowka[2]));
      Lines.Append('Заготовка колеса  ' + floattostr(Input1.Zagotowka[3]));
      Lines.Append('Заготовка второго колеса  ' + floattostr(Input1.Zagotowka[4]));

      Lines.Append('Обработка выкружки шестерни  ' +
        floattostr(Input1.motw[1]));
      Lines.Append('Обработка выкружки сателлита ' +
        floattostr(Input1.motw[2]));
      Lines.Append('Обработка выкружки колеса ' +
        floattostr(Input1.motw[3]));
      Lines.Append('Обработка выкружки второго колеса ' +
        floattostr(Input1.motw[4]));

      Lines.Append('Тип зубьев  ' + (CogType[Input1.TipZ]));
      Lines.Append('Зуборезный инструмент шестерни  ' +
        floattostr(Input1.Wikrugka[1]));
      Lines.Append('Зуборезный инструмент сателлита '+
        floattostr(Input1.Wikrugka[2]));
      Lines.Append('Зуборезный инструмент колеса ' +
        floattostr(Input1.Wikrugka[3]));
      Lines.Append('Зуборезный инструмент второго колеса ' +
        floattostr(Input1.Wikrugka[4]));

      Lines.Append('   ');

      Lines.Append('         Кинематические параметры');
      Lines.Append('Количество сателлитов ' + IntToStr(Output.zw));
      Lines.Append('Фактическое передаточное число передачи  ' +
        floattostr(Output.Uf));
      Lines.Append('Частота вращения быстроходного вала  ' +
        floattostr(Input.N1));
      Lines.Append('Частота вращения колеса  ' + floattostr(Output.n2));
      Lines.Append('Скорость, м/с ' + floattostr(Output.V));
      Lines.Append('   ');
      Lines.Append('         Параметры передачи');
      Lines.Append('Нормальный модуль ' + floattostr(Output.mn));
      Lines.Append('Межосевое расстояние передачи  ' + floattostr(Output.aw));
      Lines.Append('Степень точности   ' + inttostr(Output.St));
      Lines.Append('Суммарный к-т перекрытия  ' + floattostr(Output.epsias));
      Lines.Append('Угол зацепления зубчатых колес  ' +
        floattostr(Output.alfatw * 180 / Pi));
      Lines.Append('Числа зубьев колеса  ' + inttostr(Output.z3));
      Lines.Append('Числа зубьев второго колеса  ' + inttostr(Output.z5));
      Lines.Append('Числа зубьев сателлита  ' + inttostr(Output.z2));
      Lines.Append('Числа зубьев шестерни  ' + inttostr(Output.z1));

      Lines.Append('Коэффициент смещения исходного контура колеса  ' +
        floattostr(Output.x2));
      Lines.Append('Коэффициент смещения исходного контура  шестерни ' +
        floattostr(Output.x1));
      Lines.Append('    ');

      Lines.Append('          Размеры колес');
      Lines.Append('Диаметр окружности вершин шестерни  ' +
        floattostr(Output.Da1));
      Lines.Append('Делительный диаметр шестерни  ' + floattostr(Output.d1));
      Lines.Append('Начальный диаметр шестерни  ' + floattostr(Output.Dw1));
      Lines.Append('Диаметр окружности впадин шестерни ' +
        floattostr(Output.Df1));
      Lines.Append('Ширина венца шестерни ' + floattostr(Output.B1));


      Lines.Append('Диаметр окружности вершин  сателлита G ' +   floattostr(Output.Da2));
      Lines.Append('Делительный диаметр сателлита G  ' + floattostr(Output.d2));
      Lines.Append('Начальный диаметр сателлита G  ' + floattostr(Output.Dw2));
      Lines.Append('Диаметр окружности впадин сателлита G ' +  floattostr(Output.Df2));
      Lines.Append('Ширина венца сателлита G ' + floattostr(Output.B2));

      Lines.Append('Диаметр окружности вершин  сателлита F ' +
        floattostr(Output.Da4));
      Lines.Append('Делительный диаметр сателлита  F ' + floattostr(Output.d4));
      Lines.Append('Начальный диаметр сателлита F  ' + floattostr(Output.Dw4));
      Lines.Append('Диаметр окружности впадин сателлита F ' +
        floattostr(Output.Df4));
      Lines.Append('Ширина венца сателлита F ' + floattostr(Output.B4));

      Lines.Append('Диаметр окружности вершин  колеса ' +
        floattostr(Output.Da3));
      Lines.Append('Делительный диаметр колеса  ' + floattostr(Output.d3));
      Lines.Append('Начальный диаметр колеса  ' + floattostr(Output.Dw3));
      Lines.Append('Диаметр окружности впадин колеса ' +
        floattostr(Output.Df3));
      Lines.Append('Ширина венца колеса ' + floattostr(Output.B3));

      Lines.Append('Диаметр окружности вершин второго колеса ' +
        floattostr(Output.Da5));
      Lines.Append('Делительный диаметр второго колеса  ' + floattostr(Output.d5));
      Lines.Append('Начальный диаметр второго колеса  ' + floattostr(Output.Dw5));
      Lines.Append('Диаметр окружности впадин второго колеса ' +
        floattostr(Output.Df5));
      Lines.Append('Ширина венца второго колеса ' + floattostr(Output.B5));

      Lines.Append('    ');
      Lines.Append('            Прочностные и силовые параметры');
      Lines.Append('Контактное напряжение  ' + floattostr(Output.Sigma_H));
      Lines.Append('Момент, передаваемый быстроходным валом  ' +
        floattostr(Output.T1));
      Lines.Append('Момент, передаваемый тихоходным валом  ' +
        floattostr(Output.T2));
      Lines.Append('Суммарное давление на вал  ' + floattostr(Output.Fv));
      Lines.Append('Окружное усилие шестерни ' + floattostr(Output.Ft2));
      Lines.Append('Радиальное усилие шестерни ' + floattostr(Output.Fr2));
      Lines.Append('Окружное усилие колеса   ' + floattostr(Output.Ft1));
      Lines.Append('Радиальное усилие колеса  ' + floattostr(Output.Fr1));
    end;
  end;
{$REGION 'ненужное'}
  // memo1.Lines.Append('         Кинематические параметры');
  // memo1.Lines.Append('Фактическое передаточное число передачи  '+floattostr(Output.Uf));
  // memo1.Lines.Append('Частота вращения быстроходного вала  '+floattostr(Input.N1));
  // memo1.Lines.Append('Частота вращения колеса  '+floattostr(Output.n2));
  // memo1.Lines.Append('Скорость, м/с}  '+floattostr(Output.V));
  // memo1.Lines.Append('   ');
  // memo1.Lines.Append('         Параметры передачи');
  // memo1.Lines.Append('Нормальный модуль '+floattostr(Output.Mn));
  // memo1.Lines.Append('межосевое расстояние передачи  '+floattostr(Output.aw));
  // memo1.Lines.Append('угол наклона зуба в градусах  '+floattostr(Input.betg));
  // memo1.Lines.Append('Степень точности   '+inttostr(Output.St));
  // memo1.Lines.Append('суммарный к-т перекрытия  '+floattostr(Output.epsias));
  // memo1.Lines.Append('угол зацепления зубчатых колес  '+floattostr(Output.alfatw));
  // memo1.Lines.Append('Числа зубьев колеса  '+inttostr(Output.z2));
  // memo1.Lines.Append('Числа зубьев шестерни  '+inttostr(Output.z1));
  // memo1.Lines.Append('Коэффициент смещения исходного контура колеса  '+floattostr(Output.x2));
  // memo1.Lines.Append('Коэффициент смещения исходного контура  шестерни '+floattostr(Output.x1));
  // memo1.Lines.Append('    ');
  // memo1.Lines.Append('          Размеры колес');
  // memo1.Lines.Append('Диаметр окружности вершин шестерни  '+floattostr(Output.Da1));
  // memo1.Lines.Append('Делительный диаметр шестерни  '+floattostr(Output.d1));
  // memo1.Lines.Append('Начальный диаметр шестерни  '+floattostr(Output.Dw1));
  // memo1.Lines.Append('Диаметр окружности впадин шестерни '+floattostr(Output.Df1));
  // memo1.Lines.Append('Ширина венца шестерни '+floattostr(Output.B1));
  //
  // memo1.Lines.Append('Диаметр окружности вершин  колеса '+floattostr(Output.Da2));
  // memo1.Lines.Append('Делительный диаметр колеса  '+floattostr(Output.d2));
  // memo1.Lines.Append('Начальный диаметр колеса  '+floattostr(Output.Dw2));
  // memo1.Lines.Append('Диаметр окружности впадин колеса '+floattostr(Output.Df2));
  // memo1.Lines.Append('Ширина венца колеса '+floattostr(Output.B2));
  //
  // memo1.Lines.Append('    ');
  // memo1.Lines.Append('            Прочностные и силовые параметры');
  // memo1.Lines.Append('Контактное напряжение  '+floattostr(Output.Sigma_H));
  // memo1.Lines.Append('Момент, передаваемый быстроходным валом  '+floattostr(Output.T1));
  // memo1.Lines.Append('Момент, передаваемый тихоходным валом  '+floattostr(Output.T2));
  // memo1.Lines.Append('Суммарное давление на вал  '+floattostr(Output.Fv));
  // memo1.Lines.Append('Окружное усилие шестерни '+floattostr(Output.Ft2));
  // memo1.Lines.Append('Радиальное усилие шестерни '+floattostr(Output.Fr2));
  // memo1.Lines.Append('Осевое усилие шестерни '+floattostr(Output.Fx2));
  // memo1.Lines.Append('Окружное усилие колеса   '+floattostr(Output.Ft1));
  // memo1.Lines.Append('Радиальное усилие колеса  '+floattostr(Output.Fr1));
  // memo1.Lines.Append('Осевое усилие колеса  '+floattostr(Output.Fx1));
{$ENDREGION }
end;

procedure TForm1.ButtonNom_SxClick(Sender: TObject);
begin
  FChild2 := TForm5.Create(Self);
  FChild2.Show;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked then
    CheckBox4.Caption := 'Типовой'
  else
    CheckBox4.Caption := 'Циклограмма';
end;

procedure TForm1.Edit4Exit(Sender: TObject);
var
  osh: integer; // код ошибки
begin
  val(Edit4.Text, Input.Lh, osh);
  if osh <> 0 then
    ShowMessage('Введено не верное значение')
  else
    clas.Lh := Input.Lh;
end;

procedure TForm1.Edit5Click(Sender: TObject);
//var
  //FChild1: Tform6;
  //ka1: Extended;
begin
//  ka1 := 1;
//  try
//    FChild1 := Tform6.Create(Self);
//    if FChild1.ShowModal = mrOK then
//      case FChild1.RadioGroup1.ItemIndex of
//        0:
//          ka1 := 1;
//        1:
//          ka1 := 1.10;
//        2:
//          ka1 := 1.25;
//        3:
//          ka1 := 1.50;
//      end;
//    case FChild1.RadioGroup1.ItemIndex of
//      0:
//        ka1 := ka1 + 0;
//      1:
//        ka1 := ka1 + 0.25;
//      2:
//        ka1 := ka1 + 0.50;
//      3:
//        ka1 := ka1 + 0.75;
//    end;
//    Edit5.Text := floattostr(ka1);
//    clas.Ka := ka1;
//  finally
//    FChild1.Free;
//    FChild1 := nil;
//  end;
end;

procedure TForm1.EditN1Exit(Sender: TObject);
var
  osh: integer; // код ошибки
begin
  val(EditN1.Text, Input.N1, osh);
  if osh <> 0 then
    ShowMessage('Введено не верное значение')
  else
    clas.N1 := Input.N1;
end;

procedure TForm1.EditP1Exit(Sender: TObject);
var
  osh: integer; // код ошибки
begin
  val(EditP1.Text, Input.p1, osh);
  if osh <> 0 then
    ShowMessage('Введено не верное значение')
  else
    clas.p1 := Input.p1;

end;

procedure TForm1.Editp1KeyPress(Sender: TObject; var Key: Char);
var
  i: integer;
begin
  if not(Key in ['0' .. '9', '.', #8]) then
    Key := #0;
  for i := 1 to Length((Sender as TEdit).Text) do
    if ((Key = '.') and ((Sender as TEdit).Text[i] = '.')) then
      Key := #0;
end;

procedure TForm1.EditUClick(Sender: TObject);
var
  FChild1: TForm4;
  St: string;
  ui: Extended;
  osh: integer;
begin
  FChild1 := TForm4.Create(Self);
  try
    if FChild1.ShowModal = mrOK then
    begin
      // Val понимает только точку как десятичный разделитель
      St := StringReplace(FChild1.EditU.Text, ',', '.', [rfReplaceAll]);
      val(St, ui, osh);
      if osh <> 0 then
        ShowMessage('Введено не верное значение')
      else
      begin
        clas.U := ui;
        Input.U := ui;
        EditU.Text := St;
      end;
    end;
  finally
    FChild1.Free;
  end;
end;

procedure TForm1.EditUExit(Sender: TObject);
var
  osh: integer; // код ошибки
begin
  val(EditU.Text, Input.U, osh);
  if osh <> 0 then
    ShowMessage('Введено не верное значение')
  else
    clas.U := Input.U;

end;

procedure TForm1.EditUKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0
end;

procedure TForm1.FormShow(Sender: TObject);
var
  i: integer;
begin
  Input.DeltaU := 2;
  Input.U := 3.58;
  clas := CalculateCWheel.Create;
  for i := Low(marca1) to High(marca1) do // сделать лоу  на все
    ComboBox1.Items.Add(marca1[i]);
  ComboBox1.Text := '45 ГОСТ 1050-74';
  for i := 0 to 8 do
    ComboBox2.Items.Add(HandleStr[i]);
  for i := 0 to 24 do
    begin
      ComboBox3.Items.Add(marca1[i]);
      ComboBox15.Items.Add(marca1[i]);
      ComboBox20.Items.Add(marca1[i]);
    end;
  ComboBox3.Text := '45 ГОСТ 1050-74';
  ComboBox15.Text := '45 ГОСТ 1050-74';
  ComboBox20.Text := '45 ГОСТ 1050-74';
  for i := 0 to 8 do
    begin
      ComboBox4.Items.Add(HandleStr[i]);
      ComboBox16.Items.Add(HandleStr[i]);
      ComboBox21.Items.Add(HandleStr[i]);
    end;
  for i := 0 to 2 do
    ComboBox7.Items.Add(roughness[i]);
  for i := 0 to 2 do
    begin
      ComboBox8.Items.Add(roughness[i]);
      ComboBox14.Items.Add(roughness[i]);
      ComboBox22.Items.Add(roughness[i]);
    end;
  for i := 0 to 3 do
    ComboBox9.Items.Add(PatternProcess[i]);
  for i := 0 to 3 do
    begin
    ComboBox10.Items.Add(PatternProcess[i]);
    ComboBox17.Items.Add(PatternProcess[i]);
    ComboBox23.Items.Add(PatternProcess[i]);
    end;
  for i := 0 to 2 do
    ComboBox11.Items.Add(Finish[i]);
  for i := 0 to 2 do
    begin
    ComboBox12.Items.Add(Finish[i]);
    ComboBox18.Items.Add(Finish[i]);
    ComboBox24.Items.Add(Finish[i]);
    end;
  for i := 0 to 5 do
    ComboBox5.Items.Add(LoadStr[i]);
  for i := 0 to 2 do
    ComboBox6.Items.Add(ToolStr[i]);
  for i := 0 to 2 do
    begin
    ComboBox13.Items.Add(ToolStr[i]);
    ComboBox19.Items.Add(ToolStr[i]);
    ComboBox25.Items.Add(ToolStr[i]);
    end;
end;

procedure TForm1.SpinEditZwExit(Sender: TObject);
begin
  clas.Zw := SpinEditZw.Value;
end;

end.
