class CardsController < ApplicationController
  before_action :set_kanban
  before_action :set_card, only: [:edit, :update, :destroy]

  def new
    @kanban_column = @kanban.kanban_columns.find(params[:kanban_column_id])
    @card = @kanban.cards.build
  end

  def create
    @card = @kanban.cards.build(card_params)

    if @card.save
      card_position = @card.kanban_column.cards.count - 1 #position of the card inside new column will update to the last
      @card.update(position: card_position)
      redirect_to @kanban, notice: 'Card was successfully created.'
    else
      render :new
    end
  end

  def edit
    @activities = sort_needed_activities_by_tag!(@card.activities.all)
  end

  def update
    column_id = @card.kanban_column_id #checks for the initlal column_id of card

    if @card.update(card_params)
      if column_id != card_params[:kanban_column_id].to_i #checks if card column is changed
        card_position = @card.kanban_column.cards.count - 1 #position of the card inside new column will update to the last
        @card.update(position: card_position)
      end
      redirect_to @kanban, notice: 'Card was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    redirect_to @kanban, notice: 'Card was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = @kanban.cards.find(params[:id])
  end

  def set_kanban
    @kanban = current_user.kanbans.find(params[:kanban_id])
  end

  # Only allow a list of trusted parameters through.
  def card_params
    params.require(:card).permit(:job_title, :company, :kanban_column_id)
  end
end
