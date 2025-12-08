require 'rails_helper'

RSpec.describe Inscripcion, type: :model do
  describe 'associations' do
    it { should belong_to(:estudiante) }
    it { should belong_to(:taller) }
  end

  describe 'enums' do
    it { should define_enum_for(:estado).with_values(pendiente: 'pendiente', aprobada: 'aprobada', rechazada: 'rechazada').backed_by_column_of_type(:string) }
  end

  describe 'validations' do
    subject { build(:inscripcion) }
    it { should validate_presence_of(:estudiante_id) }
    it { should validate_presence_of(:taller_id) }
  end

  describe 'scopes' do
    let(:taller) { create(:taller) }
    let(:estudiante1) { create(:estudiante) }
    let(:estudiante2) { create(:estudiante) }
    let(:estudiante3) { create(:estudiante) }

    before do
      create(:inscripcion, estudiante: estudiante1, taller: taller, estado: :pendiente)
      create(:inscripcion, estudiante: estudiante2, taller: taller, estado: :aprobada)
      create(:inscripcion, estudiante: estudiante3, taller: taller, estado: :rechazada)
    end

    describe '.pendientes' do
      it 'returns only pending inscriptions' do
        pendientes = Inscripcion.pendientes
        expect(pendientes.count).to eq(1)
        expect(pendientes.first.estado).to eq('pendiente')
      end
    end

    describe '.aprobadas' do
      it 'returns only approved inscriptions' do
        aprobadas = Inscripcion.aprobadas
        expect(aprobadas.count).to eq(1)
        expect(aprobadas.first.estado).to eq('aprobada')
      end
    end

    describe '.rechazadas' do
      it 'returns only rejected inscriptions' do
        rechazadas = Inscripcion.rechazadas
        expect(rechazadas.count).to eq(1)
        expect(rechazadas.first.estado).to eq('rechazada')
      end
    end
  end

  describe 'uniqueness validation' do
    let(:estudiante) { create(:estudiante) }
    let(:taller) { create(:taller) }

    before do
      create(:inscripcion, estudiante: estudiante, taller: taller)
    end

    it 'prevents duplicate inscriptions for same student-taller pair' do
      duplicate = build(:inscripcion, estudiante: estudiante, taller: taller)
      expect(duplicate.valid?).to be false
      expect(duplicate.errors[:estudiante_id]).to include('ya está inscrito en este taller')
    end
  end
end
