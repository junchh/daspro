unit pengembalian_handler;

interface

uses 
    data_type;
type 
    pengembalian = record
            Username, Tanggal_Pengembalian: string;
            ID_Buku: integer;
            end;
    gruppengembalian = record 
            data: array [1..1000] of pengembalian;
            size: integer;
            end;

function pengembalian_split(s: string): pengembalian;
function pengembalian_create(s: string_arr): gruppengembalian;
function pengembalian_implode(us: pengembalian):string;
function pengembalian_merge(uss: gruppengembalian): string_arr;

implementation

function pengembalian_split(s: string): pengembalian;
var 
    c:char;
    temp: string;
    hasil : pengembalian;
    i: integer;
begin
    temp := '';
    i := 1;
    for c in s do 
    begin
        if(c<>',') then
        begin
            temp := temp + c;
        end
        else
        begin
            case i of
                1:
                begin
                    hasil.Username := temp;
                end;
                2:
                begin
                    hasil.ID_Buku := StrToInt(temp);
                end;
            end;
            temp := '';
            i := i+1;
        end;
    end;
    hasil.Tanggal_Pengembalian := temp;
    pengembalian_split := hasil;
end;

function pengembalian_create(s: string_arr): gruppengembalian;
var
    hasil: gruppengembalian;
    i: integer;
begin
    i := 1;
    while(i<=s.size) do 
    begin
        hasil.data[i] := pengembalian_split(s.data[i]);
        i := i+1;
    end;
    hasil.size:=s.size;
    pengembalian_create := hasil;
end;{Username,ID_Buku,Tanggal_Pengembalian}
function pengembalian_implode(us: pengembalian): string;
var 
    hasil: string;
begin
    hasil := us.Username;
    hasil += ',';
    hasil += IntToStr(us.ID_Buku);
    hasil += ',';
    hasil += us.Tanggal_Pengembalian;
    pengembalian_implode := hasil;
end;

function pengembalian_merge(uss: gruppengembalian): string_arr;
var 
    res: string_arr;
    i: integer;
begin
    i := 1;
    while(i <= uss.size) do 
    begin
        res.data[i] := pengembalian_implode(uss.data[i]);
        i := i+1;
    end;
    res.size :=uss.size;
    pengembalian_merge := res;
end;
end.