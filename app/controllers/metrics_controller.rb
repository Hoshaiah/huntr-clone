class MetricsController < ApplicationController
  def index
    @kanban = current_user.kanbans.find(params[:kanban_id])
    @column_graph_data = @kanban.create_column_graph_data
    @jobs = @kanban.cards.order(updated_at: :desc)
  end
end
