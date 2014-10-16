class Motee < ActiveRecord::Base
  belongs_to :user

  validates :text, presence: { message: 'The Motee needs content!' }

  def deliver!
    update_attributes! last_sent_at: Time.now
    UserMailer.motee_notification(self).deliver
  end
end
