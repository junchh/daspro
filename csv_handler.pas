unit csv_handler;

interface

uses 
    data_type;

function read_csv(s: string): string_arr;
procedure write_csv(s, tipe: string; sarr: string_arr);

implementation

function read_csv(s: string): string_arr;
var
	filenya : text;
	namafile, line1: string;
    i, cnt: integer;
    hasil: string_arr;

begin
    i:=0;
    cnt:=0;
    assign(filenya, s);
	reset(filenya); 
	repeat
		readln(filenya,line1);
        if(i<>0) then
        begin
            hasil.data[i] := line1;
        end;
        cnt := cnt+1;
        i := i+1;
	until EOF(filenya);
	close(filenya);
    hasil.size := cnt-1;
    read_csv := hasil;
end;

procedure write_csv(s, tipe:string; sarr: string_arr);
var 
    filenya: text;
    tip: string;
    i: integer;
begin
    assign(filenya, s);
	erase(filenya); 
	assign(filenya, s);
	rewrite(filenya);
    case tipe of
        'user':
            begin
            tip := 'Nama,Alamat,Username,Password,Role';
            end;
        'buku':
            begin
            tip := 'ID_Buku,Judul_Buku,Author,Jumlah_Buku,Tahun_Penerbit,Kategori';
            end;
        'peminjaman':
            begin
            tip := 'Username,ID_Buku,Tanggal_Peminjaman,Tanggal_Batas_Pengembalian,Status_Pengembalian';
            end;
        'pengembalian':
            begin
            tip := 'Username,ID_Buku,Tanggal_Pengembalian';
            end;
        'hilang':
            begin
            tip := 'Username,ID_Buku_Hilang,Tanggal_Laporan';
            end;
    end;
    writeln(filenya, tip);
	i := 1;
    while (i <= sarr.size) do 
    begin 
        writeln(filenya, sarr.data[i]);
        i := i+1;
    end;
	Close(filenya);
end;
end.