program wanshitong;

uses
    data_type,
    date_handler,
    csv_handler, 
    user_handler,
    buku_handler,
    peminjaman_handler,
    pengembalian_handler,
    hilang_handler;

var 
    cmd, file_user, file_buku, file_pengembalian, file_peminjaman, file_hilang: string;
    sudahload, sudahlogin, is_admin: boolean;
    data_user: users;
    data_buku: grupbuku;
    data_pengembalian: gruppengembalian;
    data_peminjaman: gruppeminjaman;
    data_hilang: gruphilang;
    

    login_data: user;

procedure load_data();
var 
    arr_user, arr_buku, arr_pengembalian, arr_peminjaman, arr_hilang: string_arr;
begin
    write('Masukkan nama File Buku: ');
    readln(file_buku);
    arr_buku := read_csv(file_buku);
    data_buku := buku_create(arr_buku);
    write('Masukkan nama File User: ');
    readln(file_user);
    arr_user := read_csv(file_user);
    data_user := user_create(arr_user);
    write('Masukkan nama File Peminjaman: ');
    readln(file_peminjaman);
    arr_peminjaman := read_csv(file_peminjaman);
    data_peminjaman := peminjaman_create(arr_peminjaman);
    write('Masukkan nama File Pengembalian: ');
    readln(file_pengembalian);
    arr_pengembalian := read_csv(file_pengembalian);
    data_pengembalian := pengembalian_create(arr_pengembalian);
    write('Masukkan nama File Buku Hilang: ');
    readln(file_hilang);
    arr_hilang := read_csv(file_hilang);
    data_hilang := hilang_create(arr_hilang);

    writeln('File perpustakaan berhasil dimuat!');
end;

procedure login();
var 
    i: integer;
    username, password: string;
    found: boolean;
begin
    found := false;
    while(found=false) do 
    begin
        write('Masukkan username: ');
        readln(username);
        write('Masukkan password: ');
        readln(password);
        i := 1;
        while(i <= data_user.size) do 
        begin
            if(data_user.data[i].Username = username) and (data_user.data[i].Password = password) then
            begin 
                found := true;
                login_data := data_user.data[i];
            end;
            i := i+1;
        end;

        if (found=false) then 
        begin 
            writeln('Username / password salah! Silakan coba lagi.');
        end;
    end;

    writeln('Selamat datang ' + login_data.Nama + ' !');
    sudahlogin := true;
    if (login_data.Role = 1) then
    begin
        is_admin:=true;
    end;
end;

procedure daftar_akun();
var 
    nama, alamat, username, password: string;
    hasil : user;
    banyak: integer;
begin
    write('Masukkan nama pengunjung: ');
    readln(nama);
    write('Masukkan alamat pengunjung: ');
    readln(alamat);
    write('Masukkan username pengunjung: ');
    readln(username);
    write('Masukkan password pengunjung: ');
    readln(password);
    hasil.Nama := nama;
    hasil.Alamat := alamat;
    hasil.Username := username;
    hasil.Password := password;
    hasil.Role:=0;

    banyak := data_user.size+1;
    data_user.data[banyak]:=hasil;
    data_user.size := banyak;
    write_csv(file_user, 'user', user_merge(data_user));
    writeln('Pengunjung ' + nama + ' berhasil terdaftar sebagai user.')
end;

procedure cari_anggota();
var 
    username: string;
    i : integer;
    found: boolean;
    anggota: user;
begin
    write('Masukkan username: ');
    readln(username);

    found := false;
    i := 1;
    while (i <= data_user.size) do 
    begin
        if(data_user.data[i].Username=username) then
        begin
            found:=true;
            anggota := data_user.data[i];
        end;
        i := i+1;
    end;

    if(found) then
    begin
        writeln('Nama Anggota: ' + anggota.Username);
        writeln('Alamat: ' + anggota.Alamat);
    end
    else
    begin
        writeln('Tidak ditemukan user dengan username tersebut.');
    end;
end;

procedure save_file();
begin
    write('Masukkan nama File Buku: ');
    readln(file_buku);
    write_csv(file_buku, 'buku', buku_merge(data_buku));
    write('Masukkan nama File User: ');
    readln(file_user);
    write_csv(file_user, 'user', user_merge(data_user));
    write('Masukkan nama File Peminjaman: ');
    readln(file_peminjaman);
    write_csv(file_peminjaman, 'peminjaman', peminjaman_merge(data_peminjaman));
    write('Masukkan nama File Pengembalian: ');
    readln(file_pengembalian);
    write_csv(file_pengembalian, 'pengembalian', pengembalian_merge(data_pengembalian));
    write('Masukkan nama File Buku Hilang: ');
    readln(file_hilang);
    write_csv(file_hilang, 'hilang', hilang_merge(data_hilang));

    writeln('Data berhasil disimpan!');
end;

procedure statistik();
var 
    i, admin, pengunjung, sastra, sains, manga, sejarah, programming: integer;
