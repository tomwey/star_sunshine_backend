class Wechat::LuckyDrawsController < Wechat::ApplicationController
  layout 'application'
  
  skip_before_filter :check_weixin_legality
  
  before_filter :require_user, only: [:checkin]
  before_filter :check_user, only: [:checkin]
  
  def checkin
    @ld = LuckyDraw.find_by(uniq_id: params[:id])
    if @ld.blank? or !@ld.opened
      render text: '抽奖不存在', status: 404
      return
    end
    
    @page_title = @ld.title + '抽奖签到'
    
    @prize = @ld.lucky_draw_items.where(opened: true).where(started_at: nil).order('sort asc').first
    if @prize.blank?
      render text: '抽奖已结束', status: 403
      return
    end
    
    LuckyDrawCheckin.where(user_id: current_user.id, lucky_draw_id: @ld.id).first_or_create!
    
  end
  
  def portal
    if params[:cjak] != SiteConfig.cj_ak
      render text: '非法访问', status: 403
      return
    end
    
    id = params[:id]
    if id.blank?
      @ld = LuckyDraw.where(opened: true).order('id desc').first
    else
      @ld = LuckyDraw.find_by(uniq_id: id)
    end
    
    if @ld.blank? or !@ld.opened
      render text: '抽奖不存在', status: 404
      return
    end
    
    @prize = @ld.lucky_draw_items.where(opened: true).order('sort asc').first
    if @prize.started_at.blank?
      @users = @ld.users.order('id desc')
    else
      user_ids = LuckyDrawResult.where(lucky_draw_id: @ld.id).order('id desc').pluck(:user_id)
      @users = User.where(id: user_ids)
    end
    
  end
  
  def start
    id = params[:id]
    if id.blank?
      @ld = LuckyDraw.where(opened: true).order('id desc').first
    else
      @ld = LuckyDraw.find_by(uniq_id: id)
    end
    
    if @ld.blank? or !@ld.opened
      render text: '抽奖不存在'
      return
    end
    
    @prize = @ld.lucky_draw_items.where(opened: true).order('sort asc').first
    if @prize.started_at.present?
      render text: '抽奖已结束'
      return
    end
    
    user_ids = LuckyDrawCheckin.where(lucky_draw_id: @ld.id).order('RANDOM()').limit(@prize.quantity).pluck(:user_id)
    
    user_ids.each do |uid|
      LuckyDrawResult.create!(user_id: uid, lucky_draw_id: @ld.id, lucky_draw_item_id: @prize.id)
    end
    
    @prize.started_at = Time.zone.now
    @prize.save!
    
    render text: '1'
  end
  
  def stop
    
  end
  
  private 
  def require_user
    if current_user.blank?
      # 登录
      store_location
      redirect_to wechat_login_path
    end
  end
  
  def check_user
    unless current_user.verified
      # flash[:error] = "您的账号已经被禁用"
      # redirect_to wechat_shop_root_path
      render(text: "您的账号已经被禁用", status: 403)
      return
    end
  end
  
end