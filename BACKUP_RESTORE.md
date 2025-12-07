# 🔄 Guía de Backup y Restauración de Datos

## 📋 Resumen
Tu aplicación TalleresApp ahora cuenta con un sistema automático de backup y restauración de datos basado en JSON. Los archivos se guardan en la carpeta `backup/` del proyecto.

---

## 🔐 Estado Actual del Backup

**Localización:** `backup/`
- `backup/talleres.json` - 5 talleres
- `backup/estudiantes.json` - 15 estudiantes

**Última actualización:** 7 de diciembre de 2025

### Datos Respaldados:
```
5 Talleres:
- Introducción a Rails (5 inscritos / 20 cupos)
- Tailwind CSS Avanzado (4 inscritos / 25 cupos)
- APIs REST con Rails (3 inscritos / 15 cupos)
- Arte (1 inscritos / 20 cupos)
- Programación (2 inscritos / 15 cupos)

15 Estudiantes distribuidos en los talleres
```

---

## 📤 Crear un Backup

Para respaldar los datos actuales en archivos JSON:

```powershell
# Exportar solo talleres
bundle exec rake export:talleres[backup/talleres.json]

# Exportar solo estudiantes
bundle exec rake export:estudiantes[backup/estudiantes.json]

# O ambos en una sola línea
bundle exec rake export:talleres[backup/talleres.json]; bundle exec rake export:estudiantes[backup/estudiantes.json]
```

**Opciones de ruta:**
- Ruta relativa: `backup/talleres.json`
- Ruta absoluta: `C:\full\path\to\backup.json`
- Directorio temporal: `tmp/backup_$(Get-Date -Format 'yyyyMMdd').json`

---

## 📥 Restaurar desde Backup

Para restaurar datos desde un archivo JSON:

```powershell
# Importar talleres
bundle exec rake import:talleres[backup/talleres.json]

# Importar estudiantes
bundle exec rake import:estudiantes[backup/estudiantes.json]

# O ambos
bundle exec rake import:talleres[backup/talleres.json]; bundle exec rake import:estudiantes[backup/estudiantes.json]
```

### ⚠️ Notas Importantes:
1. **Los datos existentes NO se eliminan**, los nuevos se crean/actualizan.
2. Si un taller con el mismo ID existe, sus datos se actualizan.
3. Si un estudiante con el mismo ID existe, sus datos se actualizan.
4. Los estudiantes se asocian por `taller_id` o por `taller.nombre` si el ID no coincide.

---

## 🔄 Restauración Completa (Reset Total)

Para una restauración completa desde cero (borra todo):

```powershell
# Opción 1: Usar seeds (datos de muestra predefinidos)
bundle exec rails db:seed

# Opción 2: Reset completo (borra BD y inyecta seeds)
bundle exec rails db:reset

# Opción 3: Manual (drop + setup + seeds)
bundle exec rails db:drop
bundle exec rails db:setup
```

Luego restaurar el backup:
```powershell
bundle exec rake import:talleres[backup/talleres.json]
bundle exec rake import:estudiantes[backup/estudiantes.json]
```

---

## 📊 Verificar Datos

Para verificar que los datos están correctamente restaurados:

```ruby
# En rails console
bundle exec rails console

# Dentro de la consola:
Taller.all.each { |t| puts "#{t.nombre}: #{t.estudiantes.count}/#{t.cupos} cupos" }
Estudiante.all.count
```

---

## 🛠️ Archivos de Configuración

### Tareas Rake Disponibles:

**`lib/tasks/export_json.rake`**
- `export:talleres[PATH]` - Exporta talleres a JSON
- `export:estudiantes[PATH]` - Exporta estudiantes a JSON
- Rutas por defecto: `tmp/` si no se especifica

**`lib/tasks/import_json.rake`**
- `import:talleres[PATH]` - Importa talleres desde JSON
- `import:estudiantes[PATH]` - Importa estudiantes desde JSON
- Acepta rutas relativas y absolutas

---

## 💾 Estrategia de Backup Recomendada

1. **Diariamente**: Exportar datos después de cambios importantes
   ```powershell
   bundle exec rake export:talleres[backup/talleres_$(Get-Date -Format 'yyyyMMdd').json]
   bundle exec rake export:estudiantes[backup/estudiantes_$(Get-Date -Format 'yyyyMMdd').json]
   ```

2. **Antes de operaciones críticas**: Hacer backup preventivo
   ```powershell
   bundle exec rake export:talleres[tmp/backup_pre_operation.json]
   bundle exec rake export:estudiantes[tmp/backup_pre_operation.json]
   ```

3. **Almacenar en la nube**: Copiar archivos JSON a Google Drive, Dropbox o GitHub
   ```powershell
   Copy-Item backup/*.json -Destination "C:\ruta\nube\backup"
   ```

---

## ❌ Solución de Problemas

### "No se puede acceder a la BD"
```powershell
# Detener Rails server si está corriendo
Get-Process ruby -ErrorAction SilentlyContinue | Stop-Process -Force

# Esperar e intentar de nuevo
Start-Sleep -Seconds 2
bundle exec rake import:talleres[backup/talleres.json]
```

### "Archivo no encontrado"
```powershell
# Verificar que el archivo existe
Test-Path backup/talleres.json

# Listar archivos en backup
Get-ChildItem backup/
```

### "Error en la importación"
- Verificar que el JSON tiene formato válido
- Asegurarse que los `taller_id` en estudiantes existan en talleres
- Ver logs: `bundle exec rake import:estudiantes[backup/estudiantes.json]`

---

## 📝 Ejemplo Completo de Workflow

```powershell
# 1. Hacer backup de seguridad
bundle exec rake export:talleres[backup/talleres_backup.json]
bundle exec rake export:estudiantes[backup/estudiantes_backup.json]

# 2. Borrar datos (si es necesario)
bundle exec rails db:drop
bundle exec rails db:setup

# 3. Restaurar desde backup
bundle exec rake import:talleres[backup/talleres_backup.json]
bundle exec rake import:estudiantes[backup/estudiantes_backup.json]

# 4. Verificar en http://127.0.0.1:3000/talleres
```

---

## ✅ Estado de la Restauración (7 de Diciembre de 2025)

- ✅ 5 Talleres restaurados correctamente
- ✅ 15 Estudiantes restaurados correctamente
- ✅ Asociaciones Taller ↔ Estudiante intactas
- ✅ Cupos y conteos actualizados correctamente
- ✅ Capacidad máxima respetada (no se puede overbooking)

**Próxima tarea:** Hacer backup regularmente para proteger tus datos.

---

¿Necesitas ayuda? Revisa los logs o ejecuta `bundle exec rake -T | grep export` para listar todas las tareas disponibles.
