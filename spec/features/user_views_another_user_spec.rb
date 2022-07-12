require 'rails_helper'

RSpec.feature 'USER views another user', type: :feature do
  let(:user) { FactoryBot.create(:user, name: 'Alex') }

  let(:game1) do
    FactoryBot.create(
      :game,
      user: user,
      current_level: 6,
      prize: 2000,
      created_at: '11 июля, 20:04')
  end

  let(:game2) do
    FactoryBot.create(
      :game,
      user: user,
      current_level: 12,
      prize: 0,
      is_failed: true,
      fifty_fifty_used: true,
      created_at: '11 июля, 21:10',
      finished_at: '11 июля, 21:20'
    )
  end

  let!(:games) { [game1, game2] }

  before do
    visit '/'
    click_link 'Alex'
  end

  feature 'unregistered user views another user' do
    scenario 'gets required url' do
      expect(page).to have_current_path '/users/1'
    end

    scenario 'gets name of user' do
      expect(page).to have_content 'Alex'
    end

    scenario 'does not change name and password' do
      expect(page).not_to have_content 'Сменить имя и пароль'
    end

    feature 'game1' do
      scenario 'gets time ot the game' do
        expect(page).to have_content '11 июля, 20:04'
      end

      scenario 'gets number of question' do
        expect(page).to have_content(game1.current_level)
      end

      scenario 'gets prize' do
        expect(page).to have_content '2 000 ₽'
      end

      scenario 'is in progress' do
        expect(page).to have_content 'в процессе'
      end
    end

    feature 'game2' do
      scenario 'gets time ot the game' do
        expect(page).to have_content '11 июля, 21:10'
      end

      scenario 'gets number of question' do
        expect(page).to have_content(game2.current_level)
      end

      scenario 'gets 50/50 hint' do
        expect(page).to have_content '50/50'
      end

      scenario 'is failed' do
        expect(page).to have_content 'проигрыш'
      end
    end
  end
end
