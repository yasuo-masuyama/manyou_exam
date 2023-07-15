require "rails_helper"
RSpec.describe "ユーザー管理機能", type: :system do
  describe "新規会員登録" do
    context "ユーザの新規登録した場合" do
      it "登録できる" do
        visit new_user_path
        fill_in "user[name]", with: "名前1"
        fill_in "user[email]", with: "test1@test.com"
        fill_in "user[password]", with: "123456"
        fill_in "user[password_confirmation]", with: "123456"
        click_button "登録する"
        expect(page).to have_content "プロフィール"
      end
    end
  end

  describe "ログイン確認" do
    context "ログインしていない場合" do
      it "ログイン画面に移動する" do
        visit new_session_path
        expect(page).to have_content "ログイン"
      end
    end
  end

  describe "セッション機能" do
    before do
      FactoryBot.create(:user)
      visit new_session_path
      fill_in "session[email]", with: "test_user@example.com"
      fill_in "session[password]", with: "111111"
      click_on "保存する"
    end
    context "ログインした場合" do
      it "ログインができる" do
        expect(page).to have_content "test_user@example.comのタスク"
      end
    end
    context "プロフィールをクリックした場合" do
      it "自分の詳細画面(マイページ)に飛べる" do
        click_on "プロフィール"
        expect(page).to have_content "タスク"
      end
    end
    context "一般ユーザが他人の詳細画面に飛ぼうとした場合" do
      it "タスク一覧画面に遷移する" do
        user = FactoryBot.create(:second_user)
        visit user_path(user.id)
        expect(page).to have_content "プロフィール"
      end
    end
    context "ログアウトをクリックした場合" do
      it "ログアウトする" do
        click_on "ログアウト"
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe "管理画面" do
    before do
      FactoryBot.create(:user)
      FactoryBot.create(:second_user)
      FactoryBot.create(:admin_user1)
      FactoryBot.create(:admin_user2)
    end
    context "管理画面に遷移" do
      it "管理ユーザは管理画面にアクセスできる" do
        visit new_session_path
        fill_in "session[email]", with: "admin_test_user2@example.com"
        fill_in "session[password]", with: "111111"
        # binding.pry
        click_button "保存する"
        visit admin_users_path
        expect(page).to have_content ""
      end
      it "一般ユーザは管理画面にアクセスできない" do
        visit new_session_path
        fill_in "session[email]", with: "test_user@example.com"
        fill_in "session[password]", with: "1111111"
        click_on "保存する"
        sleep 1
        visit admin_users_path
        expect(page).not_to have_content "管理者権限を持っていません"
      end
    end
    context "管理ユーザがユーザの新規登録をした場合" do
      it "ユーザの新規登録ができる" do
        visit new_session_path
        fill_in "session[email]", with: "admin_test_user2@example.com"
        fill_in "session[password]", with: "111111"
        click_on "保存する"
        sleep 1
        first(:link, "管理者権限").click
        visit new_admin_user_path
        fill_in "user[name]", with: "test_user3"
        fill_in "user[email]", with: "test_user3@example.com"
        fill_in "user[password]", with: "111111"
        fill_in "user[password_confirmation]", with: "111111"
        click_on "登録する"
        expect(page).to have_content "test_user3"
      end
    end
    context "ユーザの詳細画面にアクセスする" do
      it "管理ユーザはユーザの詳細画面にアクセスできる" do
        user = FactoryBot.create(:third_user)
        task = FactoryBot.create(:task, user: user)
        visit new_session_path
        fill_in "session[email]", with: "admin_test_user1@example.com"
        fill_in "session[password]", with: "111111"
        click_on "保存する"
        sleep 1
        first(:link, "管理者権限").click
        visit admin_user_path(user.id)
        expect(page).to have_content "test_user3のページ"
      end
    end
    context "管理ユーザがユーザの編集画面で編集した場合" do
      it "ユーザを編集できる" do
        user = FactoryBot.create(:third_user)
        visit new_session_path
        fill_in "session[email]", with: "admin_test_user1@example.com"
        fill_in "session[password]", with: "111111"
        click_on "保存する"
        sleep 1
        first(:link, "管理者権限").click
        visit edit_admin_user_path(user.id)
        fill_in "user[email]", with: "test_user3@example.com"
        fill_in "user[password]", with: "111111"
        fill_in "user[password_confirmation]", with: "111111"
        click_on "更新する"
        expect(page).to have_content "プロフィール"
      end
    end
    context "管理ユーザがユーザの削除をした場合" do
      it "管理ユーザはユーザの削除をできる" do
        visit new_session_path
        fill_in "session[email]", with: "admin_test_user1@example.com"
        fill_in "session[password]", with: "111111"
        click_on "保存する"
        sleep 1
        visit admin_users_path
        click_on "削除", match: :first
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "ユーザーを削除"
      end
    end
  end
end