# encoding: UTF-8
class SessionsController < ApplicationController
  def new
  end

  def create
      user=nil
      if params[:session][:login]=~ /(^\w+$)|(^\w+\.\w+$)|(^v-\w+\.?\w+$)/
        user=User.authenticate("#{params[:session][:login]}@autonavi.com",params[:session][:password])
      end
    if user.nil?
         flash.now[:notice] ="不正确的用户名或密码"
      render 'new'
    else
      sign_in user
      redirect_back_or_default(:controller=>'mycases',:action=>'index')
    end
  end

  def destroy
    sign_out
    render 'new'
  end

end
