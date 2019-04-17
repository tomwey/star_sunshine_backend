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
        
        desc "获取艺人库"
        params do
          optional :token,  type: String, desc: '用户TOKEN'
          optional :tag_id, type: Integer, desc: '分类ID'
          optional :type,   type: Integer, desc: "艺人类别"
          use :pagination
        end
        get do
          @performers = Performer.where(verified: true).order('sort desc, id desc')
          if params[:type].present?
            unless [1,2,3].include?(params[:type])
              return render_error(-1, "不正确的type参数")
            end
            @performers = @performers.where(_type: params[:type])
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
      
    end # end class
  end
end