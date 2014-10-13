class User < ActiveRecord::Base
  validates_presence_of :name

  has_many :motees

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
         user.image = auth['info']['image']
      end
    end
  end

  def self.find_or_create_with_omniauth(auth)
    user = User.where(:provider => auth['provider'], :uid => auth['uid'].to_s).first || create_with_omniauth(auth)

    if user.image.blank? && auth['info']['image']
      user.update_attributes! image: auth['info']['image']
    end

    user
  end

  def first_name
    name.split(' ')[0]
  end

end
