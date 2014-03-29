require 'spec_helper'

describe MoteesController do
  before do
    @omni_user = FactoryGirl.create :user, :with_omni
  end
  
  context 'no user logged in' do
    
    it 'cant create motee if no user signed in' do
      visit create_user_motee_path(@omni_user)
      
      expect(page).to have_content 'Login please!'
      expect(page).to have_content 'Sign in or Register with Facebook'
    end

    it 'cant list motees if no user signed in' do
      visit user_motees_path(@omni_user)
      
      expect(page).to have_content 'Login please!'
      expect(page).to have_content 'Sign in or Register with Facebook'
    end

  end

  context 'with signed in user' do
    before do
      login @omni_user
    end

    context 'creating motees' do
      before do
        visit create_user_motee_path(@omni_user)

        fill_in :motee_text, with: 'do something you love everyday'
        click_on :save

        @omni_user.reload
      end

      it 'should create a new motee' do
        expect(Motee.count).to eq 1
        expect(Motee.first.text).to eq 'do something you love everyday'
      end

      it 'should save the motee to the user' do
        expect(@omni_user.motees.count).to eq 1
      end

      it 'should redirect back to listing' do
        expect(current_path).to eq user_motees_path(@omni_user)
      end
    end

    context 'listing motees' do
      context 'no motees yet' do
        before do
          visit user_motees_path(@omni_user)
        end
        
        it 'should show no motees message' do
          expect(page).to have_content "You haven't created any Motees yet!"
        end
      end

      context 'with motees' do
        before do
          FactoryGirl.create :motee, text: 'other motee'

          @omni_user.motees >> FactoryGirl.create :motee, text: 'inspire'
          @omni_user.save!
        end

        it 'should list the motees for the user' do
          expect(page).to have_content 'inspire'
          expect(page).to_not have_content 'other motee'
        end      
      end
    end
  end
end