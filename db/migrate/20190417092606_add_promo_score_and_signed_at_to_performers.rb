class AddPromoScoreAndSignedAtToPerformers < ActiveRecord::Migration
  def change
    add_column :performers, :promo_score, :integer, default: 0 # 艺人推广值，只有该值大于0才表示要进行推广
    add_column :performers, :signed_at, :datetime # 艺人签约时间
  end
end
