unit Model.Ponto;

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

  TPontoRegra = class
  private
    function getFAtivo: Boolean;
    function getFComOS: Boolean;
    function getFDeleted: Boolean;
    procedure putFAtivo(const Value: Boolean);
    procedure putFComOS(const Value: Boolean);
    procedure putFDeleted(const Value: Boolean);
  protected
      FId : Integer;
      FId_tipo : Integer;   //tipo -> Abertura/Fechameto
      FId_grupo : Integer;
      FId_regiao : integer;
      FPonto : Double;
      FPontoRet : Double;
      FComOS : String;
      FTratativa : Char;        // (R)esponsável / (C)riador          / (F)inalizador    / (V)endedor
      FTratativaNivel : Char;   // (A)tendimento / (O)rdem de Serviço / (A)dministrativo / o(P)eracional
      FTratativaTipo  : Char;   // (A)bertura    / (F)echamento
      FTratativaModo  : Char;   // (B)onificação / (P)enalidade
      FNivelDificuldade : Char; // (B)aixa       / (M)edia            / (A)lta
      FObservacao: String;
      FDataCadastro : TDateTime;
      FDataAlteracao : TDateTime;
      FAtivo : String;
      FDeleted : String;

      FNome_Tabela : String;
      FCampos : String;
      FCampoID : String;

  public
      constructor Create;
      destructor Destroy; override;

      property id :            Integer read FId             write FId;
      property id_tipo :       Integer read FId_tipo        write FId_tipo;
      property id_grupo :      Integer read FId_grupo       write FId_grupo;
      property id_regiao :     Integer read FId_regiao      write FId_regiao;
      property Ponto :         Double  read FPonto          write FPonto;
      property Ponto_Retirar:  Double  read FPontoRet       write FPontoRet;
      property ComOS :         Boolean read getFComOS       write putFComOS;
      property Tratativa:      char    read FTratativa      write FTratativa;
      property TratativaNivel: char    read FTratativaNivel write FTratativaNivel;
      property TratativaTipo:  char    read FTratativaTipo  write FTratativaTipo;
      property TratativaModo:  char    read FTratativaModo  write FTratativaModo;
      property Observacao:     String  read FObservacao     write FObservacao;
      property DataCadastro: Tdatetime read FDataCadastro   write FDataCadastro;
      property DataAlteracao:Tdatetime read FDataAlteracao  write FDataAlteracao;
      property Ativo:          Boolean read getFAtivo       write putFAtivo;
      property Deleted:        Boolean read getFDeleted     write putFDeleted;

      property CampoID:        String  read FCampoID        write FCampoID;
      property Campos :        String  read FCampos         write FCampos;
      property Tabela :        String  read FNome_Tabela    write FNome_Tabela;

      function Listar: string;
      function Inserir: String;
      function Editar: String;
      function Excluir: String;
  end;


implementation

{ TPontoRegra }

constructor TPontoRegra.Create;
begin
  FNome_Tabela := 'sipp.a_ponto_regras';
  FCampos      := 'tipo_id,grupo_id,regiao_id,ponto,tratativa,tratativa_nivel,modo,ponto_ret,comos,nivel,observacao,data_alteracao,ativo';
  FCampoID     := 'id';

  if Not Conn.Connected then
     Model.Conexao.Conectar;

{
      FTratativa : Char;        // (R)esponsável / (C)riador          / (F)inalizador    / (V)endedor
      FTratativaNivel : Char;   // (A)tendimento / (O)rdem de Serviço / a(D)ministrativo / o(P)eracional
      FTratativaTipo  : Char;   // (A)bertura    / (F)echamento
      FTratativaModo  : Char;   // (B)onificação / (P)enalidade
      FNivelDificuldade : Char; // (B)aixa       / (M)edia            / (A)lta
}

  FId              := -1 ;
  FId_tipo         := -1 ;
  FId_grupo        := -1 ;
  FId_regiao       := -1 ;
  FPonto           := -1 ;
  FPontoRet        :=  0 ;
  FComOS           := 'false' ;
  FTratativa       := ' ';
  FTratativaNivel  := ' ';
  FTratativaTipo   := ' ';
  FTratativaModo   := ' ';
  FNivelDificuldade:= ' ';
  FObservacao      := '' ;
  FDataCadastro    := -1 ;
  FDataAlteracao   := -1 ;
  FAtivo           := 'true' ;
  FDeleted         := 'false' ;

