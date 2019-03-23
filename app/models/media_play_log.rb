class MediaPlayLog < ActiveRecord::Base
  after_create :increment_play_count
  def increment_play_count
    if media
      media.views_count += 1
      media.save!
    end
  end
  
  def media
    @media ||= Media.where('uniq_id = :id or id = :id', { id: self.media_id }).first
  end
end
