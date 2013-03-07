# encoding: UTF-8
module SessionsHelper
	def sign_in(user)

		session[:remember_token]=[user.id,user.salt]
		current_user=user
	end
	
	def authorized?

		Management.has_rights(controller_name,current_user.id)

	end 
	
	def current_user=(user)
		@current_user=user
	end
	
	
	def current_user
		@current_user||=user_from_remember_token
   
	end
	
	
	
	def signed_in?
		!current_user.nil?

	end
	
	def sign_out
		reset_session
		@current_user=nil
		
	end
	
	
	def login_required
		current_user||=user_from_remember_token
                if current_user.nil?
                 logger.info "current user is nil"
                 else
                 logger.info "current user exist"
                end 
		signed_in??true:access_denied
		
	end

  def has_right?
    unless authorized?
      respond_to do |accepts|

       accepts.html{redirect_to "/mycases",notice: "没有授权访问"}
      end
    end

  end
	
	
	def access_denied

		respond_to do |accepts|
			accepts.html do 

				store_location
				redirect_to :controller=>'sessions',:action=>'new'
			end
		end
		false
	end
	
	
	def store_location
		session[:return_to]=request.fullpath

	end
	
	
	def redirect_back_or_default(default)
		session[:return_to]?redirect_to(session[:return_to]):redirect_to(default)
		session[:return_to]=nil
	end

	private
	
	def user_from_remember_token

		User.authenticate_with_salt(*remember_token)

	end
	
	
	def remember_token
		session[:remember_token]||[nil,nil]
	end
end
