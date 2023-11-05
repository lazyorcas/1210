# frozen_string_literal: true

class CreateThings < ActiveRecord::Migration[7.0]
  def change
    create_table(:things) do |t|
      t.string(:type)
      t.string(:title)
      t.string(:description)
      t.string(:tags)
      t.string(:city)
      t.string(:url)
      t.string(:image_url)
      t.boolean(:is_deleted)

      t.timestamps

      t.index(:city)
      t.index(:type)
    end
  end
end
