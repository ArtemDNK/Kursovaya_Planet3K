unit CALCULAT008;

{ ------------------------------------------------------------------------- }
{ Проектный и проверочный расчет планетарной передачи по схеме 3K           }
{                                                                           }
{   a - солнечная шестерня (ведущая)                                        }
{   g - венец сателлита, зацепляется с a и b                                }
{   b - неподвижное колесо с внутренними зубьями                            }
{   f - второй венец сателлита (на одной оси с g), зацепляется с e          }
{   e - подвижное колесо с внутренними зубьями (ведомое)                    }
{   Водило h - свободное (нагрузку не передает)                             }
{                                                                           }
{ Передаточное отношение  U = (1 + zb/za) / (1 - zb*zf/(zg*ze))             }
{ Расчет на прочность - по ГОСТ 21354-87, все колеса без смещения,          }
{ модуль у всех зацеплений одинаковый.                                      }
{ ------------------------------------------------------------------------- }

interface

uses
  SysUtils, Math, Materials, constants;

const
  { Номера колес }
  WA = 1; { солнечная шестерня }
  WG = 2; { сателлит, венец g }
  WB = 3; { неподвижное колесо }
  WF = 4; { сателлит, венец f }
  WE = 5; { выходное колесо }

  { Номера зацеплений }
  MAG = 1; { a - g, внешнее }
  MGB = 2; { g - b, внутреннее }
  MFE = 3; { f - e, внутреннее }

  WheelName: array [1 .. 5] of string = ('солнечная шестерня a',
    'сателлит, венец g', 'неподвижное колесо b', 'сателлит, венец f',
    'выходное колесо e');
  MeshName: array [1 .. 3] of string = ('a-g', 'g-b', 'f-e');

  { Стандартный ряд модулей, мм }
  ms: array [1 .. 41] of Extended = (1.0, 1.125, 1.25, 1.375, 1.5, 1.75, 2.0,
    2.25, 2.5, 2.75, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 7.0, 8.0, 9.0, 10.0,
    11.0, 12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 25.0, 28.0, 32.0, 36.0, 40.0,
    45.0, 50.0, 55.0, 60.0, 70.0, 80.0, 90.0, 100.0);

type
  TLoading = record
    GraphBar: word; { номер типового режима нагружения 0..5 }
    x, { отношение пикового момента к номинальному }
    y, z, { доли момента на ступенях циклограммы }
    i, j, k: single; { доли времени работы на ступенях циклограммы }
  end;

  ArrayTermobr = array [1 .. 4] of byte;
  TSteelMark = string;
  TTwoWord = array [1 .. 4] of word;

  { Исходные данные. Массивы [1..4] относятся к материалам:
    1 - шестерня a, 2 - сателлит (венцы g и f), 3 - колесо b, 4 - колесо e }
  TMyInput = record
    Loading: TLoading;
    P1, { мощность на ведущем валу, кВт }
    n1, { частота вращения ведущего вала, об/мин }
    U: Extended; { требуемое передаточное отношение }
    DeltaU: byte; { допуск на передаточное отношение, % }
    Lh: Extended; { расчетный ресурс, ч }
    Tipz: word; { тип зубьев: 1 - прямые, 2 - косые, 3 - шевронные }
    betg: Extended; { угол наклона зуба, град }
    kanavka: word; { 1 - шевронные колеса с канавкой }
    mc1, mc2, mc3, mc5: TSteelMark; { марки стали }
    Termobr1, Termobr2, Termobr3, Termobr5: byte;
    { термообработка 0..8, 0 - автовыбор (см. HandleStr) }
    ImprovStrength: array [1 .. 4] of boolean; { деформационное упрочнение }
    Zagotowka: TTwoWord; { 1 - поковка, 2 - штамповка, 3 - прокат, 4 - отливка }
    Ra1, Ra2, Ra3, Ra5: word; { шероховатость: 0 - Ra1.6, 1 - Ra3.2, 2 - Ra6.3 }
    Wikrugka: TTwoWord;
    { обработка выкружки: 0 - фрезерование, 1 - шлифование, 2 - полирование }
    Nom_sx, { номер схемы расположения колес 1..8 }
    Zw: byte; { число сателлитов }
    Psi_ba: Extended; { не используется, подбирается автоматически }
    Nagr, { True - нагрузка задана циклограммой, False - типовой режим }
    rewers: boolean; { реверсивная передача }
    Ka: Extended; { коэффициент внешней динамической нагрузки }
    otw1: boolean; { не используется: межосевое определяется модулем и z }
    BISTR: boolean; { передача быстроходная }
    motw: TTwoWord; { инструмент: 0 - фреза, 1 - новый долбяк, 2 - старый }
  end;

  TWheelReal = array [1 .. 5] of Extended;
  TWheelInt = array [1 .. 5] of integer;
  TMeshReal = array [1 .. 3] of Extended;
  TPsiList = array [0 .. 4] of Extended;

  { Результаты расчета одного варианта }
  TMyOutput = record
    Error: byte;
    zw: byte; { число сателлитов }
    Tipz: word;
    Psi_ba, { коэффициент ширины венца }
    Mn, { нормальный модуль, мм }
    aw, { межосевое расстояние, мм }
    Bet: Extended; { угол наклона зуба, рад }
    z: TWheelInt; { числа зубьев }
    d, da, df, b: TWheelReal; { диаметры и ширины венцов, мм }
    SigF, SigFP, SigFmax, SigFPmax: TWheelReal; { изгиб, МПа }
    SigH, SigHP, SigHmax, SigHPmax: TMeshReal; { контакт, МПа }
    Ft, Fr, Fx: TMeshReal; { силы в зацеплении на один сателлит, Н }
    V, EpsA, EpsB: TMeshReal; { скорость в относительном движении, перекрытие }
    St: integer; { степень точности }
    Uf, { фактическое передаточное отношение }
    Eta, { КПД }
    n2, { частота вращения выходного колеса, об/мин }
    nh, { частота вращения водила, об/мин }
    T1, T2, { моменты на входе и выходе, Н*м }
    Massa, { масса зубчатых колес, кг }
    V_p: Extended; { объем, занимаемый передачей, дм^3 }
  end;

  CalculateCWheel = class
  private
    FP1, FN1, FU, FLh: Extended;
    FZw: byte;
    FLastError: byte;
    Inp: TMyInput;
    { свойства материалов колес }
    Termobr: array [1 .. 5] of byte;
    HBp, HRCp, HVp, SigmaT, SigmaFlim0, SigmaFst0, SF, Yg, Yd: TWheelReal;
    procedure SetP1(const Value: Extended);
    procedure SetN1(const Value: Extended);
    procedure SetU(const Value: Extended);
    procedure SetZw(const Value: byte);
    procedure SetLh(const Value: Extended);
    function MatIndex(w: integer): integer;
    function LoadMaterial(w: integer): boolean;
    function Mu_H: Extended;
    function Mu_F(q: integer): Extended;
    function SigmaHP(w: integer; NK, v, d: Extended): Extended;
    function SigmaFP(w: integer; NK, m, d: Extended; Reverse: boolean): Extended;
    function SigmaHPmax(w: integer): Extended;
    function SigmaFPmax(w: integer; d: Extended): Extended;
    function KHbeta(Psi_bd: Extended; Soft: boolean): Extended;
    procedure PsiCandidates(var P: TPsiList; var N: integer);
    function SelectTeeth(za: integer; Bet: Extended; var R: TMyOutput): boolean;
    procedure CalcVariant(Psi: Extended; var R: TMyOutput);
    procedure MakeVersions;
  public
    constructor Create;
    procedure MakeVersionss(Input: TMyInput);
    property P1: Extended read FP1 write SetP1;
    property n1: Extended read FN1 write SetN1;
    property U: Extended read FU write SetU;
    property Lh: Extended read FLh write SetLh;
    property Zw: byte read FZw write SetZw;
    { причина отбраковки последнего неудачного варианта }
    property LastError: byte read FLastError;
  end;

