unit Controller.Ponto;

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
  Model.Ponto,
  uUtilitarios
  ;
const
 LineEnding = #13#10;

 procedure RegistrarEndponts;

 procedure endpointPontoRegraListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoRegraAdicionar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoRegraEditar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoRegraExcluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

 procedure endpointPontoMetaListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoMetaAdicionar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoMetaEditar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoMetaExcluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

 procedure endpointPontoPenalidadeListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoPenalidadeAdicionar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoPenalidadeEditar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
 procedure endpointPontoPenalidadeExcluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarEndponts;
Begin
    THorse.Get('/bonificacao/ponto/regra', endpointPontoRegraListar);
    THorse.Get('/bonificacao/ponto/regra/:id', endpointPontoRegraListar);
    THorse.Post('/bonificacao/ponto/regra', endpointPontoRegraAdicionar);
    THorse.Put('/bonificacao/ponto/regra', endpointPontoRegraEditar);
    THorse.Delete('/bonificacao/ponto/regra/:id', endpointPontoRegraExcluir);

    THorse.Get('/bonificacao/ponto/meta', endpointPontoMetaListar);
    THorse.Get('/bonificacao/ponto/meta/:id', endpointPontoMetaListar);
    THorse.Post('/bonificacao/ponto/meta', endpointPontoMetaAdicionar);
    THorse.Put('/bonificacao/ponto/meta', endpointPontoMetaEditar);
    THorse.Delete('/bonificacao/ponto/meta/:id', endpointPontoMetaExcluir);

    THorse.Get('/bonificacao/ponto/penalidade', endpointPontoPenalidadeListar);
    THorse.Get('/bonificacao/ponto/penalidade/:id', endpointPontoPenalidadeListar);
    THorse.Post('/bonificacao/ponto/penalidade', endpointPontoPenalidadeAdicionar);
    THorse.Put('/bonificacao/ponto/penalidade', endpointPontoPenalidadeEditar);
    THorse.Delete('/bonificacao/ponto/penalidade/:id', endpointPontoPenalidadeExcluir);
End;

procedure endpointPontoRegraListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg : TPontoRegra;
  Txt : String;
Begin
  reg := TPontoRegra.Create;

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

procedure endpointPontoRegraAdicionar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoRegra;
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

       reg  := TPontoRegra.Create;

       reg.id_tipo           := body.GetValue<Integer>('id_tipo'       ,-1);
       reg.id_grupo          := body.GetValue<Integer>('id_grupo'      ,-1);
       reg.id_regiao         := body.GetValue<Integer>('id_regiao'     ,-1);
       reg.Ponto             := body.GetValue<Double>('ponto'          ,-1);
       reg.PontoRetirar      := body.GetValue<Double>('ponto_ret'      ,-1);
       reg.Tratativa         := body.GetValue<char>('tratativa'        ,' ');
       reg.TratativaNivel    := body.GetValue<char>('tratativa_nivel'  ,' ');
       reg.TratativaTipo     := body.GetValue<char>('tratativa_tipo'   ,' ');
       reg.TratativaModo     := body.GetValue<char>('tratativa_modo'   ,' ');
       reg.NivelDificuldade  := body.GetValue<char>('nivel_dificuldade',' ');
       reg.Observacao        := body.GetValue<String>('observacao'     ,'');

       reg.Comos             := body.GetValue<Boolean>('com_os'        ,False);
       reg.Ativo             := body.GetValue<Boolean>('ativo'         ,True);
       reg.Deleted           := body.GetValue<Boolean>('deletado'      ,False);

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

procedure endpointPontoRegraEditar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoRegra;
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



       reg  := TPontoRegra.Create;

       reg.id                   := body.GetValue<Integer>('id',-1);

       if Valida.GetValue('id_tipo') <> nil then
          reg.id_tipo           := body.GetValue<Integer>('id_tipo'       ,-1);
       if Valida.GetValue('id_grupo') <> nil then
          reg.id_grupo          := body.GetValue<Integer>('id_grupo'      ,-1);
       if Valida.GetValue('id_regiao') <> nil then
          reg.id_regiao         := body.GetValue<Integer>('id_regiao'     ,-1);
       if Valida.GetValue('ponto') <> nil then
          reg.Ponto             := body.GetValue<Double>('ponto'          ,-1);
       if Valida.GetValue('ponto_ret') <> nil then
          reg.PontoRetirar      := body.GetValue<Double>('ponto_ret'      ,-1);
       if Valida.GetValue('tratativa') <> nil then
          reg.Tratativa         := body.GetValue<char>('tratativa'        ,' ');
       if Valida.GetValue('tratativa_nivel') <> nil then
          reg.TratativaNivel    := body.GetValue<char>('tratativa_nivel'  ,' ');
       if Valida.GetValue('tratativa_tipo') <> nil then
          reg.TratativaTipo     := body.GetValue<char>('tratativa_tipo'   ,' ');
       if Valida.GetValue('tratativa_modo') <> nil then
          reg.TratativaModo     := body.GetValue<char>('tratativa_modo'   ,' ');
       if Valida.GetValue('nivel_dificuldade') <> nil then
          reg.NivelDificuldade  := body.GetValue<char>('nivel_dificuldade',' ');
       if Valida.GetValue('observacao') <> nil then
          reg.Observacao        := body.GetValue<String>('observacao'     ,'');
       if Valida.GetValue('com_os') <> nil then
          reg.Comos             := body.GetValue<Boolean>('com_os'        ,False);
       if Valida.GetValue('ativo') <> nil then
          reg.Ativo             := body.GetValue<Boolean>('ativo'         ,True);
       if Valida.GetValue('deletado') <> nil then
          reg.Deleted           := body.GetValue<Boolean>('deletado'      ,False);

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

