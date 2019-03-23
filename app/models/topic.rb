class Topic < ActiveRecord::Base
  scope :latest,    -> { order('id desc, sort desc') }
  scope :suggest,   -> { order('sort desc, id desc') }
  
  before_create :generate_uniq_id
  def generate_uniq_id
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uniq_id = (n.to_s + SecureRandom.random_number.to_s[2..8]).to_i
    end while self.class.exists?(:uniq_id => uniq_id)
  end
  
  def self.following_for(user)
    joins('inner join follows on topics.ownerable_type = follows.followable_type and topics.ownerable_id = follows.followable_id').where('follows.user_id = ?', user.uid)
  end
  
  def self.liked_for(user)
    joins("inner join likes on likes.likeable_type = 'Topic' and likes.likeable_id = topics.uniq_id").where('likes.user_id = ?', user.uid)
  end
  
  def change_likes_count!(counter)
    self.likes_count += counter
    if self.likes_count < 0
      self.likes_count = 0
    end
    
    self.save!
  end
  
  def liked_users
    @ids = Like.where(likeable_type: self.class, likeable_id: self.uniq_id).order('id desc').pluck(:user_id)
    @users ||= User.where(uid: @ids)
    return @users
  end
  
  def latest_comments
    @comments ||= Comment.where(opened: true).where(commentable_type: self.class, commentable_id: self.uniq_id).order('id desc').limit(5)
    return @comments
  end
  
  def owner
    klass = Object.const_get self.ownerable_type
    if self.ownerable_type == 'User'
      @owner2 ||= User.find_by(uid: self.ownerable_id)
      return @owner2
    else
      @owner ||= klass.where('uniq_id = :id or id = :id', { id: self.ownerable_id }).first
      return @owner
    end
    
  end
  
  def topicable
    klass = Object.const_get self.topicable_type
    @topicable ||= klass.where('id = :id or uniq_id = :id', { id: self.topicable_id }).first
  end
  
  def files
    @files ||= Attachment.where(opened: true).where(attachable_type: self.class, attachable_id: self.uniq_id).order('id asc')
  end
  
end
