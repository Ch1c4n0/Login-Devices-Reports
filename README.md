# Login Devices Reports

This repository contains the PowerShell script `Login_Report.ps1` which queries Microsoft Graph sign-in (audit) logs and exports a CSV report of device login information. Below is a line-by-line explanation in English followed by the Portuguese translation (Explicação em Português).

---

## File: `Login_Report.ps1`

The script lines are shown with their explanation. For each entry: the original line (code) is shown, then an English explanation, then the Portuguese explanation.

1) ```powershell
# Etapa 1: Instalar o módulo Microsoft Graph (se ainda não tiver)
```
- English: Comment: Step 1 — Install the Microsoft Graph module if it's not already installed.
- Português: Comentário: Etapa 1 — Instalar o módulo Microsoft Graph caso ainda não esteja instalado.

2) ```powershell
Install-Module Microsoft.Graph -Scope CurrentUser -Force
```
- English: Installs the `Microsoft.Graph` PowerShell module for the current user. `-Force` suppresses prompts and overwrites older installs.
- Português: Instala o módulo `Microsoft.Graph` para o usuário atual. `-Force` força a instalação sem prompts e substitui versões anteriores.

3) ```powershell

# Etapa 2: Importar o módulo
```
- English: Comment: Step 2 — Import the module into the current session.
- Português: Comentário: Etapa 2 — Importar o módulo para a sessão atual.

4) ```powershell
Import-Module Microsoft.Graph
```
- English: Loads the `Microsoft.Graph` module so its cmdlets are available in the session.
- Português: Carrega o módulo `Microsoft.Graph` para tornar seus cmdlets disponíveis.

5) ```powershell

# Etapa 3: Conectar à Microsoft Graph com escopo correto
```
- English: Comment: Step 3 — Connect to Microsoft Graph with the required permissions (scopes).
- Português: Comentário: Etapa 3 — Conectar ao Microsoft Graph com os escopos/permissões necessários.

6) ```powershell
Connect-MgGraph -Scopes "AuditLog.Read.All"
```
- English: Opens an interactive authentication flow to connect to Microsoft Graph and request the `AuditLog.Read.All` permission in order to read sign-in audit logs.
- Português: Abre o fluxo de autenticação interativo para se conectar ao Microsoft Graph e solicitar a permissão `AuditLog.Read.All` para ler logs de auditoria de entrada.

7) ```powershell

# Etapa 4: Definir intervalo de datas (últimos 2 dias como exemplo)
```
- English: Comment: Step 4 — Define the date range for the query (example uses the last 2 days).
- Português: Comentário: Etapa 4 — Definir o intervalo de datas para a consulta (exemplo: últimos 2 dias).

8) ```powershell
$startDate = (Get-Date).AddDays(-2).ToString("yyyy-MM-ddTHH:mm:ssZ")
```
- English: Creates a `$startDate` string representing the date-time two days ago in ISO 8601 format (UTC Z suffix). This is used to filter log entries.
- Português: Cria a string `$startDate` representando a data/hora de 2 dias atrás no formato ISO 8601 (sufixo Z para UTC). Usada para filtrar as entradas.

9) ```powershell
$endDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
```
- English: Creates `$endDate` as the current date-time in ISO 8601 format (UTC). Used as the upper bound for the query.
- Português: Cria `$endDate` com a data/hora atual no formato ISO 8601 (UTC). Usada como limite superior da consulta.

10) ```powershell

# Etapa 5: Consultar eventos de login
```
- English: Comment: Step 5 — Query sign-in (login) events from Microsoft Graph.
- Português: Comentário: Etapa 5 — Consultar eventos de login no Microsoft Graph.

11) ```powershell
$logins = Get-MgAuditLogSignIn -Filter "createdDateTime ge $startDate and createdDateTime le $endDate" -Top 1000
```
- English: Calls `Get-MgAuditLogSignIn` to retrieve sign-in records where `createdDateTime` is between `$startDate` and `$endDate`. `-Top 1000` requests up to 1000 records.
- Português: Chama `Get-MgAuditLogSignIn` para recuperar registros de login cujo `createdDateTime` esteja entre `$startDate` e `$endDate`. `-Top 1000` solicita até 1000 registros.

12) ```powershell

# Etapa 6: Selecionar campos relevantes com horário convertido para UTC-3
```
- English: Comment: Step 6 — Select the relevant fields and convert timestamps to UTC-3 (Brasília time).
- Português: Comentário: Etapa 6 — Selecionar campos relevantes e converter horários para UTC-3 (horário de Brasília).

13) ```powershell
$relatorio = $logins | Select-Object `
```
- English: Starts building a new object collection `$relatorio` by piping `$logins` into `Select-Object` with custom properties.
- Português: Inicia a criação da coleção `$relatorio` ao enviar `$logins` para `Select-Object` com propriedades personalizadas.

14) ```powershell
    @{Name="Data (UTC-3)";Expression={$_.CreatedDateTime.ToUniversalTime().AddHours(-3).ToString("yyyy-MM-dd HH:mm:ss")}},
