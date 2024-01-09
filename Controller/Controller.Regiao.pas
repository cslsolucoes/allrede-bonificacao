unit Controller.Regiao;

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
  Model.Regiao,
  uUtilitarios
  ;
const
 LineEnding = #13#10;

 procedure RegistrarEndponts;

 procedure endpointRegiaoListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointRegiaoAdicionar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointRegiaoEditar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointRegiaoExcluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarEndponts;
Begin
    THorse.Get('/regiao', endpointRegiaoListar);
    THorse.Get('/regiao/:id', endpointRegiaoListar);
    THorse.Post('/regiao', endpointRegiaoAdicionar);
    THorse.Put('/regiao', endpointRegiaoEditar);
    THorse.Delete('/regiao/:id', endpointRegiaoExcluir);

End;

procedure endpointRegiaoListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg : TRegiao;
  Txt : String;
Begin
  reg := TRegiao.Create;

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

  try
     Try
       txt := reg.Listar;
       res.Send(txt).Status(200);
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

procedure endpointRegiaoAdicionar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TRegiao;
  Txt  : String;
  body : TJsonValue;
Begin

  txt := LineEnding +
  '--Inicio (' + DateToStr(Date) + '  ' + TimeToStr(Time) +') --------------------------------' + LineEnding +
  format('Caminho : %s ', [req.PathInfo]) + LineEnding +
  format('Qtd Query : %d',[req.Query.Content.Count]) + LineEnding +
  format('Filtro : %s ', [req.Query.Content.CommaText]) + LineEnding +
  format('Qtd Parametros : %d',[req.Params.Count]) + LineEnding +
  format('Parametros : %s ', [req.Params.Content.CommaText]) + LineEnding + LineEnding;

  Writeln(txt);

  res.AddHeader('Content-Type','application/json');

  try
     Try

       body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

       reg  := TRegiao.Create;

       reg.Nome                := body.GetValue<String>('nome'                      ,'');
       reg.Id_setor            := body.GetValue<Integer>('id_setor'                 ,-1);
       reg.Id_setor_primario   := body.GetValue<Integer>('id_setor_primario'        ,-1);
       reg.Id_Subregiao        := body.GetValue<Integer>('id_subregiao'             ,-1);
       reg.Id_RegiaoReferencia := body.GetValue<Integer>('id_regiaoreferencia'      ,-1);
       reg.Id_GrupoServico     := body.GetValue<Integer>('id_grupo_cliente_servico' ,-1);
       reg.Ativo               := body.GetValue<Boolean>('ativo'                    ,True);
       reg.Deleted             := body.GetValue<Boolean>('deletado'                 ,False);

       writeln('Body recebido:' + LineEnding + req.Body + LineEnding + '----' );
       txt := reg.Inserir;
       res.Send(txt).Status(201);
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
  Finally
    reg.Free;
    body.Free;
  End;
End;

procedure endpointRegiaoEditar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TRegiao;
  Txt  : String;
  body : TJsonValue;
  Valida : TJSONObject;
Begin
  txt := LineEnding +
  '--Inicio (' + DateToStr(Date) + '  ' + TimeToStr(Time) +') --------------------------------' + LineEnding +
  format('Caminho : %s ', [req.PathInfo]) + LineEnding +
  format('Qtd Query : %d',[req.Query.Content.Count]) + LineEnding +
  format('Filtro : %s ', [req.Query.Content.CommaText]) + LineEnding +
  format('Qtd Parametros : %d',[req.Params.Count]) + LineEnding +
  format('Parametros : %s ', [req.Params.Content.CommaText]) + LineEnding + LineEnding;
  Writeln(txt);

  res.AddHeader('Content-Type','application/json');

  try
     Try
       body   := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
       Valida := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONObject;

       if Not (Valida.GetValue('id') <> nil) then begin
         res.Send(
                  format( ' {                                                                            ' + LineEnding +
                          '     "status": "error"                                                        ' + LineEnding +
                          '     "msg": "Informe o id de regra, Tabela: %s  erro: Faltou informar o id",  ' + LineEnding +
                          ' }                                                                            ' + LineEnding ,[reg.Tabela])
                 ).Status(405);
         Exit;
       End;



       reg  := TRegiao.Create;

       reg.id                     := body.GetValue<Integer>('id',-1);

       if Valida.GetValue('nome') <> nil then
          reg.nome                := body.GetValue<string>('nome'               ,'');

       if Valida.GetValue('id_setor') <> nil then
          reg.Id_setor            := body.GetValue<Integer>('id_setor'          ,-1);

       if Valida.GetValue('id_setor_primario') <> nil then
          reg.Id_setor_primario   := body.GetValue<Integer>('id_setor_primario' ,-1);

       if Valida.GetValue('id_subregiao') <> nil then
          reg.Id_Subregiao        := body.GetValue<Integer>('id_subregiao'        ,-1);

       if Valida.GetValue('id_regiaoreferencia') <> nil then
          reg.Id_RegiaoReferencia := body.GetValue<Integer>('id_regiaoreferencia' ,-1);

       if Valida.GetValue('id_grupo_cliente_servico') <> nil then
          reg.Id_GrupoServico     := body.GetValue<Integer>('id_grupo_cliente_servico' ,-1);

       if Valida.GetValue('ativo') <> nil then
          reg.Ativo               := body.GetValue<Boolean>('ativo'         ,True);

       if Valida.GetValue('deletado') <> nil then
          reg.Deleted             := body.GetValue<Boolean>('deletado'      ,False);

       writeln('Body recebido:' + LineEnding + req.Body + LineEnding + '----' );
       txt :=reg.Editar;
       res.Send(txt).Status(202);
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
  Finally
    reg.Free;
    body.Free;
  End;

End;

procedure endpointRegiaoExcluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TRegiao;
  Txt  : String;
Begin

  txt := LineEnding +
  '--Inicio (' + DateToStr(Date) + '  ' + TimeToStr(Time) +') --------------------------------' + LineEnding +
  format('Caminho : %s ', [req.PathInfo]) + LineEnding +
  format('Qtd Query : %d',[req.Query.Content.Count]) + LineEnding +
  format('Filtro : %s ', [req.Query.Content.CommaText]) + LineEnding +
  format('Qtd Parametros : %d',[req.Params.Count]) + LineEnding +
  format('Parametros : %s ', [req.Params.Content.CommaText]) + LineEnding + LineEnding;

  Writeln(txt);

  res.AddHeader('Content-Type','application/json');

  if Not (Req.Params['id'].ToInteger > 0) then Begin
    res.Send(
             format( ' {                                                                            ' + LineEnding +
                     '     "status": "error"                                                        ' + LineEnding +
                     '     "msg": "Informe o id de regra, Tabela: %s  erro: Faltou informar o id",  ' + LineEnding +
                     ' }                                                                            ' + LineEnding ,[reg.Tabela])
            ).Status(405);
    Exit;
  End;

  res.AddHeader('Content-Type','application/json');
  try
     Try
       reg := TRegiao.Create;
       reg.id := Req.Params['id'].ToInteger;
       txt := reg.Excluir;
       res.Send(txt).Status(200);
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
  Finally
    reg.Free;
  End;

End;

end.
