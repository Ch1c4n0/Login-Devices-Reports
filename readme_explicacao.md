# Explicação do Script Login_Report.ps1

## Português

1. `# Repositório alvo: Login-Devices-Reports (GitHub)`
   - Comentário indicando o repositório de destino.
2. `# Descrição: Script PowerShell para gerar relatório de logins via Microsoft Graph`
   - Comentário descrevendo o objetivo do script.
3. `Install-Module Microsoft.Graph -Scope CurrentUser -Force`
   - Instala o módulo Microsoft Graph para o usuário atual.
4. `Import-Module Microsoft.Graph`
   - Importa o módulo Microsoft Graph para uso no script.
5. `Connect-MgGraph -Scopes "AuditLog.Read.All"`
   - Conecta à Microsoft Graph com permissão para ler logs de auditoria.
6. `$startDate = (Get-Date).AddDays(-2).ToString("yyyy-MM-ddTHH:mm:ssZ")`
   - Define a data inicial do filtro (2 dias atrás).
7. `$endDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")`
   - Define a data final do filtro (agora).
8. `$logins = Get-MgAuditLogSignIn -Filter "createdDateTime ge $startDate and createdDateTime le $endDate" -Top 1000`
   - Busca os eventos de login no intervalo definido.
9. `$relatorio = $logins | Select-Object ...`
   - Seleciona e formata os campos relevantes do resultado, incluindo conversão de horário para UTC-3.
10. `$relatorio | Export-Csv -Path "Relatorio_Logins_Intune.csv" -NoTypeInformation -Encoding UTF8`
    - Exporta o relatório para um arquivo CSV.
11. `Write-Host "✅ Relatório gerado com sucesso !"`
    - Exibe mensagem de sucesso.
12. Comentários finais explicam como enviar o arquivo para o GitHub.

## English

1. `# Target repository: Login-Devices-Reports (GitHub)`
   - Comment indicating the target repository.
2. `# Description: PowerShell script to generate login reports via Microsoft Graph`
   - Comment describing the script's purpose.
3. `Install-Module Microsoft.Graph -Scope CurrentUser -Force`
   - Installs the Microsoft Graph module for the current user.
4. `Import-Module Microsoft.Graph`
   - Imports the Microsoft Graph module for use in the script.
5. `Connect-MgGraph -Scopes "AuditLog.Read.All"`
   - Connects to Microsoft Graph with permission to read audit logs.
6. `$startDate = (Get-Date).AddDays(-2).ToString("yyyy-MM-ddTHH:mm:ssZ")`
   - Sets the filter start date (2 days ago).
7. `$endDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")`
   - Sets the filter end date (now).
8. `$logins = Get-MgAuditLogSignIn -Filter "createdDateTime ge $startDate and createdDateTime le $endDate" -Top 1000`
   - Fetches login events within the defined range.
9. `$relatorio = $logins | Select-Object ...`
   - Selects and formats relevant fields from the result, including time conversion to UTC-3.
10. `$relatorio | Export-Csv -Path "Relatorio_Logins_Intune.csv" -NoTypeInformation -Encoding UTF8`
    - Exports the report to a CSV file.
11. `Write-Host "✅ Relatório gerado com sucesso !"`
    - Displays a success message.
12. Final comments explain how to upload the file to GitHub.
