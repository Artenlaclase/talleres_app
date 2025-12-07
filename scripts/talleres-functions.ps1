# Funciones de ayuda para TalleresApp
# Agrega esto a tu $PROFILE de PowerShell para usarlas globalmente

function Talleres-Export {
    param(
        [string]$Path = "backup"
    )
    Write-Host "📤 Exportando datos a $Path..." -ForegroundColor Green
    bundle exec rake export:talleres["$Path/talleres.json"]
    bundle exec rake export:estudiantes["$Path/estudiantes.json"]
    Write-Host "✅ Backup completado" -ForegroundColor Green
}

function Talleres-Import {
    param(
        [string]$Path = "backup"
    )
    Write-Host "📥 Importando datos desde $Path..." -ForegroundColor Green
    bundle exec rake import:talleres["$Path/talleres.json"]
    bundle exec rake import:estudiantes["$Path/estudiantes.json"]
    Write-Host "✅ Restauración completada" -ForegroundColor Green
}

function Talleres-Reset {
    Write-Host "⚠️ Reseteando base de datos..." -ForegroundColor Yellow
    bundle exec rails db:reset
    Write-Host "✅ Base de datos reseteada" -ForegroundColor Green
}

function Talleres-Verify {
    Write-Host "🔍 Verificando datos..." -ForegroundColor Cyan
    bundle exec rails runner scripts/verify_data.rb
}

function Talleres-Seed {
    Write-Host "🌱 Inyectando datos de muestra..." -ForegroundColor Green
    bundle exec rails db:seed
    Write-Host "✅ Seeds completadas" -ForegroundColor Green
}

function Talleres-Console {
    Write-Host "🖥️ Abriendo consola de Rails..." -ForegroundColor Cyan
    bundle exec rails console
}

# Alias cortos
Set-Alias -Name talleres-exp -Value Talleres-Export -Force
Set-Alias -Name talleres-imp -Value Talleres-Import -Force
Set-Alias -Name talleres-rst -Value Talleres-Reset -Force
Set-Alias -Name talleres-ver -Value Talleres-Verify -Force
Set-Alias -Name talleres-seed -Value Talleres-Seed -Force
Set-Alias -Name talleres-con -Value Talleres-Console -Force

Write-Host "✅ Funciones de TalleresApp cargadas" -ForegroundColor Green
Write-Host "Usa: talleres-exp, talleres-imp, talleres-rst, talleres-ver, talleres-seed, talleres-con" -ForegroundColor Yellow
