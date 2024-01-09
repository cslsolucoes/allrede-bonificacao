unit Model.Autenticacao;

interface
uses

  {$ifdef FPC}
  SysUtils,
  StrUtils,
  DateUtils,
  DB,
  Classes,
  JSON,
  {$else}
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  Data.DB,
  system.Classes,
  System.JSON,
  {$endif }
  MemDS, DBAccess, Uni, PostgreSQLUniProvider,
  REST.Client,Rest.Json,REST.Types,
  Horse,
  JOSE.Core.Builder,
  JOSE.Core.JWT,
  DataSet.Serialize,
  Model.Conexao,
  uUtilitarios
  ;
const
 LineEnding = #13#10;


 Function Autenticacao(Email, Senha: String): string;

 Var
  SECRET_KEY : String = 'teste de dados';


implementation

Function Autenticacao(Email, Senha: String): string;
var
  RESTClient          : TRESTClient;
  RESTRequest         : TRESTRequest;
  RESTResponse        : TRESTResponse;

  JSONMensaje         : TJSONObject;
  JSONResponse        : TJSONObject;

  JsonRequest         : TJSONObject;
  JsonLogin           : TJSONObject;
  JsonUser            : TJSONObject;
  JsonImagem          : TJSONObject;

  jValue              : TJSONValue;

  VBaseUrl,VURL       : String;

  Token               : string;
  Response            : string;
  erro                : String;

  User_AccessToken    : string;
  User_ExpiresIn      : Integer;
  User_Refreshtoken   : String;
  User_Imagem         : string;
  User_Nome           : String;
  User_Email          : String;
  User_Id             : Integer;
  User_Ativo          : Boolean;
  User_2fa            : Boolean;
  User_Telefone       : String;
  User_TokenType      : string;
  User_Data_expiracao : String;
  User_expiracao_dias : Integer;
  User_DataInicial    : TDateTime;

  _SQL                : String;
  Txt                 : String;

  lToken              : TJWT;

  queAcesso           : TUniQuery;
  queJWT              : TUniQuery;


