unit buku_handler;

interface

uses 
    data_type;

type 
    buku = record
            Author, Kategori, Judul_Buku: string;
            ID_Buku, Jumlah_Buku, Tahun_Penerbit: integer;
            end;
    grupbuku = record 
            data: array [1..1000] of buku;
            size: integer;
            end;

function buku_split(s: string): buku;
function buku_create(s: string_arr): grupbuku;
function buku_implode(us: buku):string;
function buku_merge(uss: grupbuku): string_arr;
function buku_find(id: integer;uss: grupbuku): buku;
function buku_addnew(uss: grupbuku): grupbuku;
function buku_addqty(uss: grupbuku): grupbuku;
function valid(s:string):boolean;
procedure buku_cari(uss: grupbuku);
procedure buku_cari_tahun(uss: grupbuku);

implementation

function buku_split(s: string):buku;
var 
    c:char;
    temp: string;
    hasil : buku;
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
                    hasil.ID_Buku := StrToInt(temp);
                end;
                2:
                begin
                    hasil.Judul_Buku := temp;
                end;
                3:
                begin
                    hasil.Author := temp;
                end;
                4:
                begin
                    hasil.Jumlah_Buku := StrToInt(temp);
                end;
                5:
                begin
                    hasil.Tahun_Penerbit := StrToInt(temp);
                end;
            end;
            temp := '';
            i := i+1;
        end;
    end;
    hasil.Kategori := temp;
    buku_split := hasil;
end;

function buku_create(s: string_arr): grupbuku;
var
    hasil: grupbuku;
    i: integer;
begin
    i := 1;
    while(i<=s.size) do 
    begin
        hasil.data[i] := buku_split(s.data[i]);
        i := i+1;
    end;
    hasil.size:=s.size;
    buku_create := hasil;
end;
{ID_Buku,Judul_Buku,Author,Jumlah_Buku,Tahun_Penerbit,Kategori}
function buku_implode(us: buku): string;
var 
    hasil: string;
begin
    hasil := IntToStr(us.ID_Buku);
    hasil += ',';
    hasil += us.Judul_Buku;
    hasil += ',';
    hasil += us.Author;
    hasil += ',';
    hasil += IntToStr(us.Jumlah_Buku);
    hasil += ',';
    hasil += IntToStr(us.Tahun_Penerbit);
    hasil += ',';
    hasil += us.Kategori;
    buku_implode := hasil;
end;

function buku_merge(uss: grupbuku): string_arr;
var 
    res: string_arr;
    i: integer;
begin
    i := 1;
    while(i <= uss.size) do 
    begin
        res.data[i] := buku_implode(uss.data[i]);
        i := i+1;
    end;
    res.size :=uss.size;
    buku_merge := res;
end;

function buku_find(id: integer;uss: grupbuku): buku; {prekondisi id pasti ada}
var 
    i: integer;
    hasil: buku;
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
    buku_find := hasil;
end;

function buku_addnew(uss: grupbuku): grupbuku;
var 
    id,jumlah,tahun, siz: integer;
    judul,author,kategori: string;
    grup: grupbuku;
    bukunya: buku;
begin
    writeln('Masukkan Informasi buku yang ditambahkan:');
    write('Masukkan id buku: ');
    readln(id);
    write('Masukkan judul buku: ');
    readln(judul);
    write('Masukkan pengarang buku: ');
    readln(author);
    write('Masukkan jumlah buku: ');
    readln(jumlah);
    write('Masukkan tahun terbit buku: ');
    readln(tahun);
    write('Masukkan kategori buku: ');
    readln(kategori);
    bukunya.ID_Buku := id;
    bukunya.Judul_Buku := judul;
    bukunya.Author := author;
    bukunya.Jumlah_Buku := jumlah;
    bukunya.Tahun_Penerbit := tahun;
    bukunya.Kategori := kategori;

    siz := uss.size + 1;
    grup := uss;
    grup.data[siz] := bukunya;
    grup.size := siz;
    buku_addnew := grup;
end;

function buku_addqty(uss: grupbuku): grupbuku;
var 
    bukunya: buku;
    grup: grupbuku;
    i, qty, id: integer;
begin
    write('Masukkan ID Buku: ');
    readln(id);
    write('Masukkan jumlah buku yang ditambahkan: ');
    readln(qty);
    grup := uss;
    bukunya := buku_find(id, grup);
    bukunya.Jumlah_Buku := bukunya.Jumlah_Buku + qty;

    i := 1;
    while (i <= grup.size) do
    begin
        if(grup.data[i].ID_Buku=bukunya.ID_Buku) then
        begin
            grup.data[i] := bukunya;
        end;
        i := i+1;
    end;

    writeln('Pembaharuan jumlah buku berhasil dilakukan, total buku ' + bukunya.Judul_Buku + ' di perpustakaan menjadi ' + IntToStr(bukunya.Jumlah_Buku));
    buku_addqty := grup;
