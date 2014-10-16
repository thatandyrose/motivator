class Scheduler
  def initialize(threshold_days)
    @threshold_days = threshold_days
  end

  def run
    User.all.each do |user|
      motee = user.motees.where(''){|motee| motee.last_sent_at.nil? || motee.last_sent_at < @threshold_days.days.ago}.first
      motee.deliver! if motee && user.motees.where('date(last_sent_at) = ?', Date.today).empty?
    end
  end
end