json.extract! estudiante, :id, :nombre, :curso, :taller_id, :created_at, :updated_at
json.url estudiante_url(estudiante, format: :json)
