class User < ApplicationRecord

  mount_uploader :image, ImageUploader

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable, :omniauthable, omniauth_providers: [:twitter, :google_oauth2, :facebook]



  # お気に入りしているユーザーを取り出す(user.likingsを使えるようにする)
  has_many :liking_favorites, foreign_key: "liker_id", class_name: "Favorite", dependent: :destroy
  has_many :likings, through: :liking_favorites

  # お気に入りされているユーザーを取り出す（user.likersを使えるようにする）
  has_many :liker_favorites, foreign_key: "liking_id", class_name: "Favorite", dependent: :destroy
  has_many :likers, through: :liker_favorites

  # お気に入りしているか調べる
  def liking?(other_user)
    liking_favorites.find_by(liking_id: other_user.id)
  end

  # お気に入り
  def like!(other_user)
    liking_favorites.create!(liking_id: other_user.id)
  end

  # お気に入り取り消し
  def unlike!(other_user)
    liking_favorites.find_by(liking_id: other_user.id).destroy
  end



  # 送信しているユーザーを取り出す(user.sendingsを使えるようにする)
  has_many :sending_relationships, foreign_key: "sender_id", class_name: "Relationship", dependent: :destroy
  has_many :sendings, through: :sending_relationships

  # フォローされているユーザーを取り出す（user.sendersをできるようにする）
  has_many :sender_relationships, foreign_key: "sending_id", class_name: "Relationship", dependent: :destroy
  has_many :senders, through: :sender_relationships

  # 送信しているか調べる
  def sending?(other_user)
    sending_relationships.find_by(sending_id: other_user.id)
  end

  # 送信
  def send!(other_user)
    sending_relationships.create!(sending_id: other_user.id)
  end

  # 送信取り消し
  def unsend!(other_user)
    sending_relationships.find_by(sending_id: other_user.id).destroy
  end


  # オリジナルのカスタムバリデーション(日本語化するよりもこっちのほうが自由度が高いので良い)
  validate :add_error_user
  def add_error_user
    # ユーザーネームが20文字以上のときのエラーメッセージ
    if name.present?
      if name.length > 20
        errors[:base] << "ユーザーネームは20文字以内にしてください。"
      end
    end

    # メールアドレスがすでに使われているときのエラーメッセージ
    if User.find_by(email:email)
      if User.find_by(email:email) != User.find(id) # 自分以外のユーザーがメールアドレスを使っているか
を確認。これがなければ自分のメールアドレスに対してもバリデーションしてしまう。
        errors[:base] << "このメールアドレスはすでに使われています。"
      end
    end

    # 自己紹介文が400文字以上のときのエラーメッセージ
    if description.present?
      if description.length > 400
        errors[:base] << "自己紹介は400文字以内にしてください。"
      end
    end

    # XSS対策
    if url.present?
      if url !~ /\A(https?|ftp)(:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+)\z/
        errors[:base] << "正しいURLを入力してください。"
      end
    end
  end

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        #image: auth.info.image, #carrierwaveのimage.urlが使えないので画像は保存しない
        name: auth.info.name,
        nickname: auth.info.nickname,
        location: auth.info.location,
      )
    end

    user
  end

  private

    def self.dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end

end


