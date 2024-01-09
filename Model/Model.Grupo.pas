unit Model.Grupo;

interface
uses
  {$ifdef FPC}
  SysUtils,
  {$else}
  System.SysUtils,
  {$endif }
  Uni,
  PostgreSQLUniProvider,
  Model.Conexao;

const
 LineEnding = #13#10;

type

  TGrupo = class
  private
  protected
      FId : Integer;
      FGrupo : String;
      FNome  : String;
      FId_Setor : integer;
      FTipo_Ponto : Char;
      FId_Setor_Vinculado : integer;
      FId_Grupo_Vinculado : integer;
      FDataCadastro : TDateTime;
      FDataAlteracao : TDateTime;
      FAtivo : String;
      FDeleted : String;

      FNome_Tabela : String;
      FCampos : String;
      FCampoID : String;

    function getFAtivo: Boolean;
    function getFDeleted: Boolean;
    procedure putFAtivo(const Value: Boolean);
    procedure putFDeleted(const Value: Boolean);
  public
      constructor Create;
      destructor Destroy; override;

      property Id :                Integer read FId                 write FId;
      property Grupo :             String  read fGrupo              write FGrupo;
      property Nome :              String  read FNome               write FNome;
      property Id_Setor :          Integer read FId_setor           write FId_setor;
      property TipoPonto:          Char    read FTipo_ponto         write FTipo_Ponto;
      property Id_Setor_Vinculado: Integer read FId_Setor_Vinculado write FId_Setor_Vinculado;
      property Id_Grupo_Vinculado: Integer read FId_Grupo_Vinculado write FId_Grupo_Vinculado;
      property DataCadastro:     Tdatetime read FDataCadastro       write FDataCadastro;
      property DataAlteracao:    Tdatetime read FDataAlteracao      write FDataAlteracao;
      property Ativo:              Boolean read getFAtivo           write putFAtivo;
      property Deleted:            Boolean read getFDeleted         write putFDeleted;

      property CampoID:            String  read FCampoID            write FCampoID;
      property Campos :            String  read FCampos             write FCampos;
      property Tabela :            String  read FNome_Tabela        write FNome_Tabela;

      function Listar: string;
      function Inserir: String;
      function Editar: String;
      function Excluir: String;
  end;

implementation

{ TGrupo }

constructor TGrupo.Create;
begin
  FNome_Tabela := 'sipp.a_core_grupo';
  FCampos      := 'setor,nome,setor_id,tipo_ponto,setor_vinculo_id,agrupador_id';
  FCampoID     := 'id';

  if Not Conn.Connected then
     Model.Conexao.Conectar;

  FId                       := -1 ;
  FGrupo                    := '' ;
  FNome                     := '' ;
  FId_Setor                 := -1 ;
  FTipo_Ponto               := ' ';
  FId_Setor_Vinculado       := -1 ;
  FId_Grupo_Vinculado       := -1 ;
  FDataCadastro             := -1 ;
  FDataAlteracao            := -1 ;
  FAtivo                    := '' ;
  FDeleted                  := '' ;
end;

destructor TGrupo.Destroy;
begin

  inherited Destroy;
end;

function TGrupo.Editar: String;
Var
  Qry : TUniQuery;
  _SQL : String;

  Vgrupo,Vnome,Vsetor_id,Vsetor_id_vinculado,Vgrupo_id_vinculado,vtipo_ponto,VAtivo,Vid,VDeleted: string;


Begin
  Vgrupo := '';
  Vnome := '';
  Vsetor_id := '';
  Vsetor_id_vinculado := '';
  Vgrupo_id_vinculado := '';
  vtipo_ponto := '';
  VAtivo := '';
  Vid := '';
  VDeleted := '';

  if FId < 0 then begin
   Result := format( ' {                                                       ' + LineEnding +
                     '     "status": "error",                                   ' + LineEnding +
                     '     "msg": "Informe o id, Tabela: %s  erro: Faltou informar o id"  ' + LineEnding +
                     ' }                                                       ' + LineEnding ,[FNome_Tabela]);
    exit;
  end;


  if FGrupo                    <> ''  then  Vgrupo                    := Format('setor                    = %s,' + LineEnding,[FGrupo]);
  if FNome                     <> ''  then  Vnome                     := Format('nome                     = %s,' + LineEnding,[FNome]);
  if FId_Setor                 <> -1  then  Vsetor_id                 := Format('setor_id                 = %d,' + LineEnding,[FId_setor]);
  if FId_Setor_Vinculado       <> -1  then  Vsetor_id_vinculado       := Format('setor_vinculo_id         = %d,' + LineEnding,[FId_Setor_Vinculado]);
  if FId_Grupo_Vinculado       <> -1  then  Vgrupo_id_vinculado       := Format('agrupador_id             = %d,' + LineEnding,[FId_Grupo_Vinculado]);
  if FTipo_Ponto               <> ' ' then  vtipo_ponto               := Format('tipo_ponto               = %d,' + LineEnding,[FTipo_Ponto]);
  if FAtivo                    <> ''  then  VAtivo                    := Format('ativo           = %s,' + LineEnding,[FAtivo]);
  if FDeleted                  <> ''  then  VDeleted                  := Format('is_deleted      = %s,' + LineEnding,[FDeleted]);

  _SQL := LineEnding +
   format('update %s set         '   + LineEnding +
          '  %s' +
          '  %s' +
          '  %s' +
          '  %s' +
          '  %s' +
          '  %s' +
          '  %s' +
          '  %s' +
          'data_alteracao = now()'   + LineEnding +
          'Where id = %d         '   ,
          [
           FNome_Tabela,
            Vgrupo,
            Vnome,
            Vsetor_id,
            Vsetor_id_vinculado,
            Vgrupo_id_vinculado,
            vtipo_ponto,
            VAtivo,
            VDeleted,
           FId
          ]);

  writeln(_SQL);

  Qry := TUniQuery.Create(nil);
  try
    Try

      with Qry do
      begin
         Connection                := Conn;
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
      end;

       Result := format( ' {                                               ' + LineEnding +
                         '     "status": "success",                         ' + LineEnding +
                         '     "msg": "Aterado com sucesso, Tabela: %s"    ' + LineEnding +
                         ' }                                               ' + LineEnding ,[FNome_Tabela]);

    except on ex:exception do
      begin
         Result := format( ' {                                                   ' + LineEnding +
                           '     "status": "error",                               ' + LineEnding +
                           '     "msg": "Erro ao editar, Tabela: %s  erro: %s"   ' + LineEnding +
                           ' }                                                   ' + LineEnding ,[FNome_Tabela,ex.Message]);
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TGrupo.Inserir: String;
Var
  Qry : TUniQuery;
  _SQL : String;
