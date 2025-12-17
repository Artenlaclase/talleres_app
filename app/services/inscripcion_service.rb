class InscripcionService
  attr_reader :estudiante, :taller, :error

  def initialize(estudiante, taller)
    @estudiante = estudiante
    @taller = taller
    @error = nil
  end

  def call
    validate_inscription!
    return false unless valid?

    create_inscription
  end

  private

  def validate_inscription!
    @errors = []

    # Validar que el taller existe y tiene cupos
    unless @taller.cupo_disponible?
      @error = "No hay cupos disponibles en este taller"
      return false
    end

    # Validar que el estudiante no ha alcanzado su límite
    if @estudiante.cupos_alcanzados?
      @error = "Has alcanzado el máximo de talleres para este período"
      return false
    end

    # Validar que no existe inscripción activa
    if @estudiante.inscripciones.where(taller: @taller).exists?
      @error = "Ya estás inscrito en este taller"
      return false
    end

    true
  end

  def valid?
    @error.nil?
  end

  def create_inscription
    Inscripcion.create!(
      estudiante: @estudiante,
      taller: @taller,
      estado: 'pendiente'
    )
  rescue StandardError => e
    @error = e.message
    false
  end
end
