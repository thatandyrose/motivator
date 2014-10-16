require 'spec_helper'

describe 'Sending Motees' do
  before do
    @omni_user = FactoryGirl.create :user, email: 'andy@testing.com'

    @motee = FactoryGirl.create :motee, user: @omni_user
  end

  context 'when user has one note and threshold is 5 days' do
   
    context 'and its been more than 5 days since that motee was sent' do
      before do
        @motee.update_attributes! last_sent_at: 6.days.ago

        Scheduler.new(5).run
        @motee.reload
      end

      it 'should send motee' do
        expect(@motee.last_sent_at.to_date).to eq Date.today
        expect(last_email.to.first).to eq @omni_user.email
        expect(last_email.body.to_s).to include @motee.text
      end
    end

    context 'and its been less that 5 days since that motee was sent' do
      before do
        @motee.update_attributes! last_sent_at: 4.days.ago

        Scheduler.new(5).run
        @motee.reload
      end

      it 'should not send motee' do
        expect(@motee.last_sent_at.to_date).to eq 4.days.ago.to_date
        expect(last_email).to be_nil
      end
    end

    context 'and its never been sent' do
      before do
        Scheduler.new(5).run
        @motee.reload
      end

      it 'should send motee' do
        expect(@motee.last_sent_at.to_date).to eq Date.today
        expect(last_email.to.first).to eq @omni_user.email
        expect(last_email.body.to_s).to include @motee.text
      end
    end
  end

  context 'when user has two notes and threshold is 5 days' do
    before do
      @other_note = FactoryGirl.create :motee, user: @omni_user
    end
    
    context 'and other note has been sent today' do
      before do
        @other_note.update_attributes! last_sent_at: Time.now
        Scheduler.new(5).run
        @motee.reload
      end

      it 'should not send motee' do
        expect(@motee.last_sent_at).to be_nil
        expect(last_email).to be_nil
      end
    end

    context 'and other note has not been sent today' do
      before do
        @other_note.update_attributes! last_sent_at: 2.days.ago
        Scheduler.new(5).run
        @motee.reload
      end

      it 'should send motee' do
        expect(@motee.last_sent_at.to_date).to eq Date.today
        expect(last_email.to.first).to eq @omni_user.email
        expect(last_email.body.to_s).to include @motee.text
      end
    end

    context 'and other note has never been sent' do
      
      before do
        Scheduler.new(5).run
        @motee.reload
      end

      it 'should send motee' do
        expect(@motee.last_sent_at.to_date).to eq Date.today
        expect(last_email.to.first).to eq @omni_user.email
        expect(last_email.body.to_s).to include @motee.text
      end

      it 'should not send other motee' do
        expect(@other_note.last_sent_at).to be_nil
        expect(delivered_emails.size).to eq 1
      end
    end

  end
end