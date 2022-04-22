module ApplicationHelper
    def choose_specific_activity_creator!(type)
        if type == "Apply"
            activity_tags = ["Apply"]
        elsif type == "Interview"
            activity_tags = ["Phone Screen", "Phone Interview", "On Site Interview"]
        elsif type == "Offer"
            activity_tags= ["Offer Received"]
        elsif type == "Accept"    
            activity_tags = ["Accept Offer"]
        else
            activity_tags = ACTIVITY_TAGS
        end
        return activity_tags
    end

    def sort_needed_activities_by_tag!(activities)
      applications = []
      interviews = []
      offers = []
      acceptance = []
  
      activities.each do |activity|
        if ["Phone Interview", "Phone Screen", "On Site Interview"].include? activity.tag
          interviews.push(activity)
        elsif activity.tag == "Apply"
          applications.push(activity)
        elsif activity.tag == "Offer Received"
          offers.push(activity)
        elsif activity.tag == "Accept Offer"
          acceptance.push(activity)
        end
      end
      return {
        apply: applications,
        interview: interviews,
        offer: offers,
        accept: acceptance
      }
    end
end
