class FavoritesController < ApplicationController

   def create
    @user = User.find(params[:liker_id]) # お気に入りされる側のユーザー
    current_user.like!(@user) # お気に入り

    path = Rails.application.routes.recognize_path(request.referer) #直前のコントローラーとアクションのpathを取得
    if path[:controller] == "users" && path[:action] == "index"
      @title = "ユーザー一覧"
      @users = User.all #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "likings"
      @title = "お気に入りユーザー"
      @users = current_user.likings #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "show"
      @title = ""
      @users = ""
    end
  end


  def destroy
    @user = User.find(params[:liker_id]) # お気に入りされている側のユーザー
    current_user.unlike!(@user) # お気に入り取り消し

    path = Rails.application.routes.recognize_path(request.referer) #直前のコントローラーとアクションのpathを取得
    if path[:controller] == "users" && path[:action] == "index"
      @title = "ユーザー一覧"
      @users = User.all #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "likings"
      @title = "お気に入りユーザー"
      @users = current_user.likings #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "show"
      @title = ""
      @users = ""
    end
  end

end
