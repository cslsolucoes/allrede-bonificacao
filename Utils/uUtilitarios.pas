unit uUtilitarios;

interface

uses
 {$ifdef FPC}
 {$else}
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  Data.DB,
  //Winapi.ShellAPI,
  system.Types,system.UITypes, system.Classes
 {$endif }
 // Windows
  ;

Const
  EmptyStr = '';
  LineEnding = #13#10;
  Versao = '1.0.3';
  APP_descricao    = 'bonificacao';
  APP_id           = 6;

  acentos : array [1..46] of String [2] = ('�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,
                                           '�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,
                                           '�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,
                                           '�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,'�' ,
                                           '�' ,'�' ,'�' ,'�' ,'�' ,'�' );

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

  UTF8Acentos  : array [1..46] of String [2] = ('á','� ','â','ã','ä','é','è','ê','ë','í',
                                                'ì','î','ï','ó','ò','ô','õ','ö','ú','ù',
                                                'û','ü','ç','�' ,'À','Â','Ã','Ä','É','È',
                                                'Ê','Ë','�' ,'Ì','Î','�','Ó','Ò','Ô','Õ',
                                                'Ö','Ú','Ù','Û','Ü','Ç');

Type
    TByteArr   = array of byte;
    TStringArr = array of String;

//Var
//  _HWND             : HWND ;

Procedure log(valor : String; const arquivo : String = '');
Function  StringToByte(Valor : String): TBytes;
Function  AcentosUFT8(Valor: String): String;
//Function  ExecutaL(Comando, Parametro: String; const LocalExecucao: String ): Boolean;
Function  FCrypta   (VFString:String): String;
Function  FDesCrypta(VFString:String): String;

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
    linha := LineEnding + '--Final (' + DateToStr(Date) + '  ' + TimeToStr(Time) +') -------------------------------- API Vers�o '+ Versao + LineEnding + LineEnding;;
    Writeln(linha);
    Writeln(arq, l + valor + linha);
    CloseFile(arq);
  except
    Writeln('Erro: Arquivo ' + arquivo + ' est� em uso no momento');
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
{
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
    Writeln(Comando + ' n�o existe');
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
}
Function  FCrypta(VFString:String): String;

         Function StrZero(VFString: String; VFTamanho: Integer): String;
         Var
         VFRetorno       : String;
         I,
         VFZerosAColocar : Integer;
         Begin
         VFZerosAColocar := VFTamanho - Length(TrimLeft(TrimRight(VFString)));
         VFRetorno       := '';

         For I := 1 To VFZerosAColocar Do
             VFRetorno := VFRetorno + '0';

         Result := VFRetorno + TrimLeft(TrimRight(VFString));
         End;


         function FAsc(VFString : String) : Integer;
         var
         VFS: String;
         begin
         VFS    := VFString;
         Result := Ord(VFS[1]);
         end;


         function PDireita(VFString : String; VFQuantidade : Integer) : String;
         begin
              Result := Copy(VFString,Length(VFString)-VFQuantidade+1,VFQuantidade);
         end;

Var
   Y,
   VTamanho,
   k        : Word;
   VAsc     : Real;
   VCrypta  : String;
   VNumAsc,
   VAjuda,
   VFLetra  : String;
   VImpar   : Boolean;
Begin
   VTamanho := Length(trim(VFString));
   VCrypta  := '';
   VNumAsc  := '';
   VFString := Trim(VFString);
   For y := 1 To VTamanho Do
       Begin
       VFLetra  := Copy(VFString,y,1);
       VNumAsc  := StrZero(FloatToStr(FAsc(VFLetra)),3);
       VAjuda   := '';
       For k := 3 Downto 1 Do
           VAjuda := VAjuda + copy(VNumAsc,k,1);

       VImpar := False;

       If (y mod 2) = 0 Then
          VAsc   := StrToFloat(VAjuda)
       Else
          Begin
          VAsc   := StrToFloat(Vajuda)+3;
          VImpar := True;
       End;

       If VAsc > 255 Then
          If Vimpar Then
             VCrypta := VCrypta + Chr(252)+Chr(145)+Chr(254)+Chr(StrToInt(Copy(StrZero(FloatToStr(VAsc),3),1,2)))+Chr(StrToInt(PDireita(StrZero(FloatToStr(VAsc),3),2)))
          Else
             VCrypta := VCrypta + Chr(252)+Chr(145)+Chr(247)+Chr(StrToInt(Copy(StrZero(FloatToStr(VAsc),3),1,2)))+Chr(StrToInt(PDireita(StrZero(FloatToStr(VAsc),3),2)))
       Else
          If Vimpar Then
             VCrypta := VCrypta + Chr(254)+ Chr(StrToInt(FloatToStr(VAsc)))
          Else
             VCrypta := VCrypta + Chr(247)+ Chr(StrToInt(FloatToStr(VAsc)));
   End;
   Result := VCrypta;
