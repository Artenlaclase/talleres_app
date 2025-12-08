require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:estudiante) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(usuario: 'usuario', admin: 'admin').backed_by_column_of_type(:string) }
  end

  describe 'validations' do
    subject { build(:user) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'scopes' do
    let!(:active_user) { create(:user) }
    let!(:locked_user) { create(:user, :locked) }

    describe '.activos' do
      it 'returns only active (not locked) users' do
        expect(User.activos).to include(active_user)
        expect(User.activos).not_to include(locked_user)
      end
    end

    describe '.admins' do
      let!(:admin) { create(:user, :admin) }
      
      it 'returns only admin users' do
        expect(User.admins).to include(admin)
        expect(User.admins).not_to include(active_user)
      end
    end
  end

  describe 'account locking' do
    let(:user) { create(:user) }

    describe '#lock_account' do
      it 'sets locked_at timestamp' do
        user.lock_account
        expect(user.locked_at).not_to be_nil
      end
    end

    describe '#unlock_account' do
      let(:user) { create(:user, :locked) }
      
      it 'clears locked_at timestamp' do
        user.unlock_account
        expect(user.locked_at).to be_nil
      end
    end
  end
end