procedure MasOutputOnForm(mascount1: integer; var Output: TMyOutput;
  var Input1: TMyInput);
function ErrorText(Code: byte): string;

var
  masOutput: array of TMyOutput;
  masInput: array of TMyInput;
  mascount: integer;

implementation

const
  ZE = 190; { коэффициент упругости стальных колес, МПа^0.5 }
  FrictionK = 0.08; { коэффициент трения в зацеплении (для КПД) }
  ModuleMin = 1.5; { минимальный модуль силовой передачи, мм }
  ModuleMax = 25; { максимальный модуль }

  { Типовые режимы нагружения ГОСТ 21354-87 (0 - постоянный ... V) }
  MuH: array [0 .. 5] of Extended = (1, 0.5, 0.25, 0.18, 0.125, 0.063);
  MuF6: array [0 .. 5] of Extended = (1, 0.3, 0.143, 0.065, 0.038, 0.013);
  MuF9: array [0 .. 5] of Extended = (1, 0.2, 0.1, 0.036, 0.016, 0.004);

  { Коэффициенты аппроксимации K_Hbeta = AA*Psi_bd^2 + BB*Psi_bd + 1
    по схемам расположения колес 1..8 }
  KHB_AA: array [boolean, 1 .. 8] of Extended = ((0, 0.542, 0.106, 0.0675,
    0.083, 0.0869, 0.0448, 0.106), (0.125, 0.125, 0.0293, 0.0465, 0.0435,
    0.0362, 0.0272, 0.0293));
  KHB_BB: array [boolean, 1 .. 8] of Extended = ((1.25, 0.42, 0.247, 0.221,
    0.111, 0.0307, 0.0251, 0.247), (0.425, 0.265, 0.128, 0.058, 0.0313, 0.0141,
    0.0035, 0.128));

  { Номера колес материала: a - 1, g и f - 2 (сателлит), b - 3, e - 4 }
  WheelMat: array [1 .. 5] of integer = (1, 2, 3, 2, 4);
  { Колеса зацеплений: [зацепление, 1] - шестерня (меньшее/внешнее), [.., 2] }
  MeshWheel: array [1 .. 3, 1 .. 2] of integer = ((WA, WG), (WG, WB), (WF, WE));
  MeshInternal: array [1 .. 3] of boolean = (False, True, True);

{ ------------------------- вспомогательные функции ------------------------ }

function GCD(a, b: integer): integer;
var
  t: integer;
begin
  while b <> 0 do
  begin
    t := a mod b;
    a := b;
    b := t;
  end;
  Result := a;
end;

function Clamp(x, Lo, Hi: Extended): Extended;
begin
  Result := Min(Max(x, Lo), Hi);
end;

{ Перевод твердостей (аппроксимация таблиц ГОСТ 8.064) }
function HRCtoHB(h: Extended): Extended;
begin
  if h <= 30 then
    Result := 220 * Power(h / 20, 0.665)
  else
    Result := 300 * Power(h / 32.5, 0.96);
end;

function HBtoHRC(hb: Extended): Extended;
begin
  if hb <= HRCtoHB(30) then
    Result := 20 * Power(hb / 220, 1 / 0.665)
  else
    Result := 32.5 * Power(hb / 300, 1 / 0.96);
end;

function HBtoHV(hb: Extended): Extended;
begin
  if hb <= 350 then
    Result := hb
  else if hb <= 450 then
    Result := 350 + (hb - 350) * 1.4
  else
    Result := 450 + (hb - 450) * 1.6;
end;

