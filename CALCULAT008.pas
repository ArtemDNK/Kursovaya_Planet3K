unit CALCULAT008;

interface

Uses
  Math1, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms,
  Dialogs, StdCtrls, Grids, Spin, Materials, constants, Math;

Type
  TLoading = record
    GraphBar: word;
    x, y, z, i, j, k: single;
  end;

  ArrayTermobr = array [1 .. 4] of byte;
  TSteelMark = string[23];
  TTwoWord = array [1 .. 4] of word;
  TT1 = array [1 .. 45] of single;

  TMyInput = record
    Loading: TLoading;
    P1, { Мощность, передаваемая быстроходным валом }
    n1, { Частота вращения быстроходного вала }
    U: Extended; { Передаточное число передачи }
    DeltaU: byte;
    Lh: Extended; { Расчетный ресурс передачи }
    // сделать >0
    Tipz: word;
    { тип зубьев колес: 1 - прямые                             // все
      2 - косые
      3 - шевронные
      0 - автовыбор }
    betg: Extended; { угол наклона зуба в градусах;        //0 ..45
      при Tipz= 0 становится варьируемым
      параметром со знчениями 0, 10, 25 }
    kanavka: word;
    { Для шевронных колес при наличии канавки = 1,             // если типс 3 принимать 0 или 1 иначе -1
      при отсутствии канавки =0 }
    mc1, { марка стали для шестерни }   { ???????????????? }
    mc2,
    mc3,
    mc5: TSteelMark; { марка стали для колеса }     { ?????????????????? }
    Termobr1, { термообработка зуба шестерни, номер }
    // 0..8
    Termobr2,
    Termobr3,
    Termobr5: byte; { термообработка зуба колеса, номер }
    ImprovStrength: array [1 .. 4] of boolean;
    Zagotowka: TTwoWord;
    { Способ получения заготовки шестерни и колеса
      = 1 для поковок
      = 2 для штамповок
      = 3 для проката
      = 4 для отливок }                                     // 1..4
    Ra1, { Шероховатость боковой поверхности зуба шестерни }        // 0..2
    Ra2,
    Ra3,
    Ra5: word; { Шероховатость боковой поверхности зуба колеса }
    Wikrugka: TTwoWord;
    { Финишная обработка выкружки зуба
      = 0 выкружка зубофрезерована или шлифована
      = 1 при полировании выкружки }
    Nom_sx, { Номер схемы расположения колес }
    Zw: byte; { Число колес находящихся в одновремен-
      ном контакте с шестерней }
    Psi_ba: Extended;
    { Коффициент ширины венца,                                 //тоже выкинуть
      при фиксированном значении вводится из стандартного
      ряда в зависимости от схемы передачи;
      при вводе АВТОВЫБОР становится варьируемым
      параметром также в зависимости от схемы передачи }
    Nagr, { =1 для типового режима,
      = 0 для циклограммы }
    rewers: boolean; { При реверсировании = 1;
      без реверсирования = 0 }
    Ka: Extended; { Коэффициент внешней динамики }
    otw1: boolean; { При стандартном межосевом расстоянии = 'Y',
      при нестандартном межосевом расстоянии ='n' }
    BISTR: boolean; { "0", если передача является тихоходной ступенью }
    { "1", если передача является быстроходной ступенью }
    motw: TTwoWord;
    { Выбор инструмента:
      1   при нарезании долбяком
      0   при нарезании фрезой
      2   при нарезании старым долбякоми }
  end;

  { ------------------------------------------------------------------- }
  TMyOutput = record
    { --------------------- Критерии качества --------------------------------- }
    Massa, { Суммарная масса зубчатых колес }
    V_p, { Объём занимаемый передачей }
    B1,
    { ------------------------------------------------------------------------- }
    b2,
    b3,
    b4,
    b5,{ ширина венца }
    Mn, { Нормальный модуль }
    aw: Extended; { межосевое расстояние передачи }
    z1, z2, z3, z4, z5: word; { Числа зубьев }
    St: integer; { Степень точности }
    Fv, { Суммарное давление на вал }
    epsias, { суммарный к-т перекрытия }
    alfatw, { угол зацепления зубчатых колес }
    Uf, { Фактическое передаточное число передачи }
    n2, { Частота вращения колеса }
    V, { Скорость, м/с }
    Da1, Da2, Da3, Da4, Da5,{ Диаметр окружности вершин }
    d1, d2, d3, d4, d5,{ Делительный диаметр }
    x1, x2, { Коэффициент смещения исходного контура }
    Dw1, { Начальный диаметр }
    Df1, { Диаметр окружности впадин }
    Dw2, { Начальный диаметр }
    Df2,
    Dw3,
    Df3,
    Dw4,
    Df4,
    Dw5,
    Df5, { Диаметр окружности впадин }
    Bet, Sigma_H, { Контактное напряжение }
    T1, { Момент, передаваемый быстроходным валом }
    T2, { Момент, передаваемый тихоходным валом }
    Ft1, { Окружное усилие }
    Fr1, { Радиальное усилие }
    Fx1, { Осевое усилие }
    Ft2, { Окружное усилие }
    Fr2, { Радиальное усилие }
    Fx2: Extended;
    Error: byte;
    Sigma_F1, { Напряжения изгиба в зубе шестерни }
    Sigma_F2,
    Sigma_f3, { Напряжения изгиба в зубе колеса }
    Sigma_Fp1, Sigma_Fp2, Sigma_Fp3, Sigma_Fp5,{ Допускаемые напряжения изгиба }
    Sigma_Hp: Extended;
    zw: byte;
    { Допускаемое контактное напряжение }
  end;

