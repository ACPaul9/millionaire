require 'rails_helper'

RSpec.describe GameQuestion, type: :model do
  let(:game_question) { FactoryBot.create(:game_question, a: 2, b: 1, c: 4, d: 3) }

  describe 'variants' do
    it 'should return correct variants' do
      expect(game_question.variants).to eq({
                                             'a' => game_question.question.answer2,
                                             'b' => game_question.question.answer1,
                                             'c' => game_question.question.answer4,
                                             'd' => game_question.question.answer3
                                           })
    end

    describe '.answer_correct?' do
      it 'correct .answer_correct?' do
        expect(game_question.answer_correct?('b')).to be true
      end
    end

    describe 'text .delegate' do
      it 'should return question text' do
        expect(game_question.text).to eq(game_question.question.text)
      end
    end

    describe 'level .delegate' do
      it 'should return question level' do
        expect(game_question.level).to eq(game_question.question.level)
      end
    end

    describe '.correct_answer_key' do
      context 'when .correct_answer is b' do
        it 'should return b' do
          expect(game_question.correct_answer_key).to eq 'b'
        end
      end
    end
  end
end
