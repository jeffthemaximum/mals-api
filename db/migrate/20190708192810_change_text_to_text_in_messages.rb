class ChangeTextToTextInMessages < ActiveRecord::Migration[5.2]
  def change
    change_column :messages, :text, :text
  end
end
