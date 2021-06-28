program tictactoe;

{$mode Delphi}

uses
        ttt,
        Crt;
var
        game: Tttt;
        mode: Byte;
begin
        game := Tttt.create;

        Write('Please, choose mode - PVP or PVC [1,2]: ');
        Readln(mode);

        if mode = 1 then
                game.PVP
        else if mode = 2 then
                game.PVC
        else
                Writeln('Exit');

        game.Destroy;

        readln;

end.
