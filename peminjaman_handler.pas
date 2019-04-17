unit peminjaman_handler;

interface

uses 
    data_type,
    date_handler;

type 
    peminjaman = record
            Username, Tanggal_Peminjaman, Tanggal_Batas_Pengembalian: string;
            ID_Buku, Status_Pengembalian: integer;
            end;
    gruppeminjaman = record 
            data: array [1..1000] of peminjaman;
            size: integer;
            end;

function peminjaman_split(s: string): peminjaman;
function peminjaman_create(s: string_arr): gruppeminjaman;
function peminjaman_implode(us: peminjaman):string;
function peminjaman_merge(uss: gruppeminjaman): string_arr;
function peminjaman_add(id_buku: integer;username:string;date_pinjam:string;uss: gruppeminjaman): gruppeminjaman;
function peminjaman_find(id: integer;uss: gruppeminjaman): peminjaman; {prekondisi id pasti ada}

implementation

function peminjaman_split(s: string):peminjaman;
var 
    c:char;
    temp: string;
    hasil : peminjaman;
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
                3:
                begin
                    hasil.Tanggal_Peminjaman := temp;
                end;
                4:
                begin
                    hasil.Tanggal_Batas_Pengembalian := temp;
                end;
            end;
            temp := '';
            i := i+1;
        end;
    end;
    hasil.Status_Pengembalian := StrToInt(temp);
    peminjaman_split := hasil;
end;

function peminjaman_create(s: string_arr): gruppeminjaman;
var
    hasil: gruppeminjaman;
    i: integer;
begin
    i := 1;
    while(i<=s.size) do 
    begin
        hasil.data[i] := peminjaman_split(s.data[i]);
        i := i+1;
    end;
    hasil.size:=s.size;
    peminjaman_create := hasil;
end;

function peminjaman_implode(us: peminjaman): string;
var
    hasil: string;
begin
    hasil := us.Username;
    hasil += ',';
    hasil += IntToStr(us.ID_Buku);
    hasil += ',';
    hasil += us.Tanggal_Peminjaman;
    hasil += ',';
    hasil += us.Tanggal_Batas_Pengembalian;
    hasil += ',';
    hasil += IntToStr(us.Status_Pengembalian);
    peminjaman_implode := hasil;
end;

function peminjaman_merge(uss: gruppeminjaman): string_arr;
var 
    res: string_arr;
    i: integer;
begin
    i := 1;
    while(i <= uss.size) do 
    begin
        res.data[i] := peminjaman_implode(uss.data[i]);
        i := i+1;
    end;
    res.size :=uss.size;
    peminjaman_merge := res;
end;

function peminjaman_add(id_buku: integer;username:string;date_pinjam: string;uss:gruppeminjaman): gruppeminjaman;
var 
    pinjam: peminjaman;
    grup: gruppeminjaman;
    siz: integer;
begin
    pinjam.Username := username;
    pinjam.ID_Buku := id_buku;
    pinjam.Tanggal_Peminjaman := date_pinjam;
    pinjam.Tanggal_Batas_Pengembalian := next_seven(date_pinjam);
    pinjam.Status_Pengembalian := 0;
    grup := uss;
    siz := uss.size+1;
    grup.size := siz;
    grup.data[siz] := pinjam;
    peminjaman_add := grup;
end;

function peminjaman_find(id: integer;uss: gruppeminjaman): peminjaman; {prekondisi id pasti ada}
var 
    i: integer;
    hasil: peminjaman;
begin
    i := 1;
    while (i <= uss.size) do 
    begin
        if(uss.data[i].ID_Buku=id) then
        begin
            hasil := uss.data[i];
        end;
        i := i+1;
    end;
    peminjaman_find := hasil;
end;
end.