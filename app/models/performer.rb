class Performer < ActiveRecord::Base
  validates :name, presence: true
  # validates_uniqueness_of :mobile
  
  mount_uploader :avatar, AvatarUploader
  mount_uploaders :photos, ImagesUploader
  
  belongs_to :user
  
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
  
  def self.all_users_for(performer)
    user_ids = Performer.where.not(user_id: nil).pluck(:user_id)
    if performer && performer.user_id
      if user_ids.include? performer.user_id
        user_ids.delete(performer.user_id)
      end
    end
    User.where.not(id: user_ids).map { |u| ["#{u.auth_profile.try(:nickname)}|#{u.uid}", u.id] }
  end
  
  def comm_id
    self.uniq_id
  end
  
  def format_avatar_url
    if self.avatar.blank?
      if self.user
        if self.user.auth_profile
          self.user.auth_profile.headimgurl
        else
          ''
        end
      else
        ''
      end
    else
      self.avatar.url(:large)
    end
  end
  
  def comm_name
    self.name
  end
  
  def comm_type
    'performer'
  end
  
  def type_name
    I18n.t("common.performer.type_#{self._type}")
  end
  
  def marry_type_name
    I18n.t("common.performer.m_type_#{self.marry_type}")
  end
  
  def format_avatar_url
    if self.avatar.blank?
      ''
    else
      self.avatar.url(:large)
    end
  end
  
  def approve!
    self.approved_at = Time.zone.now
    self.save!
  end
  
  def sign!
    self.signed_at = Time.zone.now
    self.save!
  end
  
  def no_approve!
    self.approved_at = nil
    self.save!
  end
  
  def no_sign!
    self.signed_at = nil
    self.save!
  end
  
end
