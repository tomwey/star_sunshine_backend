ActiveAdmin.register Banner do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :image, :sort, :opened, :link
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
  selectable_column
  column('#',:id)
  column 'ID', :uniq_id
  column :title
  column '封面图' do |o|
    image_tag o.image.url(:small)
  end
  column '链接' do |o|
    o.is_link? ? link_to('打开链接', o.link) : o.link
  end
  column 'at', :created_at
  actions
end

end
