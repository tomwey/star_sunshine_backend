class Job < ActiveRecord::Base
  validates :name, :begin_time, :end_time, :price, presence: true
  
  before_create :generate_uniq_id
  def generate_uniq_id
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..6]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def has_apply_for(opts)
    return false if opts.blank? or opts[:opts].blank? or opts[:opts][:user].blank?
    user = opts[:opts][:user]
    Appointment.where(user_id: user.id, job_id: self.id).count > 0
  end
end
