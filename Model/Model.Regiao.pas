unit Model.Regiao;

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

  TRegiao = class
  private
  protected
      FId : Integer;
      FNome : String;
      FId_setor : integer;
      FId_setor_Primario : integer;
      FId_Subregiao : integer;
      FId_RegiaoReferecia : integer;
      FId_grupo_cliente_servico : integer;
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
      property Nome :              String  read FNome               write FNome;
      property Id_setor :          Integer read FId_setor           write FId_setor;
      property Id_setor_primario:  Integer read FId_setor_Primario  write FId_setor_Primario;
      property Id_Subregiao :      Integer read FId_Subregiao       write FId_Subregiao;
      property Id_RegiaoReferencia:Integer read FId_RegiaoReferecia write FId_RegiaoReferecia;
      property Id_GrupoServico:    Integer read FId_Subregiao       write FId_Subregiao;
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

{ TRegiao }

constructor TRegiao.Create;
begin
  FNome_Tabela := 'sipp.a_core_regiao';
  FCampos      := 'nome,setor_id,setor_id_primario,subregiao,regiao_referencia,id_grupo_cliente_servico';
  FCampoID     := 'id';

  if Not Conn.Connected then
     Model.Conexao.Conectar;

  FId                       := -1 ;
  FNome                     := '' ;
  FId_setor                 := -1 ;
  FId_setor_Primario        := -1 ;
  FId_Subregiao             := -1 ;
  FId_RegiaoReferecia       := -1 ;
  FId_grupo_cliente_servico := -1 ;
  FDataCadastro             := -1 ;
  FDataAlteracao            := -1 ;
  FAtivo                    := '' ;
  FDeleted                  := '' ;


end;

destructor TRegiao.Destroy;
begin

  inherited Destroy;
end;

function TRegiao.Inserir: String;
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
                    // 'nome,setor_id,setor_id_primario,subregiao,regiao_referencia,id_grupo_cliente_servico';
                'VALUES(%s,  %d,      %d,               %d,       %d,               %d                     )' + LineEnding +
                'RETURNING %s ) Select to_jsonb(row) as consulta from (Select ''success'' as status, ''Regra adicionada com sucesso'' as msg,%s as id from inserir)row '
                 ,[
                 FNome_Tabela, FCampos,
                 QuotedStr(FNome),
                 Id_setor,
                 FId_setor_Primario,
                 FId_Subregiao,
                 FId_RegiaoReferecia,
                 FId_grupo_cliente_servico,
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

function TRegiao.Listar: string;
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

      'Select id, nome, setor_id as id_setor, setor_id_primario as id_setor_primario, subregiao, regiao_referencia, id_grupo_cliente_servico, data_alteracao, data_cadastro, ativo, is_deleted as deletado from %s Where 1 = 1 '

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

function TRegiao.Editar: String;
Var
  Qry : TUniQuery;
  _SQL : String;

  Vnome,Vsetor_id,Vsetor_id_primario,VSubregiao,Vregiao_referencia,Vid_grupo_cliente_servico,VAtivo,Vid,VDeleted: string;


Begin
  Vnome := '';
  Vsetor_id := '';
  Vsetor_id_primario := '';
  VSubregiao := '';
  Vregiao_referencia := '';
  Vid_grupo_cliente_servico := '';
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


  if FNome                     <> ''  then  Vnome                     := Format('nome                     = %s,' + LineEnding,[FNome]);
  if FId_setor                 <> -1  then  Vsetor_id                 := Format('setor_id                 = %d,' + LineEnding,[FId_setor]);
  if FId_setor_Primario        <> -1  then  Vsetor_id_primario        := Format('setor_id_primario        = %d,' + LineEnding,[FId_setor_Primario]);
  if FId_Subregiao             <> -1  then  VSubregiao                := Format('subregiao                = %d,' + LineEnding,[FId_Subregiao]);
  if FId_RegiaoReferecia       <> -1  then  Vregiao_referencia        := Format('regiao_referencia        = %d,' + LineEnding,[FId_RegiaoReferecia]);
  if FId_grupo_cliente_servico <> -1  then  Vid_grupo_cliente_servico := Format('id_grupo_cliente_servico = %d,' + LineEnding,[FId_grupo_cliente_servico]);
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
            Vnome,
            Vsetor_id,
            Vsetor_id_primario,
            VSubregiao,
            Vregiao_referencia,
            Vid_grupo_cliente_servico,
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

function TRegiao.Excluir: String;
Var
  Qry : TUniQuery;
  _SQL : String;
Begin

  if Not FId > 0 then begin
   Result := format( ' {                                                       ' + LineEnding +
                     '     "status": "error",                                   ' + LineEnding +
                     '     "msg": "Informe o id, Tabela: %s  erro: Faltou informar o id"  ' + LineEnding +
                     ' }                                                       ' + LineEnding ,[FNome_Tabela]);
    exit;
  end;

  _SQL := LineEnding +
   format('Delete from %s '   +
          'Where %s = %d ',
          [
           FNome_Tabela,
           FCampoID,
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
                         '     "msg": "Excluido com sucesso, Tabela: %s"    ' + LineEnding +
                         ' }                                               ' + LineEnding ,[FNome_Tabela]);

    except on ex:exception do
      begin
         Result := format( ' {                                                   ' + LineEnding +
                           '     "status": "error",                               ' + LineEnding +
                           '     "msg": "Erro ao excluir, Tabela: %s  erro: %s"   ' + LineEnding +
                           ' }                                                   ' + LineEnding ,[FNome_Tabela,ex.Message]);
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TRegiao.getFAtivo: Boolean;
begin
   Result := False;
   if FAtivo = 'true' then
     Result := True;
end;

function TRegiao.getFDeleted: Boolean;
begin
   Result := False;
   if FDeleted = 'true' then
     Result := True;
end;

procedure TRegiao.putFAtivo(const Value: Boolean);
begin
   FAtivo := 'false';
   if Value = True then
     FAtivo := 'true';
end;

procedure TRegiao.putFDeleted(const Value: Boolean);
begin
   FDeleted := 'false';
   if Value = True then
     FDeleted := 'true';
end;

end.
