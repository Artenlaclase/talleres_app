# Funciones de ayuda para TalleresApp
# Agrega esto a tu $PROFILE de PowerShell para usarlas globalmente

function Export-TalleresData {
    param(
        [string]$Path = "backup"
    )
    Write-Host "📤 Exportando datos a $Path..." -ForegroundColor Green
    bundle exec rake export:talleres["$Path/talleres.json"]
    bundle exec rake export:estudiantes["$Path/estudiantes.json"]
    Write-Host "✅ Backup completado" -ForegroundColor Green
}

function Import-TalleresData {
    param(
        [string]$Path = "backup"
    )
    Write-Host "📥 Importando datos desde $Path..." -ForegroundColor Green
    bundle exec rake import:talleres["$Path/talleres.json"]
    bundle exec rake import:estudiantes["$Path/estudiantes.json"]
    Write-Host "✅ Restauración completada" -ForegroundColor Green
}

function Reset-TalleresDatabase {
    Write-Host "⚠️ Reseteando base de datos..." -ForegroundColor Yellow
    bundle exec rails db:reset
    Write-Host "✅ Base de datos reseteada" -ForegroundColor Green
}

function Test-TalleresData {
    Write-Host "🔍 Verificando datos..." -ForegroundColor Cyan
    bundle exec rails runner scripts/verify_data.rb
}

function Initialize-TalleresData {
    Write-Host "🌱 Inyectando datos de muestra..." -ForegroundColor Green
    bundle exec rails db:seed
    Write-Host "✅ Seeds completadas" -ForegroundColor Green
}

function Show-TalleresConsole {
    Write-Host "🖥️ Abriendo consola de Rails..." -ForegroundColor Cyan
    bundle exec rails console
}

# Alias cortos
Set-Alias -Name talleres-exp -Value Export-TalleresData -Force
Set-Alias -Name talleres-imp -Value Import-TalleresData -Force
Set-Alias -Name talleres-rst -Value Reset-TalleresDatabase -Force
Set-Alias -Name talleres-tst -Value Test-TalleresData -Force
Set-Alias -Name talleres-init -Value Initialize-TalleresData -Force
Set-Alias -Name talleres-con -Value Show-TalleresConsole -Force

Write-Host "✅ Funciones de TalleresApp cargadas" -ForegroundColor Green
Write-Host "Usa: talleres-exp, talleres-imp, talleres-rst, talleres-tst, talleres-init, talleres-con" -ForegroundColor Yellow
