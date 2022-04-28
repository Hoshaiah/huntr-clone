class MetricsController < ApplicationController
  def index
    @kanban = current_user.kanbans.find(params[:kanban_id])

    if params[:from_date].nil? && params[:to_date].nil?
      @cards = @kanban.cards.where(created_at: 1.month.ago.beginning_of_day..Date.current.end_of_day)
    else
      @cards = @kanban.cards.where(created_at: params[:from_date].to_date.beginning_of_day..params[:to_date].to_date.end_of_day)
    end

    @column_graph_data = @kanban.create_column_graph_data(params[:from_date], params[:to_date])
  end

end
