unit Model.Usuario;

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


  TUsuario = class
  private
  protected
      FId : Integer;
      FNome : String;
      FEmail : String;
      FTelefone_Primario : String;
      FTelefone_Secundario : String;
      FId_Imagem : integer;
      FId_Funcionario : integer;
      FId_Grupo: Integer;
      FId_Regiao: integer;
      FDetalhe : Boolean;
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

      property Id :                 Integer read FId                   write FId;
      property Nome :               String  read FNome                 write FNome;
      property Email :              String  read FEmail                write FEmail;
      property Telefone_Primario:   String  read FTelefone_Primario    write FTelefone_Primario;
      property Telefone_Secundario: String  read FTelefone_Secundario  write FTelefone_Secundario;
      property Id_Imagem :          Integer read FId_Imagem            write FId_Imagem;
      property Id_Funcionario:      Integer read FId_Funcionario       write FId_Funcionario;
      property Id_Grupo:            Integer read FId_Grupo             write FId_Grupo;
      property Id_Regiao:           Integer read FId_Regiao            write FId_Regiao;
      property Detalhe:             boolean read FDetalhe              write FDetalhe;
      property DataCadastro:     Tdatetime  read FDataCadastro         write FDataCadastro;
      property DataAlteracao:    Tdatetime  read FDataAlteracao        write FDataAlteracao;
      property Ativo:              Boolean  read getFAtivo             write putFAtivo;
      property Deleted:            Boolean  read getFDeleted           write putFDeleted;

      property CampoID:             String  read FCampoID              write FCampoID;
      property Campos :             String  read FCampos               write FCampos;
      property Tabela :             String  read FNome_Tabela          write FNome_Tabela;

      function Listar: string;
//      function Inserir: String;
//      function Editar: String;
//      function Excluir: String;
  end;


implementation

{ TUsuario }

constructor TUsuario.Create;
begin
  FNome_Tabela := 'public.users';
  FCampos      := 'name,email,telefone_primario,telefone_secundario,id_imagem_upload,id_funcionario';
  FCampoID     := 'id';

  if Not Conn.Connected then
     Model.Conexao.Conectar;

  FId                       := -1 ;
  FNome                     := '' ;
  FTelefone_Primario        := '' ;
  FTelefone_Secundario      := '' ;
  FId_Grupo                 := -1 ;
  FId_Regiao                := -1 ;
  FDetalhe                  := True;
  FDataCadastro             := -1 ;
  FDataAlteracao            := -1 ;
  FAtivo                    := '' ;
  FDeleted                  := '' ;

end;

destructor TUsuario.Destroy;
begin

  inherited Destroy;
end;

function TUsuario.Listar: string;
Var
   Qry : TUniQuery;
  _SQL : String;
  _SQL_Detalhe : String;