Begin
  Qry := TUniQuery.Create(nil);
  try
    Try
      _SQL :=
         format('With inserir as (' + LineEnding +
                'Insert into %s ( %s )' + LineEnding +
                    // 'setor,nome,setor_id,tipo_ponto,setor_vinculo_id,agrupador_id'
                'VALUES(%s,   %s,  %d,      %s,        %d,              %d                     )' + LineEnding +
                'RETURNING %s ) Select to_jsonb(row) as consulta from (Select ''success'' as status, ''Regra adicionada com sucesso'' as msg,%s as id from inserir)row '
                 ,[
                 FNome_Tabela, FCampos,
                 QuotedStr(FNome),
                 QuotedStr(FGrupo),
                 QuotedStr(FNome),
                 FId_Setor,
                 QuotedStr(FTipo_Ponto),
                 FId_Setor_Vinculado,
                 FId_Grupo_Vinculado,
                 FCampoID,
                 FCampoID
                 ]) ;

      writeln(_SQL);

      with Qry do
      begin
         Connection                := Conn;
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
         Open;

         Result := FieldByName('consulta').AsString;
      end;

      except on ex:exception do
      begin
         Result := format( ' {                                                   ' + LineEnding +
                           '     "status": "error",                               ' + LineEnding +
                           '     "msg": "Erro ao inserir, Tabela: %s  msg: %s"  ' + LineEnding +
                           ' }                                                   ' + LineEnding ,[FNome_Tabela,ex.Message]);
      end;
    end;
  finally
    Qry.Free;
  end;

end;

function TGrupo.Listar: string;
Var
   Qry : TUniQuery;
  _SQL : String;
Begin
  try

   Qry  := TUniQuery.Create(nil);

   _SQL := '';

   Try
      _SQL := 'Select to_jsonb(array_agg(row)) as consulta from ( ';
      _SQL := _SQL + format(

      'SELECT id, setor as grupo, nome as abreviacao, setor_id as id_setor, tipo_ponto, setor_vinculo_id as id_setor_vinculado, agrupador_id as id_grupo_vinculado, data_alteracao, data_cadastro,ativo,is_deleted as deletado from %s Where 1 = 1 '

      ,[FNome_Tabela]);


      if FId > 0 then
        _SQL := Format(_SQL + ' %s',[Format('AND %s = %d',[FCampoID,FId])]);

//     _SQL := _SQL + ' Limit 20';
     _SQL := _SQL + ')row';

      Writeln(_SQL);

      with Qry do
      begin
         Connection                := Conn;
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
         Open;
      end;

      if Not Qry.IsEmpty and not Qry.FieldByName('consulta').IsNull then
         Result := Qry.FieldByName('consulta').AsString
      Else
         Result := '[{ }]';

    except on ex:exception do
      begin
         Result := format( ' {                                                   ' + LineEnding +
                           '     "status": "error",                               ' + LineEnding +
                           '     "msg": "Erro ao Consultar, Tabela: %s  erro: %s"  ' + LineEnding +
                           ' }                                                   ' + LineEnding ,[FNome_Tabela,ex.Message]);
      end;
  end;
  finally
    Qry.Free;
  end;
end;

function TGrupo.Excluir: String;
begin

end;

function TGrupo.getFAtivo: Boolean;
begin
   Result := False;
   if FAtivo = 'true' then
     Result := True;
end;

function TGrupo.getFDeleted: Boolean;
begin
   Result := False;
   if FDeleted = 'true' then
     Result := True;
end;

procedure TGrupo.putFAtivo(const Value: Boolean);
begin
   FAtivo := 'false';
   if Value = True then
     FAtivo := 'true';
end;

procedure TGrupo.putFDeleted(const Value: Boolean);
begin
   FDeleted := 'false';
   if Value = True then
     FDeleted := 'true';
end;

end.
