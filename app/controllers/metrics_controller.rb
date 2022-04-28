class MetricsController < ApplicationController
  def index
    @kanban = current_user.kanbans.find(params[:kanban_id])

    if params[:from_date].nil? && params[:to_date].nil?
      @cards = @kanban.cards.where(created_at: 1.month.ago.beginning_of_day..Date.current.end_of_day)
    else
      @cards = @kanban.cards.where(created_at: params[:from_date].to_date.beginning_of_day..params[:to_date].to_date.end_of_day)
    end

    @column_graph_data = @kanban.create_column_graph_data(params[:from_date], params[:to_date])

    @jobs_created_data = return_jobs_created_data(@cards, params[:from_date], params[:to_date])
  end

  private

  def return_jobs_created_data(cards, from_date, to_date)
    from_date = from_date.nil? ? 1.month.ago.beginning_of_day : from_date.to_date.beginning_of_day
    to_date = to_date.nil? ? Date.current.end_of_day : to_date.to_date.end_of_day

    @cards.group_by_day(:created_at, format: '%d %b %y', range: from_date..to_date).count
  end

end
