class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :title
      t.text :subtitle
      t.text :body
      t.string :slug

      t.timestamps null: false
    end
  end
end