End;

function FDesCrypta(VFString: String): String;

         Function StrZero(VFString: String; VFTamanho: Integer): String;
         Var
         VFRetorno       : String;
         I,
         VFZerosAColocar : Integer;
         Begin
         VFZerosAColocar := VFTamanho - Length(TrimLeft(TrimRight(VFString)));
         VFRetorno       := '';

         For I := 1 To VFZerosAColocar Do
             VFRetorno := VFRetorno + '0';

         Result := VFRetorno + TrimLeft(TrimRight(VFString));
         End;


         function FAsc(VFString : String) : Integer;
         var
         VFS: String;
         begin
         VFS    := VFString;
         Result := Ord(VFS[1]);
         end;


         function PDireita(VFString : String; VFQuantidade : Integer) : String;
         begin
              Result := Copy(VFString,Length(VFString)-VFQuantidade+1,VFQuantidade);
         end;

Var
   y,
   k         : Word;
   VCrypta,
   VProc,
   VFLetra,
   VAjuda,
   VNumASc   : String;
   VAsc      : Real;
   VPrimNum,
   VContProc,
   VPegouPar,
   VPar,
   VParLetra : Boolean;
Begin
   VCrypta    := '';
   VProc      := '';
   VNumASc    := '';
   VPrimNum   := False;
   VContProc  := False;
   VPegouPar := False;
   VParLetra  := False;
   For y := 1 To Length(VFString) Do
       Begin
       VFLetra  := Copy(VFString,y,1);
       If (FAsc(VFLetra) = 252) And (VProc = '') Then
          Begin
          VProc := Vproc + VFletra;
          Continue;
       End;
       If (FAsc(VFLetra) = 145) And (VFLetra <> '') Then
          Begin
          VProc := VProc + VFletra;
          Continue;
       End;
       If VProc = Chr(252)+Chr(145) Then
          Begin
          VPrimNum  := True;
          VProc     := '';
          If VFLetra = Chr(247) Then
             VPar := True
          Else
             VPar := False;

          VPegoupar := True;
          Continue;
       End;
       If VPrimNum Then
          Begin
          VPrimNum := False;
          VNumAsc  := Trim(FloatToStr(FAsc(VFLetra)));
          Continue;
       End;
       If VPegoupar Then
          Begin
          VPegouPar := False;
          VNumAsc   := VNumAsc + PDireita(Trim(FloatToStr(FAsc(VFLetra))),1);
          VAsc      := StrToFloat(VNumASc);
          If Not Vpar Then
             VAsc  := VAsc - 3;

          VAjuda := '';
          For k := 3 Downto 1 Do
              VAjuda := VAjuda + Copy(FloatToStr(VAsc),k,1);

          VAsc := StrToFloat(VAjuda);
       End
       Else
          Begin
          If Not VParLetra Then
             Begin
             If VFletra = Chr(247) Then
                VPar := True
             Else
                Vpar := False;

             VParLetra := True;
             Continue;
          End
          Else
            VParletra := False;

          VAjuda := FloatToStr(FAsc(VFLetra));

          If VPar Then
             VAsc := StrToFloat(VAjuda)
          Else
             VAsc := StrToFloat(VAjuda) - 3;

          VNumAsc  := StrZero(FloatToStr(VAsc),3);
          VAjuda   := '';
          For k := 3 Downto 1 Do
              VAjuda := VAjuda + Copy(VNumAsc,k,1);

          VAsc := StrToFloat(VAjuda);
       End;
       VCrypta := VCrypta + Chr(StrToInt(FloatToStr(VAsc)));
   End;
   Result := VCrypta;
end;

end.

