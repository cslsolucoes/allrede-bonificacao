unit Model.Conexao;

interface
  uses
  {$ifdef FPC}
     SysUtils,StrUtils,DateUtils,Classes,IniFiles,DB,
  {$else}
     System.SysUtils,System.StrUtils, System.DateUtils, System.Classes,  System.IniFiles, Data.DB,System.JSON,
  {$endif}
  MemDS,
  DBAccess,
  Uni,
  PostgreSQLUniProvider,
  uUtilitarios
  ;

Const
 LineEnding = #13#10;
 arq_ini    =  'ARBonificacao.ini';

Var
  Conn : TUniConnection;
  SIPPConn : TUniConnection;
  PostgreSQL : TPostgreSQLUniProvider;
  portaServico : Integer;
  ini : TIniFile;

  ClienteId: integer;

  SIPPPorvider : String;
  SIPPPort     : integer;
  SIPPDatabase : String;
  SIPPUsername : String;
  SIPPPassword : String;
  SIPPServer   : String;

  ClientePorvider : String;
  ClientePort     : integer;
  ClienteDatabase : String;
  ClienteUsername : String;
  ClientePassword : String;
  ClienteServer   : String;

  API_Empresa       : String;
  API_UrlBase       : String;
  API_ClienteID     : String;
  API_ClienteSecret : String;
  API_Usuario       : String;
  API_Senha         : String;

  API_app           : String;
  API_app_id        : integer;
  API_chaveJWT      : String;
  API_expiracao     : integer;
  SECRET_KEY        : String ;




Function  CarregaINI(Conexao: TUniConnection) : String;
Function  Conectar : TUniConnection;
procedure Disconetar;

Function  CarregaSIPPini(Conexao: TUniConnection) : String;
Function  ConectarSIPP : TUniConnection;
procedure DisconetarSIPP;

Procedure ConexaoCliente(Id:Integer);
Procedure APICliente(Id:Integer);
procedure IniciarQuery(out queAux: TUniQuery; SQLText: String);
procedure IniciarQuerySIPP(out queAux: TUniQuery; SQLText: String);

implementation
procedure IniciarQuerySIPP(out queAux: TUniQuery; SQLText: String);
var
  Aberto:Boolean;
begin
    If not Assigned(SIPPConn) Then
      Conectar;

    If not Assigned(queAux) Then
      queAux  := TUniQuery.Create(Nil);

    If queAux.Active Then
      queAux.Close;

    with queAux do
    begin
       Connection                := SIPPConn;
       Options.AutoPrepare       := True;
       Options.SetFieldsReadOnly := True; //False;
       SpecificOptions.Values['UnknownAsString'] := 'true';
       Close;
       SQL.Clear;
       SQL.Add(SQLText);
    end;
End;

Procedure ConexaoCliente(Id:Integer);
Var
  Query : TUniQuery;
  _SQL  : String;
Begin
{
  ClientePorvider := 'PostgreSQL';
  ClientePort     := 9432;
  ClienteDatabase := 'hubsoft';
  ClienteUsername := 'sipp';
  ClientePassword := '12ff5b175c5856d16e20550ed271b9366696826e';
  ClienteServer   := '18.230.16.241';
}
   Try
     Query := TUniQuery.Create(nil);

     _SQL :=
        Format('Select * from "funcaoConexao"(%d)',
        [
        Id
        ]);
     //Writeln(_SQL);
     IniciarQuerySIPP(Query,_SQL);
     query.Open;
     if Not query.IsEmpty then begin
        ClientePorvider := query.FieldByName('provider').AsString;
        ClientePort     := query.FieldByName('port').AsInteger;
        ClienteDatabase := query.FieldByName('database').AsString;
        ClienteUsername := query.FieldByName('user').AsString;
        ClientePassword := trim(query.FieldByName('pass').Value);
        ClienteServer   := trim(query.FieldByName('host').Value);
     end;
     query.Close;
   Finally
     Query.Free;
   End;

End;

