class Motee < ActiveRecord::Base
  belongs_to :user

  validates :text, presence: { message: 'The Motee needs content!' }
end
