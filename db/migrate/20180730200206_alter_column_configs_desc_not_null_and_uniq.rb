class AlterColumnConfigsDescNotNullAndUniq < ActiveRecord::Migration[5.2]
  def change
  	add_index :configs, :description, unique: true
  	add_index :configs, :description, null: false
  end
end
