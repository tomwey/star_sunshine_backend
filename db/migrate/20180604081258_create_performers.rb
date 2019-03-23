class CreatePerformers < ActiveRecord::Migration
  def change
    create_table :performers do |t|
      t.integer :uniq_id
      t.string :name,   null: false, default: ''              # 姓名
      t.string :avatar                                        # 头像
      t.string :photos, null: false, array: true, default: [] # 照片
      # t.string :mobile
      t.integer :_type, default: 1 # 艺人类型: 1 表示自由艺人, 2 表示签约艺人
      t.string :sex        # 性别
      t.integer :age       # 年龄
      t.string :nation     # 籍贯
      t.string :edu_level  # 学历
      t.string :speciality # 专业
      t.boolean :is_marry  # 婚否
      t.string :now_job    # 现职业
      t.string :interest   # 爱好
      t.string :source     # 信息来源
      t.string :height     # 身高
      t.string :weight     # 体重
      t.string :body_size  # 体型
      t.string :chest_size # 胸围
      t.string :waist_size # 腰围
      t.string :hip_size   # 臀围
      t.string :vision     # 视力
      t.string :hair_style # 发型（长发、短发）
      t.string :hair_color # 头发颜色
      t.string :footcode   # 鞋码
      
      t.text :skills       # 个人才艺
      t.text :trainings    # 艺术培训
      t.text :bio          # 简介、工作经历、演出经历等等
      
      t.integer :follows_count, default: 0
      # t.string :private_token # TOKEN
      t.boolean :verified, default: true
      t.timestamps null: false
    end
    add_index :performers, :uniq_id, unique: true
    # add_index :performers, :mobile, unique: true
  end
end
