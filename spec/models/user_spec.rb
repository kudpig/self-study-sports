require 'rails_helper'

RSpec.describe User, type: :model do

  # userのcreateに関するテスト
  describe "バリデーション" do

    it 'email, password, paasword_confirmation, usernameが存在すれば登録できること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'emailがない場合は登録できないこと' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it 'emailが既に使用されている場合は登録できないこと' do
      first_user = create(:user)
      another_user = build(:user, email: first_user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end
    # another_userのemailを、作成済みのfirst_userのemailでbuildしている。

    it 'passwordがない場合は登録できないこと' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("は3文字以上で入力してください")
    end

    it 'usernameがない場合は登録できないこと' do
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include("を入力してください")
    end

    it 'usernameが既に使用されている場合は登録できないこと' do
      first_user = create(:user)
      another_user = build(:user, username: first_user.username)
      another_user.valid?
      expect(another_user.errors[:username]).to include("はすでに存在します")
    end

  end
end