{ Коэффициент формы зуба с учетом концентрации напряжений (x = 0) }
function YFS(z: integer; Bet: Extended): Extended;
begin
  Result := 3.47 + 13.2 * Power(Cos(Bet), 3) / z;
end;

{ Степень точности по окружной скорости }
function Accuracy(v: Extended; Helical: boolean): integer;
begin
  if not Helical then
  begin
    if v < 2 then
      Result := 9
    else if v < 6 then
      Result := 8
    else if v < 10 then
      Result := 7
    else
      Result := 6;
  end
  else if v < 10 then
    Result := 8
  else if v < 16 then
    Result := 7
  else
    Result := 6;
end;

{ Коэффициент g0, учитывающий разность шагов }
function G0(St: integer; m: Extended): Extended;
const
  Tab: array [6 .. 9, 1 .. 3] of Extended = ((3.8, 4.2, 4.8), (4.7, 5.3, 6.4),
    (5.6, 6.1, 7.3), (7.3, 8.2, 10));
begin
  if m <= 3.55 then
    Result := Tab[St, 1]
  else if m <= 10 then
    Result := Tab[St, 2]
  else
    Result := Tab[St, 3];
end;

{ K_Halfa для косозубых колес }
function KHalfa(St: integer; v: Extended): Extended;
const
  Tab: array [6 .. 9, 1 .. 3] of Extended = ((1.02, 1.03, 1.04),
    (1.03, 1.05, 1.07), (1.07, 1.10, 1.13), (1.13, 1.16, 1.16));
begin
  if v <= 5 then
    Result := Tab[St, 1]
  else if v <= 10 then
    Result := Tab[St, 2]
  else
    Result := Tab[St, 3];
end;

procedure MasOutputOnForm(mascount1: integer; var Output: TMyOutput;
  var Input1: TMyInput);
begin
  Output := masOutput[mascount1];
  Input1 := masInput[mascount1];
end;

function ErrorText(Code: byte): string;
begin
  case Code of
    0:
      Result := 'нет ошибок';
    5:
      Result := 'прочность не обеспечивается даже при модуле ' +
        FloatToStr(ModuleMax) + ' мм';
    7:
      Result := 'нет сочетания чисел зубьев для заданного передаточного ' +
        'отношения, числа сателлитов и допуска (условия соосности, ' +
        'сборки и соседства)';
    8:
      Result := 'для выбранной стали нет данных по выбранной термообработке';
    9:
      Result := 'слишком низкий КПД (меньше 0.3), возможно самоторможение';
  else
    Result := 'ошибка ' + IntToStr(Code);
  end;
end;

{ ------------------------------ CalculateCWheel --------------------------- }

constructor CalculateCWheel.Create;
begin
  inherited Create;
  FP1 := 10;
  FN1 := 1500;
  FU := 40;
  FLh := 10000;
  FZw := 3;
end;

procedure CalculateCWheel.SetP1(const Value: Extended);
begin
  if (Value < P1Min) or (Value > P1Max) then
    raise ERangeError.CreateFmt
      ('Мощность на ведущем валу (P1) не может быть равна %g, допустимый диапазон от %g до %g кВт',
      [Value, P1Min, P1Max]);
  FP1 := Value;
end;

procedure CalculateCWheel.SetN1(const Value: Extended);
begin
  if (Value < N1Min) or (Value > N1Max) then
    raise ERangeError.CreateFmt
      ('Частота вращения (n1) не может быть равна %g, допустимый диапазон от %g до %g об/мин',
      [Value, N1Min, N1Max]);
  FN1 := Value;
end;

procedure CalculateCWheel.SetU(const Value: Extended);
begin
  if (Value < UMin) or (Value > UMax) then
    raise ERangeError.CreateFmt
      ('Передаточное отношение (U) не может быть равно %g, допустимый диапазон от %g до %g',
      [Value, UMin, UMax]);
  FU := Value;
end;

procedure CalculateCWheel.SetZw(const Value: byte);
begin
  if (Value < ZwMin) or (Value > ZwMax) then
    raise ERangeError.CreateFmt
      ('Число сателлитов (Zw) не может быть равно %d, допустимый диапазон от %g до %g',
      [Value, ZwMin, ZwMax]);
  FZw := Value;
end;

procedure CalculateCWheel.SetLh(const Value: Extended);
begin
  if Value <= 0 then
    raise ERangeError.CreateFmt
      ('Ресурс передачи (Lh) должен быть больше нуля, задано %g', [Value]);
  FLh := Value;
end;

function CalculateCWheel.MatIndex(w: integer): integer;
begin
  Result := WheelMat[w];
end;

{ Свойства материала колеса w из таблицы Materials }
function CalculateCWheel.LoadMaterial(w: integer): boolean;
var
  i, row, mi: integer;
  mc: TSteelMark;
  hs: Extended;
begin
  mi := MatIndex(w);
  case mi of
    1:
      mc := Inp.mc1;
    2:
      mc := Inp.mc2;
    3:
      mc := Inp.mc3;
  else
    mc := Inp.mc5;
  end;
  row := 0;
  for i := Low(marka) to High(marka) do
    if (marka[i] = mc) and (Th[i] = Termobr[w]) then
      row := i;
  Result := row > 0;
  if not Result then
    Exit;
  { В таблице твердость до 100 задана в HRC, больше 100 - в HB }
  hs := H_HB[row];
  if hs > 100 then
  begin
    HBp[w] := hs;
    HRCp[w] := HBtoHRC(hs);
  end
  else
  begin
    HRCp[w] := hs;
    HBp[w] := HRCtoHB(hs);
  end;
  HVp[w] := HBtoHV(HBp[w]);
  SigmaT[w] := Sigma_t[row];
  SigmaFlim0[w] := Sigma_Flim0[row];
  SigmaFst0[w] := Sigma_Fst0[row];
  SF[w] := S_F[row];
  { Y_g - шлифование переходной поверхности, Y_d - деформационное упрочнение }
  if Inp.Wikrugka[mi] = 1 then
    Yg[w] := Y_g[row]
  else
    Yg[w] := 1;
  if Inp.ImprovStrength[mi] then
    Yd[w] := Y_d[row]
  else
    Yd[w] := 1;