```
- English: Creates a calculated property named `Data (UTC-3)`. It takes the record's `CreatedDateTime`, converts to UTC, subtracts 3 hours (UTC-3), and formats as `yyyy-MM-dd HH:mm:ss`.
- Português: Cria uma propriedade calculada `Data (UTC-3)`. Converte `CreatedDateTime` para UTC, subtrai 3 horas (UTC-3) e formata como `yyyy-MM-dd HH:mm:ss`.

15) ```powershell
    @{Name="Usuário";Expression={$_.UserDisplayName}},
```
- English: Adds property `Usuário` containing the sign-in record's `UserDisplayName` (display name of the user).
- Português: Adiciona a propriedade `Usuário` com o `UserDisplayName` (nome exibido do usuário) do registro.

16) ```powershell
    @{Name="UPN";Expression={$_.UserPrincipalName}},
```
- English: Adds property `UPN` with the user's principal name (UPN/email).
- Português: Adiciona `UPN` com o User Principal Name (geralmente o e-mail) do usuário.

17) ```powershell
    @{Name="Nome do Dispositivo";Expression={$_.DeviceDetail.DisplayName}},
```
- English: Adds `Nome do Dispositivo` with the device display name from the `DeviceDetail` object (if available).
- Português: Adiciona `Nome do Dispositivo` com o nome exibido do dispositivo vindo de `DeviceDetail` (se disponível).

18) ```powershell
    @{Name="Dispositivo ID";Expression={$_.DeviceDetail.DeviceId}},
```
- English: Adds `Dispositivo ID` with the device identifier from `DeviceDetail`.
- Português: Adiciona `Dispositivo ID` com o identificador do dispositivo em `DeviceDetail`.

19) ```powershell
    @{Name="Sistema Operacional";Expression={$_.DeviceDetail.OperatingSystem}},
```
- English: Adds `Sistema Operacional` containing the device OS information from `DeviceDetail`.
- Português: Adiciona `Sistema Operacional` com as informações do SO do dispositivo de `DeviceDetail`.

20) ```powershell
    @{Name="Status";Expression={$_.Status.ErrorCode}}
```
- English: Adds `Status` containing the sign-in status/error code (helps identify failures or success codes).
- Português: Adiciona `Status` com o código de erro/status do login (útil para identificar falhas ou sucessos).

21) ```powershell

# Etapa 7: Exportar para CSV
```
- English: Comment: Step 7 — Export the resulting report to a CSV file.
- Português: Comentário: Etapa 7 — Exportar o relatório resultante para um arquivo CSV.

22) ```powershell
$relatorio | Export-Csv -Path "Relatorio_Logins_Intune.csv" -NoTypeInformation -Encoding UTF8
```
- English: Exports the `$relatorio` objects to `Relatorio_Logins_Intune.csv` with UTF-8 encoding and without PowerShell type header info.
- Português: Exporta os objetos `$relatorio` para `Relatorio_Logins_Intune.csv` com codificação UTF-8 e sem informações de tipo do PowerShell.

23) ```powershell

Write-Host "✅ Relatório gerado com sucesso com horário ajustado para Brasília (UTC-3) e nome do dispositivo incluído!"
```
- English: Writes a success message to the console indicating the report was generated and time adjusted for Brasília (UTC-3).
- Português: Escreve uma mensagem de sucesso no console indicando que o relatório foi gerado e o horário ajustado para Brasília (UTC-3).

---

## Criar repositório GitHub e enviar os arquivos

Instruções rápidas para automatizar a criação do repositório e upload dos arquivos desta pasta:

Requisitos:
- git instalado
- GitHub CLI (gh) instalado e autenticado (gh auth login)

Opção automática (recomendada):
1. Abra PowerShell na pasta do projeto:
   cd "C:\Users\chica\OneDrive\vscode\Login Devices Reports"
2. Execute o script para criar o repositório e enviar os arquivos:
   .\create_and_push_repo.ps1 -RepoName "Login-Devices-Reports" -Public

Opção manual:
1. git init
2. git add .
3. git commit -m "Initial import"
4. gh repo create Login-Devices-Reports --public --source=. --remote=origin --push

Após o push, verifique o repositório em https://github.com/<seu-usuario>/Login-Devices-Reports

---

## Notes and small improvements
- English:
  - The script assumes interactive authentication (works when run in a user session).
  - If you need non-interactive automation, use an app registration and client credentials with appropriate graph permissions and adjust the auth flow.
  - The filter uses string interpolation in the `-Filter` argument; ensure the `$startDate`/`$endDate` values are in the correct Graph filter format (this script uses ISO strings).
  - For large environments consider paging or using a larger query strategy (and honoring Graph API throttling).

- Português:
  - O script supõe autenticação interativa (funciona quando executado em sessão de usuário).
  - Para automação sem interação, use um app registration com client credentials e permissões adequadas, e ajuste o fluxo de autenticação.
  - O filtro usa interpolação de string no argumento `-Filter`; verifique se `$startDate`/`$endDate` estão no formato esperado pelo Graph (este script usa strings ISO).
  - Em ambientes grandes, considere paginação ou estratégias de consulta maiores e cuide do tratamento de throttling da API Graph.

---

If you want, I can:
- Add a small PowerShell wrapper to accept start/end date parameters.
- Add a CSV path parameter or timestamped filename.
- Create a Git repo and make an initial commit (requires your Git credentials/local git).


