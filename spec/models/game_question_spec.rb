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

  describe '.add_fifty_fifty' do
    context 'there is no key in the hints yet' do
      before do
        expect(game_question.help_hash).not_to include(:fifty_fifty)

        game_question.add_fifty_fifty
      end

      it 'add fifty-fifty help to .help_hash' do
        expect(game_question.help_hash).to include(:fifty_fifty)
      end

      it 'add fifty-fifty help has 2 keys' do
        expect(game_question.help_hash[:fifty_fifty].size).to eq 2
      end

      it 'add fifty-fifty help with correct answer key' do
        expect(game_question.help_hash[:fifty_fifty]).to include(game_question.correct_answer_key)
      end
    end
  end

  describe '.add_friend_call' do
    context 'and friend call has not been used before' do
      before do
        expect(game_question.help_hash).not_to include(:friend_call)

        game_question.add_friend_call
      end

      it 'add friend call to help_hash' do
        expect(game_question.help_hash).to include(:friend_call)
      end

      it 'contain string' do
        expect(game_question.help_hash[:friend_call]).to include('считает, что это вариант')
      end
    end
  end
end
