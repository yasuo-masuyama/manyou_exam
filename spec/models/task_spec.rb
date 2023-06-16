require "rails_helper"

RSpec.describe "タスクモデル機能", type: :model do
  it "is invalid without a title" do
    task = Task.new(title: nil)
    task.valid?
    expect(task.errors[:title]).to include("を入力してください")
  end
  it "is invalid with title is 256 or more characters" do
    task = Task.new(title: "a" * 256)
    task.valid?
    expect(task.errors[:title]).to include("は255文字以内で入力してください")
  end
  context "タスクの詳細が空の場合" do
    it "バリデーションにひっかかる" do
      task = Task.new(title: "詳細空のテスト", detail: nil)
      expect(task).not_to be_valid
    end
  end
  context "タスクのタイトルと詳細に内容が記載されている場合" do
    it "バリデーションが通る" do
      task = Task.new(title: "タイトル合格", detail: "詳細合格")
      expect(task).to be_valid
    end
  end
  describe "検索機能" do
    let!(:task) { FactoryBot.create(:task, title: "task") }
    let!(:second_task) { FactoryBot.create(:second_task, title: "sample") }
    context "scopeメソッドでタイトルのあいまい検索をした場合" do
      it "検索キーワードを含むタスクが絞り込まれる" do
        expect(Task.search_word("task")).to include(task)
        expect(Task.search_word("task")).not_to include(second_task)
        expect(Task.search_word("task").count).to eq 1
      end
    end
    context "scopeメソッドでステータス検索をした場合" do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_status("0")).to include(task)
        expect(Task.search_status("2")).not_to include(second_task)
        expect(Task.search_status("1").count).to eq 1
      end
    end
    context "scopeメソッドでタイトルのあいまい検索とステータス検索をした場合" do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(Task.search_word("task").search_status("0")).to include(task)
        expect(Task.search_word("task").search_status("2")).not_to include(task)
        expect(Task.search_word("sample").search_status("1").count).to eq 1
      end
    end
  end
end
