class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def motee_notification(motee)
    @motee = motee
    mail to: motee.user.email, subject: "Random motee"
  end
end
