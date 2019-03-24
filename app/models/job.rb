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
end
