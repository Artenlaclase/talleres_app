# 🛡️ TalleresApp - Guía de Backup y Restauración Rápida

## ⚡ Inicio Rápido

### Cargar Funciones en PowerShell
```powershell
# Ejecuta esto UNA SOLA VEZ en tu terminal
. .\scripts\talleres-functions.ps1
```

Después, puedes usar estos comandos cortos:
```powershell
talleres-exp     # Exportar (crear backup)
talleres-imp     # Importar (restaurar)
talleres-ver     # Verificar datos
talleres-rst     # Reset completo
talleres-seed    # Restaurar seeds
talleres-con     # Abrir consola Rails
```

---

## 📋 Estado Actual (7 de Diciembre de 2025)

**Datos Respaldados:**
- ✅ 5 Talleres (5 cupos inscritos de 107 totales)
- ✅ 15 Estudiantes (correctamente distribuidos)
- ✅ Validaciones de capacidad activas

**Ubicación del Backup:** `backup/` en la raíz del proyecto

---

## 🔄 Operaciones Comunes

### 1. Hacer un Backup (Exportar)
```powershell
talleres-exp
# O manualmente:
bundle exec rake export:talleres[backup/talleres.json]
bundle exec rake export:estudiantes[backup/estudiantes.json]
```

### 2. Restaurar desde Backup
```powershell
talleres-imp
# O manualmente:
bundle exec rake import:talleres[backup/talleres.json]
bundle exec rake import:estudiantes[backup/estudiantes.json]
```

### 3. Verificar Datos
```powershell
talleres-ver
# O manualmente:
bundle exec rails runner scripts/verify_data.rb
```

### 4. Restaurar Seeds (Datos de Muestra)
```powershell
talleres-seed
# O manualmente:
bundle exec rails db:seed
```

### 5. Reset Total (Borra TODO)
```powershell
talleres-rst
# O manualmente:
bundle exec rails db:reset
```

---

## 📁 Estructura de Archivos

```
talleres_app/
├── backup/
│   ├── talleres.json        # 5 talleres
│   └── estudiantes.json     # 15 estudiantes
├── scripts/
│   ├── verify_data.rb       # Script de verificación
│   └── talleres-functions.ps1  # Funciones PowerShell
├── BACKUP_RESTORE.md        # Documentación completa
└── (resto del proyecto)
```

---

## 🆘 Solucionar Problemas

### "No encuentro las funciones"
```powershell
# Cargar las funciones nuevamente
. .\scripts\talleres-functions.ps1
```

### "Archivo de BD bloqueado"
```powershell
# Detener Rails server
Get-Process ruby -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
# Reintentar operación
```

### "No se puede eliminar base de datos"
```powershell
# Eliminar manualmente
Remove-Item storage/development.sqlite3 -Force
bundle exec rails db:setup
```

### "Verificar que los datos se importaron"
```powershell
talleres-ver
```

---

## 💡 Mejores Prácticas

1. **Backup antes de cambios importantes:**
   ```powershell
   talleres-exp
   ```

2. **Backup con timestamp:**
   ```powershell
   $fecha = Get-Date -Format 'yyyyMMdd_HHmmss'
   bundle exec rake export:talleres["backup/talleres_$fecha.json"]
   bundle exec rake export:estudiantes["backup/estudiantes_$fecha.json"]
   ```

3. **Guardar backups en la nube:**
   - Sincronizar carpeta `backup/` con Google Drive o Dropbox
   - O commitear a Git con `.gitignore` actualizado

4. **Verificar regularmente:**
   ```powershell
   talleres-ver  # Ejecutar cada semana
   ```

---

## 📊 Datos Actuales

### Talleres (5 total)
| ID | Nombre | Inscritos | Cupos | Disponibles |
|----|--------|-----------|-------|------------|
| 1 | Introducción a Rails | 5 | 20 | 15 |
| 2 | Tailwind CSS Avanzado | 4 | 25 | 21 |
| 3 | APIs REST con Rails | 3 | 15 | 12 |
| 4 | Arte | 1 | 20 | 19 |
| 5 | Programación | 2 | 15 | 13 |
| **TOTAL** | | **15** | **95** | **80** |

### Estudiantes (15 total)
- Todos correctamente asociados a sus talleres
- Validaciones de capacidad activas
- No permite overbooking

---

## 🔗 Enlaces Útiles

- **Documentación completa:** `BACKUP_RESTORE.md`
- **App en línea:** http://127.0.0.1:3000
- **Talleres:** http://127.0.0.1:3000/talleres
- **Estudiantes:** http://127.0.0.1:3000/estudiantes

---

## 📞 Comandos Útiles

```powershell
# Iniciar servidor
bundle exec rails server

# Abrir consola Rails
talleres-con

# Ver todas las migraciones
bundle exec rails db:migrate:status

# Ver logs
Get-Content log/development.log -Tail 50

# Ejecutar tests
bundle exec rails test
```

---

**Última actualización:** 7 de Diciembre de 2025  
**Estado:** ✅ Completamente funcional y respaldado