Function  CarregaSIPPini(Conexao: TUniConnection) : String;
Begin
    try
        try
            // Instanciar arquivo INI...
            ini := TIniFile.Create(arq_ini);

            // Verifica se INI existe...
            if NOT FileExists(arq_ini) or (LowerCase(ParamStr(1)) = '-c')  then
            begin
              ini.WriteInteger('Dados Cliente', 'ClienteId', 5);
              if LowerCase(ParamStr(1)) = '-c' then Begin
                ini.WriteString( 'SIPP Conexao' , 'Provider' , 'PostgreSQL');
                ini.WriteInteger('SIPP Conexao' , 'Port'     , 5432);
                ini.WriteString( 'SIPP Conexao' , 'Database' , 'sipp');
                ini.WriteString( 'SIPP Conexao' , 'Username' , 'sipp');
                ini.WriteString( 'SIPP Conexao' , 'Server'   , 'db.cslsoftwares.com.br'); //'db.allrede.hubsoft.com.br';
                ini.WriteString( 'SIPP Conexao' , 'Password' , '5ea0f6c45ebb8492cf3a3df5357ccfbbe9e1445d');
              End;
            end;

            ClienteId    := ini.ReadInteger('Dados Cliente', 'ClienteId', 5);

            SIPPPorvider := ini.ReadString( 'SIPP Conexao' , 'Provider' , 'PostgreSQL');
            SIPPPort     := ini.ReadInteger('SIPP Conexao' , 'Port'     ,  5432);
            SIPPDatabase := ini.ReadString( 'SIPP Conexao' , 'Database' , 'sipp');
            SIPPUsername := ini.ReadString( 'SIPP Conexao' , 'Username' , 'sipp');
            SIPPServer   := ini.ReadString( 'SIPP Conexao' , 'Server'   , 'db.cslsoftwares.com.br');
            SIPPPassword := ini.ReadString( 'SIPP Conexao' , 'Password' , '5ea0f6c45ebb8492cf3a3df5357ccfbbe9e1445d');

            With Conexao do Begin
              LoginPrompt  := False;
              ProviderName := SIPPPorvider;
              Port         := SIPPPort;
              Database     := SIPPDatabase;
              Username     := SIPPUsername;
              Server       := SIPPServer;
              Password     := SIPPPassword;
            end;

            Result := 'OK';
        except on ex:exception do
            Result := 'Erro ao configurar banco: ' + ex.Message;
        end;
    finally
        if Assigned(ini) then
        {$ifdef FPC}
           ini.free;
        {$else}
           ini.DisposeOf;
        {$endif}
    end;
End;

Function  CarregaINI(Conexao: TUniConnection) : String;
Begin
    try
        try
            // Instanciar arquivo INI...
            ini := TIniFile.Create(arq_ini);

            // Verifica se INI existe...
            if NOT FileExists(arq_ini) then
            begin
              ini.WriteInteger('ARBonificacao'      , 'Porta'   , 9008 );
              if LowerCase(ParamStr(1)) = '-c' then Begin
                ini.WriteString( 'Banco de Dados', 'Provider', ClientePorvider);
                ini.WriteInteger('Banco de Dados', 'Port'    , ClientePort);
                ini.WriteString( 'Banco de Dados', 'Database', ClienteDatabase);
                ini.WriteString( 'Banco de Dados', 'Username', ClienteUsername);
                ini.WriteString( 'Banco de Dados', 'Server'  , ClienteServer);
                ini.WriteString( 'Banco de Dados', 'Password', ClientePassword);
              End;
            end;

            With Conexao do Begin
              LoginPrompt  := False;
              portaServico := ini.ReadInteger('ARBonificacao'      , 'Porta'   , 9008);
              ProviderName := ini.ReadString( 'Banco de Dados', 'Provider', ClientePorvider);
              Port         := ini.ReadInteger('Banco de Dados', 'Port'    , ClientePort);
              Database     := ini.ReadString( 'Banco de Dados', 'Database', ClienteDatabase);
              Username     := ini.ReadString( 'Banco de Dados', 'Username', ClienteUsername);
              Server       := ini.ReadString( 'Banco de Dados', 'Server'  , ClienteServer); //'unificacaomaster.hubsoft.com.br';
              Password     := ini.ReadString( 'Banco de Dados', 'Password', ClientePassword);//'64d781dc746b092ee9970e38105fe26407181d92';
            end;

            Result := 'OK';
        except on ex:exception do

         Result := format( ' {                                                ' + LineEnding +
                           '     "status": "error"                            ' + LineEnding +
                           '     "msg": "Erro ao configurar banco, msg: %s",  ' + LineEnding +
                           ' }                                                ' + LineEnding ,[ex.Message]);
        end;
    finally
        if Assigned(ini) then
        {$ifdef FPC}
           ini.free;
        {$else}
           ini.DisposeOf;
        {$endif}
    end;