procedure endpointPontoRegraExcluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoRegra;
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


  try
     Try
       reg := TPontoRegra.Create;
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

procedure endpointPontoMetaListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg : TPontoMeta;
  Txt : String;
Begin
  reg := TPontoMeta.Create;

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

procedure endpointPontoMetaAdicionar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoMeta;
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

       reg  := TPontoMeta.Create;

       reg.id_regiao           := body.GetValue<Integer>('id_regiao'     ,-1);
       reg.id_grupo            := body.GetValue<Integer>('id_grupo'      ,-1);
       reg.PontoInicial        := body.GetValue<Integer>('ponto_inicial' ,-1);
       reg.PontoFinal          := body.GetValue<Integer>('ponto_final'   ,-1);
       reg.PontoValor          := body.GetValue<double>('ponto_valor'    ,-1);
       reg.PontoTipo           := body.GetValue<Char>('ponto_tipo'       , ' ');
       reg.PontoMedio          := body.GetValue<Boolean>('ponto_medio'   ,False);
       reg.Id_grupo_Referencia := body.GetValue<Integer>('id_grupo_referencia' ,-1);
       reg.Observacao          := body.GetValue<String>('observacao'     ,'');
       reg.Ativo               := body.GetValue<Boolean>('ativo'         ,True);
       reg.Deleted             := body.GetValue<Boolean>('deletado'      ,False);

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

procedure endpointPontoMetaEditar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoMeta;
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

       reg  := TPontoMeta.Create;

       reg.id                := body.GetValue<Integer>('id',-1);

       if Valida.GetValue('id_regiao') <> nil then
          reg.id_regiao           := body.GetValue<Integer>('id_regiao'     ,-1);
       if Valida.GetValue('id_grupo') <> nil then
          reg.id_grupo            := body.GetValue<Integer>('id_grupo'      ,-1);
       if Valida.GetValue('ponto_inicial') <> nil then
          reg.PontoInicial        := body.GetValue<Integer>('ponto_inicial'  ,-1);
       if Valida.GetValue('ponto_final') <> nil then
          reg.PontoFinal          := body.GetValue<Integer>('ponto_final'    ,-1);
       if Valida.GetValue('ponto_valor') <> nil then
          reg.PontoValor          := body.GetValue<Double>('ponto_valor'    ,-1);
       if Valida.GetValue('ponto_tipo') <> nil then
          reg.PontoTipo           := body.GetValue<char>('ponto_tipo'       ,' ');
       if Valida.GetValue('id_grupo_referencia') <> nil then
          reg.Id_grupo_Referencia := body.GetValue<Integer>('id_grupo_referencia' ,-1);
       if Valida.GetValue('observacao') <> nil then
          reg.Observacao          := body.GetValue<String>('observacao'     ,'');

       if Valida.GetValue('ponto_medio') <> nil then
          reg.PontoMedio          := body.GetValue<Boolean>('ponto_medio'   ,false);
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

procedure endpointPontoMetaExcluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoMeta;
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


  try
     Try
       reg := TPontoMeta.Create;
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

procedure endpointPontoPenalidadeListar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg : TPontoPenalidade;
  Txt : String;
Begin
  reg := TPontoPenalidade.Create;

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

procedure endpointPontoPenalidadeAdicionar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoPenalidade;
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

       reg  := TPontoPenalidade.Create;

       reg.Descricao           := body.GetValue<string>('descricao'      ,'');
       reg.Observacao          := body.GetValue<String>('observacao'     ,'');
       reg.Ativo               := body.GetValue<Boolean>('ativo'         ,True);
       reg.Deleted             := body.GetValue<Boolean>('deletado'      ,False);

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

procedure endpointPontoPenalidadeEditar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoPenalidade;
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

       reg  := TPontoPenalidade.Create;

       reg.id                := body.GetValue<Integer>('id',-1);

       if Valida.GetValue('descricao') <> nil then
          reg.Descricao           := body.GetValue<string>('descricao'     ,'');
       if Valida.GetValue('observacao') <> nil then
          reg.Observacao          := body.GetValue<String>('observacao'     ,'');
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

procedure endpointPontoPenalidadeExcluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  reg  : TPontoMeta;
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


  try
     Try
       reg := TPontoMeta.Create;
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
