unit int128impl;

interface

type
  // https://forum.lazarus.freepascal.org/index.php/topic,17273.15.html
  Int128 = packed record
  private
    class procedure DivMod128(const Value1: Int128; const Value2: Int128;
        out DivResult: Int128; out Remainder: Int128); static;
    class procedure Inc128(var Value: Int128); static;
    class procedure SetBit128(var Value: Int128; numBit: integer); static;
    function Invert: Int128;
  public
    class operator Add(a, b: Int128): Int128;
    class operator Equal(a, b: Int128): Boolean;
    class operator GreaterThan(a, b: Int128): Boolean;
    class operator GreaterThanOrEqual(a, b: Int128): Boolean;
    class operator Implicit(Value: Int8): Int128;
    class operator Implicit(Value: UInt8): Int128;
    class operator Implicit(Value: Int16): Int128;
    class operator Implicit(Value: UInt16): Int128;
    class operator Implicit(Value: Int32): Int128;
    class operator Implicit(Value: UInt32): Int128;
    class operator Implicit(Value: Int64): Int128;
    class operator Implicit(Value: UInt64): Int128;
    class operator Implicit(Value: Int128): string;
    class operator LeftShift(Value: Int128; Shift: Integer): Int128;
    class operator LeftShift(Value, Shift: Int128): Int128;
    class operator LessThan(a, b: Int128): Boolean;
    class operator LessThanOrEqual(a, b: Int128): Boolean;
    class operator LogicalNot(Value: Int128): Int128;
    class operator Multiply(a, b: Int128): Int128;
    class operator NotEqual(a, b: Int128): Boolean;
    class operator RightShift(Value: Int128; Shift: Integer): Int128;
    class operator RightShift(Value, Shift: Int128): Int128;
    class operator Subtract(a, b: Int128): Int128;
  strict private
    case Byte of
      0: (sb: packed array[0..15] of UInt8);
      1: (db: packed array[0..7] of UInt16);
      2: (dw0, dw1, dw2, dw3: UInt32);
      3: (dw: packed array[0..3] of UInt32);
      4: (dc0, dc1: UInt64);
      5: (dc: packed array[0..1] of UInt64);
  end;

implementation

uses System.SysUtils;

class procedure Int128.DivMod128(const Value1: Int128; const Value2: Int128;
    out DivResult: Int128; out Remainder: Int128);
var curShift: integer;
    sub: Int128;
begin
  if Value2 = 0 then raise Exception.Create('DivMod128: div by zero');
  if Value2 = 1 then begin
    DivResult := Value1;
    Remainder := 0;
    Exit;
  end;
  sub := Value2;
  Remainder := Value1;
  DivResult := 0;

  curShift := 0;
  while (sub.dw3 and $80000000 = 0) and (sub < Remainder) do begin
    sub := sub shl 1;
    inc(curShift);
    if (sub > Remainder) then begin
      sub := sub shr 1;
      dec(curShift);
      break;
    end;
  end;

  while True do begin
    if sub <= Remainder then
    begin
      Remainder := Remainder - sub;
      SetBit128(DivResult, curShift);
    end;
    if curShift > 0 then begin
      sub := sub shr 1;
      dec(curShift);
    end else
      break;
  end;
end;

class procedure Int128.Inc128(var Value: Int128);
begin
  if Value.dw0 <> $ffffffff then Inc(Value.dw0) else begin
    Value.dw0 := 0;
    if Value.dw1 <> $ffffffff then Inc(Value.dw1) else begin
      Value.dw1 := 0;
      if Value.dw2 <> $ffffffff then Inc(Value.dw2) else begin
        Value.dw2 := 0;
        if Value.dw3 <> $ffffffff then Inc(Value.dw3) else
          Value.dw3 := 0;
      end;
    end;
  end;
end;

class procedure Int128.SetBit128(var Value: Int128; numBit: integer);
begin
  Value.dw[numBit shr 5] := Value.dw[numBit shr 5] or longword(1 shl (numBit and 31));
