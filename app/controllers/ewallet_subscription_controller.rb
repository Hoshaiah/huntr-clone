class EwalletSubscriptionController < ApplicationController

    before_action :free_account, only: [:gcash_source, :grabpay_source, :gcash_payment_success, :grabpay_payment_success, :details, :error]
  

    def gcash_source
      gcash = PaymongoApi::V1::EwalletGcash.new
      begin 
          @source = gcash.create_source_gcash
      rescue ApiExceptions::BadRequest
        redirect_to error_path
      end  

      checkout_url = gcash.gcash_checkout_url
      if payment_status = 'pending'
        redirect_to checkout_url
      end

    end

    def grabpay_source
      grabpay = PaymongoApi::V1::EwalletGrabpay.new
      begin 
        @source = grabpay.create_source_grabpay
      rescue ApiExceptions::BadRequest
        redirect_to error_path
      end

      checkout_url = grabpay.grabpay_checkout_url
      if payment_status = 'pending'
        redirect_to checkout_url
      end
    end
  
    def gcash_payment_success
      gcash = PaymongoApi::V1::EwalletGcash.new
  
      begin 
        gcash.gcash_create_payments
        payment_status = gcash.gcash_status?
        if payment_status = 'paid'
          current_user.update(premium: true)
          UserMailer.with(user: current_user).user_upgraded_to_premium.deliver_now
        end
      rescue ApiExceptions::BadRequest
        redirect_to error_path
      end
  

    end

    def grabpay_payment_success
      grabpay = PaymongoApi::V1::EwalletGrabpay.new
      
      begin 
        @payment = grabpay.grabpay_create_payments
        payment_status = grabpay.grabpay_status?
      if payment_status = 'paid'
        current_user.update(premium: true)
        UserMailer.with(user: current_user).user_upgraded_to_premium.deliver_now
      end
      rescue ApiExceptions::BadRequest
        redirect_to error_path
      end
      
    end

    def ewallet_failed
      
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