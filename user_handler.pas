unit user_handler;

interface

uses 
    data_type;

type 
    user = record
            Nama, Alamat, Username, Password: string;
            Role: integer;
            end;
    users = record 
            data: array [1..1000] of user;
            size: integer;
            end;

function user_split(s: string): user;
function user_create(s: string_arr): users;
function user_implode(us: user):string;
function user_merge(uss: users): string_arr;

implementation

function user_split(s: string):user;
var 
    c:char;
    temp: string;
    hasil : user;
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
                    hasil.Nama := temp;
                end;
                2:
                begin
                    hasil.Alamat := temp;
                end;
                3:
                begin
                    hasil.Username := temp;
                end;
                4:
                begin
                    hasil.Password := temp;
                end;
            end;
            temp := '';
            i := i+1;
        end;
    end;
    hasil.Role := StrToInt(temp);
    user_split := hasil;
end;

function user_create(s: string_arr): users;
var
    hasil: users;
    i: integer;
begin
    i := 1;
    while(i<=s.size) do 
    begin
        hasil.data[i] := user_split(s.data[i]);
        i := i+1;
    end;
    hasil.size:=s.size;
    user_create := hasil;
end;

function user_implode(us: user): string;
var 
    hasil: string;
begin
    hasil := us.Nama;
    hasil += ',';
    hasil += us.Alamat;
    hasil += ',';
    hasil += us.Username;
    hasil += ',';
    hasil += us.Password;
    hasil += ',';
    hasil += IntToStr(us.Role);
    user_implode := hasil;
end;

function user_merge(uss: users): string_arr;
var 
    res: string_arr;
    i: integer;
begin
    i := 1;
    while(i <= uss.size) do 
    begin
        res.data[i] := user_implode(uss.data[i]);
        i := i+1;
    end;
    res.size :=uss.size;
    user_merge := res;
end;
end.