end;

function Int128.Invert: Int128;
begin
  Result.dc0 := Self.dc0 xor $FFFFFFFFFFFFFFFF;
  Result.dc1 := Self.dc1 xor $FFFFFFFFFFFFFFFF;
end;

class operator Int128.Add(a, b: Int128): Int128;
var qw: UInt64;
    c0, c1, c2: Boolean;

  procedure inc3;
  begin
    if Result.dw3 = $ffffffff then
    begin
      Result.dw3 := 0;
    end else
      Inc(Result.dw3);
  end;

  procedure inc2;
  begin
    if Result.dw2 = $ffffffff then
    begin
      Result.dw2 := 0;
      inc3;
    end else
      Inc(Result.dw2);
  end;

  procedure inc1;
  begin
    if Result.dw1 = $ffffffff then
    begin
      Result.dw1 := 0;
      inc2;
    end else
      Inc(Result.dw1);
  end;

begin
  qw := UInt64(a.dw0) + UInt64(b.dw0);
  Result.dw0 := qw and $ffffffff;
  c0 := (qw shr 32) = 1;

  qw := UInt64(a.dw1) + UInt64(b.dw1);
  Result.dw1 := qw and $ffffffff;
  c1 := (qw shr 32) = 1;

  qw := UInt64(a.dw2) + UInt64(b.dw2);
  Result.dw2 := qw and $ffffffff;
  c2 := (qw shr 32) = 1;

  qw := UInt64(a.dw3) + UInt64(b.dw3);
  Result.dw3 := qw and $ffffffff;

  if c0 then inc1;
  if c1 then inc2;
  if c2 then inc3;
end;

class operator Int128.Equal(a, b: Int128): Boolean;
begin
  Result := (a.dw0 = b.dw0) and (a.dw1 = b.dw1) and (a.dw2 = b.dw2) and (a.dw3 = b.dw3);
end;

class operator Int128.GreaterThan(a, b: Int128): Boolean;
begin
  if a.dw3 > b.dw3 then Result := True
  else if a.dw3 < b.dw3 then Result := False
  else if a.dw2 > b.dw2 then Result := True
  else if a.dw2 < b.dw2 then Result := False
  else if a.dw1 > b.dw1 then Result := True
  else if a.dw1 < b.dw1 then Result := False
  else if a.dw0 > b.dw0 then Result := True
  else Result := False;
end;

class operator Int128.GreaterThanOrEqual(a, b: Int128): Boolean;
begin
  Result := (a = b) or (a > b);
end;

class operator Int128.Implicit(Value: Int8): Int128;
begin
  var Sign: Byte := 0;
  Result.sb[0] := Value;
  if Value < 0 then Sign := $FF;

  FillChar(Result.sb[1], SizeOf(Result) - SizeOf(Result.sb[0]), Sign);
end;

class operator Int128.Implicit(Value: UInt8): Int128;
begin
  Result.sb[0] := Value;
  FillChar(Result.sb[1], SizeOf(Result) - SizeOf(Result.sb[0]), 0);
end;

class operator Int128.Implicit(Value: Int16): Int128;
begin
  var Sign: Byte := 0;
  Result.db[0] := Value;
  if Value < 0 then Sign := $FF;

  FillChar(Result.db[1], SizeOf(Result) - SizeOf(Result.db[0]), Sign);
end;

class operator Int128.Implicit(Value: UInt16): Int128;
begin
  Result.db[0] := Value;
  FillChar(Result.db[1], SizeOf(Result) - SizeOf(Result.db[0]), 0);
end;

class operator Int128.Implicit(Value: Int32): Int128;
begin
  var Sign: Byte := 0;
  Result.dw[0] := Value;
  if Value < 0 then Sign := $FF;

  FillChar(Result.dw[1], SizeOf(Result) - SizeOf(Result.dw[0]), Sign);
