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

    function getFAtivo: Boolean;
    function getFComOS: Boolean;
    function getFDeleted: Boolean;
    procedure putFAtivo(const Value: Boolean);
    procedure putFComOS(const Value: Boolean);
    procedure putFDeleted(const Value: Boolean);
  public
      constructor Create;
      destructor Destroy; override;

      property Id :              Integer read FId               write FId;
      property Id_tipo :         Integer read FId_tipo          write FId_tipo;
      property Id_grupo :        Integer read FId_grupo         write FId_grupo;
      property Id_regiao :       Integer read FId_regiao        write FId_regiao;
      property Ponto :           Double  read FPonto            write FPonto;
      property PontoRetirar:     Double  read FPontoRet         write FPontoRet;
      property Comos :           Boolean read getFComOS         write putFComOS;
      property Tratativa:        char    read FTratativa        write FTratativa;
      property TratativaNivel:   char    read FTratativaNivel   write FTratativaNivel;
      property TratativaTipo:    char    read FTratativaTipo    write FTratativaTipo;
      property TratativaModo:    char    read FTratativaModo    write FTratativaModo;
      property NivelDificuldade: char    read FNivelDificuldade write FNivelDificuldade;
      property Observacao:       String  read FObservacao       write FObservacao;
      property DataCadastro:   Tdatetime read FDataCadastro     write FDataCadastro;
      property DataAlteracao:  Tdatetime read FDataAlteracao    write FDataAlteracao;
      property Ativo:            Boolean read getFAtivo         write putFAtivo;
      property Deleted:          Boolean read getFDeleted       write putFDeleted;

      property CampoID:          String  read FCampoID          write FCampoID;
      property Campos :          String  read FCampos           write FCampos;
      property Tabela :          String  read FNome_Tabela      write FNome_Tabela;

      function Listar: string;
      function Inserir: String;
      function Editar: String;
      function Excluir: String;
  end;

  TPontoMeta = class
  private
  protected
      FId : Integer;
      FId_grupo : Integer;
      FId_regiao : integer;
      FPontoInicial : integer;
      FPontoFinal   : integer;
      FPontoValor   : Double;
      FPontoTipo    : Char;   // (P)onto / (V)alor / per(C)entual
      FId_grupo_referencia : integer;
      FObservacao: String;
      FDataCadastro : TDateTime;
      FDataAlteracao : TDateTime;
      FPontoMedio   : String;
      FAtivo : String;
      FDeleted : String;

      FNome_Tabela : String;
      FCampos : String;
      FCampoID : String;

    function getFAtivo: Boolean;
    function getFDeleted: Boolean;
    function getFPontoMedio: Boolean;
    procedure putFAtivo(const Value: Boolean);
    procedure putFDeleted(const Value: Boolean);
    procedure putFPontoMedio(const Value: Boolean);

  public
      constructor Create;
      destructor Destroy; override;

      property Id :              Integer read FId               write FId;
      property Id_grupo :        Integer read FId_grupo         write FId_grupo;
      property Id_regiao :       Integer read FId_regiao        write FId_regiao;
      property PontoInicial :    integer read FPontoInicial     write FPontoInicial;
      property PontoFinal :      integer read FPontoFinal       write FPontoFinal;
      property PontoValor:       Double  read FPontoValor       write FPontoValor;
      property PontoTipo:        char    read FPontoTipo        write FPontoTipo;
      property Id_grupo_Referencia: integer read FId_grupo_referencia write FId_grupo_referencia;
      property Observacao:       String  read FObservacao       write FObservacao;
      property DataCadastro:   Tdatetime read FDataCadastro     write FDataCadastro;
      property DataAlteracao:  Tdatetime read FDataAlteracao    write FDataAlteracao;
      property PontoMedio:       Boolean read getFPontoMedio    write putFPontoMedio;
      property Ativo:            Boolean read getFAtivo         write putFAtivo;
      property Deleted:          Boolean read getFDeleted       write putFDeleted;

      property CampoID:          String  read FCampoID          write FCampoID;
      property Campos :          String  read FCampos           write FCampos;
      property Tabela :          String  read FNome_Tabela      write FNome_Tabela;

      function Listar: string;
      function Inserir: String;
      function Editar: String;
      function Excluir: String;
  end;

  TPontoPenalidade = class
  private
  protected
      FId : Integer;
      FDescricao : String;
      FObservacao: String;
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

      property Id :              Integer read FId               write FId;
      property Descricao:        String  read FDescricao        write FDescricao;
      property Observacao:       String  read FObservacao       write FObservacao;
      property DataCadastro:   Tdatetime read FDataCadastro     write FDataCadastro;
      property DataAlteracao:  Tdatetime read FDataAlteracao    write FDataAlteracao;
      property Ativo:            Boolean read getFAtivo         write putFAtivo;
      property Deleted:          Boolean read getFDeleted       write putFDeleted;

      property CampoID:          String  read FCampoID          write FCampoID;
      property Campos :          String  read FCampos           write FCampos;
      property Tabela :          String  read FNome_Tabela      write FNome_Tabela;

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
  FCampos      := 'tipo_id,grupo_id,regiao_id,ponto,tratativa,tratativa_nivel,modo,tratativa_tipo,nivel,observacao,ponto_ret,comos,ativo';
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
  FPontoRet        := -1 ;
  FComOS           := '' ;
  FTratativa       := ' ';
  FTratativaNivel  := ' ';
  FTratativaTipo   := ' ';
  FTratativaModo   := ' ';
  FNivelDificuldade:= ' ';
  FObservacao      := '' ;
  FDataCadastro    := -1 ;
  FDataAlteracao   := -1 ;
  FAtivo           := '' ;
  FDeleted         := '' ;

