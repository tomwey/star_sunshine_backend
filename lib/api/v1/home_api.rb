module API
  module V1
    class HomeAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :entry, desc: '首页相关接口' do
        desc "获取首页数据接口"
        params do
          optional :token, type: String, desc: '用户TOKEN'
          optional :loc,   type: String, desc: '用户位置，格式为：(lng,lat)，例如：104.384747,30.4847373'
        end
        get do
          # 获取首页Banner
          @banners = Banner.opened.sorted.limit(5)
          
          # @media = Media.where(opened: true).order('sort desc').limit(3)
          # @modules = [
          #   {
          #     name: '校园MV',
          #     list: API::V1::Entities::Media.represent(@media)
          #   }
          # ]
          
          @jobs = Job.where(opened: true, deleted_at: nil).order('id desc').limit(5)
          
          @performers = Performer.where(verified: true).limit(4)
          
          @user = User.find_by(private_token: params[:token])
          result = {
            banners: API::V1::Entities::Banner.represent(@banners),
            # vote: API::V1::Entities::Vote.represent(@vote, { user: @user }),
            # featured: @sections,
            # sections: @modules,
            performers: API::V1::Entities::Performer.represent(@performers, opts: { user: @user }),
            latest_jobs: API::V1::Entities::Job.represent(@jobs)
          }
          
          { code: 0, message: 'ok', data: result }
        end # end get /
      end # end resource
      
      resource :tags, desc: "分类相关接口" do
        desc "获取分类"
        get do
          @tags = Tag.order('id asc')
          render_json(@tags, API::V1::Entities::TagName)
        end # end get tags
      end # end resource
      
      resource :jobs, desc: "活动通告相关接口" do
        desc "获取所有通告"
        params do
          optional :token, type: String, desc: '用户TOKEN'
          # optional :tag_id, type: Integer, desc: '分类ID'
          use :pagination
        end
        get do
          @jobs = Job.where(opened: true, deleted_at: nil).order('id desc')
          if params[:page]
            @jobs = @jobs.paginate page: params[:page], per_page: page_size
            total = @jobs.total_entries
          else
            total = @jobs.size
          end
          
          render_json(@jobs, API::V1::Entities::Job, {user: User.find_by(private_token: params[:token])}, total)
        end # end jobs 
        desc "通告报名"
        params do
          requires :token, type: String, desc: '用户TOKEN'
          requires :name, type: String
          requires :phone, type: String
          optional :address, type: String
        end
        post '/:id/apply' do
          user = authenticate!
          @job = Job.where(uniq_id: params[:id], deleted_at: nil).first
          if @job.blank?
            return render_error(4004, '通告不存在')
          end
          
          unless @job.opened
            return render_error(4000, '通告未上线，不能报名')
          end
          
          if Performer.where(user_id: user.id).count == 0
            return render_error(4000, '您的艺人资料还未上传，不能报名')
          end
          
          if Performer.where('user_id = ? and approved_at is not null', user.id).count == 0
            return render_error(4000, '您的艺人身份还未审核通过，不能报名')
          end
          
          if Appointment.where(user_id: user.id, job_id: @job.id).count > 0
            return render_error(4000, '该通告您已经报名过了')
          end
          
          Appointment.create!(user_id: user.id, job_id: @job.id, name: params[:name], phone: params[:phone], address: params[:address])
          render_json_no_data
          
        end # end post
      end # end resource
      
      resource :performs, desc: '艺人相关接口' do
        desc "获取艺人分类"
        get :types do
          @tags = Tag.order('sort asc')
          render_json(@tags, API::V1::Entities::Tag2)
        end # end get types
        
        desc "艺人入驻"
        params do
          requires :token, type: String, desc: '用户TOKEN'
          requires :payload, type: JSON, desc: "其他非图片JSON数据"
          optional :avatar, type: Rack::Multipart::UploadedFile, desc: '图片二进制'
          optional :files,   type: Array do
            requires :file, type: Rack::Multipart::UploadedFile, desc: '附件二进制'
          end
        end
        post :create do
          user = authenticate!
          
          if Performer.where(user_id: user.id).count > 0
            return render_error(3000, '您已经入驻了')
          end
          
          obj = Performer.new(user_id: user.id)
          
          if params[:payload]
            params[:payload].each do |k,v|
              # puts "#{k}:#{v}"
              if v.present? && obj.has_attribute?(k)
                # puts k
                if k == 'tags'
                  obj.tags = v.split(',')
                else
                  obj.send "#{k}=", v
                end
                
              end
            end
          end
          
          # 保存头像
          if params[:avatar].present?
            obj.avatar = params[:avatar]
          end
          
          # 保存照片
          if params[:files] && params[:files].any?
            files = []
            params[:files].each do |param|
              files << param[:file]
            end
            obj.photos = files
          end
          
          if obj.save!
            render_json(obj, API::V1::Entities::Performer)
          else
            render_error(3001, "提交失败!")
          end
        end # end create
        
        desc "获取艺人库"
        params do
          optional :token,  type: String, desc: '用户TOKEN'
          optional :tag_id, type: Integer, desc: '分类ID'
          optional :type,   type: Integer, desc: "艺人类别"
          use :pagination
        end
        get do
          @performers = Performer.where(verified: true).where.not(approved_at: nil)
          if params[:type].present?
            unless [1,2,3].include?(params[:type])
              return render_error(-1, "不正确的type参数")
            end
            if params[:type] == 2 # 签约艺人
              @performers = @performers.where.not(signed_at: nil).order('sort desc, id desc')
            elsif params[:type] == 3 # 推广艺人
              @performers = @performers.where('promo_score > 0').order('promo_score desc, sort desc, id desc')
            else # 自由艺人
              @performers = @performers.order('sort desc, id desc')
            end
            
          else
            @performers = @performers.order('sort desc, id desc')
          end
          
          if params[:tag_id].present?
            @performers = @performers.where('? = ANY(tags)', params[:tag_id])
          end
          
          if params[:page]
            @performers = @performers.paginate page: params[:page], per_page: page_size
            total = @performers.total_entries
          else
            total = @performers.size
          end
          render_json(@performers, API::V1::Entities::Performer, { user: User.find_by(private_token: params[:token]) }, total)
        end # get /
      end # end resource
      
      resource :utils, desc: "工具相关接口" do
        desc "获取七牛上传TOKEN"
        params do
        get :uptoken do
          bucket = "#{SiteConfig.qiniu_bucket}"
          
          #构建上传策略
          put_policy = Qiniu::Auth::PutPolicy.new(
              bucket,      # 存储空间
              nil,     # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
              72000000    #token过期时间，默认为3600s
          )

          #生成上传 Token
          uptoken = Qiniu::Auth.generate_uptoken(put_policy)
          { code: 0, message: 'ok', data: { token: uptoken } }
        end # end get uptoken 
      end # end resource utils
      
    end # end class
  end
end