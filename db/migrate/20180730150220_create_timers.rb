class CreateTimers < ActiveRecord::Migration[5.2]
  def change
    create_table :timers do |t|
      t.string :identifier
      t.string :jid

      t.timestamps
    end
  end
end