Const
  ms: TT1 = (1.0, 1.125, 1.25, 1.375, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0, 3.5,
    4.0, 4.5, 5.0, 5.5, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 14.0, 16.0, 18.0,
    20.0, 22.0, 25.0, 28.0, 32.0, 36.0, 40.0, 45.0, 50.0, 55.0, 60.0, 70.0,
    80.0, 90.0, 100.0, 0, 0, 0, 0);

  Aws: TT1 = (40, 50, 63, 80, 100, 125, 140, 160, 180, 200, 225, 250, 280, 315,
    355, 400, 450, 500, 560, 630, 710, 800, 900, 1000, 1120, 1250, 1400, 1600,
    1800, 2000, 2240, 2500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  c_ = 0.25;

type
  CalculateCWheel = class
  private
{$REGION 'Методы CalculateCWheel'}
    FLh: Extended;
    FTipz: word;
    Fbetg: Extended;
    Fkanavka: word;
    Fmc1, Fmc2, Fmc3, Fmc5: TSteelMark;
    FTermobr1, FTermobr2, FTermobr3, FTermobr5: byte;
    FImprovStrength: array [1 .. 4] of boolean;
    FZagotowka: TTwoWord;
    FRa1, FRa2, FRa3, FRa5: word;
    FWikrugka: TTwoWord;
    FNom_sx: byte;
    FPsi_ba: Extended;
    FNagr, Frewers: boolean;
    Fotw1: boolean;
    FBISTR: boolean;
    Fmotw: TTwoWord;
    FP1, FU, FN1, FKa: Extended;
    FZw, FDeltaU: byte;
    Iz, i, II, IAw, Metka, Tipp, otbet, otbet1: byte;
    H_l, dv2, Ro_f, Alfa, Epsia1, Epsia2, Za, K_HB, Sigma_Hlimb1, Sigma_Hlimb2, Sigma_Hlimb3, Sigma_Hlimb5,
    { Параметры исходного контура }
    ha, hl, rof: Extended;
    { -------------------------- }
    Z_min, Z1_: byte;
    otw: char;
    { Параметры долбяка }
    aw0, betaa0, roa0, sn0, alfatw0, alfaa0: Extended;
    { Переменные для расчета коэффициентов смещения }
    z0, z: array [1 .. 2] of integer;
    x, alfaa, dww, db, roa, alfaat, x11, x22: array [1 .. 2] of Extended;
    sss: string[40];
    s: array [1 .. 8] of byte;
    Sigma_Fpmax1, Sigma_Fpmax2, Sigma_Fpmax3, Sigma_Fpmax5: Extended;
    Sigma_Hpmax: Extended;
    Imn: byte;
    da0, db0, x0: array [1 .. 5] of Extended;
    rol, rop, xmin: array [1 .. 2] of Extended;
    Alfat: Extended;
    xs: Extended;
    a: Extended;
    bw, Bk: Extended;
    tet1, tet2: Extended;
    izn: Extended;
    sna1, sna2, epsia: Extended;
    Zmin: Extended;
    x1min: Extended;
    Eps_bet: Extended;
    Betb: Extended;
    Sigma_Hmax: Extended;
    Sigma_Fmax1, Sigma_Fmax2, Sigma_Fmax3, Sigma_Fmax5: Extended;
    db1, db2, db3, db5: Extended;
    Sna, Srezmax, Srez: array [1 .. 2] of Extended;
    TipZp: byte;
    Massa1, Massa2: Extended;
    Loading: TLoading;
    // P1,               {Мощность, передаваемая быстроходным валом}
    // n1,               {Частота вращения быстроходного вала}
    // U:Extended;           {Передаточное число передачи}
    // Zw:byte;          {Число колес находящихся в одновременном контакте с шестерней}
    // DeltaU: byte;
    // Lh:Extended;          {Расчетный ресурс передачи}
    // Tipz:word;        {тип зубьев колес: 1 - прямые
    // 2 - косые
    // 3 - шевронные
    // 0 - автовыбор}
    // betg:Extended;        {угол наклона зуба в градусах;
    // при Tipz= 0 становится варьируемым
    // параметром со знчениями 0, 10, 25 }
    // kanavka: word;    {Для шевронных колес при наличии канавки = 1,
    // при отсутствии канавки =0}
    // mc1,              {марка стали для шестерни}   {????????????????}
    // mc2:TSteelMark;   {марка стали для колеса}     {??????????????????}
    // Termobr1,         {термообработка зуба шестерни, номер}
    // Termobr2:byte;    {термообработка зуба колеса, номер}
    ImprovStrength: array [1 .. 4] of boolean;
    Zagotowka: TTwoWord;
    // {Способ получения заготовки шестерни и колеса
    // = 1 для поковок
    // = 2 для штамповок
    // = 3 для проката
    // = 4 для отливок  }
    // Ra1,              {Шероховатость боковой поверхности зуба шестерни}
    // Ra2:word;         {Шероховатость боковой поверхности зуба колеса}
    Wikrugka: TTwoWord;
    // {Финишная обработка выкружки зуба
    // = 0 выкружка зубофрезерована или шлифована
    // = 1 при полировании выкружки}
    // Nom_sx:byte;             {Номер схемы расположения колес}
    //
    // Psi_ba:Extended;      {Коффициент ширины венца,
    // при фиксированном значении вводится из стандартного
    // ряда в зависимости от схемы передачи;
    // при вводе АВТОВЫБОР становится варьируемым
    // параметром также в зависимости от схемы передачи}
    // Nagr,             {=1 для типового режима,
    // = 0 для циклограммы}
    // rewers:boolean;   {При реверсировании = 1;
    // без реверсирования = 0}
    // Ka:Extended;          {Коэффициент внешней динамики}
    // otw1:boolean;     {При стандартном межосевом расстоянии = 'Y',
    // при нестандартном межосевом расстоянии ='n'}
    // BISTR:boolean;    { "0", если передача является тихоходной ступенью}
    // { "1", если передача является быстроходной ступенью}
    motw: TTwoWord;
    // {Выбор инструмента:
    // 1   при нарезании долбяком
    // 0   при нарезании фрезой
    // 2   при нарезании старым долбякоми}
    H_HRcs1, { Твердость сердцевины зуба шестерни по Роквеллу }
    H_HRcs2,
    H_HRcs3,
    H_HRcs5, { Твердость сердцевины зуба колеса по Роквеллу }

    H_HRcp1, { Твердость поверхности зуба шестерни по Роквеллу }
    H_HRcp2,
    H_HRcp3,
    H_HRcp5, { Твердость поверхности зуба колеса по Роквеллу }

    H_HBs1, { Твердость сердцевины зуба шестерни по Бринелю }
    H_HBs2,
    H_HBs3,
    H_HBs5,{ Твердость сердцевины зуба колеса по Бринелю }

    H_HBp1, { Твердость поверхности зуба шестерни по Бринелю }
    H_HBp2,
    H_HBp3,
    H_HBp5, { Твердость поверхности зуба колеса по Бринелю }

    H_HVs1, { Твердость сердцевины зуба шестерни по Виккерсу }
    H_HVs2,
    H_HVs3,
    H_HVs5,{ Твердость сердцевины зуба колеса по Виккерсу }

    H_HVp1, { Твердость поверхности зуба шестерни по Виккерсу }
    H_HVp2,
    H_HVp3,
    H_HVp5: integer; { Твердость поверхности зуба колеса по Виккерсу }

    S_f1, { Коэффициент выносливости по изгибу для шестерни }
    S_f2,
    S_f3,
    S_f5,{ Коэффициент выносливости по изгибу для колеса }

    Y_d1, { Коэффициент деформационного упрочнения для шестерни }
    Y_d2,
    Y_d3,
    Y_d5,{ Коэффициент деформационного упрочнения для колеса }

    Y_g1,
    Y_g2, { Коэффициент, учитывающий шлифование  для шестерни }
    Y_g3,
    Y_g5: Extended; { Коэффициент, учитывающий шлифование  для колеса }
    Sigma_t1, { Предел текучести материала шестерни }
    Sigma_t2,
    Sigma_t3,
    Sigma_t5,{ Предел текучести материала колеса }
    Sigma_Flim01, { Предел выносливости по изгибу для шестерни }
    Sigma_Flim02,
    Sigma_Flim03,
    Sigma_Flim05,{ Предел выносливости по изгибу для колеса }
    Sigma_Fst01, { Предельное напряжение для шестерни }
    Sigma_Fst02,
    Sigma_Fst03,
    Sigma_Fst05: Extended; { Предельное напряжение для колеса }
    { ------------------------------------------------------------------- }
    { --------------------- Критерии качества --------------------------------- }
    Massa, { Суммарная масса зубчатых колес }
    V_p, { Объём занимаемый передачей }
    B1,
    { ------------------------------------------------------------------------- }
    b2,
    b3,
    b4,
    b5,{ ширина венца }
    Mn, { Нормальный модуль }
    aw: Extended; { межосевое расстояние передачи }
    z1, z2, z3, z4, z5: word; { Числа зубьев }
    St: integer; { Степень точности }
    Fv, { Суммарное давление на вал }
    epsias, { суммарный к-т перекрытия }
    alfatw, { угол зацепления зубчатых колес }
    Uf, { Фактическое передаточное число передачи }
    n2, { Частота вращения колеса }
    V, { Скорость, м/с }
    Da1, Da2, Da3, Da4, Da5,{ Диаметр окружности вершин }
    d1, d2,d3, d4, d5,{ Делительный диаметр }
    x1, x2, { Коэффициент смещения исходного контура }
    Dw1, { Начальный диаметр }
    Df1, { Диаметр окружности впадин }
    Dw2, { Начальный диаметр }
    Df2,
    Dw3,
    Df3,
    Dw4,
    Df4,
    Dw5,
    Df5,{ Диаметр окружности впадин }
    Bet, Sigma_H, { Контактное напряжение }
    T1, { Момент, передаваемый быстроходным валом }
    T2, { Момент, передаваемый тихоходным валом }
    Ft1, { Окружное усилие }
    Fr1, { Радиальное усилие }
    Fx1, { Осевое усилие }
    Ft2, { Окружное усилие }
    Fr2, { Радиальное усилие }
    Fx2: Extended;
    Error: byte;
    Sigma_F1, { Напряжения изгиба в зубе шестерни }
    Sigma_F2,
    Sigma_F3,
    Sigma_F5, { Напряжения изгиба в зубе колеса }
    Sigma_Fp1, Sigma_Fp2,Sigma_Fp3, Sigma_Fp5,    { Допускаемые напряжения изгиба }
    Sigma_Hp: Extended { Допускаемое контактное напряжение };
    memo1: tmemo;
    ArTermobr1, ArTermobr2, ArTermobr3, ArTermobr5: ArrayTermobr;
    // FDeltaU: Extended;
{$ENDREGION 'Методы CalculateCWheel'}
    procedure SetP1(const Value: Extended);
    procedure SetN1(const Value: Extended);
    procedure SetU(const Value: Extended);
    // procedure SetDeltaU(const Value: Extended);
    procedure SetZw(const Value: byte);
{$REGION 'Методы CalculateCWheel'}
    FUNCTION Mu_H: Extended;

    FUNCTION Mu_F(Target: byte): Extended;
    { ----------------------------------------------------------------------- }
    PROCEDURE PzubC2;
    PROCEDURE PrSigHp(Da, Mn, N, Mu_H, H_HBp, H_HRcp, H_HVp, Ra: Extended;
      Lh: integer; Termobr, Zw: byte; var Sigma_Hlimb, Sigma_Hp: Extended);
    PROCEDURE PrSigFp(Da, Mn, Mu_F, N, S_f, Yd, Yg: Extended; Lh: integer;
      H_HBp, Sigma_Flim0: Extended; rewers: boolean;
      Termobr, Zagotowka, Wikrugka, Zw: byte; var Sigma_Fp: Extended);
    PROCEDURE PrSigMax(Sigma_t, H_HRcp, H_HVp, Sigma_Fst0, Da: Extended;
      Zagotowka, Termobr: byte; var Sigma_Hpmax, Sigma_Fpmax: Extended);
    { ----------------------------------------------------------------------- }

    Procedure Wibor(a: Extended; b: TT1; N: byte; var Iw: byte);
    { ----------------------------------------------------------------------- }
    PROCEDURE PzubC3;
    { ----------------------------------------------------------------------- }
    { ----------------------------------------------------------------------- }
    PROCEDURE PzubC4;
    { ----------------------------------------------------------------------- }
    PROCEDURE PzubC5; // РАСЧЕТ НАПРЯЖЕНИЙ В ЗУБЬЯХ
    Procedure PrSigH; // процедура расчета контактных напряжений
    Procedure PrSigF(z: integer; x: Extended;
      var Sigma_F, Sigma_Fmax: Extended);
    // Расчет изгибных напряжений
    { ----------------------------------------------------------------------- }
    PROCEDURE PzubC6; // Расчет размеров колес и передачи
    { ----------------------------------------------------------------------- }
    PROCEDURE PzubC8; // Расчет усилий в зацеплении
    { ----------------------------------------------------------------------- }
    procedure rac4et; // Запуск расчета одной передачи
    procedure ParamToRec(Input: TMyInput);
    procedure wiborTerm(mc: TSteelMark; var ArTermobr: ArrayTermobr);
    procedure Setbetg(const Value: Extended);
    procedure SetBISTR(const Value: boolean);
    procedure SetImprovStrength(const Value: array of boolean);
    procedure Setkanavka(const Value: word);
    procedure SetLh(const Value: Extended);
    procedure Setmc(const Value: TSteelMark);
    procedure Setmotw(const Value: TTwoWord);
    procedure SetNagr(const Value: boolean);
    procedure SetNom_sx(const Value: byte);
    procedure Setotw1(const Value: boolean);
    procedure SetPsi_ba(const Value: Extended);
    procedure SetRa(const Value: word);
    procedure Setrewers(const Value: boolean);
    procedure SetTermobr(const Value: byte);
    procedure SetTipz(const Value: word);
    procedure SetWikrugka(const Value: TTwoWord);
    procedure SetZagotowka(const Value: TTwoWord);
    procedure SetKa(const Value: Extended);
    procedure SetDeltaU(const Value: byte);
  public
    constructor Create; overload;
    // constructor Create(Input:TMyInput);  overload;
    PROCEDURE MakeVersionss(Input: TMyInput);
    PROCEDURE MakeVersions;
    procedure recordOutput;
    // Мощность на ведущем валу, кВт
    property P1: Extended read FP1 write SetP1;
    // Частота вращения ведущего шкива, об/мин
    property n1: Extended read FN1 write SetN1;
    // Передаточное число
    property U: Extended read FU write SetU;
    property Lh: Extended read FLh write SetLh;
    property Tipz: word read FTipz write SetTipz;
    property betg: Extended read Fbetg write Setbetg;
    property kanavka: word read Fkanavka write Setkanavka;
    property mc1: TSteelMark read Fmc1 write Fmc1;
    property mc2: TSteelMark read Fmc2 write Fmc2;
    property mc3: TSteelMark read Fmc3 write Fmc3;
    property mc5: TSteelMark read Fmc5 write Fmc5;
    property Termobr1: byte read FTermobr1 write FTermobr1;
    property Termobr2: byte read FTermobr2 write FTermobr2;
    property Termobr3: byte read FTermobr3 write FTermobr3;
    property Termobr5: byte read FTermobr5 write FTermobr5;
    // property ImprovStrength: array [1..2] of boolean read FImprovStrength write SetImprovStrength;
    // property Zagotowka:TTwoWord read FZagotowka write SetZagotowka;
    property Ra1: word read FRa1 write FRa1;
    property Ra2: word read FRa2 write FRa2;
    property Ra3: word read FRa3 write FRa3;
    property Ra5: word read FRa5 write FRa5;
    // property Wikrugka:TTwoWord read FWikrugka write SetWikrugka;
    property Nom_sx: byte read FNom_sx write SetNom_sx;
    property Psi_ba: Extended read FPsi_ba write SetPsi_ba;
    property Nagr: boolean read FNagr write SetNagr;
    property rewers: boolean read Frewers write Setrewers;
    property otw1: boolean read Fotw1 write Setotw1;
    property BISTR: boolean read FBISTR write SetBISTR;
    // property motw:TTwoWord read Fmotw write Setmotw;
    property Ka: Extended read FKa write SetKa;
    property Zw: byte read FZw write SetZw;

    property DeltaU: byte read FDeltaU write SetDeltaU;
  end;
{$ENDREGION 'Методы CalculateCWheel'}

procedure MasOutputOnForm(mascount1: integer; var Output: TMyOutput;
  var Input1: TMyInput);

{$REGION 'переменные CalculateConeWheel'}

var
  C_prim, f_pb, K_Hv, K_Hbeta, K_Halfa, g0, Epsia1, Epsia2, Z_v1, Z_v2, n_alfa,
    n_beta, y_alfa: Extended;
  Ft: Extended;
  TransChk: byte;
  Output: TMyOutput;
  Input: TMyInput;
  masOutput: array of TMyOutput;
  masInput: array of TMyInput;
  mascount: integer;
{$ENDREGION 'переменные CalculateConeWheel'}

implementation

constructor CalculateCWheel.Create;
begin

  Ft := 0;
  Nagr := False;
  Loading.GraphBar := 0;
  with Loading do
  begin
    x := 2;
    y := 0.3;
    z := 0.2;
    i := 0.6;
    j := 0.2;
    k := 0.2;
  end;
  P1 := 10; { 0.2..300 }
  n1 := 750; { 1 .. 5000 об/мин }
  U := 3.58; { 1 .. 8 }
  DeltaU := 2;
  H_HBp1 := 0; { 0..350 }
  H_HBp2 := 0;
  H_HBp3 := 0;
  H_HBp5 := 0;{ 0 .. 350 }

  H_HBs1 := 300; { 0 .. 350 }
  H_HBs2 := 300;
  H_HBs3 := 300;
  H_HBs5 := 300; { 0 .. 350 }

  H_HRcp1 := 48; { 35 .. 68 }
  H_HRcp2 := 48;
  H_HRcp3 := 48;
  H_HRcp5 := 48; { 35 .. 68 }

  H_HRcs1 := 0;
  H_HRcs2 := 0;
  H_HRcs3 := 0;
  H_HRcs5 := 0;

  Sigma_t1 := 800; { 100 .. 2000 MПa }
  Sigma_t2 := 800;
  Sigma_t3 := 800;
  Sigma_t5 := 800;{ 100 .. 2000 ЬПа }

  Sigma_Flim01 := 460; { 100 .. 1500 МПа }
  Sigma_Flim02 := 381;
  Sigma_Flim03 := 381;
  Sigma_Flim05 := 381;{ 100 .. 1500 МПа }

  Sigma_Fst01 := 1228; { 100 .. 1500 МПа }
  Sigma_Fst02 := 1017;
  Sigma_Fst03 := 1017;
  Sigma_Fst05 := 1017;{ 100 .. 1500 МПа }

  mc1 := '45 ГОСТ 1050-74';
  mc2 := '45 ГОСТ 1050-74';
  mc3 := '45 ГОСТ 1050-74';
  mc5 := '45 ГОСТ 1050-74';

  Termobr1 := 2; { 1 .. 8 }
  Termobr2 := 2; { 1 .. 8 }
  Termobr3 := 2;
  Termobr5 := 2;{ 1 .. 8 }

  ImprovStrength[1] := False;
  ImprovStrength[2] := False;
  ImprovStrength[3] := False;
  ImprovStrength[4] := False;

  Lh := 6300; { 10 ... 100000 ч }
  betg := 0; { 0 .. 45 }
  kanavka := 1;
  Ka := 1.0;
  Wikrugka[1] := 0;
  Wikrugka[2] := 0;
  Wikrugka[3] := 0;
  Wikrugka[4] := 0;
  Ra1 := 2;
  Ra2 := 2;
  Ra3 := 2;
  Ra5 := 2;
  Zw := 3;
  Tipz := 1;
  Nagr := False;
  rewers := False;
  BISTR := True;
  Zagotowka[1] := 1;
  Zagotowka[2] := 1;
  Zagotowka[3] := 1;
  Zagotowka[4] := 1;
  Nom_sx := 3;
  S_f1 := 1.75;
  S_f2 := 1.75;
  S_f3 := 1.75;
  S_f5 := 1.75;
  Y_d1 := 1;
  Y_d2 := 1;
  Y_d3 := 1;
  Y_d5 := 1;
  Y_g1 := 1;
  Y_g2 := 1;
  Y_g3 := 1;
  Y_g5 := 1;
  motw[1] := 0;
  motw[2] := 0;
  motw[3] := 0;
  motw[4] := 0;
  otw1 := True;
  Massa := 0;
  V_p := 0;
  B1 := 0;
  b2 := 0;
  b3 := 0;
  b5 := 0;
  Mn := 0;
  aw := 0;
  z1 := 0;
  z2 := 0;
  z3 := 0;
  z4 := 0;
  z5 := 0;
  St := 0;
  Fv := 0;
  epsias := 0;
  alfatw := 0;
  Uf := 0;
  n2 := 0;
  V := 0;
  Da1 := 0;
  Da2 := 0;
  Da3 := 0;
  Da4 := 0;
  Da5 := 0;
  d1 := 0;
  d2 := 0;
  d3 := 0;
  d4 := 0;
  d5 := 0;
  x1 := 0;
  x2 := 0;
  Dw1 := 0;
  Df1 := 0;
  Dw2 := 0;
  Df2 := 0;
  Dw3 := 0;
  Df3 := 0;
  Dw4 := 0;
  Df4 := 0;
  Dw5 := 0;
  Df5 := 0;
  Bet := 0;
  Sigma_H := 0;
  T1 := 0;
  T2 := 0;
  Ft1 := 0;
  Fr1 := 0;
  Fx1 := 0;
  Ft2 := 0;
  Fr2 := 0;
  Fx2 := 0;
  Error := 0;
  Sigma_F1 := 0;
  Sigma_F2 := 0;
  Sigma_F3 := 0;
  Sigma_F5 := 0;
  Sigma_Fp1 := 0;
  Sigma_Fp2 := 0;
  Sigma_Fp3 := 0;
  Sigma_Fp5 := 0;
  Sigma_Hp := 0;
  mascount := 0;
  // MaterialsDB:=nil;
end;

procedure MasOutputOnForm(mascount1: integer; var Output: TMyOutput;
  var Input1: TMyInput);
begin
  Output := masOutput[mascount1];
  Input1 := masInput[mascount1];
end;

procedure CalculateCWheel.recordOutput;
begin

  Output.Mn := Mn;
  { --------------------- Критерии качества --------------------------------- }
  Output.Massa := Massa; { Суммарная масса зубчатых колес }
  Output.V_p := V_p; { Объём занимаемый передачей }
  Output.B1 := B1;
  { ------------------------------------------------------------------------- }
  Output.b2 := b2;
  Output.b3 := b3;
  Output.b4 := b4;
  Output.b5 := b5;{ ширина венца }
  Output.Mn := Mn; { Нормальный модуль }
  Output.aw := aw; { межосевое расстояние передачи }
  Output.z1 := z1;
  Output.z2 := z2;
  Output.z3 := z3;
  Output.z4 := z4;
  Output.z5 := z5;{ Числа зубьев }
  Output.zw := Zw;

  Output.St := St; { Степень точности }

  Output.Fv := Fv; { Суммарное давление на вал }
  Output.epsias := epsias; { суммарный к-т перекрытия }
  Output.alfatw := alfatw; { угол зацепления зубчатых колес }
  { Фактическое передаточное число планетарной передачи (при остановленном колесе 3) }
  if z1 > 0 then
    Output.Uf := 1 + z3 / z1
  else
    Output.Uf := Uf;

  Output.n2 := n2; { Частота вращения колеса }
  Output.V := V; { Скорость, м/с }
  Output.Da1 := Da1;
  Output.Da2 := Da2;
  Output.Da3 := Da3;
  Output.Da4 := Da4;
  Output.Da5 := Da5;{ Диаметр окружности вершин }
  Output.d1 := d1;
  Output.d2 := d2;
  Output.d3 := d3;
  Output.d4 := d4;
  Output.d5 := d5;{ Делительный диаметр }
  Output.x1 := x1;
  Output.x2 := x2; { Коэффициент смещения исходного контура }
  Output.Dw1 := Dw1; { Начальный диаметр }
  Output.Df1 := Df1; { Диаметр окружности впадин }
  Output.Dw2 := Dw2; { Начальный диаметр }
  Output.Df2 := Df2;
  Output.Dw3 := Dw3; { Начальный диаметр }
  Output.Df3 := Df3;
  Output.Dw4 := Dw4; { Начальный диаметр }
  Output.Df4 := Df4;
  Output.Dw5 := Dw5; { Начальный диаметр }
  Output.Df5 := Df5;{ Диаметр окружности впадин }
  Output.Bet := Bet;
  Output.Sigma_H := Sigma_H; { Контактное напряжение }
  Output.T1 := T1; { Момент, передаваемый быстроходным валом }
  Output.T2 := T2; { Момент, передаваемый тихоходным валом }
  Output.Ft1 := Ft1; { Окружное усилие }
  Output.Fr1 := Fr1; { Радиальное усилие }
  Output.Fx1 := Fx1; { Осевое усилие }
  Output.Ft2 := Ft2; { Окружное усилие }
  Output.Fr2 := Fr2; { Радиальное усилие }
  Output.Fx2 := Fx2;
  Output.Error := Error;
  Output.Sigma_F1 := Sigma_F1; { Напряжения изгиба в зубе шестерни }
  Output.Sigma_F2 := Sigma_F2;
  Output.Sigma_F3 := Sigma_F3; { Напряжения изгиба в зубе колеса }
  Output.Sigma_Fp1 := Sigma_Fp1;
  Output.Sigma_Fp2 := Sigma_Fp2;
  Output.Sigma_Fp3 := Sigma_Fp3;{ Допускаемые напряжения изгиба }
  Output.Sigma_Hp := Sigma_Hp; { Допускаемое контактное напряжение }
  Input.P1 := P1;
  Input.n1 := n1;
  Input.U := U;
  Input.Lh := Lh;
  Input.mc1 := mc1;
  Input.Termobr1 := Termobr1;
  Input.mc2 := mc2;
  Input.Termobr2 := Termobr2;
  Input.mc3 := mc3;
  Input.Termobr3 := Termobr3;
  Input.mc5 := mc5;
  Input.Termobr5 := Termobr5;
  Input.Zagotowka[1] := Zagotowka[1];
  Input.Zagotowka[2] := Zagotowka[2];
  Input.Zagotowka[3] := Zagotowka[3];
  Input.Zagotowka[4] := Zagotowka[4];
  Input.Wikrugka[1] := Wikrugka[1];
  Input.Wikrugka[2] := Wikrugka[2];
  Input.Wikrugka[3] := Wikrugka[3];
  Input.Wikrugka[4] := Wikrugka[4];
  Input.Tipz := Tipz;
  Input.motw[1] := motw[1];
  Input.motw[2] := motw[2];
  Input.motw[3] := motw[3];
  Input.motw[4] := motw[4];
end;




// procedure CalculateCWheel.SetDeltaU(const Value: byte);
// begin
// if (Value < DeltaUMin) or (Value > DeltaUMax) then
// raise ERangeError.CreateFmt
// ('[CalculateCWheel.SetDeltaU] Допуск на передаточное число(DeltaU) не может быть равна %g, допустимый диапазон от %g до %g об/мин',
// [Value, DeltaUMin, DeltaUMax]);
// FDeltaU := Value;
// end;

procedure CalculateCWheel.Setbetg(const Value: Extended);
begin
  Fbetg := Value;
end;

procedure CalculateCWheel.SetBISTR(const Value: boolean);
begin
  FBISTR := Value;
end;

procedure CalculateCWheel.SetDeltaU(const Value: byte);
begin
  FDeltaU := Value;
end;

procedure CalculateCWheel.SetImprovStrength(const Value: array of boolean);
begin
  // FImprovStrength := Value;
end;

procedure CalculateCWheel.SetKa(const Value: Extended);
begin
  FKa := Value;
end;

procedure CalculateCWheel.Setkanavka(const Value: word);
begin
  Fkanavka := Value;
end;

procedure CalculateCWheel.SetLh(const Value: Extended);
begin
  FLh := Value;
end;

procedure CalculateCWheel.Setmc(const Value: TSteelMark);
begin
  Fmc2 := Value;
end;

procedure CalculateCWheel.Setmotw(const Value: TTwoWord);
begin
  Fmotw := Value;
end;

procedure CalculateCWheel.SetN1(const Value: Extended);
begin
  if (Value < N1Min) or (Value > N1Max) then
    raise ERangeError.CreateFmt
      ('[CalculateCWheel.SetN1] Частота вращения(N1) ведущего колеса (шкива) не может быть равна %g, допустимый диапазон от %g до %g об/мин',
      [Value, N1Min, N1Max])
  else
    FN1 := Value;
end;

procedure CalculateCWheel.SetNagr(const Value: boolean);
begin
  FNagr := Value;
end;

procedure CalculateCWheel.SetNom_sx(const Value: byte);
begin
  FNom_sx := Value;
end;

procedure CalculateCWheel.Setotw1(const Value: boolean);
begin
  Fotw1 := Value;
end;

procedure CalculateCWheel.SetP1(const Value: Extended);
begin
  if (Value < P1Min) or (Value > P1Max) then
    raise ERangeError.CreateFmt
      ('[CalculateCWheel.SetP1] Мощность на ведущем валу (P1) не может быть равна %g, допустимый диапазон от %g до %g кВт',
      [Value, P1Min, P1Max])
  else
    FP1 := Value;

end;

procedure CalculateCWheel.SetPsi_ba(const Value: Extended);
begin
  FPsi_ba := Value;
end;

procedure CalculateCWheel.SetRa(const Value: word);
begin
  FRa1 := Value;
end;

procedure CalculateCWheel.Setrewers(const Value: boolean);
begin
  Frewers := Value;
end;

procedure CalculateCWheel.SetTermobr(const Value: byte);
begin
  FTermobr1 := Value;
end;

procedure CalculateCWheel.SetTipz(const Value: word);
begin
  if (Value < TipzMin) or (Value > TipzMax) then
    raise ERangeError.CreateFmt
      ('[CalculateCWheel.SetTipz] Тип зубьев (Tipz) не может быть равно %d, допустимый диапазон от %d до %d',
      [Value, TipzMin, TipzMax])
  else
    FTipz := Value;
end;

procedure CalculateCWheel.SetU(const Value: Extended);
begin
  if (Value < UMin) or (Value > UMax) then
    raise ERangeError.CreateFmt
      ('[CalculateCWheel.SetU] Передаточное число (U) не может быть равно %g, допустимый диапазон от %g до %g',
      [Value, UMin, UMax])
  else
    FU := Value;
end;

procedure CalculateCWheel.SetWikrugka(const Value: TTwoWord);
begin
  FWikrugka := Value;
end;

procedure CalculateCWheel.SetZagotowka(const Value: TTwoWord);
begin
  FZagotowka := Value;
end;

procedure CalculateCWheel.SetZw(const Value: byte);
begin
  if (Value < ZwMin) or (Value > ZwMax) then
    raise ERangeError.CreateFmt
      ('[CalculateCWheel.SetZw] Число колес (Zw) не может быть равно %d, допустимый диапазон от %g до %g',
      [Value, ZwMin, ZwMax])
  else
    FZw := Value;
end;

PROCEDURE CalculateCWheel.MakeVersions;
  FUNCTION Process(ProcessID: char): byte;
  BEGIN
    case ProcessID of
      'U':
        Process := 0;
      'л':
        Process := 1;
      'о':
        Process := 2;
      'б':
        Process := 3;
      'а':
        Process := 4;
      'е':
        Process := 5;
      'и':
        Process := 6;
      'з':
        Process := 7;
      'т':
        Process := 8;
    end;
  END;

Var
  BufRec: string[65];
  ConvChk, i2: integer;
  Possible: array [1 .. 3] of single;
  CWC: byte;
  CTH: array [1 .. 2] of integer;
  // THandles: array [1..2] of PCollection;
  TPTemp: array [1 .. 4] of byte;
  CogTemp: word;

Const
  ValStr: string[4] = '    ';

BEGIN

  begin

    CogTemp := Tipz;
    TPTemp[1] := Termobr1;
    TPTemp[2] := Termobr2;
    TPTemp[3] := Termobr3;
    TPTemp[4] := Termobr5;
    for i2 := 1 to 50 do
      if ((mc1 = marka[i2]) and (Termobr1 = th[i2])) then
      begin
        H_HRcp1 := H_HB[i2];
        H_HRcs1 := si[i2];
        Sigma_t1 := Sigma_t[i2];
        Sigma_Flim01 := Sigma_Flim0[i2];
        Sigma_Fst01 := Sigma_Fst0[i2];
        S_f1 := S_f[i2];
        Y_g1 := Y_g[i2];
        Y_d1 := Y_d[i2];
      end;
    for i2 := 1 to 50 do
      if ((mc2 = marka[i2]) and (Termobr2 = th[i2])) then
      begin
        H_HRcp2 := H_HB[i2];
        H_HRcs2 := si[i2];
        Sigma_t2 := Sigma_t[i2];
        Sigma_Flim02 := Sigma_Flim0[i2];
        Sigma_Fst02 := Sigma_Fst0[i2];
        S_f2 := S_f[i2];
        Y_g2 := Y_g[i2];
        Y_d2 := Y_d[i2];
      end;
    for i2 := 1 to 50 do
      if ((mc3 = marka[i2]) and (Termobr3 = th[i2])) then
      begin
        H_HRcp3 := H_HB[i2];
        H_HRcs3 := si[i2];
        Sigma_t3 := Sigma_t[i2];
        Sigma_Flim03 := Sigma_Flim0[i2];
        Sigma_Fst03 := Sigma_Fst0[i2];
        S_f3 := S_f[i2];
        Y_g3 := Y_g[i2];
        Y_d3 := Y_d[i2];
      end;
    for i2 := 1 to 50 do
      if ((mc5 = marka[i2]) and (Termobr5 = th[i2])) then
      begin
        H_HRcp5 := H_HB[i2];
        H_HRcs5 := si[i2];
        Sigma_t5 := Sigma_t[i2];
        Sigma_Flim05 := Sigma_Flim0[i2];
        Sigma_Fst05 := Sigma_Fst0[i2];
        S_f5 := S_f[i2];
        Y_g5 := Y_g[i2];
        Y_d5 := Y_d[i2];
      end;
    // THandles[1]:=New(PStringCollection, Init(5, 5));
    // THandles[2]:=New(PStringCollection, Init(5, 5));
    // if Termobr1 = 0 then
    // ReadMaterials(Termobr1, mc1, THandles[1]);
    // if Termobr2 = 0 then
    // ReadMaterials(Termobr2, mc2, THandles[2]);
    // CTH[1]:=0;
    // repeat
    // if TPTemp[1] = 0 then
    // begin
    // Termobr1:=Process(string(THandles[1]^.At(CTH[1])^)[2]);
    // Inc(CTH[1]);
    // end;
    // ReadMaterials(Termobr1, mc1, @BufRec);
    // Move(BufRec[3], ValStr[2], 3);
    // Val(ValStr, H_HRcp1, ConvChk);
    // Move(BufRec[6], ValStr[2], 3);
    // Val(ValStr, H_HRcs1, ConvChk);
    // Move(BufRec[13], ValStr[1], 4);
    // Val(ValStr, Sigma_t1, ConvChk);
    // Move(BufRec[17], ValStr[1], 4);
    // Val(ValStr, Sigma_Flim01, ConvChk);
    // Move(BufRec[21], ValStr[1], 4);
    // Val(ValStr, Sigma_Fst01, ConvChk);
    // Move(BufRec[25], ValStr[1], 4);
    // Val(ValStr, S_F1, ConvChk);
    // Move(BufRec[29], ValStr[1], 4);
    // Val(ValStr, Y_g1, ConvChk);
    // Move(BufRec[37], ValStr[1], 4);
    // Val(ValStr, Y_d1, ConvChk);
    // FillChar(ValStr[1], 4, ' ');
    // CTH[2]:=0;
    // if not ImprovStrength[1] then
    // Y_d1:=1;
    // repeat
    // if TPTemp[2] = 0 then
    // begin
    // Termobr2:=Process(string(THandles[2]^.At(CTH[2])^)[2]);
    // Inc(CTH[2]);
    // end;
    // ReadMaterials(Termobr2, mc2, @BufRec);
    // Move(BufRec[3], ValStr[2], 3);
    // Val(ValStr, H_HRcp2, ConvChk);
    // Move(BufRec[6], ValStr[2], 3);
    // Val(ValStr, H_HRcs2, ConvChk);
    // Move(BufRec[13], ValStr[1], 4);
    // Val(ValStr, Sigma_t2, ConvChk);
    // Move(BufRec[17], ValStr[1], 4);
    // Val(ValStr, Sigma_Flim02, ConvChk);
    // Move(BufRec[21], ValStr[1], 4);
    // Val(ValStr, Sigma_Fst02, ConvChk);
    // Move(BufRec[25], ValStr[1], 4);
    // Val(ValStr, S_F2, ConvChk);
    // Move(BufRec[29], ValStr[1], 4);
    // Val(ValStr, Y_g2, ConvChk);
    // Move(BufRec[37], ValStr[1], 4);
    // Val(ValStr, Y_d2, ConvChk);
    // FillChar(ValStr[1], 4, ' ');
    // if not ImprovStrength[2] then
    // Y_d2:=1;

    if H_HRcp1 > 100 then
    begin
      H_HBp1 := H_HRcp1;
      H_HRcp1 := 0;
    end;
    if H_HRcp2 > 100 then
    begin
      H_HBp2 := H_HRcp2;
      H_HRcp2 := 0;
    end;
    if H_HRcp3 > 100 then
    begin
      H_HBp3 := H_HRcp3;
      H_HRcp3 := 0;
    end;
    if H_HRcp5 > 100 then
    begin
      H_HBp5 := H_HRcp5;
      H_HRcp5 := 0;
    end;

    if H_HRcs1 > 100 then
    begin
      H_HBs1 := H_HRcs1;
      H_HRcs1 := 0;
    end;
    if H_HRcs2 > 100 then
    begin
      H_HBs2 := H_HRcs2;
      H_HRcs2 := 0;
    end;
    if H_HRcs3 > 100 then
    begin
      H_HBs3 := H_HRcs3;
      H_HRcs3 := 0;
    end;
    if H_HRcs5 > 100 then
    begin
      H_HBs5 := H_HRcs5;
      H_HRcs5 := 0;
    end;
    { Перевод твердостей }
    { Из  HRc  в  HB }

    If (H_HRcs1 <= 30) and (H_HRcs1 > 0) then
      H_HBs1 := Round(220 * Exp(0.665 * Ln(H_HRcs1 / 20)))
    else if H_HRcs1 > 30 then
      H_HBs1 := Round(300 * Exp(0.96 * Ln(H_HRcs1 / 32.5)));

    If (H_HRcs2 <= 30) and (H_HRcs2 > 0) then
      H_HBs2 := Round(220 * Exp(0.665 * Ln(H_HRcs2 / 20)))
    else if H_HRcs2 > 30 then
      H_HBs2 := Round(300 * Exp(0.96 * Ln(H_HRcs2 / 32.5)));

    If (H_HRcs3 <= 30) and (H_HRcs3 > 0) then
      H_HBs3 := Round(220 * Exp(0.665 * Ln(H_HRcs3 / 20)))
    else if H_HRcs3 > 30 then
      H_HBs3 := Round(300 * Exp(0.96 * Ln(H_HRcs3 / 32.5)));

    If (H_HRcs5 <= 30) and (H_HRcs5 > 0) then
      H_HBs5 := Round(220 * Exp(0.665 * Ln(H_HRcs5 / 20)))
    else if H_HRcs3 > 30 then
      H_HBs5 := Round(300 * Exp(0.96 * Ln(H_HRcs5 / 32.5)));

    If (H_HRcp1 <= 30) and (H_HRcp1 > 0) then
      H_HBp1 := Round(220 * Exp(0.665 * Ln(H_HRcp1 / 20)))
    else if H_HRcp1 > 30 then
      H_HBp1 := Round(300 * Exp(0.96 * Ln(H_HRcp1 / 32.5)));

    If (H_HRcp2 <= 30) and (H_HRcp2 > 0) then
      H_HBp2 := Round(220 * Exp(0.665 * Ln(H_HRcp2 / 20)))
    else if H_HRcp2 > 30 then
      H_HBp2 := Round(300 * Exp(0.96 * Ln(H_HRcp2 / 32.5)));

    If (H_HRcp3 <= 30) and (H_HRcp3 > 0) then
      H_HBp3 := Round(220 * Exp(0.665 * Ln(H_HRcp3 / 20)))
    else if H_HRcp3 > 30 then
      H_HBp3 := Round(300 * Exp(0.96 * Ln(H_HRcp3 / 32.5)));

    If (H_HRcp5 <= 30) and (H_HRcp5 > 0) then
      H_HBp5 := Round(220 * Exp(0.665 * Ln(H_HRcp5 / 20)))
    else if H_HRcp3 > 30 then
      H_HBp5 := Round(300 * Exp(0.96 * Ln(H_HRcp5 / 32.5)));

    { Из HB в HV }
    If H_HBp1 < 100 then
      H_HVp1 := Round(0.13 * sqr(H_HBp1));
    If H_HBp2 < 100 then
      H_HVp2 := Round(0.13 * sqr(H_HBp2));
    If H_HBp3 < 100 then
      H_HVp3 := Round(0.13 * sqr(H_HBp3));
    If H_HBp5 < 100 then
      H_HVp5 := Round(0.13 * sqr(H_HBp5));

    if (H_HBp1 > 100) and (H_HBp1 < 350) then
      H_HVp1 := H_HBp1;
    if (H_HBp2 > 100) and (H_HBp2 < 350) then
      H_HVp2 := H_HBp2;
    if (H_HBp3 > 100) and (H_HBp3 < 350) then
      H_HVp3 := H_HBp3;
    if (H_HBp5 > 100) and (H_HBp5 < 350) then
      H_HVp5 := H_HBp5;

    if (H_HBp1 >= 350) and (H_HBp1 < 450) then
      H_HVp1 := Round(350 + (H_HBp1 - 350) * 1.4);
    if (H_HBp2 >= 350) and (H_HBp2 < 450) then
      H_HVp2 := Round(350 + (H_HBp2 - 350) * 1.4);
    if (H_HBp3 >= 350) and (H_HBp3 < 450) then
      H_HVp3 := Round(350 + (H_HBp3 - 350) * 1.4);
    if (H_HBp5 >= 350) and (H_HBp5 < 450) then
      H_HVp5 := Round(350 + (H_HBp5 - 350) * 1.4);

    if H_HBp1 > 450 then
      H_HVp1 := Round(450 + (H_HBp1 - 450) * 1.6);
    if H_HBp2 > 450 then
      H_HVp2 := Round(450 + (H_HBp2 - 450) * 1.6);
    if H_HBp3 > 450 then
      H_HVp3 := Round(450 + (H_HBp3 - 450) * 1.6);
    if H_HBp5 > 450 then
      H_HVp5 := Round(450 + (H_HBp5 - 450) * 1.6);

    Tipz := CogTemp;
    repeat
      if CogTemp = 0 then
      begin
        Tipz := Tipz;
        if Tipz = 1 then
          betg := 0
        else if Tipz = 3 then
          betg := 35
        else if Nom_sx = 8 then
          betg := 25
        else
          betg := 10;
      end;
      Possible[1] := -1;
      Possible[2] := -1;
      Possible[3] := -1;
      if BISTR then
        if H_HBp2 <= 350 then
          if Tipz = 3 then
          begin
            Possible[1] := 0.63;
            Possible[2] := 0.8;
            if Nom_sx = 7 then
              Possible[3] := 1;
          end
          else
            case Nom_sx of
              1, 2:
                begin
                  Possible[1] := 0.2;
                  Possible[2] := 0.25;
                end;
              3, 5, 8:
                begin
                  Possible[1] := 0.315;
                  Possible[2] := 0.4;
                end;
              7:
                begin
                  Possible[1] := 0.4;
                  Possible[2] := 0.5;
                  Possible[3] := 0.63;
                end;
            else // 4, 6
              begin
                Possible[1] := 0.315;
                Possible[2] := 0.4;
              end;
            end
        else if Tipz = 3 then
        begin
          Possible[1] := 0.5;
          Possible[2] := 0.63;
          if Nom_sx = 7 then
            Possible[3] := 0.8;
        end
        else
          case Nom_sx of
            1, 2:
              begin
                Possible[1] := 0.16;
                Possible[2] := 0.2;
              end;
            3, 5, 8:
              begin
                Possible[1] := 0.25;
                Possible[2] := 0.315;
              end;
            7:
              begin
                Possible[1] := 0.315;
                Possible[2] := 0.4;
                Possible[3] := 0.5;
              end;
          else // 4, 6
            begin
              Possible[1] := 0.25;
              Possible[2] := 0.315;
            end;
          end
      else if H_HBp2 <= 350 then
        if Tipz = 3 then
          case Nom_sx of
            4, 5:
              begin
                Possible[1] := 0.63;
                Possible[2] := 0.8;
                Possible[3] := 1;
              end;
            6:
              begin
                Possible[1] := 0.63;
                Possible[2] := 0.8;
              end;
            7:
              begin
                Possible[1] := 0.8;
                Possible[2] := 1;
                Possible[3] := 1.25;
              end;
          else
            begin
              Possible[1] := 0.63;
              Possible[2] := 0.8;
            end;
          end
        else
          case Nom_sx of
            1, 2:
              begin
                Possible[1] := 0.2;
                Possible[2] := 0.315;
              end;
            4, 5, 8:
              begin
                Possible[1] := 0.5;
                Possible[2] := 0.68;
                Possible[3] := 0.8;
              end;
            6:
              begin
                Possible[1] := 0.4;
                Possible[2] := 0.5;
                Possible[3] := 0.63;
              end;
            7:
              begin
                Possible[1] := 0.63;
                Possible[2] := 0.8;
                Possible[3] := 1;
              end;
          else // 3
            begin
              Possible[1] := 0.5;
              Possible[2] := 0.68;
              Possible[3] := 0.8;
            end;
          end
      else if Tipz = 3 then
        case Nom_sx of
          4, 5:
            begin
              Possible[1] := 0.5;
              Possible[2] := 0.63;
              Possible[3] := 0.8;
            end;
          6:
            begin
              Possible[1] := 0.5;
              Possible[2] := 0.63;
            end;
          7:
            begin
              Possible[1] := 0.63;
              Possible[2] := 0.8;
              Possible[3] := 1;
            end;
        else
          begin
            Possible[1] := 0.5;
            Possible[2] := 0.63;
          end;
        end
      else
        case Nom_sx of
          1, 2:
            begin
              Possible[1] := 0.16;
              Possible[2] := 0.2;
              Possible[3] := 0.25;
            end;
          4, 5, 8:
            begin
              Possible[1] := 0.4;
              Possible[2] := 0.5;
            end;
          6:
            begin
              Possible[1] := 0.315;
              Possible[2] := 0.4;
              Possible[3] := 0.5;
            end;
          7:
            begin
              Possible[1] := 0.5;
              Possible[2] := 0.63;
              Possible[3] := 0.8;
            end;
        else // 3
          begin
            Possible[1] := 0.4;
            Possible[2] := 0.5;
          end;
        end;
      for CWC := 1 to 3 do
        if Possible[CWC] > 0 then
        begin
          Psi_ba := Possible[CWC];
          Mn := 0;

            Error := 0;
            rac4et;

            // условие сборки: (z1 + z3) должно делиться на число сателлитов
            if (Error = 0) and (Zw > 1) and (((z1 + z3) mod Zw) <> 0) then
              Error := 30;
            // условие соседства: сателлиты не должны задевать друг друга
            if (Error = 0) and (Zw > 1) and (aw * sin(Pi / Zw) <= 0.5 * Da2) then
              Error := 31;

            if Error = 0 then
            begin
              SetLength(masOutput, mascount + 1);
              SetLength(masInput, mascount + 1);
              recordOutput;
              masOutput[mascount] := Output;
              masInput[mascount] := Input;
              inc(mascount);
            end;
            // AddVersion;

        end;
    until (CogTemp <> 0) or ((Tipz = 2) and (Nom_sx = 8)) or (Tipz = 3);
  end;
  // until i4=5;
  // until   i3=5;
  // Dispose(THandles[1], Done);
  // Dispose(THandles[2], Done);
  // inherited MakeVersions;
END;

procedure CalculateCWheel.MakeVersionss(Input: TMyInput);
var
  i4, i3: integer;
begin
  i3 := 1;
  mascount := 0;
  SetLength(masOutput, 0);
  SetLength(masInput, 0);
  FillChar(ArTermobr1, SizeOf(ArTermobr1), 0);
  FillChar(ArTermobr2, SizeOf(ArTermobr2), 0);
  ParamToRec(Input);

  if Termobr1 = 0 then
  begin
    wiborTerm(mc1, ArTermobr1);
  end
  else
    ArTermobr1[1] := Termobr1;
  if Termobr2 = 0 then
  begin
    wiborTerm(mc2, ArTermobr2);
  end
  else
    ArTermobr2[1] := Termobr2;
  // для колес 3 и 5 при автовыборе берется первая допустимая термообработка
  if Termobr3 = 0 then
  begin
    FillChar(ArTermobr3, SizeOf(ArTermobr3), 0);
    wiborTerm(mc3, ArTermobr3);
    Termobr3 := ArTermobr3[1];
  end;
  if Termobr5 = 0 then
  begin
    FillChar(ArTermobr5, SizeOf(ArTermobr5), 0);
    wiborTerm(mc5, ArTermobr5);
    Termobr5 := ArTermobr5[1];
  end;
  repeat
    if ArTermobr1[i3] <> 0 then
    begin
      i4 := 1;
      Termobr1 := ArTermobr1[i3];
      repeat
        if ArTermobr2[i4] <> 0 then
        begin
          Termobr2 := ArTermobr2[i4];
          MakeVersions;
        end;
        inc(i4)
      until i4 = 5;
    end;
    inc(i3);
  until i3 = 5;
end;

procedure CalculateCWheel.rac4et;
BEGIN
  { Парметры исходного контура }
  ha := 1;
  H_l := 2;
  Ro_f := 0.38;
  Alfa := Pi * 20 / 180;
  { --------------------------------------------------------------- }
  TipZp := 1;
  if Wikrugka[1] = 0 then
    Y_g1 := 1;
  if Wikrugka[2] = 0 then
    Y_g2 := 1;
  if Wikrugka[3] = 0 then
    Y_g3 := 1;
  if Wikrugka[4] = 0 then
    Y_g5 := 1;
  Bet := betg * Pi / 180;

  if H_HBp1 <= 350 then               //Расчет зубьев шестерни
    z1:=24;
  if H_HRcp1 <= 52 then
    z1:=21;
  if H_HRcp1 > 52 then
    z1:=18;

  { ------------------------------------------- }

  T1 := P1 * 30 * 1000 / (Pi * n1);
  T2 := T1 * U;
  { Расчет допускаемых напряжений }
  Da1 := 0;
  Da2 := 0;
  Da3 := 0;
  Da5 := 0;
  Metka := 1;
  PzubC2;
  { Проектный расчет передачи }

  PzubC3; // 1:
  if Error <> 0 then
    Exit;
  { Выбор коэффициентов Х1 и Х2 }
  PzubC4; // 2:
  { Расчет фактических напряжений }
  PzubC5; // 3:
  { Уточнение допускаемых напряжений }
  PzubC2;
  { Проверка условия: допускаемое напряжение больше фактического }
  { Проверка по контактным напряжениям }
  if Error <> 0 then
    Exit;
  if Sigma_H > (1.03 * Sigma_Hp) then
  begin
    if not otw1 then
      aw := aw * Exp(0.666 * Ln(Sigma_H / Sigma_Hp));
    if otw1 then
    begin
      if IAw < 32 then
        inc(IAw);
      aw := Aws[IAw];
    end;
    Mn := 0; // модуль пересчитывается под новое межосевое расстояние
    Metka := 2;
    PzubC3;
  End;
  { --------------------------------------- }
  if Sigma_Hmax > Sigma_Hpmax then
  begin
    if not otw1 then
      aw := aw * Exp(0.666 * Ln(Sigma_Hmax / Sigma_Hpmax));
    if otw1 then
    begin
      if IAw < 32 then
        inc(IAw);
      aw := Aws[IAw];
    end;
    Mn := 0; // модуль пересчитывается под новое межосевое расстояние
    Metka := 2;
    PzubC3;
  End;
  { ---------------------------- }
  { Проверка по изгибным напряжениям }
  If ((Sigma_F1 > Sigma_Fp1) or (Sigma_F2 > Sigma_Fp2)) then
  Begin
    if Imn < 41 then
      Imn := Imn + 1;
    Mn := ms[Imn];
    Metka := 3;
    PzubC3;
  End;
  If ((Sigma_Fmax1 > Sigma_Fpmax1) or (Sigma_Fmax2 > Sigma_Fpmax2)) then
  Begin
    if Imn < 41 then
      Imn := Imn + 1;
    Mn := ms[Imn];
    Metka := 3;
    PzubC3;
  End;
  { Расчет усилий }
  PzubC8;
  Fv := sqrt(Ft1 * Ft1 + Fr1 * Fr1);
  { Расчет размеров }
  PzubC6;
  { Расчет массы колес }
  dv2 := Exp(0.333 * Ln(T2 / 5)) * 10;
  Massa1 := Pi * 0.25 * (Dw1 * Dw1 * B1 + 0.54 * Zw * b2 *
    (Dw2 * Dw2 + dv2 * dv2)) * 1.0E-6 * 7.81;
  Massa2 := Pi * 0.25 * (Dw1 * Dw1 * B1 + Zw * b2 * (Dw2 * Dw2 - dv2 * dv2)) *
    1.0E-6 * 7.81;
  if Nom_sx = 8 then
  begin
    Massa1 := 2 * Massa1;
    Massa2 := 2 * Massa2;
  end
  else if Nom_sx = 4 then
  begin
    Massa1 := Pi * 0.25 * (Dw1 * Dw1 * Zw * B1 + 0.54 * b2 *
      (Dw2 * Dw2 + dv2 * dv2)) * 1.0E-6 * 7.81;
    Massa2 := Pi * 0.25 * (Dw1 * Dw1 * Zw * B1 + b2 * (Dw2 * Dw2 - dv2 * dv2)) *
      1.0E-6 * 7.81;
  end;
  Massa := Min3(Massa1, Massa2, Massa2);
  { Расчет объёма, занимаемого передачей }
  V_p := B1 * (Pi / 8 * (sqr(d1) + sqr(d2)) + (d1 + d2) / 2 * aw) * 1E-6;

END; // 7:    {  Конец процедуры  ExpanData      }

// constructor CalculateCWheel.Create(Input:TMyInput);
// begin
//
// Loading:=Input.Loading;
// P1:=Input. P1;             {Мощность, передаваемая быстроходным валом}
// n1:=Input.n1;              {Частота вращения быстроходного вала}
// U:=Input.u;          {Передаточное число передачи}
// DeltaU:=Input. DeltaU;
// Lh:=Input. Lh;        {Расчетный ресурс передачи}
// Tipz:=Input. Tipz;       {тип зубьев колес: 1 - прямые
// 2 - косые
// 3 - шевронные
// 0 - автовыбор}
// betg:=Input. betg;       {угол наклона зуба в градусах;
//
// при Tipz= 0 становится варьируемым
// параметром со знчениями 0, 10, 25 }
// kanavka:=Input.kanavka;    {Для шевронных колес при наличии канавки = 1,
// при отсутствии канавки =0}
// mc1:=Input. mc1;             {марка стали для шестерни}   {????????????????}
// mc2:=Input.mc2;  {марка стали для колеса}     {??????????????????}
// Termobr1:=Input.Termobr1;         {термообработка зуба шестерни, номер}
// Termobr2:=Input.Termobr2;    {термообработка зуба колеса, номер}
// Zagotowka:=Input.  Zagotowka;
// {Способ получения заготовки шестерни и колеса
// = 1 для поковок
// = 2 для штамповок
// = 3 для проката
// = 4 для отливок  }
// Ra1:=Input.Ra1;             {Шероховатость боковой поверхности зуба шестерни}
// Ra2:=Input. Ra2;        {Шероховатость боковой поверхности зуба колеса}
// Wikrugka:=Input.Wikrugka;
// {Финишная обработка выкружки зуба
// = 0 выкружка зубофрезерована или шлифована
// = 1 при полировании выкружки}
// Nom_sx:=Input.Nom_sx;           {Номер схемы расположения колес}
// Zw:=Input.Zw;          {Число колес находящихся в одновремен-
// ном контакте с шестерней}
// Psi_ba:=Input.Psi_ba;      {Коффициент ширины венца,
// при фиксированном значении вводится из стандартного
// ряда в зависимости от схемы передачи;
// при вводе АВТОВЫБОР становится варьируемым
// параметром также в зависимости от схемы передачи}
// Nagr:=Input. Nagr;           {=1 для типового режима,
// = 0 для циклограммы}
// rewers:=Input. rewers;  {При реверсировании = 1;
// без реверсирования = 0}
// Ka:=Input.Ka;          {Коэффициент внешней динамики}
// otw1:=Input.otw1;     {При стандартном межосевом расстоянии = 'Y',
// при нестандартном межосевом расстоянии ='n'}
// BISTR:=Input. BISTR;   { "0", если передача является тихоходной ступенью}
// { "1", если передача является быстроходной ступенью}
// motw:=Input.motw;
// {Выбор инструмента:
// 1   при нарезании долбяком
// 0   при нарезании фрезой
// 2   при нарезании старым долбякоми}
// H_HRcs1:=Input.H_HRcs1;          {Твердость сердцевины зуба шестерни по Роквеллу}
// H_HRcs2:=Input.H_HRcs2;          {Твердость сердцевины зуба колеса по Роквеллу}
// H_HRcp1:=Input.H_HRcp1;          {Твердость поверхности зуба шестерни по Роквеллу}
// H_HRcp2:=Input.H_HRcp2;          {Твердость поверхности зуба колеса по Роквеллу}
// H_HBs1:=Input. H_HBs1;          {Твердость сердцевины зуба шестерни по Бринелю}
// H_HBs2:=Input. H_HBs2 ;         {Твердость сердцевины зуба колеса по Бринелю}
// H_HBp1:=Input.H_HBp1;           {Твердость поверхности зуба шестерни по Бринелю}
// H_HBp2:=Input.H_HBp2;           {Твердость поверхности зуба колеса по Бринелю}
// H_HVs1:=Input.H_HVs1;           {Твердость сердцевины зуба шестерни по Виккерсу}
// H_HVs2:=Input.H_HVs2;           {Твердость сердцевины зуба колеса по Виккерсу}
// H_HVp1:=Input.H_HVp1;           {Твердость поверхности зуба шестерни по Виккерсу}
// H_HVp2:=Input.H_HVp2;{Твердость поверхности зуба колеса по Виккерсу}
// S_f1:=Input.S_f1;             { Коэффициент выносливости по изгибу для шестерни}
// S_f2:=Input.S_f2;             { Коэффициент выносливости по изгибу для колеса}
// Y_d1:=Input.Y_d1;             {Коэффициент деформационного упрочнения для шестерни}
// Y_d2:=Input.Y_d2;             {Коэффициент деформационного упрочнения для колеса}
// Y_g1:=Input.Y_g1;             {Коэффициент, учитывающий шлифование  для шестерни}
// Y_g2 :=Input.Y_g2;      {Коэффициент, учитывающий шлифование  для колеса}
// Sigma_t1:=Input.Sigma_t1;         {Предел текучести материала шестерни}
// Sigma_t2:=Input.Sigma_t2;         {Предел текучести материала колеса}
// Sigma_Flim01:=Input.Sigma_Flim01;    {Предел выносливости по изгибу для шестерни}
// Sigma_Flim02:=Input.Sigma_Flim02;     {Предел выносливости по изгибу для колеса}
// Sigma_Fst01:=Input.Sigma_Fst01;      {Предельное напряжение для шестерни}
// Sigma_Fst02:=Input.Sigma_Fst02; {Предельное напряжение для колеса}
// mn:= Output.Mn;
// {-------------------------------------------------------------------}
// MakeVersions;
// end;

function CalculateCWheel.Mu_F(Target: byte): Extended;
Const
  Mf6: array [0 .. 5] of single = (1, 0.3, 0.143, 0.065, 0.038, 0.013);
  Mf9: array [0 .. 5] of single = (1, 0.2, 0.1, 0.063, 0.016, 0.004);
Var
  qF: byte;
  Termobr: Extended;

BEGIN
  { Target - номер колеса: 1 - шестерня, 2 - сателлит, 3 - колесо, 4 - второе колесо }
  case Target of
    1:
      Termobr := Termobr1;
    2:
      Termobr := Termobr2;
    3:
      Termobr := Termobr3;
  else
    Termobr := Termobr5;
  end;
  if (Wikrugka[Target] <> 0) or not(Termobr > 2) then
    qF := 6
  else
    qF := 9;
  if not Nagr then
    case qF of
      6:
        Mu_F := Mf6[Loading.GraphBar];
      9:
        Mu_F := Mf9[Loading.GraphBar];
    end
  else
    with Loading do
      Mu_F := i + j * XBY(y, qF) + k * XBY(z, qF);
end;

function CalculateCWheel.Mu_H: Extended;
Const
  ConstMh: array [0 .. 5] of single = (1, 0.5, 0.25, 0.18, 0.125, 0.063);

BEGIN
  if not Nagr then
    Mu_H := ConstMh[Loading.GraphBar]
  else
    with Loading do
      Mu_H := i + j * XBY(y, 3) + k * XBY(z, 3);
end;

procedure CalculateCWheel.ParamToRec(Input: TMyInput);
begin
  Loading := Input.Loading;
  P1 := Input.P1; { Мощность, передаваемая быстроходным валом }
  n1 := Input.n1; { Частота вращения быстроходного вала }
  U := Input.U; { Передаточное число передачи }
  DeltaU := Input.DeltaU;
  Lh := Input.Lh; { Расчетный ресурс передачи }
  Tipz := Input.Tipz; { тип зубьев колес: 1 - прямые
    2 - косые
    3 - шевронные
    0 - автовыбор }
  betg := Input.betg; { угол наклона зуба в градусах;

    при Tipz= 0 становится варьируемым
    параметром со знчениями 0, 10, 25 }
  kanavka := Input.kanavka; { Для шевронных колес при наличии канавки = 1,
    при отсутствии канавки =0 }
  mc1 := Input.mc1; { марка стали для шестерни }
  mc2 := Input.mc2; { марка стали для сателлита }
  mc3 := Input.mc3; { марка стали для колеса }
  mc5 := Input.mc5; { марка стали для второго колеса }
  Termobr1 := Input.Termobr1; { термообработка зуба шестерни, номер }
  Termobr2 := Input.Termobr2; { термообработка зуба сателлита, номер }
  Termobr3 := Input.Termobr3; { термообработка зуба колеса, номер }
  Termobr5 := Input.Termobr5; { термообработка зуба второго колеса, номер }
  ImprovStrength[1] := Input.ImprovStrength[1];
  ImprovStrength[2] := Input.ImprovStrength[2];
  ImprovStrength[3] := Input.ImprovStrength[3];
  ImprovStrength[4] := Input.ImprovStrength[4];
  Zagotowka := Input.Zagotowka;
  { Способ получения заготовки шестерни и колеса
    = 1 для поковок
    = 2 для штамповок
    = 3 для проката
    = 4 для отливок }
  Ra1 := Input.Ra1; { Шероховатость боковой поверхности зуба шестерни }
  Ra2 := Input.Ra2; { Шероховатость боковой поверхности зуба сателлита }
  Ra3 := Input.Ra3; { Шероховатость боковой поверхности зуба колеса }
  Ra5 := Input.Ra5; { Шероховатость боковой поверхности зуба второго колеса }
  Wikrugka := Input.Wikrugka;
  { Финишная обработка выкружки зуба
    = 0 выкружка зубофрезерована или шлифована
    = 1 при полировании выкружки }
  Nom_sx := Input.Nom_sx;
  Zw := Input.Zw; { Число сателлитов }

  Psi_ba := Input.Psi_ba; { Коффициент ширины венца,
    при фиксированном значении вводится из стандартного
    ряда в зависимости от схемы передачи;
    при вводе АВТОВЫБОР становится варьируемым
    параметром также в зависимости от схемы передачи }
  Nagr := Input.Nagr; { =1 для типового режима,
    = 0 для циклограммы }
  rewers := Input.rewers; { При реверсировании = 1;
    без реверсирования = 0 }
  Ka := Input.Ka; { Коэффициент внешней динамики }
  otw1 := Input.otw1; { При стандартном межосевом расстоянии = 'Y',
    при нестандартном межосевом расстоянии ='n' }
  BISTR := Input.BISTR; { "0", если передача является тихоходной ступенью }
  { "1", если передача является быстроходной ступенью }
  motw := Input.motw;
  { Выбор инструмента:
    1   при нарезании долбяком
    0   при нарезании фрезой
    2   при нарезании старым долбякоми }
  Mn := Output.Mn;
end;

{расчетные изгибные напряжения по номиналу и по пиковым нагрузкам}
procedure CalculateCWheel.PrSigF(z: integer; x: Extended;
  var Sigma_F, Sigma_Fmax: Extended);

Var
  Y_epsilon, Y_beta, Y_Fs, K_Falfa, K_Fbeta, Delta_F, W_Fv, K_epsbet, K_F, K_Fv,
    Z_v, l_k, Psi_lm, H: Extended;
BEGIN
  bw := b2;
  if betg = 0 then
    Y_epsilon := 1
  else if Eps_bet < 1 then
    Y_epsilon := 0.2 + 0.8 / epsia
  else
    Y_epsilon := 1 / epsia;
  Y_beta := 1 - Eps_bet * betg / 120;
  { учесть разницу градусов и радиан }
  if Y_beta < 0.7 then
    Y_beta := 0.7;
  Z_v := z / Exp(3 * Ln(Cos(Bet)));
  Y_Fs := 3.47 + 13.2 / Z_v - 29.7 * x / Z_v + 0.092 * sqr(x);
  { -------------------- }
  if betg = 0 then
    K_Falfa := 1
  else
  begin
    n_alfa := Frac(epsia);
    n_beta := Frac(Eps_bet);
    if Eps_bet <= epsia then
    begin
      if Eps_bet = 0 then
      begin
        Error := 20;
        Exit;
      end
      else if n_alfa < n_beta then
        K_epsbet := (n_alfa - n_alfa * n_beta) / Eps_bet
      else
        K_epsbet := (n_beta - n_alfa * n_beta) / Eps_bet;
      K_Falfa := (0.9 + Cos(Alfat) * Cos(Bet) * C_prim * bw * (f_pb - y_alfa) /
        (Ft * Ka * K_Hv) * (epsia - 1 + K_epsbet)) / (epsia + K_epsbet);
    End
    else
      K_Falfa := K_Halfa;
    if K_Falfa > 1 then
      K_Falfa := 1;
  End;
  { --------------------- }
  H := 2 * Mn;
  if Bet = 0 then
    H := H / epsia;
  K_Fbeta := Exp(sqr(bw / H) / (sqr(bw / H) + bw / H + 1) * Ln(K_Hbeta));
  { ----------------------- }
  if betg = 0 then
    Delta_F := 0.16
  else
    Delta_F := 0.06;
  W_Fv := Delta_F * g0 * V * sqrt(aw / Uf);
  K_Fv := 1 + W_Fv * bw / (Ft * Ka);
  { ------------------------- }
  K_F := Ka * K_Fv * K_Fbeta * K_Falfa;
  Sigma_F := Ft * K_F * Y_Fs * Y_beta * Y_epsilon / (bw * Mn);
  Sigma_Fmax := Sigma_F * Ka;
END;

{расчет допускаемых напряжений изгиба}
procedure CalculateCWheel.PrSigFp(Da, Mn, Mu_F, N, S_f, Yd, Yg: Extended;
  Lh: integer; H_HBp, Sigma_Flim0: Extended; rewers: boolean;
  Termobr, Zagotowka, Wikrugka, Zw: byte; var Sigma_Fp: Extended);
var
  Yx, Yr, Yn, Y_delta, Yz, N_sum, N_Fe, Sigma_Flim, Ya, q_F: Extended;
BEGIN
  if Wikrugka = 0 then
    Yr := 1
  else
    case Termobr of
      4 .. 7:
        Yr := 1.05;
    else
      Yr := 1.2;
    end;
  N_sum := 60 * N * Lh * Zw;
  N_Fe := Mu_F * N_sum;
  if (Wikrugka = 0) and (H_HBp > 350) then
    q_F := 9
  else
    q_F := 6;
  If N_Fe > 4E6 then
    Yn := 1
  else
    Yn := Exp(q_F * Ln(4E6 / N_Fe));
  if ((q_F = 6) and (Yn > 4)) then
    Yn := 4;
  if ((q_F = 9) and (Yn > 2.5)) then
    Yn := 2.5;
  If not rewers then
    Ya := 1
  else
    Case Termobr of
      3, 4, 5, 6:
        Ya := 0.75;
      7:
        Ya := 0.9
    else
      Ya := 0.65;
    end;
  Case Zagotowka of
    0, 1:
      Yz := 1;
    2:
      Yz := 0.9;
  else
    Yz := 0.8; // прокат, отливка
  end;
  If Da = 0 then
    Sigma_Fp := 0.4 * Sigma_Flim0 * Yn * Ya
  else
  begin
    Yx := 1.05 - 0.000125 * Da;
    Y_delta := 1.082 - 0.172 * Log10(Mn);
    Sigma_Flim := Sigma_Flim0 * Yz * Yg * Yd * Ya;
    Sigma_Fp := Sigma_Flim * Yn * Y_delta * Yr * Yx / S_f;
  end;
end;


{расчетных фактических контактных напряжений}
procedure CalculateCWheel.PrSigH;
// Label 1,2,3,4,5;

Var
  Delta_H, W_Hv, F_beta, a_beta, f_ky, f_kz, K_Hw, Y_a, f_pb_1, f_pb_2, a_alfa,
    K_H, Z_eps, Z_H, Sigma_H0, Alfaa1, Alfaa2, Gamma_sig, Bwl, eps_betbet,
    y_betb, y_alfa1, y_alfa2, y_alfamax, Betb, Psi_lm, l_k, K_epsi, epsilon,
    a_n, K_epsbet: Extended;
  i, I1, I_pb_v, I_pb_g: byte;
  M: Extended;
Type
  TT1 = array [1 .. 5, 1 .. 7] of Extended;
Const
  f_pb_6: TT1 = ((9.5, 10, 12, 13, 15, 0, 0), //
    (12, 13, 13, 15, 17, 19, 0), (13, 15, 17, 17, 19, 21, 24),
    (0, 17, 19, 19, 21, 24, 25), (0, 0, 0, 0, 0, 0, 0));

  f_pb_7: TT1 = ((13, 15, 17, 19, 21, 0, 0), (17, 19, 19, 21, 24, 26, 0),
    (19, 21, 24, 24, 26, 30, 34), (0, 24, 26, 26, 30, 34, 38),
    (0, 30, 34, 34, 38, 38, 42));

  f_pb_8: TT1 = ((19, 21, 21, 26, 30, 0, 0), (24, 26, 26, 30, 34, 38, 0),
    (26, 30, 34, 34, 38, 42, 48), (0, 34, 38, 38, 42, 48, 53),
    (0, 42, 48, 48, 53, 53, 60));

  f_pb_9: TT1 = ((26, 30, 34, 38, 42, 0, 0), (34, 38, 38, 42, 48, 53, 0),
    (38, 42, 45, 48, 53, 60, 67), (0, 48, 53, 53, 60, 67, 75),
    (0, 60, 67, 67, 75, 75, 85));

  f_pb_g: array [1 .. 7] of integer = (125, 480, 800, 1000, 2000, 4000, 8000);

  f_pb_v: array [1 .. 5] of Extended = (3.55, 6.3, 10, 16, 25);

  F_betm: array [1 .. 4, 1 .. 6] of integer = ((9, 12, 16, 20, 25, 28),
    (11, 16, 20, 25, 28, 32), (18, 25, 32, 40, 45, 56),
    (28, 40, 50, 63, 71, 90));

  F_beta_g: array [1 .. 6] of integer = (40, 100, 160, 200, 400, 630);
  Procedure Proced3;
  BEGIN
    case St of
      6:
        f_pb_1 := f_pb_6[I_pb_g, I_pb_v];
      7:
        f_pb_1 := f_pb_7[I_pb_g, I_pb_v];
      8:
        f_pb_1 := f_pb_8[I_pb_g, I_pb_v];
      9:
        f_pb_1 := f_pb_9[I_pb_g, I_pb_v];
    end;
  end;
  Procedure Proced2;
  var
    i: integer;
  BEGIN
    for i := 1 to 5 do
      if Mn <= f_pb_v[i] then
      begin
        I_pb_g := i;
        Proced3
      end;
  END;
  Procedure Proced4;
  begin
    case St of
      6:
        f_pb_2 := f_pb_6[I_pb_g, I_pb_v];
      7:
        f_pb_2 := f_pb_7[I_pb_g, I_pb_v];
      8:
        f_pb_2 := f_pb_8[I_pb_g, I_pb_v];
      9:
        f_pb_2 := f_pb_9[I_pb_g, I_pb_v];
    end;
  end;

BEGIN
  { расчет K_Hv }
  if betg = 0 Then
  Begin
    Z_v1 := z1;
    Z_v2 := z2;
  End
  Else
  Begin
    Z_v1 := z1 / Exp(3 * Ln(Cos(Bet)));
    Z_v2 := z2 / Exp(3 * Ln(Cos(Bet)));
  End;
  d1 := z1 * Mn / Cos(Bet);
  d2 := z2 * Mn / Cos(Bet);
  bw := b2;
  Ft := 2000 * T1 / (d1 * Zw);
  if Nom_sx = 8 then
    Ft := Ft / 2;
  V := Pi * d1 * n1 / 60000;
  if Bet = 0 then
  begin
    if V < 2 then
      St := 9
    else if V < 6 then
      St := 8
    else if V < 10 then
      St := 7
    else
      St := 6;
  end;
  if Bet > 0 then
  begin
    if V < 10 then
      St := 8
    else if V < 16 then
      St := 7
    else
      St := 6;
  end;
  M := Mn;
  case St of
    6:
      if M <= 3.55 then
        g0 := 3.8
      else if M <= 10 then
        g0 := 4.2
      else
        g0 := 4.8;
    7:
      if M <= 3.55 then
        g0 := 4.7
      else if M <= 10 then
        g0 := 5.3
      else
        g0 := 6.4;
    8:
      if M <= 3.55 then
        g0 := 5.6
      else if M <= 10 then
        g0 := 6.1
      else
        g0 := 7.3;
    9:
      if M <= 3.55 then
        g0 := 7.3
      else if M <= 10 then
        g0 := 8.2
      else
        g0 := 10
  end;
  if (H_HVp1 > 350) and (H_HVp2 > 350) then
    if betg = 0 then
      Delta_H := 0.14
    else
      Delta_H := 0.04
  else if betg = 0 then
    Delta_H := 0.06
  else
    Delta_H := 0.02;
  W_Hv := Delta_H * g0 * V * sqrt(aw / U);
  K_Hv := 1 + W_Hv * bw / (Ft * Ka);
  { расчет K_Halfa }
  for i := 1 to 7 do
    if d1 <= f_pb_g[i] then
    begin
      I_pb_v := i;
      Proced2
    end;

  for i := 1 to 7 do
    if d2 <= f_pb_g[i] then
    begin
      I_pb_v := i;
      Proced4
    end;
  Da1 := (2 + z1) * Mn / Cos(Bet);
  Da2 := (2 + z2) * Mn / Cos(Bet);
  if (H_HVp1 > 350) and (H_HVp2 > 350) then
    a_alfa := 0.3
  else
    a_alfa := 0.2;
  f_pb := a_alfa * sqrt(sqr(f_pb_1) + sqr(f_pb_2));
  Alfaa1 := ArcCos(Mn * z1 / Cos(Bet) * Cos(Alfat) / Da1);
  Alfaa2 := ArcCos(Mn * z2 / Cos(Bet) * Cos(Alfat) / Da2);
  Epsia1 := z1 * (Tan(Alfaa1) - Tan(alfatw)) / (2 * Pi);
  Epsia2 := z2 * (Tan(Alfaa2) - Tan(alfatw)) / (2 * Pi);
  epsia := Epsia1 + Epsia2;
  case Tipz of
    1:
      Eps_bet := 0;
    2:
      Eps_bet := b2 * Sin(Bet) / (Pi * Mn);
    3:
      Eps_bet := 0.5 * b2 * Sin(Bet) / (Pi * Mn);
  end;
  epsias := epsia + Eps_bet;
  if Bet > 0 then
  begin
    if Eps_bet < 1 then
      Z_eps := sqrt((4 - epsia) * (1 - Eps_bet) / 3 + Eps_bet / (epsia))
    else
      Z_eps := sqrt(1 / epsia);
  end
  else
    Z_eps := sqrt((4 - epsia) / 3);
  C_prim := 1 / (0.05139 + 0.1425 / Z_v1 + 0.186 / Z_v2 - 0.1027 * x1 / Z_v1 -
    0.01 * x1 + 0.00455 * x2 + 0.3762 * x2 / Z_v2 + 0.00734 * sqr(x1) - 0.00054
    * sqr(x2));

  if betg = 0 then
    K_Halfa := 1
  else
  begin
    n_alfa := Frac(epsia);
    n_beta := Frac(Eps_bet);
    if H_HVp1 > 350 then
    begin
      y_alfa1 := 0.075 * f_pb;
      if y_alfa1 > 3 then
        y_alfa1 := 3;
    end
    else
    begin
      y_alfa1 := 160 * f_pb / Sigma_Hlimb1;
      if V >= 5 then
        y_alfamax := 12800 / Sigma_Hlimb1;
      if V >= 10 then
        y_alfamax := 6400 / Sigma_Hlimb1;
      if V >= 5 then
        if y_alfa1 > y_alfamax then
          y_alfa1 := y_alfamax;
    end;
    if H_HVp2 > 350 then
    begin
      y_alfa2 := 0.075 * f_pb;
      if y_alfa2 > 3 then
        y_alfa2 := 3;
    end
    else
    begin
      y_alfa2 := 160 * f_pb / Sigma_Hlimb2;
      if V >= 5 then
        y_alfamax := 12800 / Sigma_Hlimb2;
      if V >= 10 then
        y_alfamax := 6400 / Sigma_Hlimb2;
      if V >= 5 then
        if y_alfa2 > y_alfamax then
          y_alfa2 := y_alfamax;
    end;
    y_alfa := (y_alfa1 + y_alfa2) / 2;
    if Eps_bet = 0 then
    begin
      Error := 20;
      Exit;
    end
    else if (n_alfa + n_beta) <= 1 then
      K_epsi := 1 - n_alfa * n_beta / (epsia * Eps_bet)
    else
      K_epsi := 1 - (1 - n_alfa) * (1 - n_beta) / (epsia * Eps_bet);
    if Eps_bet <= epsia then
      K_Halfa := (0.9 + Cos(Alfat) * Cos(Bet) * C_prim * bw * (f_pb - y_alfa) /
        (Ft * Ka * K_Hv) * (K_epsi * epsia - 1)) / (K_epsi * epsia)
    else
      K_Halfa := (0.9 + Cos(Alfat) * Cos(Bet) * C_prim * bw * (f_pb - y_alfa) /
        (Ft * Ka * K_Hv) * (epsia - epsia / Eps_bet)) / Eps_bet;
  End;
  If K_Halfa > 1 then
    K_Halfa := 1;
  { -------------------------- }
  { расчет K_Hbeta }
  K_Hbeta := K_HB;
  K_H := K_Hv * K_Hbeta * K_Halfa * Ka;
  Betb := ArcSin(Sin(Bet) * Cos(20 * Pi / 180));
  Z_H := 1 / Cos(Alfat) * sqrt(2 * Cos(Betb) / Tan(alfatw));
  b2 := Round(Psi_ba * aw);
  bw:=b2;
  if Nom_sx < 8 then
    Sigma_H0 := 190 * Z_H * Z_eps *
      sqrt(2000 * T1 * (U + 1) / (bw * sqr(d1) * Uf * Zw))
  else
    Sigma_H0 := 190 * Z_H * Z_eps *
      sqrt(1000 * T1 * (U + 1) / (bw * sqr(d1) * Uf * Zw));
  Sigma_H := Sigma_H0 * sqrt(K_H);
  Sigma_Hmax := Sigma_H * sqrt(Loading.x);

  { конец процедуры расчета контактных напряжений }
END;


{расчет допускаемых контактных напряжений}
procedure CalculateCWheel.PrSigHp(Da, Mn, N, Mu_H, H_HBp, H_HRcp, H_HVp,
  Ra: Extended; Lh: integer; Termobr, Zw: byte;
  var Sigma_Hlimb, Sigma_Hp: Extended);

var
  Zx, Zv, Zr, Sh, N_Hlim, N_sum, N_He, Zn, Sigma_Hlim: Extended;

BEGIN
  If Ra = 0 then
    Zr := 1
  else if Ra = 1 then
    Zr := 0.95
  else
    Zr := 0.9;

  Case Termobr of
    4, 5, 6, 7:
      Sh := 1.2
  else
    Sh := 1.1;
  end;
  Case Termobr of
    3:
      Sigma_Hlim := 1.8 * H_HBp + 150;
    4:
      Sigma_Hlim := 1.7 * H_HBp + 200;
    5, 6:
      Sigma_Hlim := 2.3 * H_HBp;
    7:
      Sigma_Hlim := 1050;
  else
    Sigma_Hlim := 2 * H_HBp + 70; // улучшение, нормализация, отжиг
  End;
  N_Hlim := 30 * Exp(2.4 * Ln(H_HBp));
  if N_Hlim > 12E7 then
    N_Hlim := 12E7;
  N_sum := 60 * N * Lh * Zw;
  N_He := Mu_H * N_sum;
  If N_He <= N_Hlim then
  begin
    Zn := Exp(0.167 * Ln(N_Hlim / N_He));
    if Termobr <= 3 then
      if Zn > 2.6 then
        Zn := 2.6
      else if Zn > 1.8 then
        Zn := 1.8;
  end
  Else
  begin
    Zn := Exp(0.05 * Ln(N_Hlim / N_He));
    if Zn < 0.75 then
      Zn := 0.75;
  end;
  If Da = 0 then
    Sigma_Hp := Sigma_Hlim * Zn * 0.9 / Sh
  else
  begin
    if Da <= 700 then
      Zx := 1
    else
      Zx := sqrt(1.07 - 0.0001 * Da);
    V := Pi * (Da - 2 * Mn) * N / 60000;
    if H_HBp <= 350 then
      Zv := 0.85 * Exp(0.1 * Ln(V))
    else
      Zv := 0.925 * Exp(0.05 * Ln(V));
    Sigma_Hp := Sigma_Hlim * Zn * Zr * Zv * Zx / Sh
  End;
  Sigma_Hlimb := Sigma_Hlim;
end;
{конец расчета допускаемых контактных напряжений}


//расчет допускаемых изгибных и контактных напряжений от пусковых нарузок
procedure CalculateCWheel.PrSigMax(Sigma_t, H_HRcp, H_HVp, Sigma_Fst0,
  Da: Extended; Zagotowka, Termobr: byte;
  var Sigma_Hpmax, Sigma_Fpmax: Extended);
var
  S_Fst, Yx, Yz: Extended;

BEGIN
  Case Termobr of
    4, 5, 6:
      Sigma_Hpmax := 44 * H_HRcp;
    7:
      Sigma_Hpmax := 3 * H_HVp
  else
    Sigma_Hpmax := 2.8 * Sigma_t;
  end;
  Case Zagotowka of
    0, 1:
      Yz := 1;
    2:
      Yz := 0.9;
  else
    Yz := 0.8; // прокат, отливка
  end;
  S_Fst := Yz * 1.75;
  Yx := 1.05 - 0.000125 * Da;
  Sigma_Fpmax := Sigma_Fst0 * Yx / S_Fst
end;

procedure CalculateCWheel.PzubC2;
Var
  c1: Extended;
  Sigma_Hp1, Sigma_Hp2, Sigma_Hp3, Sigma_hp5: Extended;
  Sigma_Hpmax1, Sigma_Hpmax2, Sigma_Hpmax3, Sigma_Hpmax5: Extended;
BEGIN
  c1 := 1.23;
  PrSigHp(Da1, Mn, n1, Mu_H, H_HBp1, H_HRcp1, H_HVp1, Ra1, trunc(Lh), Termobr1,
    Zw, Sigma_Hlimb1, Sigma_Hp1);
  n2 := n1 / U;
  PrSigHp(Da2, Mn, n2, Mu_H, H_HBp2, H_HRcp2, H_HVp2, Ra2, trunc(Lh), Termobr2,
    Zw, Sigma_Hlimb2, Sigma_Hp2);
  PrSigHp(Da3, Mn, n2, Mu_H, H_HBp3, H_HRcp3, H_HVp3, Ra3, trunc(Lh), Termobr3,
    Zw, Sigma_Hlimb3, Sigma_Hp3);
  PrSigHp(Da5, Mn, n2, Mu_H, H_HBp5, H_HRcp5, H_HVp5, Ra5, trunc(Lh), Termobr5,
    Zw, Sigma_Hlimb5, Sigma_Hp5);

  If Bet = 0 then
    Sigma_Hp := Min3(Sigma_Hp1, Sigma_Hp2, Sigma_Hp3)
  else
  begin
    if 0.45 * (Sigma_Hp1 + Sigma_Hp2) > c1 * Min3(Sigma_Hp1, Sigma_Hp2,
      Sigma_Hp3) then
      Sigma_Hp := c1 * Min3(Sigma_Hp1, Sigma_Hp2, Sigma_Hp3)
    else
      Sigma_Hp := 0.45 * (Sigma_Hp1 + Sigma_Hp2);
  end;

  PrSigFp(Da1, Mn, Mu_F(1), n1, S_f1, Y_d1, Y_g1, trunc(Lh), H_HBp1,
    Sigma_Flim01, rewers, Termobr1, Zagotowka[1], Wikrugka[1], Zw, Sigma_Fp1);
  PrSigFp(Da2, Mn, Mu_F(2), n2, S_f2, Y_d2, Y_g2, trunc(Lh), H_HBp2,
    Sigma_Flim02, rewers, Termobr2, Zagotowka[2], Wikrugka[2], Zw, Sigma_Fp2);
  PrSigFp(Da3, Mn, Mu_F(3), n2, S_f3, Y_d3, Y_g3, trunc(Lh), H_HBp3,
    Sigma_Flim03, rewers, Termobr3, Zagotowka[3], Wikrugka[3], Zw, Sigma_Fp3);
  PrSigFp(Da5, Mn, Mu_F(4), n2,
 S_f5, Y_d5, Y_g5, trunc(Lh), H_HBp5,
    Sigma_Flim05, rewers, Termobr5, Zagotowka[4], Wikrugka[4], Zw, Sigma_Fp5);

  PrSigMax(Sigma_t1, H_HRcp1, H_HVp1, Sigma_Fst01, Da1, Zagotowka[1], Termobr1,
    Sigma_Hpmax1, Sigma_Fpmax1);
  PrSigMax(Sigma_t2, H_HRcp2, H_HVp2, Sigma_Fst02, Da2, Zagotowka[2], Termobr2,
    Sigma_Hpmax2, Sigma_Fpmax2);
  PrSigMax(Sigma_t3, H_HRcp3, H_HVp3, Sigma_Fst03, Da3, Zagotowka[3], Termobr3,
    Sigma_Hpmax3, Sigma_Fpmax3);
  PrSigMax(Sigma_t5, H_HRcp5, H_HVp5, Sigma_Fst05, Da5, Zagotowka[4], Termobr5,
    Sigma_Hpmax5, Sigma_Fpmax5);

  Sigma_Hpmax := Min3(Sigma_Hpmax1, Sigma_Hpmax2, Sigma_Hpmax3);

END; { Конец   PzubC2 }

procedure CalculateCWheel.PzubC3;
// Label 1, 2,3,4 ;
Var
  AA, BB, Psi_bd, A_w, M_n, T_He2: Extended;
  K_a, Ze, K_ma: integer;
  Procedure Proced1;

  BEGIN
    If H_HBp3 < 350 then
      Case Nom_sx of
        1:
          begin
            AA := 0.125;
            BB := 0.425;
          end;
        2:
          begin
            AA := 0.125;
            BB := 0.265;
          end;
        3:
          begin
            AA := 0.0293;
            BB := 0.128;
          end;
        4:
          begin
            AA := 0.0465;
            BB := 0.058;
          end;
        5:
          begin
            AA := 0.0435;
            BB := 0.0313;
          end;
        6:
          begin
            AA := 0.0362;
            BB := 0.0141;
          end;
        7:
          begin
            AA := 0.0272;
            BB := 0.0035;
          end;
        8:
          begin
            AA := 0.0293;
            BB := 0.128;
          end;
      end
    else
      Case Nom_sx of
        1:
          begin
            AA := 0;
            BB := 1.25;
          end;
        2:
          begin
            AA := 0.542;
            BB := 0.42;
          end;
        3:
          begin
            AA := 0.106;
            BB := 0.247;
          end;
        4:
          begin
            AA := 0.0675;
            BB := 0.221;
          end;
        5:
          begin
            AA := 0.083;
            BB := 0.111;
          end;
        6:
          begin
            AA := 0.0869;
            BB := 0.0307;
          end;
        7:
          begin
            AA := 0.0448;
            BB := 0.0251;
          end;
        8:
          begin
            AA := 0.106;
            BB := 0.247;
          end;
      end;
    K_HB := AA * sqr(Psi_bd) + BB * Psi_bd + 1;
      K_a := 495;
    if Nom_sx = 8 then
      T_He2 := 0.5 * T2
    else
      T_He2 := T2 / Zw;
    begin
      A_w := K_a * (U + 1) * power((1.15*K_HB*P1)/(Zw*0.4*U*sqr(Sigma_Flim01)),1/3); // добавить power
      If A_w > 2500 then
        Error := 4;
      If otw1 then
      begin
        Wibor(A_w, Aws, 32, IAw);
        aw := Aws[IAw];
      End
      else
        aw := A_w;
    end;
  END;
  Procedure Proced2;
  BEGIN
    Case Tipz of
      1:
        K_ma := 1400;
      2:
        K_ma := 1100;
      3:
        K_ma := 850;
    End;

    if Mn = 0 then
      //M_n := K_ma * T1 * (U + 1) * 3.5 / (aw * Psi_ba * aw * Sigma_Fp1);
      M_n := 2*aw/(z2+z1)
    else
      M_n := Mn;
    If M_n > 25 then
      Error := 5;
    // ближайший стандартный модуль, не превышающий расчетный,
    // чтобы зубчатая пара поместилась в межосевое расстояние
    Imn := 1;
    while (Imn < 41) and (ms[Imn + 1] <= M_n) do
      inc(Imn);
    if Imn < 5 then
      Imn := 5;
    Mn := ms[Imn];
  end;
  Procedure Proced0;
  var
    k: integer;
  BEGIN

    { Числа зубьев колес }
    z3 := Round(z1 * (U - 1));
    if z3 <= z1 + 1 then
    begin
      // передаточное число слишком мало для планетарной передачи
      Error := 7;
      Exit;
    end;
    z2 := Round(0.5 * (z3 - z1));
    // условие сборки: (z1 + z3) = 2 * (z1 + z2) должно делиться на Zw;
    // подбираем ближайшее подходящее z2
    if Zw > 1 then
      for k := 0 to Zw do
        if ((2 * (z1 + z2 + k)) mod Zw) = 0 then
        begin
          z2 := z2 + k;
          Break;
        end
        else if (z2 > k + 1) and (((2 * (z1 + z2 - k)) mod Zw) = 0) then
        begin
          z2 := z2 - k;
          Break;
        end;
    z3 := z1 + 2 * z2; // условие соосности
    z4 := Round((z3 - z1) / (1.4 + 1));
    z5 := Round((z1) * (U - 0.8));
    Uf := z1 / z2;
  end;
  Procedure Proced3;
  BEGIN
      if Mn * (z1 + z2) / (2 * Cos(Bet)) > aw + 1E-6 then
      begin
        Error := 20;
        Exit;
      end;
      if Bet > 0 then
        Bet := ArcCos((z1 + z2) * Mn / (2 * aw));
      if not otw1 then
        aw := 0.5 * (z1 + z2) * Mn / Cos(Bet);
      Dw1 :=Round(Mn*z1);
      Dw2 := Round(Mn*z2);
      Dw3 := Round(Mn*z3);
      Dw4 := Round(Mn*z4);
      Dw5 := Round(Mn*z5);
      Da1 := (2 + z1) * Mn / Cos(Bet);
      Da2 := (2 + z2) * Mn / Cos(Bet);
      Da3 := (2 + z3) * Mn / Cos(Bet);
      Da4 := (2 + z4) * Mn / Cos(Bet);
      Da5 := (2 + z5) * Mn / Cos(Bet);
      b2 := Round(Psi_ba * aw);
      b3 := Round(Psi_ba * aw);
      b4 := Round(Psi_ba * aw);
      b5 := Round(Psi_ba * aw);
      if (Tipz = 3) and (kanavka = 1) then
      begin
        if Round(Mn) < 2 then
          Bk := 15
        else if Round(Mn) in [2 .. 5] then
          Bk := 17 - Mn
        else
          Bk := 10;
        Bk := Round(Bk * Mn);
        b2 := b2 + Bk;
      end;
      If Tipz = 1 then
        if Mn < 16 then
          B1 := b2 + 5
        else
          B1 := Round(b2 + 0.3 * Mn)
      else
        B1 := b2;
    End;

BEGIN
  Psi_bd := 0.5 * Psi_ba * (U + 1);
  Proced0;
  if Error <> 0 then
    Exit;
  Case Metka of

    1:
      begin
        Proced1;
        Proced2;
        Proced3;
      end;
    2:
      begin
        Proced2;
        Proced3;
      end;
    3:
      Proced3;
  End;

end;

procedure CalculateCWheel.PzubC4;
{ }
var
  alfaa0, alfatw0, InwAtw, invAtw0, inwAt, xx1, xx2: Extended;
  Alfaat1: Array [1 .. 2] of Extended;
  s: array [1 .. 8] of byte;
  sa: array [1 .. 2] of Extended;
  xx: Array [1 .. 2] of Extended;
  k: byte;
  cm: Extended;
  f: Extended;
  Procedure Involuta(V: Extended; var al: Extended);
  var
    t, del: Extended;
    N: integer;
  Begin
    al := 1;
    N := 0;
    Repeat
      t := Tan(al);
      del := t - al - V;
      al := al - del / sqr(t);
      inc(N);
    Until (abs(del) < 1E-6) or (N > 50);
  End;

{ ========Проверка осуществимости передачи============================= }
  Function Ppe2: boolean;
  Var
    hg, xsmin, vaat, beta, Alfat, vat, dely, x1min, x2min, epsia,
      epsias: Extended;
    i: byte;
    H_HBp: array [1 .. 4] of integer;
    d, Da, db: array [1 .. 2] of Extended;
    { ========Определение радиуса кривизны переходной поверхности========= }
    Procedure Ppe6;
    Var
      v0, d, xmind, t, vat: Extended;
      M: Extended;
    Begin
      M := Mn;
      if motw[i] = 0 Then
      Begin
        z0[i] := 0;
        da0[i] := 0;
        x0[i] := 0;
        db0[i] := 0;
        d := M * z[i] / Cos(Bet);
        rol[i] := 0.5 * d * Sin(Alfat) / Cos(Bet) - (1 - xx[i]) * M /
          Sin(Alfat);
        xmin[i] := 1 - 0.5 * z[i] * sqr(Sin(Alfat)) / Cos(Bet);
      End;
      if motw[i] in [1, 2, 3, 4] then
      Begin
        vat := Tan(Alfat) - Alfat;
        v0 := (xx[i] + x0[i]) * 0.728 / (z[i] + z0[i]) + vat;
        Involuta(v0, alfatw0);
        alfaa0 := ArcCos(M * z0[i] * 0.9397 / (da0[i] * Cos(Bet)));
        aw0 := (z[i] + z0[i]) * M * Cos(Alfat) / (2 * Cos(Bet) * Cos(alfatw0));
        rol[i] := aw0 * Sin(alfatw0) - 0.5 * sqrt(sqr(da0[i]) - sqr(db0[i]));
        t := z0[i] * Tan(alfaa0) / (z[i] + z0[i]);
        xmin[i] := (t - ArcTan(t) - vat) * (z[i] + z0[i]) / 0.728 - x0[i];
      End;
      roa[i] := 0.5 * sqrt(Da[i] * Da[i] - db[i] * db[i]);
    End;

  Begin
    Ppe2 := True;
    Alfat := ArcTan(0.364 / Cos(Bet));
    vat := Tan(Alfat) - Alfat;
    Betb := ArcSin(0.9397 * Sin(Bet));
    hg := 0.45;
    if xs = 0 then
      dely := 0
    else
      dely := xs - (aw - a) / Mn;
    xx[1] := x1;
    xx[2] := x2;
    z[1] := z1;
    z[2] := z2;
    H_HBp[1] := H_HBp1;
    H_HBp[2] := H_HBp2;
    H_HBp[3] := H_HBp3;
    H_HBp[4] := H_HBp5;
    { проверка величины к-та суммарного смещения }
    xsmin := -vat * (z1 + z2) / 0.728;
    if xs - xsmin < 0 Then
    Begin
      Ppe2 := False;
      Exit;
    End;
    For i := 1 To 2 Do
    Begin
      { проверка заострения зуба на диаметре вершин }
      d[i] := Mn * z[i] / Cos(Bet);
      Da[i] := d[i] + 2 * Mn * (ha + xx[i] - dely);
      beta := ArcTan(Da[i] * Tan(Bet) / d[i]);
      db[i] := d[i] * Cos(Alfat);
      if Da[i] < db[i] Then
      Begin
        Ppe2 := False;
        Exit;
      End;
      Alfaat1[i] := ArcCos(db[i] / Da[i]);
      vaat := Tan(Alfaat1[i]) - Alfaat1[i];
      sa[i] := Da[i] * ((Pi / 2 + 0.728 * xx[i]) / z[i] + vat - vaat) / Mn *
        Cos(beta);
      if H_HBp[i] < 350 Then
      Begin
        if sa[i] < 0.4 Then
        Begin
          Ppe2 := False;
          Exit;
        End;
      End
      Else if sa[i] < 0.25 Then
      Begin
        Ppe2 := False;
        Exit;
      End;
      { проверка подрезания ножки зуба }
      Ppe6;
      if xx[i] - xmin[i] < 0 Then
      Begin
        Ppe2 := False;
        Exit;
      End;
      { проверка соотношения da и db }
      if (Da[i] - db[i]) / (2 * Mn) < 0 Then
      Begin
        Ppe2 := False;
        Exit;
      End;
      { проверка черезмерного срезания головки зуба ножкой  долбяка }
      if z0[i] <> 0 Then
      Begin
        beta := ArcTan(Da[i] * Sin(Bet) / (d[i] * Cos(Bet)));
        if (sqrt(sqr(db[i]) + sqr(2 * aw0 * Sin(alfatw0))) + hg * Mn / Cos(beta)
          - Da[i]) < 0 Then
        Begin
          Ppe2 := False;
          Exit;
        End;
      End;
    End;
    { Проверка к-та перекрытия }
    epsia := (z1 * (Tan(Alfaat1[1]) - Tan(alfatw)) + z2 *
      (Tan(Alfaat1[2]) - Tan(alfatw))) / (2 * Pi);
    epsias := epsia;
    if Bet > 0 Then
      case Tipz of
        1:
          epsias := epsia + bw * Sin(Bet) / Pi / Mn;
        2, 3:
          epsias := epsia + 0.5 * bw * Sin(Bet) / Pi / Mn;
      end;
    if epsia < 1.2 Then
    Begin
      Ppe2 := False;
      Exit;
    End;
    { проверка интерференции }
    rop[1] := aw * Sin(alfatw) - 0.5 * sqrt(Da[2] * Da[2] - db[2] * db[2]);
    rop[2] := aw * Sin(alfatw) - 0.5 * sqrt(Da[1] * Da[1] - db[1] * db[1]);
    if rop[1] - rol[1] < 0 Then
    Begin
      Ppe2 := False;
      Exit;
    End;
    if rop[2] - rol[2] < 0 Then
    Begin
      Ppe2 := False;
      Exit;
    End;
    x1min := xmin[1];
    x2min := xmin[2];
    { удельное скольжение }
    tet2 := Tan(alfatw);
    tet1 := -(z2 / z1 + 1) * (Tan(Alfaat1[2]) - tet2) /
      (tet2 - z2 * (Tan(Alfaat1[1]) - tet2) / z1);
    tet2 := -(z2 / z1 + 1) * (Tan(Alfaat1[1]) - tet2) /
      (z2 * tet2 / z1 - (Tan(Alfaat1[1]) - tet2));
  End;

{ ==================Расчет обобщенного критерия оптимизации==================== }
  Procedure Ppe14;
  Var
    cr: array [1 .. 3] of Extended;
    j: integer;
    { ------------------------------ }
  Begin
    s[1] := 1;
    s[2] := 1;
    s[3] := 1;
    cr[1] := -epsias;
    cr[2] := abs(3.47 + 13.2 / z1 * Exp(3 * Ln(Cos(Bet))) - Sigma_Flim01 /
      Sigma_Flim02 * (3.47 + 13.2 / z2 * Exp(3 * Ln(Cos(Bet)))));
    cr[3] := abs(tet2 - tet1);

    f := 0;
    For j := 1 To 3 Do
      f := f + s[j] * cr[j];
  End;

{ ------------------------------------------------------ }
BEGIN
  bw := b2;
  Alfat := ArcTan(0.364 / Cos(Bet));
  if Bet = 0 then
    Zmin := 17
  else
    Zmin := Round(2 * Cos(Bet) / sqr(Sin(Alfat)));
  alfatw := Alfat;
  { Проверка межосевого расстояния }
  a := Mn * (z1 + z2) / (2 * Cos(Bet));
  { 1 } if not(abs(aw - a) > 1.0E-5) then
  begin
    { Проверка подрезания }
    { 2 } If z1 < Zmin then
    Begin
      If motw[1] = 0 then
      begin
        if Bet = 0 then
          x1min := 1 - z1 * sqr(0.342) / 2
        else
          x1min := 1 - z1 * sqr(Sin(Alfat)) / (2 * Cos(Bet));
      end;
      If motw[1] in [1 .. 4] then
      begin
        alfaa0 := ArcCos(Mn * z[1] / Cos(Bet) * 0.9397 / (da0[1] * Cos(Bet)));
        alfatw0 := ArcTan(z0[1] * Tan(alfaa0) / (z1 * (1 + z0[1] / z1)));
        invAtw0 := Tan(alfatw0) - alfatw0;
        inwAt := Tan(Alfat) - Alfat;
        x1min := (invAtw0 - inwAt) * (z1 - z0[1]) / 0.728;
      end;
      x1 := x1min;
      x2 := -x1;
      xs := 0;
      alfatw := Alfat;
      if not Ppe2 then
        Error := 6;
      { 2 } end
    { 3 } else
    begin
      x1 := 0;
      x2 := 0;
      alfatw := Alfat;
      { 3 } end;
    { 1 } end
  { 4 } Else
  begin
    if a < aw * 1.024 then
    begin
      alfatw := ArcCos(0.5 * Mn * (z1 + z2) * Cos(Alfat) / (aw * Cos(Bet)));
      InwAtw := Tan(alfatw) - alfatw;
      inwAt := Tan(Alfat) - Alfat;
      xs := (InwAtw - inwAt) * (z1 + z2) / 0.728;
    end;
    x1 := -1;
    xx1 := -2;
    cm := 1E10;
    For k := 1 to 101 Do
    BEGIN
      x2 := xs - x1;
      if Ppe2 then
      begin
        Ppe14;
        if xx1 = -2 then
        begin
          xx1 := x1;
          xx2 := x2;
          cm := f;
        end;
        if cm > f then
        begin
          xx1 := x1;
          xx2 := x2;
          cm := f;
        end;
      end;
      x1 := x1 + 0.03;
    End;
    if xx1 > -2 then
    begin
      x1 := xx1;
      x2 := xx2;
      f := cm;
    end;
    { 4 } END;
end; { Конец PzubC4 }

procedure CalculateCWheel.PzubC5;

Type
  TT1 = array [1 .. 5, 1 .. 7] of Extended;
Var
  C_prim, f_pb, K_Hv, K_Hbeta, K_Halfa, g0, Epsia1, Epsia2, Z_v1, Z_v2, n_alfa,
    n_beta, y_alfa: Extended;
Begin
  PrSigH;
  PrSigF(z1, x1, Sigma_F1, Sigma_Fmax1);
  PrSigF(z2, x2, Sigma_F2, Sigma_Fmax2);
  PrSigF(z3, x2, Sigma_F3, Sigma_Fmax3);
  PrSigF(z5, x2, Sigma_F5, Sigma_Fmax5);
END;

procedure CalculateCWheel.PzubC6;
Var
  invAlfatw0: Extended;
  dely: Extended;
  i: byte;
BEGIN
  Alfat := ArcTan(0.364 / Cos(Bet));
  d1 := Mn * z1 / Cos(Bet);
  d2 := Mn * z2 / Cos(Bet);
  d3 := Mn * z3 / Cos(Bet);
  d4 := Mn * z4 / Cos(Bet);
  d5 := Mn * z5 / Cos(Bet);

  //Dw1 := 2 * aw / (Uf + 1);
  //Dw2 := 2 * aw - Dw1;
  a := 0.5 * (d1 + d2);
  if x1 + x2 = 0 then
    dely := 0
  else
    dely := (x1 + x2) - (aw - a) / Mn;
  //Da1 := d1 + 2 * Mn * (1 + x1 - dely);
  //Da2 := d2 + 2 * Mn * (1 + x2 - dely);
  db1 := d1 * Cos(Alfat);
  db2 := d2 * Cos(Alfat);
  db3 := d3 * Cos(Alfat);
  db5 := d5 * Cos(Alfat);
  x[1] := x1;
  x[2] := x2;
  z[1] := z1;
  z[2] := z2;
  For i := 1 to 2 Do
  begin
    If motw[i] = 0 then
    begin
      Df1 := d1 - 2 * Mn * (1 + c_ - x1);
      Df2 := d2 - 2 * Mn * (1 + c_ - x1);
      Df3 := d3 - 2 * Mn * (1 + c_ - x1);
      Df4 := d4 - 2 * Mn * (1 + c_ - x1);
      Df5 := d5 - 2 * Mn * (1 + c_ - x1);
    End
    else
    begin
      invAlfatw0 := (x[i] + x0[i]) / (z[i] + z0[i]) * 0.728 +
        (0.364 - 20 * Pi / 180);
      Involuta(invAlfatw0, alfatw0);
      aw0 := Mn * (z[i] + z0[i]) / 2 * Cos(Alfat) / (Cos(alfatw0) * Cos(Bet));
      Df1 := 2 * aw0 - da0[1];
      Df2 := 2 * aw0 - da0[2];
      Df3 := 2 * aw0 - da0[3];
      Df4 := 2 * aw0 - da0[4];
      Df5 := 2 * aw0 - da0[5];
    End;
  end;
END; { Конец PzubC6 }

procedure CalculateCWheel.PzubC8;
BEGIN

  Ft1 := 2 * T2 * 1000 / (Dw3 * Zw);
  if Nom_sx = 8 then
    Ft1 := Ft1 / 2;
  Ft2 := Ft1;
  Fr1 := Ft2 * Tan(Alfat);
  Fr2 := Fr1;
  Fx1 := Ft2 * Tan(Bet);
  Fv := sqrt(sqr(Ft1) + sqr(Fr1));
  Fx2 := Fx1;

END; { Конец    PzubC8 }

procedure CalculateCWheel.Wibor(a: Extended; b: TT1; N: byte; var Iw: byte);
// label 1;
var
  i: integer;
BEGIN
  // выбор ближайшего стандартного значения, не меньшего a
  // (таблица b упорядочена по возрастанию)
  Iw := N;
  for i := 1 to N do
    if b[i] >= a then
    begin
      Iw := i;
      Exit;
    end;
END;


procedure CalculateCWheel.wiborTerm(mc: TSteelMark;
  var ArTermobr: ArrayTermobr);
begin
  if mc = '12ХН2 ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '12ХН3А ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '12Х2Н4А ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '15ХГНТА ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '18ХГТ ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '18Х2Н4ВА ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '20Х ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '20ХН ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '20ХН2М ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '20ХН3А ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '20Х2Н4А ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '20ХГР ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;

  if mc = '25ХГТМА ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '30ХГТ ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 5;
  end;
  if mc = '25ХГМ ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 6;
  end;
  if mc = '25ХГТ ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 6;
  end;
  if mc = '20ХН3А ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 6;
  end;
  if mc = '35ХМ ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 4;
  end;
  if mc = '40 ГОСТ 1050-74' then
  begin
    ArTermobr[1] := 1;
    ArTermobr[2] := 2;
  end;
  if mc = '40Х ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 1;
    ArTermobr[2] := 2;
    ArTermobr[3] := 3;
    ArTermobr[4] := 4;
  end;
  if mc = '40ХН ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 1;
    ArTermobr[2] := 2;
    ArTermobr[3] := 3;
    ArTermobr[4] := 4;
  end;
  if mc = '40ХФА ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 1;
    ArTermobr[2] := 2;
    ArTermobr[3] := 3;
  end;
  if mc = '40ХН2МА ГОСТ 4543-71' then
  begin
    ArTermobr[1] := 1;
    ArTermobr[2] := 2;
    ArTermobr[3] := 3;
    ArTermobr[4] := 4;
  end;
  if mc = '45 ГОСТ 1050-74' then
  begin
    ArTermobr[1] := 1;
    ArTermobr[2] := 2;
  end;
  if mc = '50ХН ГОСТ 1050-74' then
  begin
    ArTermobr[1] := 3;
  end;

end;

end.