end;

class operator Int128.Implicit(Value: UInt32): Int128;
begin
  Result.dw[0] := Value;
  FillChar(Result.dw[1], SizeOf(Result) - SizeOf(Result.dw[0]), 0);
end;

class operator Int128.Implicit(Value: Int64): Int128;
begin
  var Sign: Byte := 0;
  Result.dc[0] := Value;
  if Value < 0 then Sign := $FF;

  FillChar(Result.dc[1], SizeOf(Result) - SizeOf(Result.dc[0]), Sign);
end;

class operator Int128.Implicit(Value: UInt64): Int128;
begin
  Result.dc0 := Value;
  Result.dc1 := 0;
end;

class operator Int128.Implicit(Value: Int128): string;
var digit, curValue, nextValue, ten: Int128;
    Neg: Boolean;
begin
  Result := '';
  ten := 10;
  if Value.sb[15] shr 7 = 1 then begin
    curValue := Value.Invert + 1;
    Neg := True;
  end else begin
    curValue := Value;
    Neg := False;
  end;
  while CurValue <> 0 do begin
    DivMod128(CurValue, ten, nextValue, digit);
    Result := Chr(Ord('0') + digit.dw0) + Result;
    curValue := NextValue;
  end;
  if Result = '' then Result := '0';
  if Neg then Result := '-' + Result;
end;

class operator Int128.LeftShift(Value: Int128; Shift: Integer): Int128;
begin
  if Shift >= 128 then
    Result := 0
  else if Shift >= 64 then begin
    Result.dw2 := Value.dw0;
    Result.dw3 := Value.dw1;
    Result.dw1 := 0;
    Result.dw0 := 0;
    Result := Result shl (Shift - 64);
  end else if Shift >= 32 then begin
    Result.dw3 := Value.dw2;
    Result.dw2 := Value.dw1;
    Result.dw1 := Value.dw0;
    Result.dw0 := 0;
    Result := Result shl (Shift - 32);
  end else if Shift = 0 then
    Result := Value
  else if Shift < 0 then
    Result := Value shr (-shift)
  else begin
    Result.dw3 := (Value.dw3 shl Shift) or (Value.dw2 shr (32-shift));
    Result.dw2 := (Value.dw2 shl Shift) or (Value.dw1 shr (32-shift));
    Result.dw1 := (Value.dw1 shl Shift) or (Value.dw0 shr (32-shift));
    Result.dw0 := (Value.dw0 shl Shift);
  end;
end;

class operator Int128.LeftShift(Value, Shift: Int128): Int128;
begin
  if (Shift.dw0 > 128) or (Shift.dw1 <> 0) or (Shift.dw2 <> 0) or (Shift.dw3 <> 0) then
    Result := 0
  else
    Result := Value shl Shift.dw0;
end;

class operator Int128.LessThan(a, b: Int128): Boolean;
begin
  if a.dw3 < b.dw3 then Result := True
  else if a.dw3 > b.dw3 then Result := False
  else if a.dw2 < b.dw2 then Result := True
  else if a.dw2 > b.dw2 then Result := False
  else if a.dw1 < b.dw1 then Result := True
  else if a.dw1 > b.dw1 then Result := False
  else if a.dw0 < b.dw0 then Result := True
  else Result := False;
end;

class operator Int128.LessThanOrEqual(a, b: Int128): Boolean;
begin
  Result := (a = b) or (a < b);
end;

class operator Int128.LogicalNot(Value: Int128): Int128;
begin
  Result.dw0 := not Value.dw0;
  Result.dw1 := not Value.dw1;
  Result.dw2 := not Value.dw2;
  Result.dw3 := not Value.dw3;
end;

class operator Int128.Multiply(a, b: Int128): Int128;
var qw: UInt64;
    v: Int128;