end;

{ Коэффициент эквивалентности по контактным напряжениям }
function CalculateCWheel.Mu_H: Extended;
begin
  if Inp.Nagr then
    with Inp.Loading do
      Result := i + j * Power(y, 3) + k * Power(z, 3)
  else
    Result := MuH[Inp.Loading.GraphBar];
end;

{ Коэффициент эквивалентности по напряжениям изгиба, q - показатель кривой }
function CalculateCWheel.Mu_F(q: integer): Extended;
begin
  if Inp.Nagr then
    with Inp.Loading do
      Result := i + j * Power(y, q) + k * Power(z, q)
  else if q = 6 then
    Result := MuF6[Inp.Loading.GraphBar]
  else
    Result := MuF9[Inp.Loading.GraphBar];
end;

{ Допускаемое контактное напряжение колеса w.
  NK - число циклов, v - окружная скорость, d - диаметр (0 - проектный расчет) }
function CalculateCWheel.SigmaHP(w: integer; NK, v, d: Extended): Extended;
var
  SigmaHlim, SH, NHlim, NHE, ZN, ZR, Zv, Zx: Extended;
  Surface: boolean;
begin
  Surface := Termobr[w] in [4 .. 7]; { поверхностное упрочнение }
  case Termobr[w] of
    3:
      SigmaHlim := 18 * HRCp[w] + 150;
    4:
      SigmaHlim := 17 * HRCp[w] + 200;
    5, 6:
      SigmaHlim := 23 * HRCp[w];
    7:
      SigmaHlim := 1050;
  else { улучшение, нормализация, отжиг }
    SigmaHlim := 2 * HBp[w] + 70;
  end;
  if Surface then
    SH := 1.2
  else
    SH := 1.1;
  NHlim := Min(30 * Power(HBp[w], 2.4), 12E7);
  NHE := Mu_H * NK;
  if NHE <= NHlim then
  begin
    ZN := Power(NHlim / NHE, 1 / 6);
    if Surface then
      ZN := Min(ZN, 1.8)
    else
      ZN := Min(ZN, 2.6);
  end
  else
    ZN := Max(Power(NHlim / NHE, 1 / 20), 0.75);
  case WheelMat[w] of
    1:
      ZR := Inp.Ra1;
    2:
      ZR := Inp.Ra2;
    3:
      ZR := Inp.Ra3;
  else
    ZR := Inp.Ra5;
  end;
  if ZR = 0 then { Ra1.6 }
    ZR := 0.95
  else { Ra3.2, Ra6.3 }
    ZR := 0.9;
  Zv := 1;
  Zx := 1;
  if d > 0 then
  begin
    if v > 5 then
      if HBp[w] <= 350 then
        Zv := 0.85 * Power(v, 0.1)
      else
        Zv := 0.925 * Power(v, 0.05);
    Zv := Max(Zv, 1);
    if d > 700 then
      Zx := sqrt(1.07 - 0.0001 * d);
  end
  else
    ZR := 0.9; { проектный расчет: Z_R*Z_v*Z_x = 0.9 }
  Result := SigmaHlim * ZN * ZR * Zv * Zx / SH;
end;

{ Допускаемое напряжение изгиба колеса w }
function CalculateCWheel.SigmaFP(w: integer; NK, m, d: Extended;
  Reverse: boolean): Extended;
var
  q: integer;
  NFE, YN, YA, YZ, YR, Ydelta, YX, SigmaFlim: Extended;
  Polished: boolean;
begin
  Polished := Inp.Wikrugka[WheelMat[w]] = 2;
  if (HBp[w] <= 350) or Polished then
    q := 6
  else
    q := 9;
  NFE := Mu_F(q) * NK;
  if NFE >= 4E6 then
    YN := 1
  else if q = 6 then
    YN := Min(Power(4E6 / NFE, 1 / 6), 4)
  else
    YN := Min(Power(4E6 / NFE, 1 / 9), 2.5);
  { Y_A - реверсивная (двусторонняя) нагрузка }
  if not Reverse then
    YA := 1
  else
    case Termobr[w] of
      3 .. 6:
        YA := 0.75;
      7:
        YA := 0.9;
    else
      YA := 0.65;
    end;
  case Inp.Zagotowka[WheelMat[w]] of
    3:
      YZ := 0.9; { прокат }
    4:
      YZ := 0.8; { отливка }
  else
    YZ := 1; { поковка, штамповка }
  end;
  if not Polished then
    YR := 1
  else if Termobr[w] in [4 .. 7] then
    YR := 1.05
  else
    YR := 1.2;
  SigmaFlim := SigmaFlim0[w] * YZ * Yg[w] * Yd[w] * YA;
  if d = 0 then { проектный расчет }
    Result := 0.4 * SigmaFlim * YN
  else
  begin
    Ydelta := 1.082 - 0.172 * Log10(m);
    YX := 1.05 - 0.000125 * d;
    Result := SigmaFlim * YN * Ydelta * YR * YX / SF[w];
  end;
end;

{ Предельное допускаемое контактное напряжение при пиковой нагрузке }
function CalculateCWheel.SigmaHPmax(w: integer): Extended;
begin
  case Termobr[w] of
    4 .. 6:
      Result := 44 * HRCp[w];
    7:
      Result := 3 * HVp[w];
  else
    Result := 2.8 * SigmaT[w];
  end;
end;

