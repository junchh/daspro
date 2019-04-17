unit date_handler;

interface


uses 
    data_type;

function isKabisat(year: integer): boolean;
function date_parse(hari: integer;bulan: integer; tahun: integer):string;
function next_seven(tanggal: string): string;
function date_compare(date1:string;date2:string):integer;

implementation
function isKabisat(year: integer): boolean;
begin
    if (year mod 4 = 0) then
    begin
        if(year mod 400 = 0) then
        begin
            isKabisat := true;
        end
        else
        begin
            if(year mod 100 = 0) then
            begin
                isKabisat := false;
            end
            else
            begin
                isKabisat := true;
            end;
        end;
    end
    else
    begin
        isKabisat := false;
    end;
end;

function date_parse(hari: integer;bulan: integer; tahun: integer):string;
var 
    h,b,t, res: string;
begin
    if(hari <= 9) then
    begin
        h := '0'+IntToStr(hari);
    end
    else
    begin
        h := IntToStr(hari);
    end;
    if(bulan <= 9) then
    begin
        b := '0'+IntToStr(bulan);
    end
    else
    begin
        b := IntToStr(bulan);
    end;
    res := h + '/' + b + '/' + IntToStr(tahun);
    date_parse:=res;
end;

function next_seven(tanggal: string): string;
var 
    hari,bulan,tahun, i: integer;
    temp, hasil: string;
    c: char;
begin
    temp := '';
    i := 1;
    for c in tanggal do 
    begin
        if (c <> '/') then
        begin
            temp := temp + c;
        end
        else
        begin
            case i of
                1:
                begin
                    hari := StrToInt(temp);
                end;
                2:
                begin
                    bulan := StrToInt(temp);
                end;
            end;
            i := i+1;
            temp := '';
        end;
    end;
    tahun := StrToInt(temp);
    if (bulan=1) or (bulan=3) or(bulan=5) or(bulan=7) or (bulan=8) or (bulan=10) then
    begin
        if(hari <= 24) then
        begin
            hasil := date_parse(hari+7, bulan, tahun);
        end
        else 
        begin
            hasil := date_parse((hari+7) mod 31, bulan+1, tahun);
        end
    end
    else if (bulan=12) then
    begin
        if(hari <= 24) then
        begin
            hasil := date_parse(hari+7, bulan, tahun);
        end
        else 
        begin
            hasil := date_parse((hari+7) mod 31, 1, tahun+1);
        end
    end
    else if(bulan=2) then
    begin
        if(isKabisat(tahun)) then
        begin
            if(hari <= 22) then
            begin
                hasil := date_parse(hari+7, bulan, tahun);
            end
            else 
            begin
                hasil := date_parse((hari+7) mod 29, bulan+1, tahun);
            end
        end
        else
        begin
            if(hari <= 21) then
            begin
                hasil := date_parse(hari+7, bulan, tahun);
            end
            else 
            begin
                hasil := date_parse((hari+7) mod 28, bulan+1, tahun);
            end
        end
    end
    else
    begin
        if(hari <= 23) then
            begin
                hasil := date_parse(hari+7, bulan, tahun);
            end
            else 
            begin
                hasil := date_parse((hari+7) mod 30, bulan+1, tahun);
            end
    end;

    next_seven := hasil;
end;

function date_compare(date1:string;date2:string):integer;
var 
    hari1,hari2,bulan1,bulan2,tahun1,tahun2, i: integer;
    temp : string;
    c: char;
begin
    temp := '';
    i := 1;
    for c in date1 do 
    begin
        if (c <> '/') then
        begin
            temp := temp + c;
        end
        else
        begin
            case i of
                1:
                begin
                    hari1 := StrToInt(temp);
                end;
                2:
                begin
                    bulan1 := StrToInt(temp);
                end;
            end;
            i := i+1;
            temp := '';
        end;
    end;
    tahun1 := StrToInt(temp);
    temp := '';
    i := 1;
    for c in date2 do 
    begin
        if (c <> '/') then
        begin
            temp := temp + c;
        end
        else
        begin
            case i of
                1:
                begin
                    hari2 := StrToInt(temp);
                end;
                2:
                begin
                    bulan2 := StrToInt(temp);
                end;
            end;
            i := i+1;
            temp := '';
        end;
    end;
    tahun2 := StrToInt(temp);


    if(tahun1 < tahun2) then
    begin
        date_compare := -1;
    end
    else if(tahun1 > tahun2) then
    begin
        date_compare := 1;
    end
    else
    begin
        if(bulan1 < bulan2) then
        begin
            date_compare := -1;
        end
        else if(bulan1 > bulan2) then
        begin
            date_compare := 1;
        end
        else
        begin
            if(hari1 < hari2) then
            begin
                date_compare := -1;
            end
            else if(hari1 > hari2) then
            begin
                date_compare := 1;
            end
            else
            begin
                date_compare := 0;
            end;
        end;
    end;
end;

end.