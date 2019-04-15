ActiveAdmin.register Performer do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :avatar, :mobile, :_type, :school, :bio, :height, :weight, :phone, :nickname,
:sex,:age,:nation,:edu_level,:speciality,:marry_type,:now_job,:interest,:source,:body_size,:chest_size,:address, :sort,
:waist_size,:hip_size,:vision,:hair_style,:hair_color,:footcode,:skills,:trainings, { photos: [] }, { tags: [] }
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
  # column :mobile
  column 'at', :created_at
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    f.input :_type, as: :select, collection: [['自由艺人', 1], ['签约艺人', 2], ['推广艺人', 3]]
    f.input :name, placeholder: '输入真实名字'
    f.input :avatar
    f.input :photos, as: :file, hint: "图片尺寸为1080x668", input_html: { multiple: true }
    f.input :tags, label: '所属分类', as: :check_boxes, collection: Tag.all.map { |tag| [tag.name, tag.id] }
    f.input :phone, placeholder: '输入联系方式，手机或座机'
    f.input :nickname, placeholder: '输入艺名'
    f.input :sex, as: :radio, collection: ['男', '女']
    f.input :age, placeholder: '输入年龄，单位(岁)'
    f.input :nation
    f.input :edu_level, as: :select, collection: ['本科','大专','中专','硕士','博士','其它']
    f.input :speciality
    # f.input :is_marry
    f.input :marry_type, as: :radio, collection: ['未婚', 0], ['已婚', 1], ['离异', 2]
    f.input :now_job
    f.input :interest
    # f.input :mobile
    f.input :source, as: :radio, collection: ['网络','报纸','朋友介绍','助理介绍']
    f.input :height, as: :number, placeholder: '身高,单位为CM'
    f.input :weight, as: :number, placeholder: '体重,单位为KG'
    f.input :body_size
    f.input :chest_size, as: :number
    f.input :waist_size, as: :number
    f.input :hip_size, as: :number
    f.input :vision, as: :number
    f.input :hair_style, as: :radio, collection: ['长发','短发']
    f.input :hair_color, as: :string
    f.input :footcode, as: :number
    # f.input :school, placeholder: '输入学校专业等'
    f.input :skills, as: :text, input_html: { class: 'redactor' }, placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
    f.input :trainings, as: :text, input_html: { class: 'redactor' }, placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
    f.input :bio, as: :text, input_html: { class: 'redactor' }, placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
    f.input :sort, hint: '值越大，在APP中显示越靠前'
  end
  
  # f.inputs '选填信息' do
  #   f.input :birth, placeholder: '生日'
  #   f.input :height, placeholder: '身高,单位为CM'
  #   f.input :weight, placeholder: '体重,单位为KG'
  # end
  actions
end

end