{ Предельное допускаемое напряжение изгиба при пиковой нагрузке }
function CalculateCWheel.SigmaFPmax(w: integer; d: Extended): Extended;
var
  SFst: Extended;
begin
  case Inp.Zagotowka[WheelMat[w]] of
    3:
      SFst := 1.75 * 1.1;
    4:
      SFst := 1.75 * 1.3;
  else
    SFst := 1.75;
  end;
  Result := SigmaFst0[w] * (1.05 - 0.000125 * d) / SFst;
end;

function CalculateCWheel.KHbeta(Psi_bd: Extended; Soft: boolean): Extended;
var
  sx: integer;
begin
  sx := Inp.Nom_sx;
  if not(sx in [1 .. 8]) then
    sx := 3;
  Result := KHB_AA[Soft, sx] * sqr(Psi_bd) + KHB_BB[Soft, sx] * Psi_bd + 1;
end;

{ Рекомендуемые значения коэффициента ширины венца Psi_ba }
procedure CalculateCWheel.PsiCandidates(var P: TPsiList; var N: integer);
  procedure SetP(const V: array of Extended);
  var
    i: integer;
  begin
    N := Length(V);
    for i := 0 to N - 1 do
      P[i] := V[i];
  end;

var
  Soft: boolean;
  sx: integer;
begin
  Soft := HBp[WG] <= 350;
  sx := Inp.Nom_sx;
  if Inp.BISTR then
  begin { быстроходная передача }
    if Inp.Tipz = 3 then
    begin
      if Soft then
        SetP([0.63, 0.8, 1])
      else
        SetP([0.5, 0.63, 0.8]);
      if sx <> 7 then
        N := 2;
    end
    else if Soft then
      case sx of
        1, 2:
          SetP([0.2, 0.25]);
        7:
          SetP([0.4, 0.5, 0.63]);
      else
        SetP([0.315, 0.4]);
      end
    else
      case sx of
        1, 2:
          SetP([0.16, 0.2]);
        7:
          SetP([0.315, 0.4, 0.5]);
      else
        SetP([0.25, 0.315]);
      end;
  end
  else if Inp.Tipz = 3 then
  begin { тихоходная шевронная }
    if Soft then
      case sx of
        4, 5:
          SetP([0.63, 0.8, 1]);
        7:
          SetP([0.8, 1, 1.25]);
      else
        SetP([0.63, 0.8]);
      end
    else
      case sx of
        4, 5:
          SetP([0.5, 0.63, 0.8]);
        7:
          SetP([0.63, 0.8, 1]);
      else
        SetP([0.5, 0.63]);
      end;
  end
  else if Soft then
    case sx of { тихоходная прямозубая или косозубая }
      1, 2:
        SetP([0.2, 0.315]);
      6:
        SetP([0.4, 0.5, 0.63]);
      7:
        SetP([0.63, 0.8, 1]);
    else
      SetP([0.5, 0.63, 0.8]);
    end
  else
    case sx of
      1, 2:
        SetP([0.16, 0.2, 0.25]);
      6:
        SetP([0.315, 0.4, 0.5]);
      7:
        SetP([0.5, 0.63, 0.8]);
    else
      SetP([0.4, 0.5]);
    end;
end;

{ Подбор чисел зубьев zg, zb, zf, ze при заданном za.
  Условия: соосность  zb = za + 2*zg,  ze = zf + za + zg;
  сборка  (za + zb) mod nw = 0  и  (za*zf + ze*zg) mod (nw*НОД(zf, zg)) = 0;
  соседство  (za + zg)*sin(pi/nw) > max(zg, zf) + 2.5.
  Из подходящих вариантов выбирается самый компактный. }
function CalculateCWheel.SelectTeeth(za: integer; Bet: Extended;
  var R: TMyOutput): boolean;
var
  zg, zb, zf, ze, nw, zmin, best: integer;
  Denom, Uc, Tol: Extended;
begin
  Result := False;
  nw := FZw;
  { минимальное число зубьев без подрезания (по эквивалентному колесу) }
  zmin := Ceil(17 * Power(Cos(Bet), 3));
  if Inp.DeltaU = 0 then
    Tol := 0.02
  else
    Tol := Inp.DeltaU / 100;
  best := MaxInt;
  for zg := zmin to 3 * za do
  begin
    zb := za + 2 * zg;
    if (nw > 1) and (((za + zb) mod nw) <> 0) then
      Continue;
    for zf := zmin to za + zg do
    begin
      ze := zf + za + zg;
      Denom := 1 - zb * zf / (zg * ze);
      if Denom <= 1E-3 then
        Continue;
      Uc := (1 + zb / za) / Denom;
      if Abs(Uc - FU) > Tol * FU then
        Continue;
      if nw > 1 then
      begin
        if ((za * zf + ze * zg) mod (nw * GCD(zf, zg))) <> 0 then
          Continue;
        if (za + zg) * Sin(Pi / nw) <= Max(zg, zf) + 2.5 then
          Continue;
      end;
      if Max(zb, ze) < best then
      begin
        best := Max(zb, ze);
        R.z[WA] := za;
        R.z[WG] := zg;
        R.z[WB] := zb;
        R.z[WF] := zf;
        R.z[WE] := ze;
        R.Uf := Uc;
        Result := True;
      end;
    end;
  end;
end;

