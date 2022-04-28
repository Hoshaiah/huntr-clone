class UserMailer < ApplicationMailer
    # Important for production
    default from: "huntrclone@gmail.com"
  
    def user_upgraded_to_premium
      @user = params[:user]
  
      mail to: @user.email, subject: "Congratulations!, Your account has been upraded to Premium."
    end
  end