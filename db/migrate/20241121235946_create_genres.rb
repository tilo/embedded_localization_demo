class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.text :i18n
      t.string :other

      t.timestamps
    end
  end
end
