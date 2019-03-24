class Performer < ActiveRecord::Base
  validates :name, :photos, :_type, presence: true
  # validates_uniqueness_of :mobile
  
  mount_uploader :avatar, AvatarUploader
  mount_uploaders :photos, ImagesUploader
  
  before_create :generate_uniq_id_and_token
  def generate_uniq_id_and_token
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..6]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
    # self.private_token = SecureRandom.uuid.gsub('-', '')
  end
  
  before_save :remove_blank_value_for_array
  def remove_blank_value_for_array
    self.tags = self.tags.compact.reject(&:blank?)
  end
  
  def comm_id
    self.uniq_id
  end
  
  def comm_name
    self.name
  end
  
  def comm_type
    'performer'
  end
  
  def format_avatar_url
    if self.avatar.blank?
      ''
    else
      self.avatar.url(:large)
    end
  end
  
end