end;

destructor TPontoRegra.Destroy;
begin

  inherited Destroy;
end;

function TPontoRegra.Editar: String;
Var
  Qry : TUniQuery;
  _SQL : String;

  Vtipo_id,Vgrupo_id,Vregiao_id,Vponto,Vponto_ret,Vcom_os,
  Vtratativa,Vtratativa_nivel,Vtratativa_tipo,Vtratativa_modo,
  Vnivel_dificuldade,Vobservacao,VAtivo,Vid,VDeleted: string;


Begin
  Vtipo_id := '';
  Vgrupo_id := '';
  Vregiao_id := '';
  Vponto := '';
  Vponto_ret := '';
  Vcom_os := '';
  Vtratativa := '';
  Vtratativa_nivel := '';
  Vtratativa_tipo := '';
  Vtratativa_modo := '';
  Vnivel_dificuldade := '';
  Vobservacao := '';
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


  if FId_tipo          <> -1  then  Vtipo_id           := Format('tipo_id         = %d,' + LineEnding,[FId_tipo]);
  if FId_grupo         <> -1  then  Vgrupo_id          := Format('grupo_id        = %d,' + LineEnding,[FId_grupo]);
  if FId_regiao        <> -1  then  Vregiao_id         := Format('regiao_id       = %d,' + LineEnding,[FId_tipo]);
  if FPonto            <> -1  then  Vponto             := Format('ponto           = %d,' + LineEnding,[FloatToStr(FPonto)]);
  if FPontoRet         <> -1  then  Vponto_ret         := Format('ponto_ret       = %d,' + LineEnding,[FloatToStr(FPontoRet)]);
  if FComOS            <> ''  then  Vcom_os            := Format('comos           = %s,' + LineEnding,[QuotedStr(FComOS)]);
  if FTratativa        <> ' ' then  Vtratativa         := Format('tratativa       = %s,' + LineEnding,[QuotedStr(FTratativa)]);
  if FTratativaNivel   <> ' ' then  Vtratativa_nivel   := Format('tratativa_nivel = %s,' + LineEnding,[QuotedStr(FTratativaNivel)]);
  if FTratativaModo    <> ' ' then  Vtratativa_modo    := Format('modo            = %s,' + LineEnding,[QuotedStr(FTratativaModo)]);
  if FTratativaTipo    <> ' ' then  Vtratativa_tipo    := Format('tratativa_tipo  = %s,' + LineEnding,[QuotedStr(FTratativaTipo)]);
  if FNivelDificuldade <> ' ' then  Vnivel_dificuldade := Format('nivel           = %s,' + LineEnding,[QuotedStr(FNivelDificuldade)]);
  if FObservacao       <> ''  then  Vobservacao        := Format('observacao      = %s,' + LineEnding,[QuotedStr(FObservacao)]);
  if FAtivo            <> ''  then  VAtivo             := Format('ativo           = %s,' + LineEnding,[FAtivo]);
  if FDeleted          <> ''  then  VDeleted           := Format('is_deleted      = %s,' + LineEnding,[FDeleted]);



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
            Vtipo_id,
            Vgrupo_id,
            Vregiao_id,
            Vponto,
            Vponto_ret,
            Vcom_os,
            Vtratativa,
            Vtratativa_nivel,
            Vtratativa_tipo,
            Vtratativa_modo,
            Vnivel_dificuldade,
            Vobservacao,
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