begin
    admin := 0;
    pengunjung := 0;
    i := 1;
    while (i <= data_user.size) do 
    begin 
        if(data_user.data[i].Role=0) then 
        begin
            pengunjung := pengunjung + 1;
        end 
        else
        begin
            admin := admin + 1;
        end;
        i := i+1;
    end;
    sastra := 0;
    sains := 0;
    manga := 0;
    sejarah := 0;
    programming := 0;
    i := 1;
    while (i <= data_buku.size) do
    begin
        case (data_buku.data[i].Kategori) of
            'programming':
            begin
                programming := programming + 1;
            end;
            'sastra':
            begin
                sastra := sastra + 1;
            end;
            'sains':
            begin
                sains := sains + 1;
            end;
            'sejarah':
            begin
                sejarah := sejarah + 1;
            end;
            'manga':
            begin
                manga := manga + 1;
            end;
        end;
        i := i+1;
    end;

    writeln('Pengguna:');
    writeln('Admin | ' + IntToStr(admin));
    writeln('Pengunjung | ' + IntToStr(pengunjung));
    writeln('Total | ' + IntToStr(data_user.size));
    writeln('Buku:');
    writeln('sastra | ' + IntToStr(sastra));
    writeln('sains | ' + IntToStr(sains));
    writeln('manga | ' + IntToStr(manga));
    writeln('sejarah | ' + IntToStr(sejarah));
    writeln('programming | ' + IntToStr(programming));
    writeln('Total | ' + IntToStr(data_buku.size));
end;

procedure lihat_laporan();
var 
    i : integer;
    bukunya : buku;
begin
    writeln('Buku yang hilang :');
    i := 1;
    while ( i <= data_hilang.size) do
    begin
        bukunya := buku_find(data_hilang.data[i].ID_Buku_Hilang, data_buku);
        writeln(IntToStr(bukunya.ID_Buku) + ' | ' + bukunya.Judul_Buku + ' | ' + data_hilang.data[i].Tanggal_Laporan);
        i := i+1;
    end;
end;

procedure tambah_buku();
begin
    data_buku := buku_addnew(data_buku);
    write_csv(file_buku, 'buku', buku_merge(data_buku));

    writeln('Buku berhasil ditambahkan ke dalam sistem!');
end;

procedure tambah_jumlah_buku();
begin
    data_buku := buku_addqty(data_buku);
    write_csv(file_buku, 'buku', buku_merge(data_buku));
end;

procedure lapor_hilang();
begin
    data_hilang := hilang_add(login_data.Username, data_hilang);
    write_csv(file_hilang, 'hilang', hilang_merge(data_hilang));
end;

procedure riwayat();
var 
    username: string;
    pinjam: peminjaman;
    bukunya: buku;
    i: integer;
begin
    i := 1;
    write('Masukkan username pengunjung: ');
    readln(username);
    writeln('Riwayat:');
    while(i <= data_peminjaman.size) do
    begin
        if(data_peminjaman.data[i].Username=username) then
        begin
            bukunya := buku_find(data_peminjaman.data[i].ID_Buku, data_buku);
            writeln(data_peminjaman.data[i].Tanggal_Peminjaman + ' | ' + IntToStr(bukunya.ID_Buku) + ' | ' + bukunya.Judul_Buku);
        end;
        i := i+1;
    end;
end;

procedure pinjam_buku();
var 
    id, i: integer;
    username, date_pinjam: string;
    bukunya: buku;
begin
    write('Masukkan id buku yang ingin dipinjam: ');
    readln(id);
    write('Masukkan tanggal hari ini: ');
    readln(date_pinjam);
    username := login_data.Username;

    bukunya := buku_find(id, data_buku);
    if(bukunya.Jumlah_Buku = 0) then
    begin
        writeln('Buku ' + bukunya.Judul_Buku + ' sedang habis!');
        writeln('Coba lain kali.');
    end
    else
    begin
        bukunya.Jumlah_Buku := bukunya.Jumlah_Buku - 1;
        i := 1;
        while (i <= data_buku.size) do 
        begin
            if(data_buku.data[i].ID_Buku = bukunya.ID_Buku) then
            begin
                data_buku.data[i] := bukunya;
            end;
            i := i+1;
        end;
        data_peminjaman := peminjaman_add(id, username, date_pinjam, data_peminjaman);

        write_csv(file_buku, 'buku', buku_merge(data_buku));
        write_csv(file_peminjaman, 'peminjaman', peminjaman_merge(data_peminjaman));
        writeln('Buku ' + bukunya.Judul_Buku + ' berhasil dipinjam!');
        writeln('Tersisa ' + IntToStr(bukunya.Jumlah_Buku) + ' buku Clean Code.');
        writeln('Terima kasih sudah meminjam.');
    end;
end;

procedure kembalikan_buku();
var 
    id, idx, cmp, i: integer;
    bukunya: buku;
    pinjam: peminjaman;
    skrg: string;
    baru: gruppeminjaman;
