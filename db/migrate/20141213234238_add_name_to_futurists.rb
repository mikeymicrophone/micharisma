class AddNameToFuturists < ActiveRecord::Migration
  def change
    add_column :futurists, :name, :string
  end
end
