# Repositório alvo: Login-Devices-Reports (GitHub)
# Descrição: Script PowerShell para gerar relatório de logins via Microsoft Graph


# Etapa 1: Instalar o módulo Microsoft Graph (se ainda não tiver)
Install-Module Microsoft.Graph -Scope CurrentUser -Force

# Etapa 2: Importar o módulo
Import-Module Microsoft.Graph

# Etapa 3: Conectar à Microsoft Graph com escopo correto
Connect-MgGraph -Scopes "AuditLog.Read.All"

# Etapa 4: Definir intervalo de datas (últimos 2 dias como exemplo)
$startDate = (Get-Date).AddDays(-2).ToString("yyyy-MM-ddTHH:mm:ssZ")
$endDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

# Etapa 5: Consultar eventos de login
$logins = Get-MgAuditLogSignIn -Filter "createdDateTime ge $startDate and createdDateTime le $endDate" -Top 1000

# Etapa 6: Selecionar campos relevantes com horário convertido para UTC-3
$relatorio = $logins | Select-Object `
    @{Name="Data (UTC-3)";Expression={$_.CreatedDateTime.ToUniversalTime().AddHours(-3).ToString("yyyy-MM-dd HH:mm:ss")}},
    @{Name="Usuário";Expression={$_.UserDisplayName}},
    @{Name="UPN";Expression={$_.UserPrincipalName}},
    @{Name="Nome do Dispositivo";Expression={$_.DeviceDetail.DisplayName}},
    @{Name="Dispositivo ID";Expression={$_.DeviceDetail.DeviceId}},
    @{Name="Sistema Operacional";Expression={$_.DeviceDetail.OperatingSystem}},
    @{Name="Status";Expression={$_.Status.ErrorCode}}

# Etapa 7: Exportar para CSV
$relatorio | Export-Csv -Path "Relatorio_Logins_Intune.csv" -NoTypeInformation -Encoding UTF8

Write-Host "✅ Relatório gerado com sucesso !"

# Pequena instrução para upload:
# Para criar o repositório e enviar este arquivo automaticamente, execute o script create_github_repo.ps1
# (requer Git e GitHub CLI: https://cli.github.com/). Alternativamente siga as instruções do README.md.

