unit data_type;

interface

type 
    string_arr = record 
        data: array [1..1000] of string;
        size: integer;
        end;

function conv1(y: integer):char;
function conv2(y: char): integer;
function IntToStr(g: integer):string;
function StrToInt(g: string):integer;
implementation

function conv1(y: integer):char;
begin
    case y of
        0:
        begin
            conv1 := '0';
        end;
        1:
        begin
            conv1 := '1';
        end;
        2:
        begin
            conv1 := '2';
        end;
        3:
        begin
            conv1 := '3';
        end;
        4:
        begin
            conv1 := '4';
        end;
        5:
        begin
            conv1 := '5';
        end;
        6:
        begin
            conv1 := '6';
        end;
        7:
        begin
            conv1 := '7';
        end;
        8:
        begin
            conv1 := '8';
        end;
        9:
        begin
            conv1 := '9';
        end;
    end;
end;

function conv2(y: char):integer;
begin
    case y of
        '0':
        begin
            conv2 := 0;
        end;
        '1':
        begin
            conv2 := 1;
        end;
        '2':
        begin
            conv2 := 2;
        end;
        '3':
        begin
            conv2 := 3;
        end;
        '4':
        begin
            conv2 := 4;
        end;
        '5':
        begin
            conv2 := 5;
        end;
        '6':
        begin
            conv2 := 6;
        end;
        '7':
        begin
            conv2 := 7;
        end;
        '8':
        begin
            conv2 := 8;
        end;
        '9':
        begin
            conv2 := 9;
        end;
    end;
end;

function IntToStr(g: integer):string;
var 
    res: string;
begin
    res := '';
    while (g <> 0) do 
    begin
        res := conv1(g mod 10)+res;
        g := g div 10;
    end;
    if(res='') then
    begin
        res:='0';
    end;
    IntToStr := res;
end;
function StrToInt(g: string): integer;
var 
    res, t, len: integer;
    c: char;
    test: string;
begin
    res := 0;
    len := 1;
    for c in g do 
    begin
        len := len*10;
    end;
    len := len div 10;
    for c in g do
    begin
        res := res + len*conv2(c);
        len := len div 10;
    end;
    StrToInt := res;
end;
end.