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

initialization
  RegisterTest(TInt128_TestCase.Suite);
end.