{ Расчет одного варианта передачи при заданном Psi_ba }
procedure CalculateCWheel.CalcVariant(Psi: Extended; var R: TMyOutput);
var
  nw, k, w, w1, w2, Imn, it: integer;
  p, nRelA, nRelG, nRelE, Tb, Kw, Ka, Alfa, Alfat, Bet, m, bw, Kper: Extended;
  zp, zw2, u, Tp, SHP, Psi_bd, awReq, mReq, Kd, Sgn, Psi_loss: Extended;
  NK: TWheelReal;
  Internal, Helical, Ok: boolean;

  function SoftMesh(k: integer): boolean;
  begin
    Result := (HBp[MeshWheel[k, 1]] <= 350) or (HBp[MeshWheel[k, 2]] <= 350);
  end;

  { Скорость в зацеплении в относительном движении (относительно водила) }
  function MeshSpeed(k: integer): Extended;
  begin
    if k = MFE then
      Result := Pi * R.d[WF] * nRelG / 60000
    else
      Result := Pi * R.d[WA] * nRelA / 60000;
  end;

  { Расчет напряжений при модуле m; True - прочность обеспечена }
  function Check: boolean;
  var
    k, w, j, St: integer;
    v, u, dp, Ft, EpsA, EpsB, Zeps, ZH, Betb, dH, dF, KHv, KHb, KHa, KFv, KFb,
      KFa, Yeps, Ybet, NF, bh, SigF, SHP1, SHP2: Extended;
  begin
    R.Mn := m;
    R.aw := m * (R.z[WA] + R.z[WG]) / (2 * Cos(Bet));
    bw := Round(Psi * R.aw);
    if bw < 1 then
      bw := 1;
    for w := 1 to 5 do
    begin
      R.d[w] := m * R.z[w] / Cos(Bet);
      if w in [WB, WE] then
      begin { внутренние зубья }
        R.da[w] := R.d[w] - 2 * m;
        R.df[w] := R.d[w] + 2.5 * m;
      end
      else
      begin
        R.da[w] := R.d[w] + 2 * m;
        R.df[w] := R.d[w] - 2.5 * m;
      end;
      R.b[w] := bw;
      R.SigF[w] := 0;
    end;
    { канавка для выхода инструмента у шевронных колес }
    if (Inp.Tipz = 3) and (Inp.kanavka = 1) then
      for w := 1 to 5 do
        R.b[w] := R.b[w] + Round(m * Clamp(17 - m, 10, 15));
    R.b[WA] := R.b[WA] + 5; { шестерня шире на 5 мм }
    for w := 1 to 5 do
      R.SigFP[w] := SigmaFP(w, NK[w], m, R.d[w], Inp.rewers or (w = WG));
    R.St := 9;
    Result := True;
    for k := 1 to 3 do
    begin
      w1 := MeshWheel[k, 1];
      w2 := MeshWheel[k, 2];
      Internal := MeshInternal[k];
      if Internal then
        Sgn := -1
      else
        Sgn := 1;
      if Internal or (R.z[w1] <= R.z[w2]) then
      begin
        dp := R.d[w1];
        u := R.z[w2] / R.z[w1];
      end
      else
      begin
        dp := R.d[w2];
        u := R.z[w1] / R.z[w2];
      end;
      case k of
        MAG:
          Ft := 2000 * R.T1 / (nw * R.d[WA]);
        MGB:
          Ft := 2000 * Tb / (nw * R.d[WB]);
      else
        Ft := 2000 * R.T2 / (nw * R.d[WE]);
      end;
      R.Ft[k] := Ft;
      R.Fr[k] := Ft * Tan(Alfat);
      R.Fx[k] := Ft * Tan(Bet);
      Ft := Ft * Kw; { неравномерность распределения нагрузки по сателлитам }
      v := MeshSpeed(k);
      R.V[k] := v;
      St := Accuracy(v, Helical);
      R.St := Min(R.St, St);
      { коэффициенты перекрытия }
      EpsA := (1.88 - 3.2 * (1 / R.z[w1] + Sgn / R.z[w2])) * Cos(Bet);
      if not Helical then
        EpsB := 0
      else if Inp.Tipz = 3 then
        EpsB := 0.5 * bw * Sin(Bet) / (Pi * m)
      else
        EpsB := bw * Sin(Bet) / (Pi * m);
      R.EpsA[k] := EpsA;
      R.EpsB[k] := EpsB;
      { --- контактная прочность --- }
      if not Helical then
        Zeps := sqrt((4 - EpsA) / 3)
      else if EpsB < 1 then
        Zeps := sqrt((4 - EpsA) * (1 - EpsB) / 3 + EpsB / EpsA)
      else
        Zeps := sqrt(1 / EpsA);
      Betb := ArcSin(Sin(Bet) * Cos(Alfa));
      ZH := sqrt(2 * Cos(Betb) / Tan(Alfat)) / Cos(Alfat);
      if (HVp[w1] > 350) and (HVp[w2] > 350) then
        if Helical then
          dH := 0.04
        else
          dH := 0.14
      else if Helical then
        dH := 0.02
      else
        dH := 0.06;
      KHv := 1 + dH * G0(St, m) * v * sqrt(R.aw / u) * bw / (Ft * Ka);
      KHb := KHbeta(bw / dp, SoftMesh(k));
      if Helical then
        KHa := KHalfa(St, v)
      else
        KHa := 1;
      R.SigH[k] := ZE * ZH * Zeps * sqrt(Ft * Ka * KHv * KHb * KHa * (u + Sgn)
        / (bw * dp * u));
      SHP1 := SigmaHP(w1, NK[w1], v, R.d[w1]);
      SHP2 := SigmaHP(w2, NK[w2], v, R.d[w2]);
      if Helical then
        R.SigHP[k] := Clamp(0.45 * (SHP1 + SHP2), Min(SHP1, SHP2),
          1.23 * Min(SHP1, SHP2))
      else
        R.SigHP[k] := Min(SHP1, SHP2);
      R.SigHmax[k] := R.SigH[k] * sqrt(Kper);
      R.SigHPmax[k] := Min(SigmaHPmax(w1), SigmaHPmax(w2));
      if (R.SigH[k] > 1.05 * R.SigHP[k]) or (R.SigHmax[k] > R.SigHPmax[k]) then
        Result := False;
      { --- изгибная прочность --- }
      if Helical then
        dF := 0.06
      else
        dF := 0.16;
      KFv := 1 + dF * G0(St, m) * v * sqrt(R.aw / u) * bw / (Ft * Ka);
      bh := bw / (2.25 * m);
      NF := sqr(bh) / (1 + bh + sqr(bh));
      KFb := Power(KHb, NF);
      if Helical then
      begin
        KFa := (4 + (EpsA - 1) * (St - 5)) / (4 * EpsA);
        Ybet := Max(1 - EpsB * Bet * 180 / Pi / 120, 0.7);
        if EpsB < 1 then
          Yeps := 0.2 + 0.8 / EpsA
        else
          Yeps := 1 / EpsA;
      end
      else
      begin
        KFa := 1;
        Ybet := 1;
        Yeps := 1;
      end;
      for j := 1 to 2 do
      begin
        w := MeshWheel[k, j];
        SigF := Ft * Ka * KFv * KFb * KFa * YFS(R.z[w], Bet) * Ybet * Yeps /
          (bw * m);
        R.SigF[w] := Max(R.SigF[w], SigF);
      end;
    end;
    for w := 1 to 5 do
    begin
      R.SigFmax[w] := R.SigF[w] * Kper;
      R.SigFPmax[w] := SigmaFPmax(w, R.d[w]);
      if (R.SigF[w] > R.SigFP[w]) or (R.SigFmax[w] > R.SigFPmax[w]) then
        Result := False;
    end;
  end;