function TPontoRegra.Excluir: String;
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
     // 'tipo_id,grupo_id,regiao_id,ponto,tratativa,tratativa_nivel,modo,tratativa_tipo,nivel,observacao,ponto_ret,comos,data_alteracao,ativo';
      _SQL :=
         format('With inserir as (' + LineEnding +
                'Insert into %s ( %s )' + LineEnding +
                    // 'tipo_id,grupo_id,regiao_id,ponto,tratativa,tratativa_nivel,modo,tratativa_tipo,nivel,observacao,ponto_ret,comos,ativo';
                'VALUES(%d,     %d,      %d,       %s,   %s,       %s,             %s,  %s,            %s,   %s,        %s,       %s,   %s)' + LineEnding +
                'RETURNING %s ) Select to_jsonb(row) as consulta from (Select ''success'' as status, ''Regra adicionada com sucesso'' as msg,%s as id from inserir)row '
                 ,[
                 FNome_Tabela, FCampos,
                 FId_tipo,
                 Id_grupo,
                 FId_regiao,
                 FloatToStr(FPonto),
                 QuotedStr(FTratativa),
                 QuotedStr(FTratativaNivel),
                 QuotedStr(FTratativaModo),
                 QuotedStr(FTratativaTipo),
                 QuotedStr(FNivelDificuldade),
                 QuotedStr(FObservacao),
                 FloatToStr(FPontoRet),
                 FComOS,
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
      '		Select                                   ' + LineEnding +
      '   gp.id,                                   ' + LineEnding +
      '   gp.tipo_id as id_tipo,                   ' + LineEnding +
      '   gp.grupo_id as id_grupo,                 ' + LineEnding +
      '   gp.regiao_id as id_regiao,               ' + LineEnding +
      '   gp.ponto,                                ' + LineEnding +
      '   gp.ponto_ret,                            ' + LineEnding +
      '   gp.comos as com_os,                      ' + LineEnding +
      '   gp.tratativa,                            ' + LineEnding +
      '   gp.tratativa_nivel,                      ' + LineEnding +
      '   gp.tratativa_tipo,                       ' + LineEnding +
      '   gp.modo as tratativa_modo,               ' + LineEnding +
      '   gp.nivel as nivel_dificuldade,           ' + LineEnding +
      '   gp.observacao,                           ' + LineEnding +
      '   gp.data_alteracao,                       ' + LineEnding +
      '   gp.data_cadastro,                        ' + LineEnding +
      '   gp.ativo,                                ' + LineEnding +
      '   gp.is_deleted as deletado,               ' + LineEnding +

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
      '		END)::character varying AS tipo_descricao,                                                                                                                                        ' + LineEnding +

      '   st.descricao as grupo_descricao,         ' + LineEnding +
      '   rg.nome as regiao_nome,                  ' + LineEnding +
      '		btrim(to_char((gp.ponto)::real, ''990D99''::text)) AS ponto_descricao,                                                                                                            ' + LineEnding +
      '		btrim(to_char((gp.ponto_ret)::real, ''990D99''::text)) AS ponto_ret_descricao,                                                                                                    ' + LineEnding +

      '		( CASE gp.comos                                                                                                                                                                   ' + LineEnding +
      '		     WHEN true  THEN ''Com O.S.''::varchar                                                                                                                                        ' + LineEnding +
      '				 WHEN false THEN ''Sem O.S.''::varchar                                                                                                                                        ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END)::character varying AS com_os_descricao,                                                                                                                                       ' + LineEnding +

      '		( CASE gp.tratativa                                                                                                                                                               ' + LineEnding +
      '				 WHEN ''C''::bpchar THEN ''Criação''::varchar                                                                                                                                 ' + LineEnding +
      '				 WHEN ''R''::bpchar THEN ''Responsável''::varchar                                                                                                                             ' + LineEnding +
      '				 WHEN ''F''::bpchar THEN ''Finalizador''::varchar                                                                                                                             ' + LineEnding +
      '				 WHEN ''V''::bpchar THEN ''Vedendor''::varchar                                                                                                                                ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END)::character varying AS tratativa_descricao,                                                                                                                                   ' + LineEnding +

      '		( CASE gp.tratativa_nivel                                                                                                                                                         ' + LineEnding +
      '				 WHEN ''O''::bpchar THEN ''Atendimento''::varchar       -- A                                                                                                                  ' + LineEnding +
      '				 WHEN ''S''::bpchar THEN ''Ordem de Serviço''::varchar  -- O                                                                                                                  ' + LineEnding +
      '				 WHEN ''A''::bpchar THEN ''Administrativo''::varchar                                                                                                                          ' + LineEnding +
      '				 WHEN ''P''::bpchar THEN ''Operacional''::varchar                                                                                                                             ' + LineEnding +
      '				 WHEN ''V''::bpchar THEN ''Vendas''::varchar                                                                                                                                  ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END )::character varying AS tratativa_nivel_descricao,                                                                                                                             ' + LineEnding +

      '		( CASE gp.tratativa_tipo                                                                                                                                                          ' + LineEnding +
      '				 WHEN ''A''::bpchar THEN ''Abertura''::varchar    -- A                                                                                                                        ' + LineEnding +
      '				 WHEN ''F''::bpchar THEN ''Fechamento''::varchar  -- O                                                                                                                        ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END )::character varying AS tratativa_tipo_descricao,                                                                                                                             ' + LineEnding +

      '		( CASE gp.modo                                                                                                                                                                    ' + LineEnding +
      '				 WHEN ''B''::bpchar THEN ''Bonificação''::varchar -- A                                                                                                                        ' + LineEnding +
      '				 WHEN ''P''::bpchar THEN ''Penalidade''::varchar  -- O                                                                                                                        ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END )::character varying AS tratativa_modo_descricao,                                                                                                                             ' + LineEnding +

      '		( CASE gp.nivel                                                                                                                                                                   ' + LineEnding +
      '				 WHEN ''B''::bpchar THEN ''Baixo''::varchar  -- B                                                                                                                             ' + LineEnding +
      '				 WHEN ''M''::bpchar THEN ''Medio''::varchar  -- M                                                                                                                             ' + LineEnding +
      '				 WHEN ''A''::bpchar THEN ''Alto''::varchar   -- A                                                                                                                             ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END )::character varying AS nivel_dififuldade_descricao,                                                                                                                          ' + LineEnding +

      '		( CASE gp.ativo                                                                                                                                                                   ' + LineEnding +
      '		     WHEN true THEN ''Ativo''::varchar                                                                                                                                            ' + LineEnding +
      '				 WHEN false THEN ''Inativo''::varchar                                                                                                                                         ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END)::character varying AS ativo_descricao,                                                                                                                                       ' + LineEnding +

      '		( CASE gp.is_deleted                                                                                                                                                              ' + LineEnding +
      '		     WHEN true THEN ''Apagado''::varchar                                                                                                                                          ' + LineEnding +
      '				 WHEN false THEN ''Não Apagado''::varchar                                                                                                                                     ' + LineEnding +
      '				 ELSE ''''::varchar                                                                                                                                                           ' + LineEnding +
      '		END)::character varying AS deletado_descricao                                                                                                                                     ' + LineEnding +
      '		FROM %s gp                                                                                                                                                                        ' + LineEnding +
      '		Inner JOIN "sipp"."a_core_grupo" cg ON (cg.id       = gp.grupo_id)                                                                                                                ' + LineEnding +
      '		inner jOIN "sipp"."a_core_regiao" rg ON (rg.id=gp.regiao_id)                                                                                                                      ' + LineEnding +
      '		Left  JOIN "public"."setor"      st ON (st.id_setor = cg.setor_id)                                                                                                                ' + LineEnding +
      '		WHERE ((gp.modo = ''B''::bpchar AND gp.is_deleted = false))                                                                                                                       ' + LineEnding +
      '		ORDER BY st.descricao                                                                                                                                                             ' + LineEnding +
      ') Select * from Bonificacao Where 1 = 1                                                                                                                                              ' + LineEnding
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

      Result := Qry.FieldByName('consulta').AsString;

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

{ TPontoMeta }

constructor TPontoMeta.Create;
Begin
  FNome_Tabela := 'sipp.a_ponto_meta';
//  FCampos      := 'regiao_id,grupo_id,ponto_inicial,ponto_final,ponto_valor,tipo,media,referencia_grupo_id,observacao,ativo';
  FCampos      := 'regiao_id,grupo_id,ponto_inicial,ponto_final,ponto_valor,tipo,media,observacao,ativo';
  FCampoID     := 'id';

  if Not Conn.Connected then
     Model.Conexao.Conectar;

  FId              := -1 ;
  FId_grupo        := -1 ;
  FId_regiao       := -1 ;
  FPontoInicial    := -1 ;
  FPontoFinal      := -1 ;
  FPontoValor      := -1 ;
  FPontoTipo       := ' ';  // (P)onto / (V)alor / per(C)entual
  FId_grupo_referencia := -1;
  FObservacao      := '' ;
  FDataCadastro    := -1 ;
  FDataAlteracao   := -1 ;
  FPontoMedio      := '' ;
  FAtivo           := '' ;
  FDeleted         := '' ;

end;

destructor TPontoMeta.Destroy;
begin

  inherited Destroy;
end;

function TPontoMeta.Inserir: String;
Var
  Qry : TUniQuery;
  _SQL : String;
Begin
  Qry := TUniQuery.Create(nil);
  try
    Try
                    // 'regiao_id,grupo_id,ponto_inicial,ponto_final,ponto_valor,tipo,media,observacao,ativo'
      _SQL :=
         format('With inserir as (' + LineEnding +
                'Insert into %s ( %s )' + LineEnding +
                'VALUES(%d, %d, %d, %d, %s, %s, %s, %s, %s)' + LineEnding +
                'RETURNING %s ) Select to_jsonb(row) as consulta from (Select ''success'' as status, ''Meta adicionada com sucesso'' as msg,%s as id from inserir)row '
                 ,[
                 FNome_Tabela, FCampos,
                 FId_regiao,
                 FId_grupo,
                 FPontoInicial,
                 FPontoFinal,
                 FloatToStr(FPontoValor),
                 QuotedStr(FPontoTipo),
                 FPontoMedio,
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

function TPontoMeta.Listar: string;
Var
   Qry : TUniQuery;
  _SQL : String;
Begin
  try

   Qry  := TUniQuery.Create(nil);

   _SQL := '';

   Try
      _SQL := 'Select to_jsonb(array_agg(row)) as consulta from ( ';
      _SQL := _SQL +

    'With metas as ( ' + LineEnding +
    'SELECT  ' + LineEnding +
    'pm.id,  ' + LineEnding +
    'pm.regiao_id as id_regiao, ' + LineEnding +
    'pm.grupo_id as id_grupo, ' + LineEnding +
    'st.id_setor ,' + LineEnding +
    'pm.ponto_inicial,                                                             ' + LineEnding +
    'pm.ponto_final,                                                               ' + LineEnding +
    'pm.ponto_valor,                                                               ' + LineEnding +
    'pm.tipo as ponto_tipo,                                                        ' + LineEnding +
    'pm.referencia_grupo_id as id_grupo_referencia,                                ' + LineEnding +
    'pm.media as ponto_medio,                                                      ' + LineEnding +
    'pm.ativo,                                                                     ' + LineEnding +
    'pm.data_cadastro,                                                             ' + LineEnding +
    'pm.data_alteracao,                                                            ' + LineEnding +
    'pm.is_deleted as deletado,                                                    ' + LineEnding +
    'st.descricao as grupo_descricao,                                              ' + LineEnding +
    'cr.nome as regiao_descricao,                                                  ' + LineEnding +
    '(to_char(pm.ponto_valor, (''99999990D009'')))::varchar AS ponto_valor_format, ' + LineEnding +
    '( CASE pm.tipo                                                                ' + LineEnding +
    '   WHEN ''P''::bpchar THEN ''Pontuação''                                      ' + LineEnding +
    '		WHEN ''V''::bpchar THEN ''Valor (R$)''                                     ' + LineEnding +
    '		WHEN ''C'' THEN ''Percentual (%)''                                         ' + LineEnding +
    '		ELSE ''desconhecido''                                                      ' + LineEnding +
    'END)::varchar AS tipo_descricao,                                              ' + LineEnding +
    '( CASE pm.media                                                               ' + LineEnding +
    '    WHEN true THEN ''Ativo''::varchar                                         ' + LineEnding +
    '		WHEN false THEN ''Inativo''::varchar                                       ' + LineEnding +
    '		ELSE ''desconhecido''::varchar                                             ' + LineEnding +
    'END)::varchar AS ativo_descricao,                                             ' + LineEnding +
    '( CASE pm.ativo                                                               ' + LineEnding +
    '    WHEN true THEN ''Ativo''::varchar                                         ' + LineEnding +
    '		WHEN false THEN ''Inativo''::varchar                                       ' + LineEnding +
    '		ELSE ''desconhecido''::varchar                                             ' + LineEnding +
    'END)::varchar AS ativo_descricao,                                             ' + LineEnding +
    '( CASE pm.is_deleted                                                          ' + LineEnding +
    '    WHEN true THEN ''Apagado''::varchar                                       ' + LineEnding +
    '		WHEN false THEN ''Não Apagado''::varchar                                   ' + LineEnding +
    '		ELSE ''desconhecido''::varchar                                             ' + LineEnding +
    'END)::varchar AS deletado_descricao                                           ' + LineEnding +
    'FROM ' + FNome_Tabela + ' pm                                                  ' + LineEnding +
    'Inner JOIN a_core_grupo     cg ON (cg.id = pm.grupo_id)                       ' + LineEnding +
    'Inner JOIN a_core_regiao    cr ON (cr.id = pm.regiao_id)                      ' + LineEnding +
    'Inner JOIN "public"."setor" st ON (st.id_setor = cg.setor_id)                 ' + LineEnding +
    'ORDER BY pm.id                                                                ' + LineEnding +
    ') Select * from metas Where 1 = 1                                             ' + LineEnding ;

      if FId > 0 then
        _SQL := _SQL + Format(' %s',[Format('AND %s = %d',[FCampoID,FId])]);

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

      Result := Qry.FieldByName('consulta').AsString;

    except on ex:exception do
      begin
         Result := format( ' {                                                   ' + LineEnding +
                           '     "status": "error",                              ' + LineEnding +
                           '     "msg": "Erro ao Consultar, Tabela: %s  erro: %s"  ' + LineEnding +
                           ' }                                                   ' + LineEnding ,[FNome_Tabela,ex.Message]);
      end;
  end;
  finally
    Qry.Free;
  end;
end;

function TPontoMeta.Editar: String;
Var
  Qry : TUniQuery;
  _SQL : String;

  Vregiao_id,Vgrupo_id,Vpontoinicial,Vpontofinal,Vpontovalor,Vpontotipo,
  Vpontomedio,Vid_grupo_referencia, Vobservacao,VAtivo,Vid,VDeleted: string;


Begin
  Vregiao_id := '';
  Vgrupo_id := '';
  Vpontoinicial := '';
  Vpontofinal := '';
  Vpontovalor := '';
  Vpontotipo := '';
  Vpontomedio := '';
  Vid_grupo_referencia := '';
  Vobservacao := '';
  VAtivo := '';
  Vid := '';
  VDeleted := '';

  if FId < 0 then begin
   Result := format( ' {                                                       ' + LineEnding +
                     '     "status": "error",                                  ' + LineEnding +
                     '     "msg": "Informe o id, Tabela: %s  erro: Faltou informar o id"  ' + LineEnding +
                     ' }                                                       ' + LineEnding ,[FNome_Tabela]);
    exit;
  end;

  if FId_regiao           <> -1  then  Vregiao_id           := Format('regiao_id           = %d,' + LineEnding,[FId_regiao]);
  if FId_grupo            <> -1  then  Vgrupo_id            := Format('grupo_id            = %d,' + LineEnding,[FId_grupo]);
  if FPontoInicial        <> -1  then  Vpontoinicial        := Format('ponto_inicial       = %d,' + LineEnding,[FPontoInicial]);
  if FPontoFinal          <> -1  then  Vpontofinal          := Format('ponto_final         = %d,' + LineEnding,[FPontoFinal]);
  if FPontoValor          <> -1  then  Vpontovalor          := Format('ponto_valor         = %s,' + LineEnding,[FloatToStr(FPontoValor)]);
  if FPontoTipo           <> ' ' then  Vpontotipo           := Format('tipo                = %s,' + LineEnding,[QuotedStr(FPontoTipo)]);
  if FPontoMedio          <> ''  then  Vpontomedio          := Format('media               = %s,' + LineEnding,[QuotedStr(FPontoMedio)]);
  if FId_grupo_referencia <> -1  then  Vid_grupo_referencia := Format('referencia_grupo_id = %d,' + LineEnding,[FId_grupo_referencia]);
  if FObservacao          <> ''  then  Vobservacao          := Format('observacao          = %s,' + LineEnding,[QuotedStr(FObservacao)]);
  if FAtivo               <> ''  then  VAtivo               := Format('ativo               = %s,' + LineEnding,[FAtivo]);
  if FDeleted             <> ''  then  VDeleted             := Format('is_deleted          = %s,' + LineEnding,[FDeleted]);

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
          '  %s' +
          '  %s' +
          '  %s' +
          'data_alteracao = now()'   + LineEnding +
          'Where id = %d         '   ,
          [
           FNome_Tabela,
            Vregiao_id,
            Vgrupo_id,
            Vpontoinicial,
            Vpontofinal,
            Vpontovalor,
            Vpontotipo,
            Vpontomedio,
            Vid_grupo_referencia,
            Vobservacao,
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

function TPontoMeta.Excluir: String;
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
                           '     "status": "error",                              ' + LineEnding +
                           '     "msg": "Erro ao excluir, Tabela: %s  erro: %s"   ' + LineEnding +
                           ' }                                                   ' + LineEnding ,[FNome_Tabela,ex.Message]);
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TPontoMeta.getFAtivo: Boolean;
begin
   Result := False;
   if FAtivo = 'true' then
     Result := True;
end;

function TPontoMeta.getFDeleted: Boolean;
begin
   Result := False;
   if FDeleted = 'true' then
     Result := True;
end;

function TPontoMeta.getFPontoMedio: Boolean;
begin
   Result := False;
   if FPontoMedio = 'true' then
     Result := True;
end;

procedure TPontoMeta.putFAtivo(const Value: Boolean);
begin
   FAtivo := 'false';
   if Value = True then
     FAtivo := 'true';
end;

procedure TPontoMeta.putFDeleted(const Value: Boolean);
begin
   FDeleted := 'false';
   if Value = True then
     FDeleted := 'true';
end;

procedure TPontoMeta.putFPontoMedio(const Value: Boolean);
begin
   FPontoMedio := 'false';
   if Value = True then
     FPontoMedio := 'true';
end;

{ TPontoPenalidade }

constructor TPontoPenalidade.Create;
Begin
  FNome_Tabela := 'sipp.a_ponto_penalidadetipo';
  FCampos      := 'descricao,observacao,ativo';
  FCampoID     := 'id';

  if Not Conn.Connected then
     Model.Conexao.Conectar;

  FId              := -1 ;
  FDescricao       := '' ;
  FObservacao      := '' ;
  FDataCadastro    := -1 ;
  FDataAlteracao   := -1 ;
  FAtivo           := '' ;
  FDeleted         := '' ;

end;

destructor TPontoPenalidade.Destroy;
begin

  inherited Destroy;
end;

function TPontoPenalidade.Inserir: String;
Var
  Qry : TUniQuery;
  _SQL : String;
Begin
  Qry := TUniQuery.Create(nil);
  try
    Try
                    // 'descricao,observacao,ativo'
      _SQL :=
         format('With inserir as (' + LineEnding +
                'Insert into %s ( %s )' + LineEnding +
                'VALUES(%s, %s, %s)' + LineEnding +
                'RETURNING %s ) Select to_jsonb(row) as consulta from (Select ''success'' as status, ''Penalidade adicionada com sucesso'' as msg,%s as id from inserir)row '
                 ,[
                 FNome_Tabela, FCampos,
                 FDescricao,
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

function TPontoPenalidade.Listar: string;
Var
   Qry : TUniQuery;
  _SQL : String;
Begin
  try

   Qry  := TUniQuery.Create(nil);

   _SQL := '';

   Try
      _SQL := 'Select to_jsonb(array_agg(row)) as consulta from ( ';
      _SQL := _SQL +  'SELECT id,descricao,observacao,data_cadastro,data_alteracao,ativo,is_deleted as deletado FROM ' + FNome_Tabela + ' Where 1 = 1 ' + LineEnding ;

      if FId > 0 then
        _SQL := _SQL + Format(' %s',[Format('AND %s = %d',[FCampoID,FId])]);

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
                           '     "status": "error",                              ' + LineEnding +
                           '     "msg": "Erro ao Consultar, Tabela: %s  erro: %s"  ' + LineEnding +
                           ' }                                                   ' + LineEnding ,[FNome_Tabela,ex.Message]);
      end;
  end;
  finally
    Qry.Free;
  end;
end;

function TPontoPenalidade.Editar: String;
Var
  Qry : TUniQuery;
  _SQL : String;

  Vdescricao,Vobservacao,VAtivo,Vid,VDeleted: string;


Begin
  Vdescricao := '';
  Vobservacao := '';
  VAtivo := '';
  Vid := '';
  VDeleted := '';

  if FId < 0 then begin
   Result := format( ' {                                                       ' + LineEnding +
                     '     "status": "error",                                  ' + LineEnding +
                     '     "msg": "Informe o id, Tabela: %s  erro: Faltou informar o id"  ' + LineEnding +
                     ' }                                                       ' + LineEnding ,[FNome_Tabela]);
    exit;
  end;

  if FDescricao           <> ''  then  Vdescricao           := Format('descricao           = %s,' + LineEnding,[QuotedStr(FDescricao)]);
  if FObservacao          <> ''  then  Vobservacao          := Format('observacao          = %s,' + LineEnding,[QuotedStr(FObservacao)]);
  if FAtivo               <> ''  then  VAtivo               := Format('ativo               = %s,' + LineEnding,[FAtivo]);
  if FDeleted             <> ''  then  VDeleted             := Format('is_deleted          = %s,' + LineEnding,[FDeleted]);

  _SQL := LineEnding +
   format('update %s set         '   + LineEnding +
          '  %s' +
          '  %s' +
          '  %s' +
          '  %s' +
          'data_alteracao = now()'   + LineEnding +
          'Where id = %d         '   ,
          [
           FNome_Tabela,
            Vdescricao,
            Vobservacao,
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

function TPontoPenalidade.Excluir: String;
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
                           '     "status": "error",                              ' + LineEnding +
                           '     "msg": "Erro ao excluir, Tabela: %s  erro: %s"   ' + LineEnding +
                           ' }                                                   ' + LineEnding ,[FNome_Tabela,ex.Message]);
      end;
    end;
  finally
    Qry.Free;
  end;
end;

function TPontoPenalidade.getFAtivo: Boolean;
begin
   Result := False;
   if FAtivo = 'true' then
     Result := True;
end;

function TPontoPenalidade.getFDeleted: Boolean;
begin
   Result := False;
   if FDeleted = 'true' then
     Result := True;
end;

procedure TPontoPenalidade.putFAtivo(const Value: Boolean);
begin
   FAtivo := 'false';
   if Value = True then
     FAtivo := 'true';
end;

procedure TPontoPenalidade.putFDeleted(const Value: Boolean);
begin
   FDeleted := 'false';
   if Value = True then
     FDeleted := 'true';
end;

end.
