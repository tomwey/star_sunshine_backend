class RadioContent < ActiveRecord::Base
  belongs_to :media, class_name: 'Media', foreign_key: 'media_id'
  # validates :content, presence: true
end
