class PasswordResetsController < ApplicationController

  def create
    PasswordResetMailer.with(user: @user).reset_email.deliver_later
  end
end
