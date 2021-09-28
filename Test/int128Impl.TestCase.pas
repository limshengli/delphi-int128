unit int128Impl.TestCase;

interface

uses TestFramework;

type
  TInt128_TestCase = class(TTestCase)
  published
    procedure Size;
    procedure Test_Int8;
    procedure Test_UInt8;
    procedure Test_Int16;
    procedure Test_UInt16;
    procedure Test_Int32;
    procedure Test_UInt32;
    procedure Test_Int64;
    procedure Test_UInt64;
    procedure Test_Int128;
    procedure Test_String_Convert;
    procedure Test_Addition;
    procedure Test_Subtraction;
    procedure Test_Multiplication;
    procedure Test_Division;
    procedure Test_Left_Shift;
    procedure Test_Right_Shift;
    procedure Test_Modulus;
    procedure Test_Less_Than;
    procedure Test_Greater_Than;
  end;

implementation

uses int128impl;

procedure TInt128_TestCase.Size;
begin
  CheckEquals(16, SizeOf(Int128));
end;

procedure TInt128_TestCase.Test_Int8;
begin
  var A: Int128;
  A := Low(Int8);
  CheckEquals('-128', A);

  A := -1;
  CheckEquals('-1', A);

  A := -127;
  CheckEquals('-127', A);

  A := 126;
  CheckEquals('126', A);

  A := High(Int8);
  CheckEquals('127', A);
end;

procedure TInt128_TestCase.Test_UInt8;
begin
  var A: Int128;
  A := Low(UInt8);
  CheckEquals('0', A);

  A := High(UInt8);
  CheckEquals('255', A);
end;

procedure TInt128_TestCase.Test_Int16;
begin
  var A: Int128;
  A := Low(Int16);
  CheckEquals('-32768', A);

  A := -32767;
  CheckEquals('-32767', A);

  A := 32766;
  CheckEquals('32766', A);

  A := High(Int16);
  CheckEquals('32767', A);
end;

procedure TInt128_TestCase.Test_UInt16;
begin
  var A: Int128;
  A := Low(UInt16);
  CheckEquals('0', A);

  A := 65534;
  CheckEquals('65534', A);

  A := High(UInt16);
  CheckEquals('65535', A);
end;

procedure TInt128_TestCase.Test_Int32;
begin
  var A: Int128;
  A := Low(Int32);
  CheckEquals('-2147483648', A);

  A := -2147483647;
  CheckEquals('-2147483647', A);

  A := 2147483646;
  CheckEquals('2147483646', A);

  A := High(Int32);
  CheckEquals('2147483647', A);
end;

procedure TInt128_TestCase.Test_UInt32;
begin
  var A: Int128;
  A := Low(UInt32);
  CheckEquals('0', A);

  A := 4294967294;
  CheckEquals('4294967294', A);

  A := High(UInt32);
  CheckEquals('4294967295', A);
end;

procedure TInt128_TestCase.Test_Int64;
begin
  var A: Int128;
  A := Low(Int64);
  CheckEquals('-9223372036854775808', A);

  A := -9223372036854775807;
  CheckEquals('-9223372036854775807', A);

  A := 9223372036854775807;
  CheckEquals('9223372036854775807', A);

  A := High(Int64);
  CheckEquals('9223372036854775807', A);
end;

procedure TInt128_TestCase.Test_UInt64;
begin
  var A: Int128;
  A := Low(UInt64);
  CheckEquals('0', A);

  A := 18446744073709551614;
  CheckEquals('18446744073709551614', A);

  A := High(UInt64);
  CheckEquals('18446744073709551615', A);
end;

procedure TInt128_TestCase.Test_Int128;
begin
  var A, B: Int128;
  A := High(UInt64);
  A := A + High(UInt64);
  CheckEquals('36893488147419103230', A);

  A := High(UInt64) shr 1;
  A := A * High(UInt64);
  CheckEquals('170141183460469231704017187605319778305', A);
end;

procedure TInt128_TestCase.Test_String_Convert;
begin
  var A: Int128;

  A := Int128('-3544231');
  CheckEquals('-3544231', A);
  CheckTrue(A = Int128('-3544231'));

  A := Int128('41684684167684656548645814468');
  CheckEquals('41684684167684656548645814468', A);
  CheckTrue(A = Int128('41684684167684656548645814468'));

  A := Int128('-5465846554342544511323446554342136574');
  CheckEquals('-5465846554342544511323446554342136574', A);
  CheckFalse(A = Int128('-5465846554342544511323446554342136573'));

  A := Int128('5686');
  CheckEquals('5686', A);
  CheckFalse(A = Int128('-566'));
