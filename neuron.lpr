program main;
{$mode objfpc}{$H+}

uses
Classes, sysutils;

type

  { Neuron }

  Neuron = class
    private
      weight: single;
    public
      LastError, Smoothing: single;
      constructor Create();
      function ProcessInputData(input: single): single;
      function relu(x: single): single;
      function RestoreInputData(output: single): single;
      function Train(input, expectedResult: single): single;
      function get_weight(): single;
  end;

{ Neuron }

constructor Neuron.Create();
begin
  weight := 0.5;
  Smoothing := 0.0001;
end;

function Neuron.ProcessInputData(input: single): single;
begin
  Result := input * weight;
end;

function Neuron.relu(x: single): single;
begin
  if x > 0 then Result := x
  else Result := 0;
end;

function Neuron.RestoreInputData(output: single): single;
begin
  Result := output / weight;
end;

function Neuron.Train(input, expectedResult: single): single;
var
  state, actualResult, correction: single;
begin
  state := ProcessInputData(input);
  actualResult := relu(state);
  LastError := expectedResult - actualResult;
  correction := LastError * Smoothing;
  weight += correction;
  Result := LastError;
end;

function Neuron.get_weight(): single;
begin
  Result := weight;
end;


var
  km, miles, e: single;
  i: integer;
  _neuron: Neuron;
begin
  km := 100;
  miles := 62.1371;
  e := 0;
  i := 0;
  _neuron := Neuron.Create;

  while True do
  begin
    e := 0;
    i += 1;
    e := _neuron.Train(km, miles);
    e := abs(e);
    writeln(Format('Итерация: %d Ошибка: %f', [i, e]));
    if e < 0.01 then break;
  end;
  writeln('Обучение завершено!');
  writeln(Format('Вес: %f', [_neuron.get_weight()]));

  while True do
  begin
    write('Введите расстояние в км:');
    readln(km);
    if (km = 0.0) or (km = -1) then break;
    writeln(Format('%f миль в %f км', [_neuron.ProcessInputData(km), km]));
  end;

  _neuron.Free;
end.

