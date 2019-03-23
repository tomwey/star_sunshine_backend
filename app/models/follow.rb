class Follow < ActiveRecord::Base
  # after_create :change_stats
  def change_stats!(counter)
    if user
      user.following_count += counter
      if user.following_count < 0
        user.following_count = 0
      end
      user.save!
    end
    
    if followable
      followable.follows_count += counter
      if followable.follows_count < 0
        followable.follows_count = 0
      end
      followable.save!
    end
    
  end
  
  def user
    @user ||= User.find_by(uid: self.user_id)
  end
  
  def followable
    if self.followable_type == 'User'
      @user ||= User.find_by(uid: self.followable_id) 
      return @user
    elsif self.followable_type == 'Performer'
      @performer ||= Performer.find_by(uniq_id: self.followable_id)
      return @performer
    end
    return nil
  end
end
