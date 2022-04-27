class Card < ApplicationRecord
  belongs_to :kanban_column
  has_many :activities, dependent: :destroy
  validate :save_card?, :on => :create

  
  def create_activities_upon_drag(kanban, column_id)
    kanban_column = kanban.kanban_columns.find_by(id: column_id)
    kanban_column_name = kanban_column.name

    if kanban_column_name == "APPLIED" && !self.activities.find_by(tag: "Apply")
      self.activities.create(tag: "Apply", title: "Applied", completed: true )
      return true
    elsif kanban_column_name == "INTERVIEW"
      self.activities.create(tag: "On Site Interview", title: "On Site Interview")
      return true
    elsif kanban_column_name == "OFFER RECEIVED" && !self.activities.find_by(tag: "Offer Received") 
      self.activities.create(tag: "Offer Received", title: "Offer Received", completed: true)
      return true
    elsif kanban_column_name == "OFFER ACCEPTED" && !self.activities.find_by(tag: "Offer Accepted")  
      self.activities.create(tag: "Accept Offer", title: "Offer Accepted", completed: true)
      return true
    end
    return false
    
  end

  private

  def save_card?
    if Current.user.premium == false && Current.user.kanbans.find_by(id: Current.user.kanbans.ids).cards.count >= 10
        errors.add(:kanbans, message: "Please upgrade to premium to create more cards!")
        return false
    end
  end
end
