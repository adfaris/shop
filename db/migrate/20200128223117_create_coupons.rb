class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.string :code, null: false, index: {unique: true}
      t.float :percent_off, null: false

      t.timestamps
    end
  end
end
