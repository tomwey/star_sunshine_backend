class Appointment < ActiveRecord::Base
  validates :name, :phone, :user_id, :job_id, presence: true
  validates_uniqueness_of :job_id, scope: :user_id
  belongs_to :user
  belongs_to :job
end
