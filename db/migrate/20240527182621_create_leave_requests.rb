class CreateLeaveRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :leave_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :reason, null: false

      t.timestamps
    end
  end
end