begin
  nw := FZw;
  R.Error := 0;
  R.zw := nw;
  R.Tipz := Inp.Tipz;
  R.Psi_ba := Psi;
  Helical := Inp.Tipz in [2, 3];
  if Helical then
    Bet := Inp.betg * Pi / 180
  else
    Bet := 0;
  R.Bet := Bet;
  Alfa := 20 * Pi / 180;
  Alfat := ArcTan(Tan(Alfa) / Cos(Bet));
  Ka := Inp.Ka;
  if Ka <= 0 then
    Ka := 1;
  Kper := Max(Inp.Loading.x, 1);
  { Коэффициент неравномерности распределения нагрузки между сателлитами }
  case nw of
    1:
      Kw := 1;
    2:
      Kw := 1.1;
    3:
      Kw := 1.15;
  else
    Kw := 1.2;
  end;

  { --- Числа зубьев --- }
  if HBp[WA] <= 350 then
    k := 24
  else if HRCp[WA] <= 52 then
    k := 21
  else
    k := 18;
  { если для рекомендуемого za сочетания нет - пробуем соседние значения }
  Ok := False;
  for it := 0 to 12 do
  begin
    if Odd(it) then
      w := k + (it + 1) div 2
    else
      w := k - it div 2;
    if (w >= 17) and SelectTeeth(w, Bet, R) then
    begin
      Ok := True;
      Break;
    end;
  end;
  if not Ok then
  begin
    R.Error := 7;
    Exit;
  end;


  { --- Кинематика --- }
  p := 1 + R.z[WB] / R.z[WA]; { отношение a -> h при остановленном b }
  R.nh := FN1 / p;
  R.n2 := FN1 / R.Uf;
  nRelA := FN1 - R.nh;
  nRelG := nRelA * R.z[WA] / R.z[WG];
  nRelE := Abs(R.n2 - R.nh);
  { числа циклов нагружения зубьев за весь ресурс }
  NK[WA] := 60 * nRelA * nw * FLh;
  NK[WG] := 60 * nRelG * FLh;
  NK[WF] := NK[WG];
  NK[WB] := 60 * R.nh * nw * FLh;
  NK[WE] := 60 * nRelE * nw * FLh;

  { --- КПД: потери пропорциональны мощности в относительном движении,
    коэффициент потерь зацепления psi = 2.3*f*(1/z1 +- 1/z2) --- }
  Psi_loss := 0;
  for k := 1 to 3 do
  begin
    w1 := MeshWheel[k, 1];
    w2 := MeshWheel[k, 2];
    if MeshInternal[k] then
      Sgn := -1
    else
      Sgn := 1;
    case k of
      MAG:
        Kd := Abs(1 - 1 / p);
      MGB:
        Kd := Abs((R.Uf - 1) / p);
    else
      Kd := Abs(1 - R.Uf / p);
    end;
    Psi_loss := Psi_loss + 2.3 * FrictionK * (1 / R.z[w1] + Sgn / R.z[w2]) * Kd;
  end;
  R.Eta := 0.99 * (1 - Psi_loss); { 0.99 - потери в подшипниках }
  if R.Eta < 0.3 then
  begin
    R.Error := 9;
    Exit;
  end;
  R.T1 := 9549.3 * FP1 / FN1;
  R.T2 := R.T1 * R.Uf * R.Eta;
  Tb := R.T2 - R.T1; { реактивный момент на неподвижном колесе }

  { --- Проектный расчет: межосевое из условия контактной прочности
    для каждого зацепления, aw = Ka*(u+-1)*(KHb*Tp/(Psi*u*SHP^2))^(1/3) --- }
  if Helical then
    Kd := 430
  else
    Kd := 495;
  awReq := 0;
  for k := 1 to 3 do
  begin
    w1 := MeshWheel[k, 1];
    w2 := MeshWheel[k, 2];
    Internal := MeshInternal[k];
    case k of
      MAG:
        Tp := R.T1 * Kw / nw;
      MGB:
        Tp := Tb * Kw / nw * R.z[WG] / R.z[WB];
    else
      Tp := R.T2 * Kw / nw * R.z[WF] / R.z[WE];
    end;
    zp := R.z[w1];
    zw2 := R.z[w2];
    if (not Internal) and (zp > zw2) then
    begin { шестерней пары a-g является сателлит }
      Tp := Tp * zw2 / zp;
      zp := R.z[w2];
      zw2 := R.z[w1];
    end;
    u := zw2 / zp;
    if Internal then
      Sgn := -1
    else
      Sgn := 1;
    Psi_bd := 0.5 * Psi * (u + Sgn);
    SHP := Min(SigmaHP(w1, NK[w1], 0, 0), SigmaHP(w2, NK[w2], 0, 0));
    awReq := Max(awReq, Kd * (u + Sgn) * Power(KHbeta(Psi_bd, (HBp[w1] <= 350)
      or (HBp[w2] <= 350)) * Tp / (Psi * u * sqr(SHP)), 1 / 3));
  end;
  mReq := 2 * awReq * Cos(Bet) / (R.z[WA] + R.z[WG]);
  { Проектная формула дает запас (Z_eps = 1, приближенный K_Hbeta), поэтому
    подбор начинается с модуля 0.7*mReq, а итоговый модуль - наименьший,
    при котором выполняются все проверочные условия }
  mReq := Max(0.7 * mReq, ModuleMin);
  Imn := 1;

  while (Imn < High(ms)) and (ms[Imn] < mReq) do
    inc(Imn);

  { --- Проверочный расчет: увеличиваем модуль, пока прочность
    не будет обеспечена --- }
  Ok := False;
  for it := Imn to High(ms) do
  begin
    m := ms[it];
    if m > ModuleMax then
      Break;
    if Check then
    begin
      Ok := True;
      Break;
    end;
  end;
  if not Ok then
  begin
    R.Error := 5;
    Exit;
  end;

  { --- Масса колес (сталь 7.85 г/см^3) и габаритный объем --- }
  R.Massa := Pi / 4 * (sqr(R.d[WA]) * R.b[WA] + nw * (sqr(R.d[WG]) * R.b[WG] +
    sqr(R.d[WF]) * R.b[WF]) + (sqr(R.df[WB] + 6 * m) - sqr(R.d[WB])) * R.b[WB]
    + (sqr(R.df[WE] + 6 * m) - sqr(R.d[WE])) * R.b[WE]) * 7.85E-6;
  R.V_p := Pi / 4 * sqr(Max(R.df[WB], R.df[WE]) + 6 * m) *
    (R.b[WB] + R.b[WE] + 2 * m) * 1E-6;
