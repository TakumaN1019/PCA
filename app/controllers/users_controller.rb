class UsersController < ApplicationController

  before_action :set_user, only: [:show]
  before_action :authenticate_user!, only: [:sendings, :senders, :likings] #deviseのヘルパーメソッド、デフォルトではログイン画面に遷移する

  def index
    @title = "ユーザー一覧"
    @users = User.all
  end

  def show
    @title = "投稿"
    @uhos = Relationship.all
  end

  def sendings
    @title = "送信箱"
    @users = current_user.sendings
  end

  def senders
    @title = "受信箱"
    users = current_user.senders

    if current_user.receive_range == "all"
      @users = users
    else
      # current_userのお気に入りユーザーからのメッセージだけを@users配列につっこむ
      @users = []
      users.each do |user|
        if current_user.liking?(user)
          @users.push(user)
        end
      end
    end

  end

  def favorite_senders
    @title = "受信箱(お気に入りユーザー)"
    users = current_user.senders

    # current_userのお気に入りユーザーからのメッセージだけを@users配列につっこむ
    @users = []
    users.each do |user|
      if current_user.liking?(user)
        @users.push(user)
      end
    end
  end

  def likings
    @title = "お気に入りユーザー"
    @users = current_user.likings
  end

  private
    def set_user
      @user = User.find_by(id: params[:id])
    end

end