end;

procedure TInt128_TestCase.Test_Addition;
begin
  var A, B: Int128;
  A := Int128('2514468541324685313585343515684');
  B := Int128('5231458413545231584365135435132');

  A := A + B;
  CheckEquals('7745926954869916897950478950816', A);

  B := Int128('-546841354751434768845435113558');
  A := B + A;
  CheckEquals('7199085600118482129105043837258', A);
end;

procedure TInt128_TestCase.Test_Subtraction;
begin
  var A, B: Int128;
  A := Int128('5436854135856841354184345341532435123');
  B := Int128('5634468412534683453548654135154685433');

  A := A - B;
  CheckEquals('-197614276677842099364308793622250310', A);

  B := Int128('6546854355185413546841514354685431');
  A := B - A;
  CheckEquals('204161131033027512911150307976935741', A);
end;

procedure TInt128_TestCase.Test_Multiplication;
begin
  var A: Int128;
  A := Int128('3564643518354354134854163485');

  A := A * 398;
  CheckEquals('1418728120305032945671957067030', A);

  A := A * -9536;
  CheckEquals('-13528991355228794169927782591198080', A);
end;

procedure TInt128_TestCase.Test_Division;
begin
  var A: Int128;
  A := Int128('54168545353251854354351545464685485554');

  A := A div 5468945;
  CheckEquals('9904752260856866242822252822927', A);

  A := A div 5959;
  CheckEquals('1662150068947284148820649911', A);

  A := A div -100;
  CheckEquals('-16621500689472841488206500', A);
end;

procedure TInt128_TestCase.Test_Left_Shift;
var C: Int128;
begin
  C := Int128(123) shl 100;
  CheckEquals('155921023828072216384094494261248', C);

  C := Int128(-1234) shl 40;
  CheckEquals('-1356797348675584', C);

  C := Int128('534534684685') shl 3;
  CheckEquals('4276277477480', C);

//  C := Int128(123) shl -1;
//  CheckEquals('61', C);
//
//  C := Int128(123) shl -100;
//  CheckEquals('0', C);

  C := Int128(19632) shl 128;
  CheckEquals('0', C);

//  C := Int128('-123548689745632458638471127834758368') shl -100;
//  CheckEquals('-97462', C);
end;

procedure TInt128_TestCase.Test_Right_Shift;
var C: Int128;
begin
  C := Int128('125794368745377835274623412345424') shr 100;
  CheckEquals('99', C);

  C := Int128('1257943687453778352746') shr 38;
  CheckEquals('4576372475', C);

  C := Int128('1257943687453778352746') shr 5;
  CheckEquals('39310740232930573523', C);

  C := Int128(-100) shr 1;
  CheckEquals('-50', C);

//  C := Int128(5566) shr -96;
//  CheckEquals('440983952554395303045665627570176', C);

  C := Int128(51681) shr 128;
  CheckEquals('0', C);

//  C := Int128(-123) shr -100;
//  CheckEquals('-155921023828072216384094494261248', C);
end;

procedure TInt128_TestCase.Test_Modulus;
var A: Int128;
begin
  A := Int128('356478543547684735413847686485341');
  A := A mod 54685466;
  CheckEquals('12345495', A);

  A := Int128('35846854351638685354684365');
  A := A mod 354654;
  CheckEquals('101013', A);
end;

procedure TInt128_TestCase.Test_Less_Than;
begin
  var A := Int128('523216854135135468461354685314');
  var B := Int128('-546854135847865413548435453435');
  CheckTrue(B < A);
  CheckFalse(A < B);

  B := Int128('534584135413543136541351');
  CheckTrue(B < A);
  CheckFalse(A < B);
end;

procedure TInt128_TestCase.Test_Greater_Than;
begin
  var A := Int128('86415374685435153748614385455744441');
  var B := Int128('5343513218541513354468435135843658');
  CheckTrue(A > B);
  CheckFalse(B > A);

  B := Int128('-545613546854135213854765332158132106');
  CheckTrue(A > B);
  CheckFalse(B > A);
end;

initialization
  RegisterTest(TInt128_TestCase.Suite);
end.