end;

destructor TPontoRegra.Destroy;
begin

  inherited Destroy;
end;

function TPontoRegra.Editar: String;
Var
  Qry : TUniQuery;
  _SQL : String;
Begin

  if FId < 0 then begin
    Result := format('Informe o id de %s ', [FNome_Tabela]) ;
    exit;
  end;

  _SQL := LineEnding +
   format('update %s set        '   + LineEnding +
          'tipo_id   = %d,      '   + LineEnding +
          'grupo_id  = %d,      '   + LineEnding +
          'regiao_id = %d,      '   + LineEnding +
          'ponto     = %d,      '   + LineEnding +
          'tratativa = %s,      '   + LineEnding +
          'tratativa_nivel = %s,'   + LineEnding +
          'modo = %s,           '   + LineEnding +
          'nivel = %s,          '   + LineEnding +
          'observacao = %s,     '   + LineEnding +
          'data_alteracao = now(),' + LineEnding +
          'ativo = %s           '   + LineEnding +
          'Where id = %d        '   ,
          [
           FNome_Tabela,
           FId_tipo,
           FId_grupo,
           FId_regiao,
           FPonto,
           QuotedStr(FTratativa),
           QuotedStr(FTratativaNivel),
           QuotedStr(FTratativaModo),
           FPontoRet,
           FComOS,
           QuotedStr(FNivelDificuldade),
           QuotedStr(FObservacao),
           FAtivo,
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
         Writeln(_SQL);
         SQL.Add(_SQL);
         ExecSQL;
      end;

      Result := '{"Aterado com sucesso"}';

    except on ex:exception do
      begin
         Result := format('Erro ao editar %s: ' + ex.Message,[FNome_Tabela]);
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TPontoRegra.Excluir: String;
Var
  Qry : TUniQuery;
  _SQL : String;
Begin

  if Not FId > 0 then begin
    Result := format('Informe o id de %s',[FNome_Tabela]);
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
         Writeln(_SQL);
         SQL.Add(_SQL);
         ExecSQL;
      end;

      Result := 'Excluido com sucesso!';

    except on ex:exception do
      begin
         Result := format('Erro ao excluir %s: ' + ex.Message,[FNome_Tabela]);
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TPontoRegra.getFAtivo: Boolean;
begin
   Result := False;
   if FAtivo = 'true' then
     Result := True;
end;

function TPontoRegra.getFComOS: Boolean;
begin
   Result := False;
   if FComOS = 'true' then
     Result := True;
end;

function TPontoRegra.getFDeleted: Boolean;
begin
   Result := False;
   if FDeleted = 'true' then
     Result := True;
end;

function TPontoRegra.Inserir: String;
Var
  Qry : TUniQuery;
  _SQL : String;
Begin
  Qry := TUniQuery.Create(nil);
  try
    Try
     // 'tipo_id,grupo_id,regiao_id,ponto,tratativa,tratativa_nivel,modo,nivel,observacao,ativo';
      _SQL :=
         format('With inserir as (' + LineEnding +
                'Insert into %s ( %s )' + LineEnding +
                'VALUES(%d, %d, %d, %d, %s, %s, %s, %s, %s, %s)' + LineEnding +
                'RETURNING %s ) Select to_jsonb(array_agg(row)) as consulta from (Select %s as id from inserir)row '
                 ,[
                 FNome_Tabela,
                 FCampos,
                 FId_tipo,
                 FId_grupo,
                 FId_regiao,
                 FPonto,
                 QuotedStr(FTratativa),
                 QuotedStr(FTratativaNivel),
                 QuotedStr(FTratativaModo),
                 QuotedStr(FNivelDificuldade),
                 QuotedStr(FObservacao),
                 FAtivo,
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
         Result := format('Erro ao insetir %s: ' + ex.Message,[FNome_Tabela]);
      end;
    end;
  finally
    Qry.Free;
  end;

end;

function TPontoRegra.Listar: string;
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

      'With Bonificacao as (                                                                                                                                                                ' + LineEnding +
      '		Select st.descricao as setor,                                                                                                                                                     ' + LineEnding +
      '		( CASE gp.tratativa_nivel                                                                                                                                                         ' + LineEnding +
      '				 WHEN ''O''::bpchar THEN ''Atendimento''::varchar       -- A                                                                                                                  ' + LineEnding +
      '				 WHEN ''S''::bpchar THEN ''Ordem de Serviço''::varchar  -- O                                                                                                                  ' + LineEnding +
      '				 WHEN ''A''::bpchar THEN ''Administrativo''::varchar                                                                                                                          ' + LineEnding +
      '				 WHEN ''P''::bpchar THEN ''Operacional''::varchar                                                                                                                             ' + LineEnding +
      '				 WHEN ''V''::bpchar THEN ''Vendas''::varchar                                                                                                                                  ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END )::character varying AS tratativa_nivel_descricao,                                                                                                                            ' + LineEnding +
      '		( CASE gp.tratativa                                                                                                                                                               ' + LineEnding +
      '				 WHEN ''C''::bpchar THEN ''Criação''::varchar                                                                                                                                 ' + LineEnding +
      '				 WHEN ''R''::bpchar THEN ''Responsável''::varchar                                                                                                                             ' + LineEnding +
      '				 WHEN ''F''::bpchar THEN ''Finalizador''::varchar                                                                                                                             ' + LineEnding +
      '				 WHEN ''V''::bpchar THEN ''Vedendor''::varchar                                                                                                                                ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END)::character varying AS tratativa_descricao,                                                                                                                                   ' + LineEnding +
      '		( CASE gp.tratativa_nivel                                                                                                                                                         ' + LineEnding +
      '				 WHEN ''O''::bpchar THEN ( CASE WHEN EXISTS(SELECT at.descricao FROM "public"."tipo_atendimento" at WHERE at.id_tipo_atendimento = gp.tipo_id )                               ' + LineEnding +
      '                                           Then (SELECT at.descricao FROM "public"."tipo_atendimento" at WHERE at.id_tipo_atendimento = gp.tipo_id )                                 ' + LineEnding +
      '                                           Else ''''                                                                                                                                 ' + LineEnding +
      '                                         End )::text                                                                                                                                 ' + LineEnding +
      '				 WHEN ''S''::bpchar THEN ( CASE WHEN EXISTS(SELECT mo.descricao FROM "public"."tipo_ordem_servico" mo WHERE mo.id_tipo_ordem_servico = gp.tipo_id)                            ' + LineEnding +
      '                                           Then (SELECT mo.descricao FROM "public"."tipo_ordem_servico" mo WHERE mo.id_tipo_ordem_servico = gp.tipo_id )                             ' + LineEnding +
      '                                           Else ''''                                                                                                                                 ' + LineEnding +
      '                                         End )::text                                                                                                                                 ' + LineEnding +
      '				 WHEN ''V''::bpchar THEN ( CASE WHEN EXISTS(SELECT pl.descricao FROM "public"."servico" pl Where ativo = true and pl.id_servico = gp.tipo_id )                                ' + LineEnding +
      '                                           Then (SELECT pl.descricao FROM "public"."servico" pl Where ativo = true and pl.id_servico = gp.tipo_id )                                  ' + LineEnding +
      '                                           Else ''''                                                                                                                                 ' + LineEnding +
      '                                         End )::text                                                                                                                                 ' + LineEnding +
      '				 WHEN ''A''::bpchar THEN ( CASE WHEN EXISTS(SELECT pl.descricao FROM "sipp"."a_ponto_penalidadetipo" pl Where ativo = true and pl.id = gp.tipo_id)                            ' + LineEnding +
      '                                           Then (SELECT pl.descricao FROM "sipp"."a_ponto_penalidadetipo" pl Where ativo = true and pl.id = gp.tipo_id )                             ' + LineEnding +
      '                                           Else ''''                                                                                                                                 ' + LineEnding +
      '                                         End )::text                                                                                                                                 ' + LineEnding +
      '				 WHEN ''P''::bpchar THEN ( CASE WHEN EXISTS(SELECT pl.descricao FROM "sipp"."a_ponto_penalidadetipo" pl Where ativo = true and pl.id = gp.tipo_id)                            ' + LineEnding +
      '                                           Then (SELECT pl.descricao FROM "sipp"."a_ponto_penalidadetipo" pl Where ativo = true and pl.id = gp.tipo_id )                             ' + LineEnding +
      '                                           Else ''''                                                                                                                                 ' + LineEnding +
      '                                         End )::text                                                                                                                                 ' + LineEnding +
      '				 WHEN ''F''::bpchar THEN ( CASE WHEN EXISTS(SELECT pl.descricao FROM "public"."motivo_fechamento" pl Where deleted_at is null and pl.id_motivo_fechamento = gp.tipo_id)       ' + LineEnding +
      '                                           Then (SELECT pl.descricao FROM "public"."motivo_fechamento" pl Where deleted_at is null and pl.id_motivo_fechamento = gp.tipo_id)         ' + LineEnding +
      '                                           Else ''''                                                                                                                                 ' + LineEnding +
      '                                         End )::text                                                                                                                                 ' + LineEnding +
      '				 ELSE ''''::text                                                                                                                                                              ' + LineEnding +
      '		END)::character varying AS descricao,                                                                                                                                             ' + LineEnding +
      '		( CASE gp.ativo                                                                                                                                                                   ' + LineEnding +
      '		     WHEN true THEN ''Ativo''::varchar                                                                                                                                            ' + LineEnding +
      '				 WHEN false THEN ''Inativo''::varchar                                                                                                                                         ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END)::character varying AS ativo_descricao,                                                                                                                                           ' + LineEnding +
      '		btrim(to_char((gp.ponto)::real, ''999D99''::text)) AS ponto_qdt,                                                                                                                      ' + LineEnding +
      '		gp.comos, gp.ponto_ret, gp.id, gp.tipo_id, gp.grupo_id, gp.ponto, gp.tratativa, gp.tratativa_nivel, gp.ativo,gp.data_cadastro,gp.data_alteracao,gp.regiao_id,rg.nome as regiao_nome,  ' + LineEnding +
      '		( CASE gp.ativo                                                                                                                                                                       ' + LineEnding +
      '		     WHEN true  THEN 1                                                                                                                                                                ' + LineEnding +
      '				 WHEN false THEN 0                                                                                                                                                            ' + LineEnding +
      '				 ELSE ''-1''::integer                                                                                                                                                         ' + LineEnding +
      '		END)::character varying AS ativo_descricao_1                                                                                                                                      ' + LineEnding +
      '		FROM %s gp                                                                                                                                                   ' + LineEnding +
      '		Inner JOIN "sipp"."a_core_grupo" cg ON (cg.id       = gp.grupo_id)                                                                                                                ' + LineEnding +
      '		inner jOIN "sipp"."a_core_regiao" rg ON (rg.id=gp.regiao_id)                                                                                                                      ' + LineEnding +
      '		Left  JOIN "public"."setor"      st ON (st.id_setor = cg.setor_id)                                                                                                                ' + LineEnding +
      '		WHERE ((gp.modo = ''B''::bpchar AND gp.is_deleted = false))                                                                                                                       ' + LineEnding +
      '		ORDER BY st.descricao                                                                                                                                                             ' + LineEnding +
      ') Select * from Bonificacao                                                                                                                                                          ' + LineEnding
      ,[FNome_Tabela]);


      if FId > 0 then
        _SQL := Format(_SQL + ' %s',[Format('AND %s = %d',[FCampoID,FId])]);

//     _SQL := _SQL + ' Limit 20';
     _SQL := _SQL + ')row';

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
         Writeln(_SQL);
         Open;
      end;

      Result := Qry.FieldByName('consulta').AsString;

    except on ex:exception do
      begin
          Result := format('Erro ao consultar %s: ' + ex.Message,[FNome_Tabela]);
      end;
  end;
  finally
    Qry.Free;
  end;
end;

procedure TPontoRegra.putFAtivo(const Value: Boolean);
begin
   FAtivo := 'false';
   if Value = True then
     FAtivo := 'true';
end;

procedure TPontoRegra.putFComOS(const Value: Boolean);
begin
   FComOS := 'false';
   if Value = True then
     FComOS := 'true';
end;

procedure TPontoRegra.putFDeleted(const Value: Boolean);
begin
   FDeleted := 'false';
   if Value = True then
     FDeleted := 'true';
end;

end.
