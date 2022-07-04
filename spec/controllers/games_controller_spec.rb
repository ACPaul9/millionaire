require 'rails_helper'
require 'support/my_spec_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, is_admin: true) }
  let(:game_w_questions) { FactoryBot.create(:game_with_questions, user: user) }

  describe '#show' do
    context 'when anonymous' do
      before { get :show, params: { id: game_w_questions.id } }

      it 'return status not 200' do
        expect(response.status).not_to eq(200)
      end

      it 'redirect to the new session path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'flash alert' do
        expect(flash[:alert]).to be
      end
    end

    context 'when the user is logged in' do
      before(:each) do
        sign_in user
        get :show, params: { id: game_w_questions.id }
        generate_questions(60)
      end

      let(:game) { assigns(:game) }

      context 'user views his game' do
        it 'game not over' do
          expect(game.finished?).to be_falsey
        end

        it 'game for this user' do
          expect(game.user).to eq(user)
        end

        it 'will give status 200' do
          expect(response.status).to eq(200)
        end

        it 'render show view' do
          expect(response).to render_template('show')
        end
      end
    end
  end

  describe '#create' do
    context 'when anonymous' do
      before { post :create }

      it 'return status not 200' do
        expect(response.status).not_to eq(200)
      end

      it 'redirect to the new session path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'flash alert' do
        expect(flash[:alert]).to be
      end
    end

    context 'when the user is logged in' do
      before(:each) do
        sign_in user
        generate_questions(60)
        post :create
      end

      let(:game) { assigns(:game) }

      context 'game state not finished' do
        before do
          expect(game.finished?).to be false
        end

        it 'redirect to game in progress' do
          expect(response).to redirect_to(game_path(game))
        end
      end
    end
  end

  describe '#answer' do
    context 'when anonymous' do
      before { put :answer, params: { id: game_w_questions.id } }

      it 'return status not 200' do
        expect(response.status).not_to eq(200)
      end

      it 'redirect to the new session path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'flash alert' do
        expect(flash[:alert]).to be
      end
    end

    context 'when the user is logged in' do
      before(:each) do
        sign_in user
        generate_questions(60)
        put :answer, params: { id: game_w_questions.id, letter: answer_key }
      end

      let(:game) { assigns(:game) }

      context 'correct answer' do
        let!(:answer_key) { game_w_questions.current_game_question.correct_answer_key }

        it 'level up' do
          expect(game.current_level).to eq(1)
        end

        it 'redirect to game in progress' do
          expect(response).to redirect_to(game_path(game))
        end

        it 'continue game' do
          expect(game.finished?).to be false
        end

        it 'return status 302' do
          expect(response.status).to eq(302)
        end

        it 'no flash alert' do
          expect(flash[:alert]).to_not be
        end
      end

      context 'wrong answer' do
        # a - wrong answer
        let!(:answer_key) { 'a' }

        it 'return status :fail' do
          expect(game.status).to eq(:fail)
        end

        it 'current level 0' do
          expect(game.current_level).to be 0
        end

        it 'game finished' do
          expect(game.finished?).to be_truthy
        end

        it 'redirect to the user path' do
          expect(response).to redirect_to(user_path(user))
        end

        it 'flash alert' do
          expect(flash[:alert]).to be
        end
      end
    end
  end

  describe '#take_money' do
    context 'when anonymous' do
      before { put :take_money, params: { id: game_w_questions.id } }

      it 'return status not 200' do
        expect(response.status).not_to eq(200)
      end

      it 'redirect to the new session path' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'flash alert' do
        expect(flash[:alert]).to be
      end
    end

    context 'when user sign in' do
      before(:each) do
        sign_in user
        generate_questions(60)
        game_w_questions.update_attribute(:current_level, 2)
        put :take_money, params: { id: game_w_questions.id }
      end

      let(:game) { assigns(:game) }

      it 'game finished' do
        expect(game.finished?).to be_truthy
      end

      it 'game prize' do
        expect(game.prize).to eq(200)
      end

      it 'redirect to the user path' do
        expect(response).to redirect_to(user_path(user))
      end

      it 'flash alert' do
        expect(flash[:warning]).to be
      end
    end
  end

  describe '#help' do
    context 'when anonymous' do
      before { put :help, params: {id: game_w_questions.id } }

      it 'should not response' do
        expect(response.status).not_to eq(200)
      end

      it 'should redirect' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'should show alert' do
        expect(flash[:alert]).to be
      end
    end

    context 'when user sign in' do
      let(:game) { assigns(:game) }

      before(:each) { sign_in user }

      context 'use 50/50' do
        before do
          expect(game_w_questions.current_game_question.help_hash[:fifty_fifty]).not_to be
          expect(game_w_questions.fifty_fifty_used).to be_falsey

          put :help, params: {id: game_w_questions.id, help_type: :fifty_fifty}
        end

        it 'game should not be finished' do
          expect(game.finished?).to be false
        end

        it 'should use 50/50 help' do
          expect(game.fifty_fifty_used).to be true
        end

        it '50/50 help hash should be' do
          expect(game.current_game_question.help_hash[:fifty_fifty]).to be
        end

        it '50/50 help hash should contain correct key' do
          expect(game.current_game_question.help_hash[:fifty_fifty]).to include(game.current_game_question
                                                                                    .correct_answer_key)
        end

        it '50/50 help hash should have current size' do
          expect(game.current_game_question.help_hash[:fifty_fifty].size).to eq 2
        end

        it 'should redirect' do
          expect(response).to redirect_to(game_path(game))
        end
      end
    end
  end
end
