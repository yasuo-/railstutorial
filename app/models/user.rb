class User < ApplicationRecord
  # ユーザーがマイクロポストを複数所有する (has_many) 関連付け
  # サイト管理者はユーザーを破棄する権限を持ちます。
  # ユーザーが破棄された場合、ユーザーのマイクロポストも同様に破棄されるべき
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token
  #  email属性を小文字に変換してメールアドレスの一意性を保証する
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # use
  # - セキュアにハッシュ化したパスワードを、データベース内のpassword_digestという属性に保存できるようになる
  # - 2つのペアの仮想的な属性 (passwordとpassword_confirmation) が使えるようになる。また、存在性と値が一致するかどうかのバリデーションも追加される
  # - authenticateメソッドが使えるようになる (引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド) 
  has_secure_password
  # 編集時、パスワードのバリデーションに対して、空だったときの例外処理を加える必要があり -> allow_nil: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためユーザーをDBに記憶
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたtokenがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    # authenticated?を更新して、ダイジェストが存在しない場合に対応
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報破棄
  def forget
    update_attribute(:remember_token, nil)
  end
end
