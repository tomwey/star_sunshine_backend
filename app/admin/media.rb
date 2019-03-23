ActiveAdmin.register Media do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :_type, :title, :summary, :cover, :file, :play_url, :duration, :owner_id, :opened, :sort, { tags: [] }, radio_content_attributes: [:id, :lyrics, :composer, :original_singer, :content, :_destroy]

index do
  selectable_column
  column('#',:id)
  column 'ID', :uniq_id
  column '所有者' do |o|
    if o.owner.blank?
      '--'
    else
      link_to image_tag(o.owner.avatar.url(:large)) + raw("<br>#{o.owner.name}"), [:admin, o.owner]
    end
  end
  column :title
  column '视频文件' do |o|
    raw("<video
          id=\"video\" 
          src=\"#{o.media_file_url}\" 
          controls = \"true\"
          poster=\"#{o.cover.url(:small)}\" /*视频封面*/
          preload=\"auto\" 
          webkit-playsinline=\"true\" /*这个属性是ios 10中设置可以
                     让视频在小窗内播放，也就是不是全屏播放*/  
          playsinline=\"true\"  /*IOS微信浏览器支持小窗内播放*/ 
          x-webkit-airplay=\"allow\" 
          x5-video-player-type=\"h5\"  /*启用H5播放器,是wechat安卓版特性*/
          x5-video-player-fullscreen=\"true\" /*全屏设置，
                     设置为 true 是防止横屏*/
          x5-video-orientation=\"portraint\" //播放器支付的方向， landscape横屏，portraint竖屏，默认值为竖屏
          style=\"object-fit:fill\" width=\"240\">
          </video>")
  end
  column '统计数据' do |o|
    raw("播放数: #{o.views_count}<br>喜欢数: #{o.likes_count}<br>评论数: #{o.comments_count}<br>弹幕数: #{o.danmu_count}")
  end
  column 'at', :created_at
  actions
end

form do |f|
  f.semantic_errors
  f.inputs '基本信息' do
    # f.input :_type, as: :select, collection: [['电台', 1], ['MV', 2]]
    f.input :owner_id, as: :select, collection: Performer.where(verified: true).order('id desc').map { |p| [p.name, p.uniq_id] }, required: true
    f.input :title, placeholder: '作品标题'
    f.input :cover, hint: '图片建议尺寸为1650x928，格式为：jpg/png/gif'
    # f.input :file, hint: '播放文件格式为：mp4/mp3/ogg/wav'
    render partial: 'file_uploader', locals: { f: f }
    f.input :summary, placeholder: '简要介绍作品'
    f.input :duration, placeholder: '02:30'
    # f.input :play_url
    f.input :opened
    f.input :sort, hint: '值越大显示越靠前'
  end

  # f.inputs '电台MP3其它信息',
  #   data: { need_show: "#{(f.object and f.object._type == 1) ? '1' : '0'}" },
  #   id: 'radio-content',
  #   for: [:radio_content, (f.object.radio_content || RadioContent.new)] do |s|
  #     s.input :lyrics, label: '作词'
  #     s.input :composer, label: '作曲'
  #     s.input :original_singer, label: '原唱'
  #     s.input :content, as: :text, label: '歌词', input_html: { class: 'redactor' },
  #       placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
  # end

  actions
end

end
