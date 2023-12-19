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
  dataset.Serialize,
  MemDS,
  DBAccess,
  Uni,
  PostgreSQLUniProvider,
  uUtilitarios in 'Utils\uUtilitarios.pas',
  Model.Ponto in 'Model\Model.Ponto.pas',
  Model.Conexao in 'Model\Model.Conexao.pas',
  Controller.Ponto in 'Controller\Controller.Ponto.pas';

const
 LineEnding = #13#10;
 Versao = '1.0.0';

Var
  App: THorse;
  Caminho:String;

 begin
  try
     HorseCORS
       .AllowedOrigin('*')
//       .AllowedCredentials(true)
//       .AllowedHeaders('*')
//       .AllowedMethods('*')
//       .ExposedHeaders('*')
    ;

    THorse.Use(CORS)
          .Use(Jhonson());

    try
      Model.Conexao.Conectar;

      RegistrarEndponts;
    except
      on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
    end;

    THorse.Listen(9000,procedure
      begin
        Writeln('CSL Softwares Ltda. ' + FormatDateTime('yyyy-mm-dd hh:nn:ss',Now) + ' Versão ' + Versao );
        Writeln('AR Bonificação - API de Bonificação do Operacional');
        Writeln(format('Servidor esta sendo executado %s:%d',[app.Host,app.Port]) + LineEnding);
      end);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);

  end;
end.
