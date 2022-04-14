class ActivitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_kanban
    before_action :set_kanban_column
    before_action :set_card, only: [:new]


    def index
    end

    def new
        @activity = @card.activities.build
    end

    def create
    end

    private
    # Use callbacks to share common setup or constraints between actions.
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
        params.require(:activitiy).permit(:kanban_id, :kanban_column_id, :card_id, :title, :notes, :startdate, :enddate, :completed, :tag)
    end

end
