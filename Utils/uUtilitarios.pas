unit uUtilitarios;

interface

uses
 {$ifdef FPC}
 {$else}
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  Data.DB,
  Winapi.ShellAPI,
  system.Types,system.UITypes, Vcl.Controls,
  Messages, system.Classes, Vcl.Dialogs,vcl.Forms,
 {$endif }
  Windows
  ;

Const
  EmptyStr = '';
  LineEnding = #13#10;
  Versao = '1.0.3';


  acentos : array [1..46] of String [2] = ('á' ,'à' ,'â' ,'ã' ,'ä' ,'é' ,'è' ,'ê' ,'ë' ,'í' ,
                                           'ì' ,'î' ,'ï' ,'ó' ,'ò' ,'ô' ,'õ' ,'ö' ,'ú' ,'ù' ,
                                           'û' ,'ü' ,'ç' ,'Á' ,'À' ,'Â' ,'Ã' ,'Ä' ,'É' ,'È' ,
                                           'Ê' ,'Ë' ,'Í' ,'Ì' ,'Î' ,'Ï' ,'Ó' ,'Ò' ,'Ô' ,'Õ' ,
                                           'Ö' ,'Ú' ,'Ù' ,'Û' ,'Ü' ,'Ç' );

  semacentos : array[1..46] of String[2]= ('a' ,'a' ,'a' ,'a' ,'a' ,'e' ,'e' ,'e' ,'e' ,'i' ,
                                           'i' ,'i' ,'i' ,'o' ,'o' ,'o' ,'o' ,'o' ,'u' ,'u' ,
                                           'u' ,'u' ,'c' ,'A' ,'A' ,'A' ,'A' ,'A' ,'E' ,'E' ,
                                           'E' ,'E' ,'I' ,'I' ,'I' ,'I' ,'O' ,'O' ,'O' ,'O' ,
                                           'O' ,'U' ,'U' ,'U' ,'U' ,'C' );

  unicode : array [1..46] of String [6] = (
  '\U00E1' ,'\U00E0' ,'\U00E2' ,'\U00E3' ,'\U00E4' ,'\U00E9' ,'\U00E8' ,'\U00EA' ,'\U00EB' ,'\U00ED' ,
  '\U00EC' ,'\U00EE' ,'\U00EF' ,'\U00F3' ,'\U00F2' ,'\U00F4' ,'\U00F5' ,'\U00F6' ,'\U00FA' ,'\U00F9' ,
  '\U00FB' ,'\U00FC' ,'\U00E7' ,'\U00C1' ,'\U00C0' ,'\U00C2' ,'\U00C3' ,'\U00C4' ,'\U00C9' ,'\U00C8' ,
  '\U00CA' ,'\U00CB' ,'\U00CD' ,'\U00CC' ,'\U00CE' ,'\U00CF' ,'\U00D3' ,'\U00D2' ,'\U00D4' ,'\U00D5' ,
  '\U00D6' ,'\U00DA' ,'\U00D9' ,'\U00DB' ,'\U00DC' ,'\U00C7');

  UTF8Acentos  : array [1..46] of String [2] = ('Ã¡','Ã ','Ã¢','Ã£','Ã¤','Ã©','Ã¨','Ãª','Ã«','Ã­',
                                                'Ã¬','Ã®','Ã¯','Ã³','Ã²','Ã´','Ãµ','Ã¶','Ãº','Ã¹',
                                                'Ã»','Ã¼','Ã§','Ã' ,'Ã€','Ã‚','Ãƒ','Ã„','Ã‰','Ãˆ',
                                                'ÃŠ','Ã‹','Ã' ,'ÃŒ','ÃŽ','Ã','Ã“','Ã’','Ã”','Ã•',
                                                'Ã–','Ãš','Ã™','Ã›','Ãœ','Ã‡');

Type
    TByteArr   = array of byte;
    TStringArr = array of String;

Var
  _HWND             : HWND ;


Procedure log(valor : String; const arquivo : String = '');
Function  StringToByte(Valor : String): TBytes;
Function  AcentosUFT8(Valor: String): String;
Function  ExecutaL(Comando, Parametro: String; const LocalExecucao: String ): Boolean;

implementation

Procedure log(valor : String; const arquivo : String = '');
Var
   arq: TextFile;
   NomeArq : String;
   linha : String;
   l : String;
begin
  If arquivo = EmptyStr Then Begin
    NomeArq := ExtractFileName(ParamStr(0)) + '.txt'
  end
  Else Begin
    NomeArq := arquivo;
  end;
  l := '';
  //l := LineEnding + '--Inicio (' + DateToStr(Date) + '  ' + TimeToStr(Time) +') --------------------------------' + LineEnding + LineEnding;
  try
    AssignFile(arq,NomeArq);
      If  FileExists(arquivo)
      //and FileExists('debug.txt')
       Then
        Append(arq)
      Else
        Rewrite(arq);
    linha := LineEnding + '--Final (' + DateToStr(Date) + '  ' + TimeToStr(Time) +') -------------------------------- API Versão '+ Versao + LineEnding + LineEnding;;
    Writeln(linha);
    Writeln(arq, l + valor + linha);
    CloseFile(arq);
  except
    Writeln('Erro: Arquivo ' + arquivo + ' está em uso no momento');
  end;
End;

Function  StringToByte(Valor : String): TBytes;
begin
  Result := BytesOf(Valor)
End;

Function  AcentosUFT8(Valor: String): String;
Var
  i,l : integer;
  str : String;
  v   : Boolean;
begin
  str := Valor;
  v := False;
  for i := 1 to 46 do Begin
    str := stringreplace(str,acentos[i] , UTF8Acentos[i],[rfReplaceAll])
  end;
  Result := str ;
end;

Function ExecutaL(Comando, Parametro: String; const LocalExecucao: String ): Boolean;
Var
  Command      : Array[0..1024] of Char;
  Param        : Array[0..1024] of Char;
  DirTrab      : Array[0..1024] of Char;
  i            : integer;
  C,P          : String;
begin

  if Not FileExists(Comando) then
  Begin
    Writeln(Comando + ' não existe');
    EXIT;
  End;


  C := Comando;
  P := Parametro;
//  log(C + ' ' + P,'COMANDO');
  Writeln('Executado: ' + C + ' ' + P);
  StrPCopy(Command ,C);
  StrPCopy(Param   ,P);
  StrPCopy(DirTrab,ExtractFilePath(C));

  ShellExecute(_HWND,nil,Command,Param,DirTrab,0);
end;

end.

