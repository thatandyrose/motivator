require 'spec_helper'

describe MoteesController do
  before do
    @omni_user = FactoryGirl.create :user, email: 'andy@testing.com'
  end
  
  context 'no user logged in' do
    
    it 'cant create motee if no user signed in' do
      visit new_motee_path
      
      expect(page).to have_content 'Login please!'
      expect(page).to have_content 'Sign up today'
    end

    it 'cant list motees if no user signed in' do
      visit motees_path
      
      expect(page).to have_content 'Login please!'
      expect(page).to have_content 'Sign up today'
    end

  end

  context 'with signed in user withtout e-mail' do
    before do
      @omni_user.update_attributes!(email:'')
      login @omni_user
      visit motees_path
    end

    it 'should redirect back to add an e-mail page' do
      expect(page).to have_content 'Please enter your email address.'
      expect(current_path).to eq edit_user_path(@omni_user)
    end
  end

  context 'with signed in user' do
    before do
      login @omni_user
    end

    context 'creating motees' do
      before do
        visit new_motee_path
        fill_in :motee_text, with: 'do something you love everyday'
        click_on 'Save Motee'

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
        expect(current_path).to eq motees_path
      end
    end

    context 'listing motees' do
      context 'no motees yet' do
        before do
          visit motees_path
        end
        
        it 'should redirect to create new motee' do
          expect(current_path).to eq new_motee_path
        end
      end

      context 'with motees' do
        before do
          FactoryGirl.create :motee, text: 'other motee'

          @omni_user.motees << FactoryGirl.create(:motee, text: 'inspire')
          @omni_user.save!

          visit motees_path
        end

        it 'should list the motees for the user' do
          expect(page).to have_content 'inspire'
          expect(page).to_not have_content 'other motee'
        end      
      end
    end
  end
end