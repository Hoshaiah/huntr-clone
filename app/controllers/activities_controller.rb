class ActivitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_kanban, only: [:new, :create, :update]
    before_action :set_kanban_column, only: [:new, :create, :update]
    before_action :set_card, only: [:new, :create, :update]
    before_action :set_activity, only: [:update]


    def index
    end

    def new
        @activity = @card.activities.build
    end

    def create
        @activity = @card.activities.build(activity_params)
        if @activity.save
            redirect_to  edit_kanban_kanban_column_card_url(@kanban.id, @kanban_column.id, @card.id)
        else
            render :new
        end
    end

    def update
        if @activity.update(activity_params)
            redirect_to edit_kanban_kanban_column_card_url(@kanban.id, @kanban_column.id, @card.id)
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
        @activity = @card.activities.find(params[:id])
    end

    def set_card
        @card = @kanban_column.cards.find(params[:card_id])
    end

    def set_kanban_column
        @kanban_column = @kanban.kanban_columns.find(params[:kanban_column_id])
    end

    def set_kanban
        @kanban = current_user.kanbans.find(params[:kanban_id])
    end

    def activity_params
        params.require(:activity).permit(:kanban_id, :kanban_column_id, :card_id, :title, :notes, :startdate, :enddate, :completed, :tag)
    end

end
