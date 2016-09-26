require 'rails_helper'

describe User do
  # Omitted validations tests because devise handles it already

  describe 'account creation' do
    context 'when creating new user without an account provided' do
      let(:user) { create(:user) }

      it 'should create its own account' do
        expect(user.account).not_to be_nil
      end

      it 'should become manager of its account' do
        expect(user).to be_account_manager
      end
    end

    context 'when creating new user providing an account' do
      let(:manager) { create(:user) }
      let(:member)  { create(:user, account: manager.account )}

      it 'should use the provided account' do
        expect(member.account).to eq(manager.account)
      end

      it 'should not become manager of its account' do
        expect(member).not_to be_account_manager
      end
    end
  end
end
