unit hilang_handler;

interface

uses
    data_type;

type 
    hilang = record
            Username, Tanggal_Laporan: string;
            ID_Buku_Hilang: integer;
            end;
    gruphilang = record 
            data: array [1..1000] of hilang;
            size: integer;
            end;

function hilang_split(s: string): hilang;
function hilang_create(s: string_arr): gruphilang;
function hilang_implode(us: hilang):string;
function hilang_merge(uss: gruphilang): string_arr;
function hilang_add(username:string; uss: gruphilang): gruphilang;

implementation

function hilang_split(s: string): hilang;
var 
    c:char;
    temp: string;
    hasil : hilang;
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
                    hasil.ID_Buku_Hilang := StrToInt(temp);
                end;
            end;
            temp := '';
            i := i+1;
        end;
    end;
    hasil.Tanggal_Laporan := temp;
    hilang_split := hasil;
end;

function hilang_create(s: string_arr): gruphilang;
var
    hasil: gruphilang;
    i: integer;
begin
    i := 1;
    while(i<=s.size) do 
    begin
        hasil.data[i] := hilang_split(s.data[i]);
        i := i+1;
    end;
    hasil.size:=s.size;
    hilang_create := hasil;
end;
function hilang_implode(us: hilang): string;
var 
    hasil: string;
begin
    hasil := us.Username;
    hasil += ',';
    hasil += IntToStr(us.ID_Buku_Hilang);
    hasil += ',';
    hasil += us.Tanggal_Laporan;
    hilang_implode := hasil;
end;

function hilang_merge(uss: gruphilang): string_arr;
var 
    res: string_arr;
    i: integer;
begin
    i := 1;
    while(i <= uss.size) do 
    begin
        res.data[i] := hilang_implode(uss.data[i]);
        i := i+1;
    end;
    res.size :=uss.size;
    hilang_merge := res;
end;

function hilang_add(username: string; uss: gruphilang): gruphilang;
var
    i, siz, id: integer;
    judul, tanggal: string;
    baru: hilang;
    grup: gruphilang;
begin
    write('Masukkan id buku: ');
    readln(id);
    write('Masukkan judul buku: ');
    readln(judul);
    write('Masukkan tanggal pelaporan: ');
    readln(tanggal);
    baru.Username := username;
    baru.Tanggal_Laporan := tanggal;
    baru.ID_Buku_Hilang := id;
    grup := uss;
    siz := grup.size+1;
    grup.size := siz;
    grup.data[siz] := baru;
    writeln('Laporan berhasil diterima.');
    hilang_add := grup;
end;
end.