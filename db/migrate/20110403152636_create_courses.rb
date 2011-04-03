class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :code
      t.string :name
      t.integer :credit
      t.integer :assessments
      t.integer :mandatory_activities
      t.string :teacher

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