End;

Procedure APICliente(Id:Integer);
Var
  Query : TUniQuery;
  _SQL  : String;
  jsonResponse : TJSONArray;
Begin
{
  API_Empresa       := 'Allrede';
  API_UrlBase       := 'https://api.allrede.hubsoft.com.br';
  API_ClienteID     := '13';
  API_ClienteSecret := 'EWx6rISkbTdu6HjsNo3ZpYtbuJb5eXaa2s2DTedx';
  API_Usuario       := 'api@aplicacoesallrede.com.br';
  API_Senha         := 'zV@#f#v#FnP5P$gvVrb*!Xw$WYXxd9xQ';
}
   Try
     Query := TUniQuery.Create(nil);

     _SQL :=
        Format('Select * from "funcaoToken"(%d,%d)',
        [
        Id,
        API_app_id
        ]);
//     writeln(_SQL);
     IniciarQuerySIPP(Query,_SQL);
     query.Open;
     if Not query.IsEmpty then begin
        API_Empresa       := query.FieldByName('empresa').AsString;
        API_UrlBase       := query.FieldByName('url').AsString;
        API_ClienteID     := query.FieldByName('cliente_id').AsString;
        API_ClienteSecret := query.FieldByName('cliente_secret').AsString;
        API_Usuario       := trim(query.FieldByName('username').Value);
        API_Senha         := trim(query.FieldByName('password').Value);

        jsonResponse := TJSONObject.ParseJSONValue(query.FieldByName('chave').AsString) as TJSONArray;

        API_app_id   := jsonResponse[0].GetValue<Integer>('app_id');
        API_chaveJWT := jsonResponse[0].GetValue<string>('key');
        SECRET_KEY   := jsonResponse[0].GetValue<string>('key');
        API_expiracao:= jsonResponse[0].GetValue<Integer>('expiracao_dias');

     end;
     query.Close;
   Finally
     Query.Free;
   End;

End;

procedure IniciarQuery(out queAux: TUniQuery; SQLText: String);
var
  Aberto:Boolean;
begin
    If not Assigned(Conn) Then
      Conectar;

    If not Assigned(queAux) Then
      queAux  := TUniQuery.Create(Nil);

    If queAux.Active Then
      queAux.Close;

    with queAux do
    begin
//       ShowMessage(dm.conPG.ToString);
       Connection                := Conn;
       //CachedUpdates             := True;
       Options.AutoPrepare       := True;
       //Options.QueryRecCount     := True;
       //Options.RequiredFields    := True;
       Options.SetFieldsReadOnly := True; //False;
       //Options.ReturnParams      := True;
       SpecificOptions.Values['UnknownAsString'] := 'true';
//       Debug                     := DebugQuery;
       Close;
       SQL.Clear;
       SQL.Add(SQLText);
    end;
End;

Function  ConectarSIPP : TUniConnection;
Begin

  If not Assigned(SIPPConn) Then
  Begin
    If not Assigned(PostgreSQL) Then
    Begin
       PostgreSQL := TPostgreSQLUniProvider.Create(nil);
    end;

    SIPPConn  := TUniConnection.Create(Nil);
  end;

  CarregaSIPPini(SIPPConn);

  SIPPConn.Connected := true;

  ConexaoCliente(ClienteId);
  APICliente(ClienteId);

  Result := SIPPConn;
End;

procedure DisconetarSIPP;
Begin
  if Assigned(SIPPConn) then
  begin
    if SIPPConn.Connected then
        SIPPConn.Connected := false;

    SIPPConn.Free;
  end;
End;

Function  Conectar : TUniConnection;
Begin

  If not Assigned(Conn) Then
  Begin
    If not Assigned(PostgreSQL) Then
    Begin
       PostgreSQL := TPostgreSQLUniProvider.Create(nil);
    end;

    Conn  := TUniConnection.Create(Nil);
  end;

  API_app     := uUtilitarios.APP_descricao;
  API_app_id  := uUtilitarios.APP_id;

  ConectarSIPP;

  CarregaINI(Conn);

  Conn.Connected := true;

  Result := Conn;
End;

procedure Disconetar;
Begin
  if Assigned(Conn) then
  begin
    if Conn.Connected then
        Conn.Connected := false;

    Conn.Free;
  end;
End;

end.

