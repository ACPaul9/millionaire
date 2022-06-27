class AddHelpHashToGameQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :game_questions, :help_hash, :text
  end
end
