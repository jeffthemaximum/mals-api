class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.references :chat, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