end;

procedure CalculateCWheel.MakeVersions;
var
  w, i, N: integer;
  Psi: TPsiList;
  R: TMyOutput;
begin
  Termobr[WA] := Inp.Termobr1;
  Termobr[WG] := Inp.Termobr2;
  Termobr[WF] := Inp.Termobr2;
  Termobr[WB] := Inp.Termobr3;
  Termobr[WE] := Inp.Termobr5;
  for w := 1 to 5 do
    if not LoadMaterial(w) then
    begin
      FLastError := 8;
      Exit;
    end;
  PsiCandidates(Psi, N);
  for i := 0 to N - 1 do
  begin
    FillChar(R, SizeOf(R), 0);
    CalcVariant(Psi[i], R);
    if R.Error <> 0 then
      FLastError := R.Error
    else
    begin
      SetLength(masOutput, mascount + 1);
      SetLength(masInput, mascount + 1);
      masOutput[mascount] := R;
      masInput[mascount] := Inp;
      inc(mascount);
    end;
  end;
end;

procedure CalculateCWheel.MakeVersionss(Input: TMyInput);
var
  T1List, T2List: ArrayTermobr;
  i1, i2: integer;

  { Список допустимых термообработок стали mc (Termobr = 0 - все из таблицы) }
  procedure TermList(mc: TSteelMark; Termobr: byte; var L: ArrayTermobr);
  var
    i, j, N: integer;
    Found: boolean;
  begin
    FillChar(L, SizeOf(L), 0);
    if Termobr <> 0 then
    begin
      L[1] := Termobr;
      Exit;
    end;
    N := 0;
    for i := Low(marka) to High(marka) do
      if (marka[i] = mc) and (N < High(L)) then

      begin
        Found := False;
        for j := 1 to N do
          Found := Found or (L[j] = Th[i]);
        if not Found then
        begin
          inc(N);
          L[N] := Th[i];
        end;
      end;
  end;

begin
  mascount := 0;
  SetLength(masOutput, 0);
  SetLength(masInput, 0);
  FLastError := 0;
  P1 := Input.P1;
  n1 := Input.n1;
  U := Input.U;
  Lh := Input.Lh;
  Zw := Input.Zw;
  Inp := Input;
  if not(Inp.Tipz in [1 .. 3]) then
    Inp.Tipz := 1;
  if (Inp.Tipz = 2) and (Inp.betg = 0) then
    Inp.betg := 10;
  if (Inp.Tipz = 3) and (Inp.betg = 0) then
    Inp.betg := 30;
  if Inp.Loading.GraphBar > 5 then
    Inp.Loading.GraphBar := 0;
  { для колес b и e при автовыборе берется первая термообработка из таблицы }
  TermList(Inp.mc3, Inp.Termobr3, T1List);
  Inp.Termobr3 := T1List[1];
  TermList(Inp.mc5, Inp.Termobr5, T1List);
  Inp.Termobr5 := T1List[1];
  { перебор термообработок шестерни и сателлита }
  TermList(Inp.mc1, Input.Termobr1, T1List);
  TermList(Inp.mc2, Input.Termobr2, T2List);
  for i1 := 1 to High(T1List) do
    if T1List[i1] <> 0 then
      for i2 := 1 to High(T2List) do
        if T2List[i2] <> 0 then
        begin
          Inp.Termobr1 := T1List[i1];
          Inp.Termobr2 := T2List[i2];
          MakeVersions;
        end;
end;

end.
