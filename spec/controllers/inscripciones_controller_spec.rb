require 'rails_helper'

RSpec.describe InscripcionesController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:estudiante) { create(:estudiante) }
  let(:taller) { create(:taller, cupos: 10) }
  let(:inscripcion) { create(:inscripcion, estudiante: estudiante, taller: taller) }

  before { sign_in admin }

  describe 'POST #create' do
    context 'when admin adds a student' do
      it 'creates an approved inscription' do
        expect {
          post :create, params: {
            taller_id: taller.id,
            estudiante_id: estudiante.id
          }
        }.to change(Inscripcion, :count).by(1)
      end

      it 'sets estado to aprobada' do
        post :create, params: {
          taller_id: taller.id,
          estudiante_id: estudiante.id
        }
        new_inscripcion = Inscripcion.last
        expect(new_inscripcion.estado).to eq('aprobada')
      end
    end

    context 'when taller has no cupos' do
      before { taller.update(cupos: 1) }

      before do
        create(:inscripcion, taller: taller, estado: :aprobada)
      end

      it 'does not create an inscription' do
        expect {
          post :create, params: {
            taller_id: taller.id,
            estudiante_id: estudiante.id
          }
        }.not_to change(Inscripcion, :count)
      end
    end
  end

  describe 'PATCH #approve' do
    let(:pending_inscripcion) { create(:inscripcion, estudiante: estudiante, taller: taller, estado: :pendiente) }

    it 'changes estado from pendiente to aprobada' do
      patch :approve, params: { id: pending_inscripcion.id }
      pending_inscripcion.reload
      expect(pending_inscripcion.estado).to eq('aprobada')
    end

    it 'redirects to taller show page' do
      patch :approve, params: { id: pending_inscripcion.id }
      expect(response).to redirect_to(taller_path(pending_inscripcion.taller))
    end
  end

  describe 'PATCH #reject' do
    let(:pending_inscripcion) { create(:inscripcion, estudiante: estudiante, taller: taller, estado: :pendiente) }

    it 'changes estado from pendiente to rechazada' do
      patch :reject, params: { id: pending_inscripcion.id }
      pending_inscripcion.reload
      expect(pending_inscripcion.estado).to eq('rechazada')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the inscripcion' do
      inscripcion_to_delete = create(:inscripcion, estudiante: estudiante, taller: taller)
      expect {
        delete :destroy, params: { id: inscripcion_to_delete.id }
      }.to change(Inscripcion, :count).by(-1)
    end

    it 'redirects to taller show page' do
      inscripcion_to_delete = create(:inscripcion, estudiante: estudiante, taller: taller)
      delete :destroy, params: { id: inscripcion_to_delete.id }
      expect(response).to redirect_to(taller_path(taller))
    end
  end
end
