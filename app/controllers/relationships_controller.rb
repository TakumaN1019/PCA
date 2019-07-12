class RelationshipsController < ApplicationController

   #before_action :range_valid # @userの受け取り範囲がお気に入りユーザーのみで、current_userがお気に入りされていいなければはじく

   def create
    @user = User.find(params[:sender_id]) #送信される側のユーザー
    current_user.send!(@user) #送信

    # 相手からすでに送信されている場合はリセットして、相手からまた送信してもらえるようにする。
    if @user.sending?(current_user)
      @user.unsend!(current_user)
    end

    path = Rails.application.routes.recognize_path(request.referer) #直前のコントローラーとアクションのpathを取得
    if path[:controller] == "users" && path[:action] == "index"
      @title = "ユーザー一覧"
      @users = User.all #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "sendings"
      @title = "送信箱"
      @users = current_user.sendings #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "senders"
      @title = "受信箱"
      @users = current_user.senders #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "show"
      @title = ""
      @users = ""
    end
  end

  def destroy
    @user = User.find(params[:sender_id]) #送信されている側のユーザー
    current_user.unsend!(@user) #送信取り消し

    path = Rails.application.routes.recognize_path(request.referer) #直前のコントローラーとアクションのpathを取得
    if path[:controller] == "users" && path[:action] == "index"
      @title = "ユーザー一覧"
      @users = User.all #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "sendings"
      @title = "送信箱"
      @users = current_user.sendings #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "senders"
      @title = "受信箱"
      @users = current_user.senders #ajaxの部分変更で使う
    end
    if path[:controller] == "users" && path[:action] == "show"
      @title = ""
      @users = ""
    end
  end


  private

    def range_valid
      @user = User.find(params[:sender_id]) # 送信されている側のユーザー
      # @userの受け取り範囲がお気に入りユーザーのみで、current_userがお気に入りされていいなければはじく
      if @user.receive_range == "favorite-only" 
        if not @user.liking(current_user)
          return
        end
      end
    end




end
