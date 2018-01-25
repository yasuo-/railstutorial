# Userモデルにpassword_digest属性を追加する
# マイグレーション名は自由に指定できますが、次に示すように、末尾をto_usersにしておくことをオススメ
# こうしておくと、usersテーブルにカラムを追加するマイグレーションがRailsによって自動的に作成される
class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string
  end
end
