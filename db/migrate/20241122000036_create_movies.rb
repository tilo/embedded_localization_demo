class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :i18n
      t.string :other

      t.timestamps
    end
  end
end
