class Reply < ActiveRecord::Base
  belongs_to :comment
  after_create :increment_reply_count
  def increment_reply_count
    if comment
      comment.reply_count += 1
      comment.save!
    end
  end
  
  def from_user
    @from_user ||= User.find_by(uid: self.from_user_id)
  end
  
  def to_user
    @to_user ||= User.find_by(uid: self.to_user_id)
  end
  
  
end
