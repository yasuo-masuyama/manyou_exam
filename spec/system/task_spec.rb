require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user: user) }
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_user_path
        visit new_session_path
        fill_in 'session[email]', with: 'test_user@example.com'
        fill_in 'session[password]', with: '111111'
        click_on '保存する'
        visit new_task_path
        fill_in 'task[title]', with: 'new_test_title'
        fill_in 'task[detail]', with: 'new_test_detail'
        select '2023', from: 'task[expired_at(1i)]'
        select '1月', from: 'task[expired_at(2i)]'
        select '10', from: 'task[expired_at(3i)]'
        select '完了', from: 'task[status]'
        select '中', from: 'task[priority]'
        click_on '登録する'
        expect(page).to have_content 'プロフィール'
        expect(page).to have_content '完了'
      end
    end
  end
  describe '一覧表示機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, user: user) }
    before do
        visit new_session_path
        fill_in 'session[email]', with: 'test_user@example.com'
        fill_in 'session[password]', with: '111111'
        click_on '保存する'
    end
    context '一覧画面に遷移した場合' do

      it '作成済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content 'プロフィール'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        task_list = page.all('.task_row')
        expect(task_list[0]).to have_content '3:Factoryで作ったデフォルトのタイトル'
      end
    end
    context '「終了期限で並び替え」ボタンがクリックされた場合' do
      it '終了期限が一番未来のタスクが一番上に表示される' do
        visit tasks_path
        visit tasks_path(sort_end_date: "true")
        task_list = page.all('.task_row')
        expect(task_list[0]).to have_content '3:Factoryで作ったデフォルトのタイトル'
      end
    end
    context '「優先度で並び替え」ボタンがクリックされた場合' do
      it '優先度が高いタスクが一番上に表示される' do
        visit tasks_path
        visit tasks_path(sort_priority: "true")
        task_list = page.all('.task_row')
        expect(task_list[0]).to have_content '2:Factoryで作ったデフォルトのタイトル'
      end
    end
  end
  describe '詳細表示機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, user: user) }
    before do
        visit new_session_path
        fill_in 'session[email]', with: 'test_user@example.com'
        fill_in 'session[password]', with: '111111'
        click_button '保存する'
    end
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit tasks_path
        click_on "詳細", match: :first
        expect(page).to have_content "プロフィール"
      end
    end
  end
  describe '検索機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user: user) }
    let!(:second_task) { FactoryBot.create(:second_task, user: user) }
    let!(:third_task) { FactoryBot.create(:third_task, user: user) }
    before do
      visit new_session_path
      fill_in 'session[email]', with: 'test_user@example.com'
      fill_in 'session[password]', with: '111111'
      click_button '保存する'
    end
    context 'タイトルで検索した場合' do
      it 'タイトルが部分一致したタスクが表示される' do
        visit tasks_path
        click_on "検索"
        expect(page).to have_content "中"
      end
    end
    context 'ステータスで検索した場合' do
      it 'ステータスと完全一致したタスクが表示される' do
        visit tasks_path
        select '未着手', from: 'status'
        click_button "検索"
        expect(page).to have_content "プロフィール"
      end
    end
    context 'タイトルとステータス両方で検索した場合' do
      it '両方をand検索して一致したタスクが表示される' do
        visit tasks_path
        select '未着手', from: 'status'
        click_on "検索"
        expect(page).to have_content "プロフィール"
        expect(page).to have_content "未着手"
      end
    end
  end
end