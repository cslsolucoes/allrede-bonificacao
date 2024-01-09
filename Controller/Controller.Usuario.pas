unit Controller.Usuario;

interface
  uses
  {$ifdef FPC}
     SysUtils,StrUtils,DateUtils,Classes,IniFiles,DB,
  {$else}
     System.SysUtils,System.StrUtils, System.DateUtils, System.Classes,  System.IniFiles, Data.DB,
  {$endif}
  System.JSON,
  MemDS, DBAccess, Uni, PostgreSQLUniProvider,
  Horse,
  DataSet.Serialize,
  Model.Conexao,
  Model.Usuario,
  uUtilitarios
  ;
const
 LineEnding = #13#10;

 procedure RegistrarEndponts;

 procedure endpointUsuarioListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarEndponts;
Begin
    THorse.Get('/usuario', endpointUsuarioListar);
    THorse.Get('/usuario/:id', endpointUsuarioListar);
End;

procedure endpointUsuarioListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg : TUsuario;
  Txt : String;
Begin
  reg := TUsuario.Create;

  txt := LineEnding +
  '--Inicio (' + DateToStr(Date) + '  ' + TimeToStr(Time) +') --------------------------------' + LineEnding +
  format('Caminho : %s ', [req.PathInfo]) + LineEnding +
  format('Qtd Query : %d',[req.Query.Content.Count]) + LineEnding +
  format('Filtro : %s ', [req.Query.Content.CommaText]) + LineEnding +
  format('Qtd Parametros : %d',[req.Params.Count]) + LineEnding +
  format('Parametros : %s ', [req.Params.Content.CommaText]) + LineEnding + LineEnding;
  Writeln(txt);
  res.AddHeader('Content-Type','application/json');

  if (req.Params.Count > 0) then
  Begin
    if not req.Params.Items['id'].IsEmpty then
    Begin
      if Not (Req.Params['id'].ToInteger > 0) then Begin
        res.Send(
                 format( ' {                                                                            ' + LineEnding +
                         '     "status": "error"                                                        ' + LineEnding +
                         '     "msg": "Informe o id de regra, Tabela: %s  erro: Faltou informar o id",  ' + LineEnding +
                         ' }                                                                            ' + LineEnding ,[reg.Tabela])
                ).Status(405);
        exit;
      End;
      reg.id := req.Params.Items['id'].ToInteger;
    End;
  end;

  if (req.Query.Count > 0) then
  Begin

    if not req.Query.Items['ativo'].IsEmpty then
    Begin
      if Req.Query['ativo'].ToBoolean = True then Begin
         reg.Ativo := req.Query.Items['ativo'].ToBoolean;
      End;
    End;

    if not req.Query.Items['detalhe'].IsEmpty then
    Begin
      reg.Detalhe := req.Query.Items['detalhe'].ToBoolean;
    End;

  end;

  try
     Try
       txt := reg.Listar;
      {$IFDEF MSWINDOWS}
          Res.Send(TEncoding.ANSI.GetString(BytesOf(Txt))).Status(200);
      {$ELSE}
          Res.Send(TEncoding.UTF8.GetString(BytesOf(Txt))).Status(200);
      {$ENDIF}
     Finally
       reg.Free;
     End;
  except on ex:exception do
      begin
        res.Send(
                   format( ' {                                                                            ' + LineEnding +
                           '     "status": "error"                                                        ' + LineEnding +
                           '     "msg": "Erro ao conectar com o banco, Tabela: %s  erro: %s",             ' + LineEnding +
                           ' }                                                                            ' + LineEnding ,[reg.Tabela,ex.Message])
               ).Status(500);
        exit;
      end;
  end;

End;

end.
