class CardSubscriptionController < ApplicationController

  before_action :free_account, only: [:subscribe, :details, :error]

  def subscribe 
    paymongo = PaymongoApi::V1::Card.new

    begin 
      @payment_intent = paymongo.create_payment_intent
    rescue ApiExceptions::BadRequest
      redirect_to error_path
    end
  end

  def details 

    payment_intent_id = params[:payment_intent_id]
    client_key = params[:client_key]
    card_details = {
      card_number: params[:card_number], 
      exp_month: params[:exp_month].to_i, 
      exp_year: params[:exp_year].to_i, 
      cvc: params[:cvc]
    }
    billing = {
      address:{
      line1:params[:line1],
      line2:params[:line2],
      city:params[:city],
      state:params[:state],
      postal_code:params[:postal_code],
      country:params[:country],
      },
      name: params[:name],
      email: params[:email],
      phone: params[:phone]
    }
    type = params[:type]
    
    paymongo = PaymongoApi::V1::Card.new

    begin 
      @payment_method = paymongo.create_payment_method(card_details, billing, type)
    rescue ApiExceptions::BadRequest
      redirect_to error_path
    end

    begin 
      payment_method_id = @payment_method['data']['id']
    rescue NoMethodError
      
    end

    @response = paymongo.attach(
      payment_intent_id, 
      payment_method_id, 
      client_key
    )
    
    begin 
      id = paymongo.attach_id
      session[:id_variable] = id
      payment_type = paymongo.payment_type?
    rescue NoMethodError
      redirect_to subscribe_path, notice: "Please provide valid card informantion."
    end
    

    if payment_type == "paymaya"
      redirect_url = paymongo.redirect_url
      redirect_to redirect_url, notice: "Please  accept payment"
      return
    end
    begin 

      status = paymongo.subscription_status?

      if status == "paid"
        current_user.update(premium: true)    
      end
    rescue NoMethodError
      
    end

  end

  def card_success
    id = session[:id_variable]
    paymongo = PaymongoApi::V1::Card.new
    get_paymaya_result = paymongo.retrieve_payment_intent(id)
    @status = get_paymaya_result.data.attributes.payments[0].attributes.status

    if @status == "paid"
      current_user.update(premium: true)
    end

  end

  def error

  end

  private

  def free_account
    if current_user.premium == false 
      return
    else
      redirect_to root_path, notice: "Only free account can perform this action."
    end
  end

end