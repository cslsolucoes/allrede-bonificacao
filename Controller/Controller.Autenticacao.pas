unit Controller.Autenticacao;

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
  Model.Autenticacao,
  uUtilitarios
  ;
const
 LineEnding = #13#10;

 procedure RegistrarEndponts;
 procedure endpointAutenticacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);


implementation
procedure RegistrarEndponts;
Begin
   THorse.Post('/login', endpointAutenticacao);

End;

procedure endpointAutenticacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
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
  format('Parametros : %s ', [req.Params.Content.CommaText]) + LineEnding + LineEnding +
  format(LineEnding +'%s' ,[req.Body]);
  Writeln(txt);


  body   := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
  Valida := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONObject;

  txt :=
         format( ' {                                                                            ' + LineEnding +
                 '     "status": "error",                                                       ' + LineEnding +
                 '     "msg": "Favor preencher os campos obrigatórios de acordo com as especificaçõe" ' + LineEnding +
                 ' }                                                                            ' + LineEnding ,[]);

  res.AddHeader('Content-Type','application/json');

  if Not (Valida.GetValue('email') <> nil) then
  Begin
    res.Send(txt).Status(405);
    Exit;
  End;

  if Not (Valida.GetValue('senha') <> nil) then
  Begin
    res.Send(txt).Status(405);
    Exit;
  End;

  try
     Try
       Txt := Autenticacao( body.GetValue<string>('email',''),body.GetValue<string>('senha',''));

       Valida := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(txt), 0) as TJSONObject;

       writeln(Valida.GetValue<string>('status',''));

       if not (Valida.GetValue<string>('status','') = 'error') then
          res.Send(txt).Status(200)
       Else
          res.Send(txt).Status(401);

     except on ex:exception do
          begin
            res.Send(
                       format( ' {                               ' + LineEnding +
                               '     "status": "error"           ' + LineEnding +
                               '     "msg":"%s",                 ' + LineEnding +
                               ' }                               ' + LineEnding ,[ex.Message])
                   ).Status(500);
            exit;
          end;
     end;
  Finally

  End;

End;

end.
