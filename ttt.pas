{$mode Delphi}

unit ttt;

interface
        uses sysutils, CRT;

        type
                TFields = array[0..2, 0..2] of Char;

                TPlayer = packed record
                        fname, sname: String;
                end;

                Tttt = class
                        var
                                Fields: TFields;
                                PlayerOne: TPlayer;
                                PlayerTwo: TPlayer;
                                turn: Byte;

                        public
                                constructor Create;
                                destructor Destroy;

                                procedure printBoard;
                                procedure fillCell;
                                function isWon: Boolean;
                                function isDraw: Boolean;
                                procedure PVP;
                                procedure PVC;

                        private
                                procedure createPlayer(var Player: TPlayer);
                                procedure createBoard;
                                function vonNeumann: Boolean;
                                function diagonal: Boolean;
                                function check(x,y:Byte): Boolean;
                                procedure computerFills();
                end;

implementation

        //constructor creates instance and fill board with empty chars (procedure createBoard)
        constructor Tttt.Create;
        begin
                Writeln('Game instance created');
                createBoard;
        end;

        //destructor destroys an instance of the game
        destructor Tttt.Destroy;
        begin
                Writeln('Game instance destroyed');
        end;

        //fills board with empty chars
        procedure Tttt.createBoard;
        var
                row, col: Byte;
        begin
                for row:=Low(Fields) to High(Fields) do
                begin
                    for col:=Low(Fields[row]) to High(Fields[row]) do
                    begin
                        Fields[row][col] := ' ';
                    end;
                end;
        end;


        //print all boards
        procedure Tttt.printBoard;
        var
                row, col, line: Byte;
        begin
                for row:=Low(Fields) to High(Fields) do
                begin

                    writeln;
                    write('  ');
                    for col := Low(Fields[row]) to High(Fields[row]) do
                    begin
                        Write('|', Fields[row][col]);
                    end;

                    writeln('|');

                    if row < 2 then
                    begin
                        for line := 1 to 11 do
                                Write('-');
                    end;
                end;

                Writeln;
        end;


        //checks if draw then return true else false
        function Tttt.isDraw: Boolean;
        var
                row, col: Byte;
        begin
                //checking all cells if empty then there is no draw
                for row := Low(Fields) to High(Fields) do
                begin
                        for col := Low(Fields[row]) to High(Fields[row]) do
                        begin
                                if Fields[row][col] = ' ' then
                                        isDraw:=false;
                        end;
                end;
        end;


        //checks if current player won
        function Tttt.isWon: Boolean;
        begin
                if vonNeumann or diagonal then
                        isWon := true
                else
                        isWon := false;
        end;


        //checks if won by diagonal
        function Tttt.diagonal: Boolean;
        begin
                //Writeln('diagonal'); readln;
                if (Fields[1][1] = Fields[0][0]) and (Fields[1][1] = Fields[2][2]) and (Fields[1][1] <> ' ') then
                        diagonal := true

                else if (Fields[1][1] = Fields[0][2]) and (Fields[1][1] = Fields[2][0]) and (Fields[1][1] <> ' ') then
                        diagonal := true

                else
                        diagonal := false;
        end;


        //checks if won by horizontal and vertical
        function Tttt.vonNeumann: Boolean;
        var
                row, col: ShortInt;
                rowT, colT: ShortInt;
                count: Byte;
                won: Boolean = false;
        begin
                for row := Low(Fields) to High(Fields) do
                begin
                    for col := Low(Fields[row]) to High(Fields[row]) do
                    begin

                        if Fields[row][col] = ' ' then
                                continue;

                        count:=0;
                        for rowT := row-1 to row+1 do
                        begin
                                if (rowT < 0) or (rowT > 2) then
                                        continue;

                                if rowT = row then
                                        continue;

                                if (Fields[rowT][col] = Fields[row][col]) then
                                        count:=count+1;
                        end;

                        if count = 2 then
                                won := true;

                        count:=0;
                        for colT := col-1 to col+1 do
                        begin
                                if (colT < 0) or (colT > 2) then
                                        continue;

                                if colT = col then
                                        continue;

                                if (Fields[row][colT] = Fields[row][col]) then
                                        count:=count+1;
                        end;

                        if count = 2 then
                                won := true;
                    end;
                end;

                vonNeumann := won;
        end;


        //creates player
        procedure Tttt.createPlayer(var Player: TPlayer);
        begin
                Write('Please enter player name: ');
                Readln(Player.fname);

                Write('Please enter player surname: ');
                Readln(Player.sname);
        end;


        //fills cell
        procedure Tttt.fillCell;
        var
                x,y: Integer;
                changed: Boolean = false;
        begin
                while not changed do
                begin
                        Writeln('Player ', IntToStr(turn+1), ' turn');
                        Write('Choose your cell [x,y][0-2, 0-2]');
                        Readln(x);
                        //Writeln(x); readln;
                        Readln(y);
                        //Writeln(y); readln;
                        
                        if (x=3) or (y=3) then
                        begin
                                turn:=3;
                                changed:=true;
                        end else if ((x>=0) and (x<=2)) and ((y>=0) and (y<=2)) then
                        begin
                                //Writeln('dddddddd'); readln;
                                if Fields[x][y]=' ' then
                                begin
                                        //writeln('if'); readln;
                                        if turn=0 then
                                                Fields[x][y]:='O'
                                        else
                                                Fields[x][y]:='X';
                                        //Writeln('poza ifem');readln;
                                        changed:=true;
                                end else
                                begin
                                        Writeln('Popraw');
                                end;
                        end;
                        //Writeln('poza duzym ifem'); readln;
                end;
        end;


        //player vs player
        procedure Tttt.PVP;
        begin
            turn:=0;
            Writeln('inside pvp');
            createPlayer(PlayerOne);
            createPlayer(PlayerTwo);

            while not (turn = 3) do
            begin
                printBoard;
                fillCell;
                //Writeln('poza fillem'); readln;

                if turn=3 then
                begin
                    Writeln('Game is done');
                    continue;
                end;
                //writeln('po przerwaniu'); readln;

                if isWon then
                begin
                        if turn=0 then
                                Writeln('Player: ', PlayerOne.fname, ' ', PlayerOne.sname, ' won!')
                        else
                                Writeln('Player: ', PlayerTwo.fname, ' ', PlayerTwo.sname, ' won!');

                        turn:=3;
                        printBoard;

                        continue;
                end;
                //Writeln('po iswon'); readln;
                if isDraw then
                begin
                        Writeln('Draw!');
                        turn:=3;
                        continue;
                end;

                if turn=0 then
                        turn:=1
                else
                        turn:=0;
            end;
        end;



        {checks x,y}
        function Tttt.check(x,y:Byte): Boolean;
        begin
                if Fields[x][y] = ' ' then
                        check:=true
                else
                        check:=false;
        end;


        {computer fills cell}
        procedure Tttt.computerFills();
        var
                x,y: Byte;
        begin
                x:=Random(3);
                y:=Random(3);

                while not(check(x, y)) do
                begin
                        x:=Random(3);
                        y:=Random(3);
                end;

                Fields[x][y] := 'O';
        end;



        //player vs computer
        procedure Tttt.PVC;
        begin
                turn:=0;

                createPlayer(PlayerOne);
                createBoard;

                while (turn = 0) or (turn = 1) do
                begin
                        case turn of
                                //computer turn
                                0: computerFills;

                                //player turn
                                1:
                                begin
                                        fillCell;
                                        if turn = 3 then
                                        begin
                                                Writeln('Game is stopped');
                                                continue;
                                        end;
                                end;
                        end;

                        printBoard;

                        if isWon then
                        begin
                                if turn = 1 then
                                        Writeln('Player ', PlayerOne.fname, ' ', PlayerOne.sname, ' won!')
                                else
                                        Writeln('Computer has won!');

                                turn:=3;
                                continue;
                        end;

                        if isDraw then
                        begin
                                Writeln('Draw');
                                turn:=3;
                                continue;
                        end;

                        if turn=0 then
                                turn:=1
                        else
                                turn:=0;

                end;

        end;


end.
