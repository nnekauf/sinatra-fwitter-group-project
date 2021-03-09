class TweetsController < ApplicationController


    get '/tweets' do
        if logged_in?
            @user = current_user
            @tweets = Tweet.where(user_id: @user.id)
            # binding.pry
            erb :'tweets/index'
        #     
        #     @tweets = Tweet.all
        #     erb :'/tweets/tweets'
           else
             redirect '/login'
          end
    end
      

    get '/tweets/new' do
        if logged_in?
            @user = current_user
            erb :'/tweets/new'
          else
            redirect to '/login'
          end
    end
      
    post '/tweet' do
        # user = User.find_by(id: session[:user_id])
        # tweet = user.items.create(params[:tweet])
        @tweet = Tweet.create(content: params[:content], user: current_user)

        if @tweet.valid?
            redirect "/tweets"
        else
            
            redirect '/tweets/new'
        end
        
    end

    get '/tweets/:id' do
        if logged_in?
            @user = current_user
            @tweet = Tweet.find_by_id(params[:id])
            erb :'/tweets/show_tweet'
          else
            redirect to '/login'
          end
    end
      

    get '/tweets/:id/edit' do
        @tweet = Tweet.find_by_id(params[:id])
        if logged_in? && @tweet.user == current_user
            erb :'/tweets/edit_tweet'
         else
            redirect 'login'
        end
    end



    patch '/tweets/:id' do 
        @tweet = Tweet.find_by(id: params[:id])
        if current_user.id == session[:user_id] 
            if !params[:content].empty?
            @tweet.update(content: params[:content])
            @tweet.save
            else
                redirect "tweets/#{params[:id]}/edit"
             end
            redirect "tweets/#{params[:id]}"
          else
            redirect "tweets/#{params[:id]}/edit"
        end
        
    end      

    post '/tweets/:id/delete' do
        @tweet = Tweet.find_by(id: params[:id])
        @user = current_user
        if logged_in? && current_user.id == @tweet.user_id 
            @tweet.delete 
            redirect "/tweets/#{@tweet.id}"
        else
            erb :'/tweets/show_tweet'
        end
    end
end