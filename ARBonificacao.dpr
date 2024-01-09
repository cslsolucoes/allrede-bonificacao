program ARBonificacao;

{$APPTYPE CONSOLE}

{$ifdef FPC}
  {$MODE DELPHI}{$H+}
{$endif}

{$R *.res}

uses
  {$ifdef FPC}
  SysUtils,
  {$else}
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  Data.DB,
  {$endif }
  Horse,
  horse.Jhonson,
  Horse.CORS,
  horse.JWT,
  dataset.Serialize,
  MemDS,
  DBAccess,
  Uni,
  PostgreSQLUniProvider,
  uUtilitarios in 'Utils\uUtilitarios.pas',
  Model.Ponto in 'Model\Model.Ponto.pas',
  Model.Conexao in 'Model\Model.Conexao.pas',
  Controller.Ponto in 'Controller\Controller.Ponto.pas',
  Model.Autenticacao in 'Model\Model.Autenticacao.pas',
  Model.dm in 'Model\Model.dm.pas' {DataModule1: TDataModule},
  Model.Regiao in 'Model\Model.Regiao.pas',
  Controller.Regiao in 'Controller\Controller.Regiao.pas',
  Controller.Autenticacao in 'Controller\Controller.Autenticacao.pas',
  Model.Grupo in 'Model\Model.Grupo.pas',
  Controller.Grupo in 'Controller\Controller.Grupo.pas',
  Model.Usuario in 'Model\Model.Usuario.pas',
  Controller.Usuario in 'Controller\Controller.Usuario.pas';

const
 LineEnding = #13#10;
 Versao = '1.0.0';

Var
  App: THorse;
  Caminho:String;

 begin
 {
 // writeln(Autenticacao('paineldevagas@api.com.br','Y*H4swkUsh$5ODw'));
  writeln(Autenticacao('claiton.linhares@allrede.com.br','Qbo23o4rsafe@'));
  Readln;

  Exit  ;
 }
  try
     Model.Conexao.Conectar;


     HorseCORS
       .AllowedOrigin('*')
//       .AllowedCredentials(true)
//       .AllowedHeaders('*')
//       .AllowedMethods('*')
//       .ExposedHeaders('*')
    ;

    THorse.Use(CORS);
    THorse.Use(Jhonson());

    //THorse.Use(HorseJWT(Model.Conexao.SECRET_KEY,THorseJWTConfig.New.SkipRoutes(['/','/login','/grupo'])));

    try
      Controller.Autenticacao.RegistrarEndponts;
      Controller.Ponto.RegistrarEndponts;
      Controller.Regiao.RegistrarEndponts;
      Controller.Grupo.RegistrarEndponts;
      Controller.Usuario.RegistrarEndponts;
    except
      on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
    end;

    THorse.Listen(9000,procedure
      begin
        Writeln('CSL Softwares Ltda. ' + FormatDateTime('yyyy-mm-dd hh:nn:ss',Now) + ' Versão ' + Versao );
        Writeln('AR Bonificação - API de Bonificação do Operacional');
        Writeln(format('Servidor esta sendo executado %s:%d   Versão Horse: %s',[app.Host,app.Port,thorse.Version]) + LineEnding);
      end);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);

  end;
end.
