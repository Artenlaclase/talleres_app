require 'rails_helper'

RSpec.describe EstudiantesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:estudiante) { create(:estudiante, user: user) }
  let(:taller) { create(:taller) }

  describe 'GET #show' do
    before { sign_in user }

    it 'returns a success response' do
      get :show, params: { id: estudiante.to_param }
      expect(response).to be_successful
    end

    it 'assigns the requested estudiante' do
      get :show, params: { id: estudiante.to_param }
      expect(assigns(:estudiante)).to eq(estudiante)
    end
  end

  describe 'POST #request_inscription' do
    before { sign_in user }

    context 'when taller has available cupos' do
      before { taller.update(cupos: 10) }

      it 'creates a pending inscription' do
        expect {
          post :request_inscription, params: {
            id: estudiante.to_param,
            taller_id: taller.id
          }
        }.to change(Inscripcion, :count).by(1)
      end

      it 'creates inscription with pending estado' do
        post :request_inscription, params: {
          id: estudiante.to_param,
          taller_id: taller.id
        }
        inscripcion = Inscripcion.last
        expect(inscripcion.estado).to eq('pendiente')
      end
    end

    context 'when taller has no available cupos' do
      before { taller.update(cupos: 1) }

      before do
        create(:inscripcion, taller: taller, estado: :aprobada)
      end

      it 'does not create an inscription' do
        expect {
          post :request_inscription, params: {
            id: estudiante.to_param,
            taller_id: taller.id
          }
        }.not_to change(Inscripcion, :count)
      end

      it 'sets an alert message' do
        post :request_inscription, params: {
          id: estudiante.to_param,
          taller_id: taller.id
        }
        expect(flash[:alert]).to include('No hay cupos disponibles')
      end
    end
  end
end
