class AlterColumnTimerIdentifierUnique < ActiveRecord::Migration[5.2]
  def change
  	add_index :timers, :identifier, unique: true, null: false
  end
end
