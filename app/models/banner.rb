class Banner < ActiveRecord::Base
  validates :image, presence: true
  mount_uploader :image, BannerImageUploader
  
  scope :opened, -> { where(opened: true) }
  scope :sorted, -> { order('sort desc') }
  
  before_create :generate_uid_and_private_token
  def generate_uid_and_private_token
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..6]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def is_link?
    self.link && (self.link.start_with?('http://') or self.link.start_with?('https://'))
  end
  
  def is_vote?
    self.link && self.link.start_with?('vote://')
  end
  
  def is_media?
    self.link && self.link.start_with?('media://')
  end
  
  def vote
    if self.is_vote?
      _,id = self.link.split('id=')
      @vote ||= Vote.find_by(uniq_id: id)
    else
      nil
    end
  end
  
  def media
    if self.is_media?
      _,id = self.link.split('id=')
      @media ||= Media.find_by(uniq_id: id)
    else
      nil
    end
  end
  
end
