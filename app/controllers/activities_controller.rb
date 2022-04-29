class ActivitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_kanban, only: [:new, :create, :update, :index, :edit, :destroy]
    before_action :set_card, only: [:new, :create, :update, :index, :edit, :destroy]
    before_action :set_activity, only: [:update, :edit, :destroy]


    def index
        @activities = @card.activities.all
    end

    def new
        @activity = @card.activities.build
        @activity_tags = choose_specific_activity_creator!(params[:type])
    end

    def edit
        @activity_tags = choose_specific_activity_creator!(params[:type])
    end

    def create
        @activity = @card.activities.build(activity_params)
        if @activity.save
            redirect_to  edit_kanban_card_url(@kanban.id, @card.id)
        else
            render :new
        end
    end

    def update
        if @activity.update(activity_params)
            if params[:from_activities]
                redirect_to kanban_card_activities_url(@kanban.id, @card.id)
            else
                redirect_to edit_kanban_card_url(@kanban.id, @card.id)
            end
        end
    end

    def destroy
        if @activity.destroy
            redirect_to edit_kanban_card_url(kanban_id: @kanban, id: @card), notice: 'Activity was successfully destroyed'
        end
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
        @activity = @card.activities.find(params[:id])
    end

    def set_card
        @card = @kanban.cards.find(params[:card_id])
    end

    def set_kanban
        @kanban = current_user.kanbans.find(params[:kanban_id])
    end

    def activity_params
        params.require(:activity).permit(:kanban_id, :card_id, :title, :notes, :startdate, :enddate, :completed, :tag)
    end

end
