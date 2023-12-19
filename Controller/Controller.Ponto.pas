unit Controller.Ponto;

interface
  uses
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  Data.DB,
  System.JSON,
  System.Classes,
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

implementation

procedure RegistrarEndponts;
Begin
    THorse.Get('/bonificacao/ponto/regra', endpointPontoRegraListar);
    THorse.Get('/bonificacao/ponto/regra/:id', endpointPontoRegraListar);
    THorse.Post('/bonificacao/ponto/regra', endpointPontoRegraAdicionar);
    THorse.Put('/bonificacao/ponto/regra', endpointPontoRegraEditar);
    THorse.Delete('/bonificacao/ponto/regra/:id', endpointPontoRegraExcluir);
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

  if (req.Params.Count > 0) then
  Begin
    if not req.Params.Items['id'].IsEmpty then
    Begin
      if Not (Req.Params['id'].ToInteger > 0) then Begin
        res.Send('Informe o id de agenda');
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
  except
      res.Send('Erro ao conectar com o banco').Status(500);
      exit;
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
  try
     Try

       body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

       reg  := TPontoRegra.Create;

       reg.id_tipo           := body.GetValue<Integer>('Id_tipo'      ,-1);
       reg.id_grupo          := body.GetValue<Integer>('Id_grupo'     ,-1);
       reg.id_regiao         := body.GetValue<Integer>('Id_regiao'    ,-1);
       reg.Ponto             := body.GetValue<Double>('Ponto'         ,0);
       reg.Tratativa         := body.GetValue<char>('Tratativa'       ,' ');
       reg.TratativaNivel    := body.GetValue<char>('TratativaNivel'  ,' ');
       reg.TratativaTipo     := body.GetValue<char>('TratativaTipo'   ,' ');
       reg.TratativaModo     := body.GetValue<char>('TratativaModo'   ,' ');
       reg.Observacao        := body.GetValue<String>('Observacao'    ,'');
       reg.Ativo             := body.GetValue<Boolean>('Ativo'        ,True);

       writeln('Body recebido:' + LineEnding + req.Body + LineEnding + '----' );
       txt := reg.Inserir;
       res.Send(txt).Status(201);
      except
          res.Send('Erro ao conectar com o banco').Status(500);
          exit;
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
Begin
  txt := LineEnding +
  '--Inicio (' + DateToStr(Date) + '  ' + TimeToStr(Time) +') --------------------------------' + LineEnding +
  format('Caminho : %s ', [req.PathInfo]) + LineEnding +
  format('Qtd Query : %d',[req.Query.Content.Count]) + LineEnding +
  format('Filtro : %s ', [req.Query.Content.CommaText]) + LineEnding +
  format('Qtd Parametros : %d',[req.Params.Count]) + LineEnding +
  format('Parametros : %s ', [req.Params.Content.CommaText]) + LineEnding + LineEnding;
  Writeln(txt);

  try
     Try
       body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

       reg  := TPontoRegra.Create;

       reg.id                := body.GetValue<Integer>('Id',-1);
       reg.id_tipo           := body.GetValue<Integer>('Id_tipo'      ,-1);
       reg.id_grupo          := body.GetValue<Integer>('Id_grupo'     ,-1);
       reg.id_regiao         := body.GetValue<Integer>('Id_regiao'    ,-1);
       reg.Ponto             := body.GetValue<Double>('Ponto'         ,0);
       reg.Tratativa         := body.GetValue<char>('Tratativa'       ,' ');
       reg.TratativaNivel    := body.GetValue<char>('TratativaNivel'  ,' ');
       reg.TratativaTipo     := body.GetValue<char>('TratativaTipo'   ,' ');
       reg.TratativaModo     := body.GetValue<char>('TratativaModo'   ,' ');
       reg.Observacao        := body.GetValue<String>('Observacao'    ,'');
       reg.Ativo             := body.GetValue<Boolean>('Ativo'        ,True);

       writeln('Body recebido:' + LineEnding + req.Body + LineEnding + '----' );
       txt :=reg.Editar;
       res.Send(txt).Status(202);
      except
       res.Send('Erro ao conectar com o banco').Status(500);
       exit;
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

  if Not (Req.Params['id'].ToInteger > 0) then Begin
    res.Send('Informe o id de reagendamento');
    exit;
  End;


  try
     Try
       reg := TPontoRegra.Create;
       reg.id := Req.Params['id'].ToInteger;
       txt := reg.Excluir;
       res.Send(txt).Status(200);
      except
       res.Send('Erro ao conectar com o banco').Status(500);
       exit;
      end;
  Finally
    reg.Free;
  End;

End;

end.