Begin
  Result :=
    '{                                                                        ' + LineEnding +
    '    "status": "error",                                                   ' + LineEnding +
    '    "error": "credenciais_invalidas",                                    ' + LineEnding +
    '    "errorDescription": "As credenciais do usuario estao incorretas.",   ' + LineEnding +
    '    "message": "As credenciais do usuario estao incorretas."             ' + LineEnding +
    '}                                                                        '  ;

   VBaseUrl := 'https://api.allrede.hubsoft.com.br/api/v2/login';

  VURL := Format(VBaseUrl +'?username=%s&password=%s&origem=web',[Email,Senha]);

  RESTClient  := TRESTClient.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);


  queJWT    := TUniQuery.Create(nil);
  with queJWT do
  begin
     Connection                := SIPPConn;
     CachedUpdates             := True;
     Options.AutoPrepare       := True;
     Options.QueryRecCount     := True;
     Options.RequiredFields    := True;
     Options.SetFieldsReadOnly := False;
     Options.ReturnParams      := True;
     SpecificOptions.Values['UnknownAsString'] := 'true';
     Close;
     SQL.Clear;
  end;


  Try
    RESTClient.BaseURL := VURL;
    RESTClient.Accept  := 'application/json';
    RESTClient.AcceptCharSet := 'UTF-8';
    RESTClient.ContentType   := 'application/json';
    RESTClient.RaiseExceptionOn500 := true;

    RESTRequest.Method := TRESTRequestMethod.rmPOST;
    RESTRequest.Client := RESTClient;
    RESTRequest.Accept := 'application/json';

    RESTResponse := TRESTResponse.Create(nil);
    RESTRequest.Response := RESTResponse;
    try
      RESTRequest.Execute;
      //writeln('Codigo:', RESTResponse.StatusCode);

      if Assigned(RESTResponse.JSONValue) then
      begin
        if RESTResponse.StatusCode = 200 then
        begin
          // Processar a resposta JSON
          try
            JsonRequest.Free;
            JsonRequest := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(RESTResponse.Content), 0) as TJSONObject;
            //writeln(JsonRequest.GetValue<string>('status'));
            if Assigned(JsonRequest) then
            begin
              if (JsonRequest.GetValue<string>('status') = 'success') then
              Begin
                try
                  JsonLogin.Free;
                  JsonLogin := TJSONObject.ParseJSONValue(JsonRequest.GetValue('login').ToString) as TJSONObject;

                  if Assigned(JsonLogin) then Begin
                     User_AccessToken    := JsonLogin.GetValue<String>('access_token');
                     User_ExpiresIn      := JsonLogin.GetValue<Integer>('expires_in');
                     User_TokenType      := JsonLogin.GetValue<String>('token_type');
                     //User_Data_expiracao := FormatDateTime('yyyy-mm-dd hh:nn:ss', incDay(Now,Round(User_ExpiresIn/60/60/24)));
                  End;

                  JsonUser.Free;
                  JsonUser := TJSONObject.ParseJSONValue(JsonLogin.GetValue('user').ToString) as TJSONObject;

                  if Assigned(JsonUser) then Begin
                    User_Id        := JsonUser.GetValue<Integer>('id');
                    User_Nome      := JsonUser.GetValue<String>('name');
                    User_Ativo     := JsonUser.GetValue<Boolean>('ativo');
                    User_2fa       := JsonUser.GetValue<Boolean>('enabled2fa');
                    User_Telefone  := JsonUser.GetValue<String>('telefone_primario');
                    User_Imagem    := '';

                    If (JsonUser.GetValue('imagem').ToString <> 'null') Then
                    Begin
                      JsonImagem.Free;
                      JsonImagem := TJSONObject.ParseJSONValue(JsonUser.GetValue('imagem').ToString) as TJSONObject;
                      try

                        if Assigned(JsonImagem) then
                        Begin
                          //Writeln(JsonImagem.GetValue<string>('link_thumb') + LineEnding);
                          //Writeln(StringReplace(JsonImagem.GetValue<string>('link_thumb'),'\','',[rfReplaceAll, rfIgnoreCase]) + LineEnding);
                          User_Imagem  := StringReplace(JsonImagem.GetValue<string>('link_thumb'),'\','',[rfReplaceAll, rfIgnoreCase]);
                        End;
                      finally
                        JsonImagem.Free;
                      end;
                    End;
                  End;
                  // Resultado para o JWT
                  // Criando Json para resultado
                  JSONMensaje  := TJSONObject.Create;
                  JSONResponse := TJSONObject.Create;
                  lToken       := TJWT.Create;
                  Try
                    User_expiracao_dias := API_expiracao;
                    User_DataInicial    := Now;
                    SECRET_KEY          := API_chaveJWT;
                    User_Data_expiracao := formatdatetime('yyyy-mm-dd hh:nn:ss',IncDay(User_DataInicial,User_expiracao_dias));

                    JSONMensaje.AddPair('user_id'            , User_Id);
                    JSONMensaje.AddPair('user_nome'          , User_Nome);
                    JSONMensaje.AddPair('user_email'         , Email);
                    JSONMensaje.AddPair('user_telefone'      , User_Telefone);
                    JSONMensaje.AddPair('user_ativo'         , User_Ativo);
                    JSONMensaje.AddPair('user_2fa'           , User_2fa);
                    JSONMensaje.AddPair('user_imagem'        , User_Imagem);
                    JSONMensaje.AddPair('user_app_id'        , uUtilitarios.APP_id);
                    JSONMensaje.AddPair('user_app'           , uUtilitarios.APP_descricao);
                    JSONMensaje.AddPair('user_dias_expiracao', User_Data_expiracao );

                    //JSONMensaje.AddPair('user_AccessToken'   , User_AccessToken);
                    //JSONMensaje.AddPair('user_expiresin'     , User_ExpiresIn);
                    //JSONMensaje.AddPair('user_tokentype'     , User_TokenType);

                    lToken.Claims.SetClaim('nome',User_Nome);
                    ltoken.Claims.SetClaim('App_id',uUtilitarios.APP_id);
                    lToken.Claims.SetClaim('App',uUtilitarios.APP_descricao);
                    lToken.Claims.Issuer     := 'ALLREDE Telecom'; //Empresa
                    lToken.Claims.Subject    := Email;
                    lToken.Claims.Expiration := IncDay(User_DataInicial,User_expiracao_dias);

                    Token := TJOSE.SHA256CompactToken(SECRET_KEY,lToken);

                    JSONResponse.AddPair('status' , 'success');
                    JSONResponse.AddPair('token'  , Token);
                    JSONResponse.AddPair('data_expiracao', formatdatetime('yyyy-mm-dd hh:nn:ss',IncDay(User_DataInicial,User_expiracao_dias)));
                    JSONResponse.AddPair('dados' ,JSONMensaje);

                    _SQL := Format(
                            'With acesso as (                                                                    ' + LineEnding +
                            'insert into public.adm_acesso(app,usuario,senha,token,data_expiracao,expiracao_dia,hubsoft_accesstoken,hubsoft_refreshtoken,hubsoft_tokentype,hubsoft_expiresin) ' + LineEnding +
                            'VALUES (%s, %s, %s, %s, %s, %d, %s, %s, %s, %d)                                     ' + LineEnding +
                            'RETURNING id ) Select id from acesso' + LineEnding,
                            [
                            QuotedStr(uUtilitarios.APP_descricao),
                            QuotedStr(Email),
                            QuotedStr(FCrypta(Senha)),
                            QuotedStr(Token),
                            QuotedStr(formatdatetime('yyyy-mm-dd',IncDay(User_DataInicial,User_expiracao_dias))),
                            User_expiracao_dias,
                            QuotedStr(User_AccessToken),
                            QuotedStr(User_Refreshtoken),
                            QuotedStr(User_TokenType),
                            User_ExpiresIn
                            ]);
                    Writeln(_SQL);
                    queAcesso := TUniQuery.Create(nil);
                    with queAcesso do
                    begin
                       Connection                := SIPPConn;
                       CachedUpdates             := True;
                       Options.AutoPrepare       := True;
                       Options.QueryRecCount     := True;
                       Options.RequiredFields    := True;
                       Options.SetFieldsReadOnly := False;
                       Options.ReturnParams      := True;
                       SpecificOptions.Values['UnknownAsString'] := 'true';
                       Close;
                       SQL.Clear;
                       SQL.Add(_SQL);
                       ExecSQL;
                       Close;
                    end;

                    Result := JSONResponse.ToString;

                  Finally
                   queAcesso.Free;
                   JSONResponse.Free;
                   lToken.Free;
                  End;
                finally
                  JsonLogin.Free;
                  JsonUser.Free;
                end;
              End;
            end;
          finally
             JsonRequest.Free;
          end;
        end
        else
        begin
          if Assigned(RESTResponse.JSONValue) then
          begin
            JsonRequest.Free;
            JsonRequest := TJSONObject.ParseJSONValue(RESTResponse.Content) as TJSONObject;
            if Assigned(JsonRequest) then
            begin
              erro  := JsonRequest.GetValue('msg').ToString;
                // Exibir o corpo da resposta em caso de exceção
               writeln('Corpo da resposta em caso de exceção:');
               writeln('Erro:' + erro);
            end;
          end;
        end;
        RESTResponse.Free;
      end;

    except on E:Exception do
         Result := Format(
                  '{                     ' + LineEnding +
                  '    "error": "%s",    ' + LineEnding +
                  '    "errorDescription": "Erro inesperado", ' + LineEnding +
                  '    "message": "%s."  ' + LineEnding +
                  '}                     ' ,[RESTResponse.ErrorMessage,E.Message]);
    end;

  Finally
    RESTClient.Free;
    RESTRequest.Free;
  End;

End;

end.