Begin


  try

   Qry  := TUniQuery.Create(nil);

   _SQL := '';

   Try
      _SQL := 'Select to_jsonb(array_agg(row)) as consulta from ( With Consulta as (' + LineEnding;

     if FDetalhe = True then
        _SQL_Detalhe :=
					'(CASE WHEN ("position"((u.email)::varchar, ''@'') > 0)                                                               ' + LineEnding +
					'								 THEN ("substring"((u.email)::varchar, 1, ("position"((u.email)::varchar, ''@'') - 1)))               ' + LineEnding +
					'								 ELSE u.email END) AS username,                                                                       ' + LineEnding +
					'(SELECT string_agg( cg.id::varchar, '','') from public.usuario_setor us                                              ' + LineEnding +
					'left join public.setor s on (s.id_setor=us.id_setor)                                                                 ' + LineEnding +
					'left join sipp.a_core_regiao cg on (cg.setor_id=s.id_setor)                                                          ' + LineEnding +
					'Where us.id_usuario = u.id and s.id_setor in (Select setor_id from sipp.a_core_regiao))::varchar as id_regiao,       ' + LineEnding +
					'(SELECT string_agg( cg.id::varchar, '','') from public.usuario_setor us                                              ' + LineEnding +
					'left join public.setor s on (s.id_setor=us.id_setor)                                                                 ' + LineEnding +
					'left join sipp.a_core_grupo cg on (cg.setor_id=s.id_setor)                                                           ' + LineEnding +
					'Where us.id_usuario = u.id and not s.id_setor in (Select setor_id from sipp.a_core_regiao))::varchar as id_grupo,    ' + LineEnding +
					'(SELECT string_agg( s.id_setor::varchar, '','') from public.usuario_setor us                                         ' + LineEnding +
					'left join public.setor s on (s.id_setor=us.id_setor)                                                                 ' + LineEnding +
					'Where us.id_usuario = u.id and not s.id_setor in (Select setor_id from sipp.a_core_regiao))::varchar as id_setor,    ' + LineEnding +
					'(SELECT string_agg( s.descricao, '','') from public.usuario_setor us                                                 ' + LineEnding +
					'left join public.setor s on (s.id_setor=us.id_setor)                                                                 ' + LineEnding +
					'Where us.id_usuario = u.id and s.id_setor in (Select setor_id from sipp.a_core_regiao))::varchar as regiao_nome,     ' + LineEnding +
					'(SELECT string_agg( s.descricao, '','') from public.usuario_setor us                                                 ' + LineEnding +
					'left join public.setor s on (s.id_setor=us.id_setor)                                                                 ' + LineEnding +
					'Where us.id_usuario = u.id and not s.id_setor in (Select setor_id from sipp.a_core_regiao))::varchar as setor_nome,  ' + LineEnding +
					'CASE u.ativo                                                                                                         ' + LineEnding +
					'		WHEN True  THEN ''Ativo''                                                                                         ' + LineEnding +
					'		WHEN False THEN ''Inativo''                                                                                       ' + LineEnding +
					'END::varchar AS ativo_descricao,                                                                                     ' + LineEnding
      Else
        _SQL_Detalhe := '';

      _SQL := _SQL + format(

       		'Select  %s id,name,email,telefone_primario,telefone_secundario,id_imagem_upload,id_funcionario,created_at as data_cadastro,updated_at as data_alteracao,ativo, ' + LineEnding +
          '(SELECT concat(''https://api.allrede.hubsoft.com.br/_upload/_images/'',link) as link_imagem FROM "public"."imagem_upload" Where id_imagem_upload = u.id_imagem_upload) as link_upload ' + LineEnding +
          'from %s u Where (CASE WHEN ("position"((u.email)::varchar, ''hubsoft'') > 0) THEN 1 ELSE 0 END) = 0 '

      ,[_SQL_Detalhe,FNome_Tabela]);


      if FId_Grupo <> -1 Then Begin
         _SQL := Format(_SQL + LineEnding +

            'And   %d   = any((string_to_array(( SELECT string_agg( cg.id::varchar, '','') from public.usuario_setor us                ' + LineEnding +
            '             left join public.setor s on (s.id_setor=us.id_setor)                                                         ' + LineEnding +
            '             left join sipp.a_core_grupo cg on (cg.setor_id=s.id_setor)                                                   ' + LineEnding +
            '             Where us.id_usuario = u.id and not s.id_setor in (Select setor_id from sipp.a_core_regiao)), '','')::int[])) ' + LineEnding

         ,[FId_Grupo]);
         if FId_Regiao = -1 Then
             _SQL := _SQL + LineEnding +

             '	And  u.id in (                                                                                                                                         ' + LineEnding +
             '								Select us.id from public.users us                                                                                                        ' + LineEnding +
             '								 Where us.id in (                                                                                                                        ' + LineEnding +
             '															Select s.id_usuario from public.usuario_setor s                                                                            ' + LineEnding +
             '															Where s.id_setor = (Select r.setor_id from sipp.a_core_regiao r Where r.id= 2 limit 1)                                     ' + LineEnding +
             '														 )                                                                                                                           ' + LineEnding +
             '								 And   us.id in (                                                                                                                        ' + LineEnding +
             '															Select s.id_usuario from public.usuario_setor s                                                                            ' + LineEnding +
             '															Where s.id_setor in                                                                                                        ' + LineEnding +
             '																 (                                                                                                                       ' + LineEnding +
             '																	Select setor_id from "sipp".a_core_grupo g                                                                             ' + LineEnding +
             '																	Where g.id in (                                                                                                        ' + LineEnding +
             '																									SELECT                                                                                                 ' + LineEnding +
             '																									UNNEST(ARRAY[string_to_array(string_agg( cg.valor, '',''::varchar), '',''::varchar)])::INT4 as ids     ' + LineEnding +
             '																									FROM "sipp"."a_core_config" cg                                                                         ' + LineEnding +
             '																									WHERE titulo=''PARAM'' AND chave = ''GrupoAgrupadorRegiao''::varchar                                   ' + LineEnding +
             '																								)                                                                                                        ' + LineEnding +
             '																 )                                                                                                                       ' + LineEnding +
             '														 )                                                                                                                           ' + LineEnding +
             '	             )                                                                                                                                         ' + LineEnding ;


      End;

      if FId_Regiao <> -1 Then
         _SQL := Format(_SQL + LineEnding +

        'And   %d   = any((string_to_array(( SELECT string_agg( cg.id::varchar, '','') from public.usuario_setor us                ' + LineEnding +
        '             left join public.setor s on (s.id_setor=us.id_setor)                                                         ' + LineEnding +
        '             left join sipp.a_core_regiao cg on (cg.setor_id=s.id_setor)                                                  ' + LineEnding +
        '             Where us.id_usuario = u.id and not s.id_setor in (Select setor_id from sipp.a_core_regiao)), '','')::int[])) ' + LineEnding

         ,[FId_Regiao]);

      if FId > 0 then
        _SQL := Format(_SQL + ' %s',[Format('AND %s = %d',[FCampoID,FId])]) + LineEnding;

      if FAtivo <> '' Then
        _SQL := _SQL + LineEnding +  Format(' And u.ativo = %s ',[FAtivo]) + LineEnding;

             //     _SQL := _SQL + ' Limit 20';

     _SQL := _SQL + ' ORDER BY NAME ) Select * from Consulta )row';

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

function TUsuario.getFAtivo: Boolean;
begin
   Result := False;
   if FAtivo = 'true' then
     Result := True;
end;

function TUsuario.getFDeleted: Boolean;
begin
   Result := False;
   if FDeleted = 'true' then
     Result := True;
end;

procedure TUsuario.putFAtivo(const Value: Boolean);
begin
   FAtivo := 'false';
   if Value = True then
     FAtivo := 'true';
end;

procedure TUsuario.putFDeleted(const Value: Boolean);
begin
   FDeleted := 'false';
   if Value = True then
     FDeleted := 'true';
end;


end.
