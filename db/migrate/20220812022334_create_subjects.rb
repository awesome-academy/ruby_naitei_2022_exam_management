class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.text :description
      t.integer :duration
      t.integer :question_number
      t.integer :score_pass

      t.timestamps
    end
  end
end
