class AddStopWordsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :stop_words, :text, limit: 1000
  end
end
