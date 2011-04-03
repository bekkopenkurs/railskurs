class Course < ActiveRecord::Base
  validates_presence_of :code, :name, :credit, :assessments, :mandatory_activities, :teacher
  validates_numericality_of :credit, :assessments, :mandatory_activities
end
