ActiveAdmin.register Performer do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :avatar, :mobile, :_type, :school, :bio, :birth, :height, :weight
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
  column '头像' do |o|
    image_tag o.avatar.url(:large), size: '32x32'
  end
  column :name
  column :mobile
  column 'at', :created_at
  actions
end

form do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    f.input :avatar
    f.input :name
    f.input :mobile
    f.input :_type, as: :select, collection: [['入驻艺人', 1], ['签约艺人', 2]]
    f.input :school, placeholder: '输入学校专业等'
    f.input :bio, as: :text, input_html: { class: 'redactor' }, placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
  end
  
  f.inputs '选填信息' do
    f.input :birth, placeholder: '生日'
    f.input :height, placeholder: '身高,单位为CM'
    f.input :weight, placeholder: '体重,单位为KG'
  end
  actions
end

end
