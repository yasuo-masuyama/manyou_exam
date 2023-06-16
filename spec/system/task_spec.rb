require "rails_helper"
RSpec.describe "タスク管理機能", type: :system do
  describe "新規作成機能" do
    context "タスクを新規作成した場合" do
      it "作成したタスクが表示される" do
        visit new_task_path
        fill_in "task[title]", with: "納税"
        fill_in "task[detail]", with: "自動車税を払う"
        find("#task_expired_at_1i").find("option[value='2023']").select_option
        find("#task_expired_at_2i").find("option[value='6']").select_option
        find("#task_expired_at_3i").find("option[value='20']").select_option
        find("#task_status").find("option[value='started']").select_option
        find("#task_priority").find("option[value='middle']").select_option
        click_on "登録する"
        expect(page).to have_content "納税"
      end
    end
  end
  describe "一覧表示機能" do
    before do
      FactoryBot.create(:task)
      FactoryBot.create(:second_task)
      FactoryBot.create(:third_task)
      visit tasks_path
    end
    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が表示される" do
        expect(page).to have_content "Factory"
      end
    end
    context "タスクが作成日時の降順に並んでいる場合" do
      it "新しいタスクが一番上に表示される" do
        task_list = all(".task_row")
        expect(task_list.first.text).to start_with "3:"
      end
    end
    context "タスクが終了期限の降順に並んでいる場合" do
      it "終了期限が新しいタスクが一番上に表示される" do
        click_on "終了期限▼"
        sleep 0.5
        task_list = all(".task_row")
        expect(task_list.first.text).to start_with "1:"
      end
    end
    context "タスクの優先順位が高い順に並んでいる場合" do
      it "優先順位が高いタスクが一番上に表示される" do
        click_on "優先度▼"
        sleep 0.5
        task_list = all(".task_row")
        expect(task_list.first.text).to start_with "2:"
      end
    end
  end
  describe "詳細表示機能" do
    context "任意のタスク詳細画面に遷移した場合" do
      it "該当タスクの内容が表示される" do
        task = FactoryBot.create(:task, title: "任意タスク")
        visit task_path(task.id)
        expect(page).to have_content "任意タスク"
      end
    end
  end
  describe "検索機能" do
    before do
      FactoryBot.create(:task)
      FactoryBot.create(:second_task)
      FactoryBot.create(:third_task)
      visit tasks_path
    end
    context "タイトルであいまい検索をした場合" do
      it "検索キーワードを含むタスクで絞り込まれる" do
        fill_in "search", with: "1:F"
        click_on "検索"
        expect(page).to have_content "1:F"
      end
    end
    context "ステータス検索をした場合" do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        find("#status").find("option[value='started']").select_option
        click_on "検索"
        expect(page).to have_content "2:F"
      end
    end
    context "タイトルのあいまい検索とステータス検索をした場合" do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in "search", with: "3:F"
        find("#status").find("option[value='completed']").select_option
        click_on "検索"
        expect(page).to have_content "3:F"
      end
    end
  end
end