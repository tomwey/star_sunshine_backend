class Like < ActiveRecord::Base
  after_create :change_likes_count
  def change_likes_count
    likeable.change_likes_count!(1) if likeable.present?
  end
  
  def likeable
    klass = Object.const_get self.likeable_type
    @likeable ||= klass.where('uniq_id = :id or id = :id', {id: self.likeable_id}).first
  end
  
  def user
    @user ||= User.find_by(uid: self.user_id)
  end
  
end
