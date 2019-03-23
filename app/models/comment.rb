class Comment < ActiveRecord::Base
  has_many :replies, dependent: :destroy
  
  after_create :increment_comments_count
  def increment_comments_count
    if commentable
      commentable.comments_count += 1
      commentable.save!
    end
  end
  
  def commentable
    klass = Object.const_get self.commentable_type
    @commentable ||= klass.where('uniq_id = :id or id = :id', {id: self.commentable_id}).first
  end
  
  def user
    @user ||= User.find_by(uid: self.user_id)
  end
end
