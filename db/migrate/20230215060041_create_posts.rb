class CreatePosts < ActiveRecord::Migration[7.0]
  def change
      create_table :posts do |t|
          t.text :content
          t.text :autor

          t.timestamps
      end
  end
end