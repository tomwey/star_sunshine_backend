ActiveAdmin.register Job do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :body, :address, :price, :begin_time, :end_time, :company, :sort, :opened

form html: { multipart: true } do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    f.input :name, placeholder: '输入通告名字'
    f.input :price, as: :number, placeholder: '单位为元'
    f.input :begin_time, as: :string, placeholder: '例如：2019-03-23 15:00'
    f.input :end_time, as: :string, placeholder: '例如：2019-03-23 19:00'
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
    f.input :company, placeholder: '输入用人单位公司名字'
    f.input :address
    f.input :opened
    f.input :sort, hint: '值越大，该通告在用户端显示越靠前'
  end
  actions
end

end
