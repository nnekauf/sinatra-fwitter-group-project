require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get "/" do
    
    if logged_in?
      @user = current_user 
      @tweets = Tweet.where(user_id: @user.id)
      
      erb :"/tweets/index"
    else
    erb :index
    end
  end

  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'

    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    end
   end



  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/users/login'
    end
  end


  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect to '/signup'

    end
    
    # redirect '/tweets'
  end


  get '/logout' do
    session.clear
    redirect "/login"
  end

  helpers do

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]

    end
    def logged_in? 
      !!current_user 
    end

    # def redirect_if_not_logged_in
    #     redirect '/login' unless current_user
    # end

    # def check_owner(obj)
    #   obj.user == current_user
    # end

    # def redirect_if_not_owner(obj)
    #   if !check_owner(obj)
    #     flash[:message] = "Sorry, this is not your item!"
    #     redirect "/outfits"
    #   end
    # end
   
  end
end
