program kmeans;
uses Crt, SysUtils;

var
  X: array [0..149, 0..1] of real;
  Centroids, sums: array [0..2, 0..1] of real;
  pointClass, prevClass: array [0..149] of integer;
  counts: array [0..2] of integer;
  i, j, iterCount: integer;
  start: TDateTime;

  Userfile: text;
  readchar: char;
  readstr, line: string;

  maxx, minx, maxy, miny, mindist: real;

function dist(x1, x2, y1, y2: real): real;
begin
  dist := Sqrt(Sqr(x2-x1)+Sqr(y2-y1));
end;

procedure setBounds();
begin
  maxx := 0;
  maxy := 0;
  minx:=X[0,0];
  miny:=X[0,1];
  for i:=0 to length(X)-2 do
  begin
      if (X[i,0]>maxx) then maxx:=X[i,0];
      if (X[i,1]>maxy) then maxy:=X[i,1];
      if (X[i,0]<minx) then minx:=X[i,0];
      if (X[i,1]<miny) then miny:=X[i,1];
  end;
end;

function checkConvergence(): boolean;
var
  equal: boolean;
begin
  equal:=true;
  for i:=0 to length(pointClass)-1 do
      if (pointClass[i]<>prevClass[i]) then
      begin
        equal:=false;
        break;
      end;
  if equal then writeln('Terminado!');
  checkConvergence:=equal;
end;

begin

  iterCount := 0;
  DecimalSeparator:='.';

  system.assign(UserFile,'SW-PW.csv');
  system.reset(UserFile);

  //Lectura de csv en array X
  i:=0;
  j:=0;

  readln(UserFile,line);
  repeat
    begin
        for readchar in line do
        begin
            if(readchar=',') then
            begin
              X[i,j]:=StrToFloat(readstr);
              inc(j);
              readstr:='';
            end
            else
            begin
              readstr:=readstr+readchar;
            end;
        end;
        X[i,j]:=StrToFloat(readstr);
        j:=0;
        inc(i);
        readstr:='';
        readln(UserFile,line);
    end;
  until (EOF(UserFile));
  close(UserFile);

  //Generar centroids
  setBounds();

  for i:=0 to length(Centroids)-1 do
  begin
      Centroids[i,0]:=random(round(maxx-minx))+minx;
      Centroids[i,1]:=random(round(maxy-miny))+miny;
  end;

  start := TimeStampToMSecs(DateTimeToTimeStamp(Time));

  repeat
    prevClass:=pointClass;
    //Paso 1: Calcular distancias y asignar
    for i:=0 to length(X)-2 do
    begin
        mindist := 100000;
        for j:=0 to length(Centroids)-1 do
           if (mindist>dist(X[i,0],Centroids[j,0],X[i,1],Centroids[j,1])) then
           begin
             mindist:= dist(X[i,0],Centroids[j,0],X[i,1],Centroids[j,1]);
             pointClass[i]:= j;
           end;
    end;

    //Paso 2: calcular nuevos centroides
    for i:=0 to length(X)-2 do
    begin
        sums[pointClass[i],0] := sums[pointClass[i],0]+X[i,0];
        sums[pointClass[i],1] := sums[pointClass[i],1]+X[i,1];
        inc(counts[pointClass[i]]);
    end;
    for i:=0 to length(Centroids)-1 do
    begin
        if counts[i]=0 then counts[i]:=1;
        Centroids[i,0]:=sums[i,0]/counts[i];
        Centroids[i,1]:=sums[i,1]/counts[i];
    end;

    inc(iterCount);
  until checkConvergence();
  writeln('Ejecutado en ',iterCount,' iteraciones');
  writeln('Tiempo: ',TimeStampToMSecs(DateTimeToTimeStamp(Time))-start);
  for i in pointClass do writeln(i);
  ReadKey;
end.

