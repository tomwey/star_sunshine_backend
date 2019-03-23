class Attachment < ActiveRecord::Base
  
  mount_uploader :data, AttachmentUploader, :mount_on => :data_file_name
  
  def attachable
    klass = Object.const_get self.attachable_type
    @attachable ||= klass.where('uniq_id = :id or id = :id', { id: self.attachable_id }).first
  end
  
  def ownerable
    klass = Object.const_get self.ownerable_type
    if self.ownerable_type == 'User'
      @owner ||= User.find_by(uid: self.ownerable_id)
      return @owner
    else
      @owner2 ||= klass.where('uniq_id = :id or id = :id', { id: self.ownerable_id }).first
      return @owner2
    end
  end
  
end
