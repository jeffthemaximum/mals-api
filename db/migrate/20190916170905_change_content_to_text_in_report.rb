class ChangeContentToTextInReport < ActiveRecord::Migration[5.2]
  def change
    change_column :reports, :content, :text
  end
end
