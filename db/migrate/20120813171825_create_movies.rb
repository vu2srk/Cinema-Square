class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :pic_url
      t.string :movie_url
      t.integer :user_id

      t.timestamps
    end
  end
end
