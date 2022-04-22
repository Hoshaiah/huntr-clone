class Card < ApplicationRecord
  belongs_to :kanban_column
  has_many :activities, dependent: :destroy

  
  def create_activities_upon_drag(kanban, column_id)
    kanban_column = kanban.kanban_columns.find_by(id: column_id)
    kanban_column_name = kanban_column.name

    if kanban_column_name == "Applied" && !self.activities.find_by(tag: "Apply")
      self.activities.create(tag: "Apply", title: "Applied", completed: true )
      return true
    elsif kanban_column_name == "Interview"
      self.activities.create(tag: "On Site Interview", title: "On Site Interview")
      return true
    elsif kanban_column_name == "Offer Received" && !self.activities.find_by(tag: "Offer Received") 
      self.activities.create(tag: "Offer Received", title: "Offer Received", completed: true)
      return true
    elsif kanban_column_name == "Offer Accepted" && !self.activities.find_by(tag: "Offer Accepted")  
      self.activities.create(tag: "Offer Accepted", title: "Offer Accepted", completed: true)
      return true
    end
    return false
    
  end
end
