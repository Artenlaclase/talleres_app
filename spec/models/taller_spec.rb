require 'rails_helper'

RSpec.describe Taller, type: :model do
  describe 'associations' do
    it { should have_many(:inscripciones) }
    it { should have_many(:estudiantes_inscritos).through(:inscripciones) }
  end

  describe 'validations' do
    subject { build(:taller) }
    it { should validate_presence_of(:nombre) }
    it { should validate_length_of(:nombre).is_at_most(100) }
    it { should validate_presence_of(:fecha) }
    it { should validate_numericality_of(:cupos).is_greater_than(0) }
    it { should validate_numericality_of(:numero_evaluaciones).is_greater_than(0) }
  end

  describe 'scopes' do
    let(:future_taller) { create(:taller, fecha: 1.week.from_now.to_date) }
    let(:past_taller) { create(:taller, fecha: 1.week.ago.to_date) }
    let(:full_taller) { create(:taller, cupos: 1) }
    let(:available_taller) { create(:taller, cupos: 10) }

    describe '.proximos' do
      it 'returns talleres with future dates ordered by date' do
        talleres = Taller.proximos
        expect(talleres).to include(future_taller)
        expect(talleres).not_to include(past_taller)
      end
    end

    describe '.pasados' do
      it 'returns talleres with past dates ordered by date descending' do
        talleres = Taller.pasados
        expect(talleres).to include(past_taller)
        expect(talleres).not_to include(future_taller)
      end
    end

    describe '.con_cupo' do
      it 'returns talleres with available spots' do
        talleres = Taller.con_cupo
        expect(talleres).to include(available_taller)
        expect(talleres).to include(full_taller)
      end
    end
  end

  describe '#cupo_disponible?' do
    it 'returns true when there are available spots' do
      taller = create(:taller, cupos: 10)
      expect(taller.cupo_disponible?).to be true
    end

    it 'returns true even with single cupo available' do
      taller = create(:taller, cupos: 1)
      expect(taller.cupo_disponible?).to be true
    end
  end

  describe '#cupos_restantes' do
    let(:taller) { create(:taller, cupos: 5) }

    it 'counts only approved inscriptions' do
      create(:inscripcion, taller: taller, estado: :aprobada)
      create(:inscripcion, taller: taller, estado: :aprobada)
      create(:inscripcion, taller: taller, estado: :pendiente)
      
      expect(taller.cupos_restantes).to eq(3)
    end

    it 'excludes pending and rejected inscriptions' do
      create(:inscripcion, taller: taller, estado: :rechazada)
      create(:inscripcion, taller: taller, estado: :pendiente)
      
      expect(taller.cupos_restantes).to eq(5)
    end
  end

  describe '#total_inscritos' do
    let(:taller) { create(:taller) }

    it 'counts direct students and approved inscriptions' do
      direct_student = create(:estudiante, taller_id: taller.id)
      inscribed_student = create(:estudiante)
      create(:inscripcion, estudiante: inscribed_student, taller: taller, estado: :aprobada)
      
      expect(taller.total_inscritos).to eq(2)
    end
  end
end