begin
  qw := UInt64(a.dw0) * UInt64(b.dw0);
  Result.dw0 := qw and $ffffffff;
  Result.dw1 := qw shr 32;
  Result.dw2 := 0;
  Result.dw3 := 0;

  qw := UInt64(a.dw0) * UInt64(b.dw1);
  v.dw0 := 0;
  v.dw1 := qw and $ffffffff;
  v.dw2 := qw shr 32;
  v.dw3 := 0;
  Result := Result + v;

  qw := UInt64(a.dw1) * UInt64(b.dw0);
  v.dw0 := 0;
  v.dw1 := qw and $ffffffff;
  v.dw2 := qw shr 32;
  v.dw3 := 0;
  Result := Result + v;

  qw := UInt64(a.dw0) * UInt64(b.dw2);
  v.dw0 := 0;
  v.dw1 := 0;
  v.dw2 := qw and $ffffffff;
  v.dw3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.dw1) * UInt64(b.dw1);
  v.dw0 := 0;
  v.dw1 := 0;
  v.dw2 := qw and $ffffffff;
  v.dw3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.dw2) * UInt64(b.dw0);
  v.dw0 := 0;
  v.dw1 := 0;
  v.dw2 := qw and $ffffffff;
  v.dw3 := qw shr 32;
  Result := Result + v;

  qw := UInt64(a.dw0) * UInt64(b.dw3);
  v.dw0 := 0;
  v.dw1 := 0;
  v.dw2 := 0;
  v.dw3 := qw and $ffffffff;
  Result := Result + v;

  qw := UInt64(a.dw1) * UInt64(b.dw2);
  v.dw0 := 0;
  v.dw1 := 0;
  v.dw2 := 0;
  v.dw3 := qw and $ffffffff;
  Result := Result + v;

  qw := UInt64(a.dw2) * UInt64(b.dw1);
  v.dw0 := 0;
  v.dw1 := 0;
  v.dw2 := 0;
  v.dw3 := qw and $ffffffff;
  Result := Result + v;

  qw := UInt64(a.dw3) * UInt64(b.dw0);
  v.dw0 := 0;
  v.dw1 := 0;
  v.dw2 := 0;
  v.dw3 := qw and $ffffffff;
  Result := Result + v;
end;

class operator Int128.NotEqual(a, b: Int128): Boolean;
begin
  Result := not (a = b);
end;

class operator Int128.RightShift(Value: Int128; Shift: Integer): Int128;
begin
  if Shift >= 128 then
    Result := 0
  else if Shift >= 64 then
  begin
    Result.dw0 := Value.dw2;
    Result.dw1 := Value.dw3;
    Result.dw2 := 0;
    Result.dw3 := 0;
    Result := Result shr (Shift - 64);
  end else if Shift >= 32 then
  begin
    Result.dw0 := Value.dw1;
    Result.dw1 := Value.dw2;
    Result.dw2 := Value.dw3;
    Result.dw3 := 0;
    Result := Result shr (Shift - 32);
  end else if Shift = 0 then
    Result := Value else
  if Shift < 0 then
    Result := Value shl (-shift)
  else
  begin
    Result.dw0 := (Value.dw0 shr Shift) or (Value.dw1 shl (32-shift));
    Result.dw1 := (Value.dw1 shr Shift) or (Value.dw2 shl (32-shift));
    Result.dw2 := (Value.dw2 shr Shift) or (Value.dw3 shl (32-shift));
    Result.dw3 := (Value.dw3 shr Shift);
  end;
end;

class operator Int128.RightShift(Value, Shift: Int128): Int128;
begin
  if (Shift.dw0 > 128) or (Shift.dw1 <> 0) or (Shift.dw2 <> 0)
    or (Shift.dw3 <> 0) then Result := 0 else
    Result := Value shr Shift.dw0;
end;

class operator Int128.Subtract(a, b: Int128): Int128;
var c: Int128;
begin
  c := not b;
  Inc128(c);
  Result := a + c;
end;

end.