begin
    write('Masukkan id buku yang dikembalikan: ');
    readln(id);
    bukunya := buku_find(id, data_buku);
    i := 1;
    while (i <= data_peminjaman.size) do 
    begin
        if(data_peminjaman.data[i].ID_Buku=id) then
        begin
            pinjam := data_peminjaman.data[i];
            idx := i;
        end;
        i := i+1;
    end;
    writeln('Data peminjaman:');
    writeln('Username: ' + login_data.Username);
    writeln('Judul buku: '+bukunya.Judul_Buku);
    writeln('Tanggal peminjaman: ' + pinjam.Tanggal_Peminjaman);
    writeln('Tanggal batas pengembalian: ' + pinjam.Tanggal_Batas_Pengembalian);

    write('Masukkan tanggal hari ini: ');
    readln(skrg);
    cmp := date_compare(skrg, pinjam.Tanggal_Batas_Pengembalian);

    if(cmp <= 0) then
    begin
        writeln('Terima kasih sudah meminjam.');
    end
    else
    begin
        writeln('Anda terlambat mengembalikan buku.');
    end;

    bukunya.Jumlah_Buku := bukunya.Jumlah_Buku + 1;
    i := 1;
    while (i <= data_buku.size) do 
    begin
        if(data_buku.data[i].ID_Buku = bukunya.ID_Buku) then
        begin
            data_buku.data[i] := bukunya;
        end;
        i := i+1;
    end;

    i:=1;
    while(i<= data_peminjaman.size) do
    begin
        if(i < idx) then
        begin
            baru.data[i]:=data_peminjaman.data[i];
        end
        else if(i > idx) then
        begin
            baru.data[i-1] := data_peminjaman.data[i];
        end;
        i:=i+1;
    end;
    baru.size := data_peminjaman.size-1;
    data_peminjaman := baru;
    write_csv(file_buku, 'buku', buku_merge(data_buku));
    write_csv(file_peminjaman, 'peminjaman', peminjaman_merge(data_peminjaman));
end;

procedure cari();
begin
    buku_cari(data_buku);
end;

procedure cari_tahun();
begin
    buku_cari_tahun(data_buku);
end;
begin
    sudahload := false;
    sudahlogin := false;
    is_admin := false;
    writeln('/------------------------------\');
    writeln('||                             ||');
    writeln('||     ---WAN SHI TONG---      ||');
    writeln('||          LIBRARY            ||');
    writeln('||         -Kelas 2-           ||');
    writeln('||         Kelompok 4          ||');
    writeln('||                             ||');
    writeln('\-------------------------------/');
    writeln('');
    writeln('          Selamat Datang         ');
    writeln('silahkan load data dengan command: load');
    readln(cmd);
    while(cmd <> 'load') do 
    begin
        writeln('Anda harus melakukan load terlebih dahulu!');
        readln(cmd);
    end;
    load_data();

    readln(cmd);
    while(cmd <> 'login') do 
    begin
        writeln('Anda harus melakukan login terlebih dahulu sebelum melanjutkan!');
        readln(cmd);
    end;

    login();

    repeat 
        readln(cmd);
        case cmd of
            'register':
            begin
                if is_admin then
                begin
                    daftar_akun();
                end 
                else
                begin
                    writeln('Kamu bukan admin!');
                end;
            end;
            'cari_anggota':
            begin
                if is_admin then
                begin
                    cari_anggota();
                end 
                else
                begin
                    writeln('Kamu bukan admin!');
                end;
            end;
            'statistik':
            begin
                if is_admin then
                begin
                    statistik();
                end 
                else
                begin
                    writeln('Kamu bukan admin!');
                end;
            end;
            'save':
            begin
                save_file();
            end;
            'lihat_laporan':
            begin
                if is_admin then
                begin
                    lihat_laporan();
                end 
                else
                begin
                    writeln('Kamu bukan admin!');
                end;
            end;
            'tambah_buku':
            begin
                if is_admin then
                begin
                    tambah_buku();
                end 
                else
                begin
                    writeln('Kamu bukan admin!');
                end;
            end;
            'tambah_jumlah_buku':
            begin
                if is_admin then
                begin
                    tambah_jumlah_buku();
                end 
                else
                begin
                    writeln('Kamu bukan admin!');
                end;
            end;
            'lapor_hilang':
            begin
                lapor_hilang();
            end;
            'riwayat':
            begin
                if is_admin then
                begin
                    riwayat();
                end 
                else
                begin
                    writeln('Kamu bukan admin!');
                end;
            end;
            'pinjam_buku':
            begin
                pinjam_buku();
            end;
            'kembalikan_buku':
            begin
                kembalikan_buku();
            end;
            'cari':
            begin
                cari();
            end;
            'caritahunterbit':
            begin
                cari_tahun();
            end;
        end;
    until (cmd='exit');

    write('Apakah anda mau melakukan penyimpanan file yang sudah dilakukan (Y/N) ? ');
    readln(cmd);
    if(cmd='Y')then
    begin
        save_file();
    end;

end.