end;

function valid(s:string):boolean;
begin
    if(s='programming')or(s='sastra')or(s='sains')or(s='manga')or(s='sejarah') then
    begin
        valid := true;
    end
    else
    begin
        valid := false;
    end;
end;

procedure buku_cari(uss:grupbuku);
var 
    kategori: string; 
    temp: buku;
    i,j: integer;
    dataa: grupbuku;
begin
    write('Masukkan kategori: ');
    readln(kategori);
    while(valid(kategori)=false) do
    begin
        writeln('Kategori ' + kategori + ' tidak valid.');
        write('Masukkan kategori: ');
        readln(kategori);
    end;

    i:=1;
    j:=0;
    while(i <= uss.size) do
    begin
        if(uss.data[i].Kategori=kategori) then
        begin
            j := j+1;
            dataa.data[j] := uss.data[i];
        end;
        i := i+1;
    end;
    dataa.size := j;

    for i:= 1 to dataa.size-1 do
    begin
        for j:= dataa.size-1 downto i do
        begin
            if dataa.data[j+1].Judul_Buku < dataa.data[j].Judul_Buku then
            begin
                temp:= dataa.data[j];
                dataa.data[j] := dataa.data[j+1];
                dataa.data[j+1]:= temp;
            end;
        end;
    end;

    i:=1;
    while(i <= dataa.size) do
    begin
        writeln(IntToStr(dataa.data[i].ID_Buku) + ' | ' + dataa.data[i].Judul_Buku + ' | ' + dataa.data[i].Author);
        i := i+1;
    end;
end;

procedure buku_cari_tahun(uss:grupbuku);
var 
    kategori: string; 
    temp: buku;
    i,j, tahun: integer;
    dataa: grupbuku;
    kate: char;
begin
    write('Masukkan tahun: ');
    readln(tahun);
    write('Masukkan kategori: ');
    readln(kate);

    i:=1;
    j:=0;
    if(kate='<') then
    begin
        while(i <= uss.size) do
        begin
            if(uss.data[i].Tahun_Penerbit<tahun) then
            begin
                j := j+1;
                dataa.data[j] := uss.data[i];
            end;
            i := i+1;
        end;
    end 
    else if(kate='>') then
    begin
        while(i <= uss.size) do
        begin
            if(uss.data[i].Tahun_Penerbit>tahun) then
            begin
                j := j+1;
                dataa.data[j] := uss.data[i];
            end;
            i := i+1;
        end;
    end
    else if(kate='<=') then
    begin
        while(i <= uss.size) do
        begin
            if(uss.data[i].Tahun_Penerbit<=tahun) then
            begin
                j := j+1;
                dataa.data[j] := uss.data[i];
            end;
            i := i+1;
        end;
    end
    else if(kate='>=') then
    begin
        while(i <= uss.size) do
        begin
            if(uss.data[i].Tahun_Penerbit>=tahun) then
            begin
                j := j+1;
                dataa.data[j] := uss.data[i];
            end;
            i := i+1;
        end;
    end
    else if(kate='=') then
    begin
        while(i <= uss.size) do
        begin
            if(uss.data[i].Tahun_Penerbit=tahun) then
            begin
                j := j+1;
                dataa.data[j] := uss.data[i];
            end;
            i := i+1;
        end;
    end;
    dataa.size := j;

    for i:= 1 to dataa.size-1 do
    begin
        for j:= dataa.size-1 downto i do
        begin
            if dataa.data[j+1].Judul_Buku < dataa.data[j].Judul_Buku then
            begin
                temp:= dataa.data[j];
                dataa.data[j] := dataa.data[j+1];
                dataa.data[j+1]:= temp;
            end;
        end;
    end;
    write('Buku yang terbit ');
    write(kate);
    writeln(' ' + IntToStr(tahun));
    if(dataa.size=0) then
    begin
        writeln('Tidak ada buku dalam kategori ini.');
    end
    else
    begin
        i:=1;
        while(i <= dataa.size) do
        begin
            writeln(IntToStr(dataa.data[i].ID_Buku) + ' | ' + dataa.data[i].Judul_Buku + ' | ' + dataa.data[i].Author);
            i := i+1;
        end;
    end;
end;
end.