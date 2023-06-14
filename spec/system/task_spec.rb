require "rails_helper"
RSpec.describe "タスク管理機能", type: :system do
  describe "新規作成機能" do
    context "タスクを新規作成した場合" do
      it "作成したタスクが表示される" do
        visit new_task_path
        fill_in "task[title]", with: "タスク"
        fill_in "task[detail]", with: "タスク詳細"
        click_on "登録"
        expect(page).to have_content "タスク"
      end
    end
  end
  describe '一覧表示機能' do
    before do
      FactoryBot.create(:task)
      FactoryBot.create(:second_task)
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content "タスク"
      end
    end
    context "タスクが作成日時の降順に並んでいる場合" do
      it "新しいタスクが一番上に表示される" do
        task_list = all(".task_row")
        expect(task_list[0].text).to start_with "2:"
      end
    end
  end
end

