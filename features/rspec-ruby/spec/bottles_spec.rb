require 'spec_helper'
require_relative '../lib/bottles'

RSpec.describe 'Bottles' do
  shared_examples 'verse interface' do
    it { is_expected.to respond_to :lyrics }
  end

  class VerseFake
    def self.lyrics(number)
      "This is verse #{number}.\n"
    end
  end

  describe VerseFake do
    subject { VerseFake }

    include_examples 'verse interface'
  end

  describe BottleVerse do
    subject { BottleVerse }

    include_examples 'verse interface'

    describe '.lyrics' do
      subject { BottleVerse.lyrics(number) }

      describe 'general rule upper bound' do
        let(:number) { 99 }

        it 'returns the correct verse' do
          expect(subject).to eql <<~EXPECTED
            99 bottles of beer on the wall, 99 bottles of beer.
            Take one down and pass it around, 98 bottles of beer on the wall.
          EXPECTED
        end
      end

      describe 'general rule lower bound' do
        let(:number) { 3 }

        it {
          is_expected.to eql <<~EXPECTED
            3 bottles of beer on the wall, 3 bottles of beer.
            Take one down and pass it around, 2 bottles of beer on the wall.
          EXPECTED
        }
      end

      describe 'verse 7' do
        let(:number) { 7 }

        it {
          is_expected.to eql <<~EXPECTED
            7 bottles of beer on the wall, 7 bottles of beer.
            Take one down and pass it around, 1 six-pack of beer on the wall.
          EXPECTED
        }
      end

      describe 'verse 6' do
        let(:number) { 6 }

        it {
          is_expected.to eql <<~EXPECTED
            1 six-pack of beer on the wall, 1 six-pack of beer.
            Take one down and pass it around, 5 bottles of beer on the wall.
          EXPECTED
        }
      end

      describe 'verse 2' do
        let(:number) { 2 }

        it {
          is_expected.to eql <<~EXPECTED
            2 bottles of beer on the wall, 2 bottles of beer.
            Take one down and pass it around, 1 bottle of beer on the wall.
          EXPECTED
        }
      end

      describe 'verse 1' do
        let(:number) { 1 }

        it {
          is_expected.to eql <<~EXPECTED
            1 bottle of beer on the wall, 1 bottle of beer.
            Take it down and pass it around, no more bottles of beer on the wall.
          EXPECTED
        }
      end

      describe 'verse 0' do
        let(:number) { 0 }

        it {
          is_expected.to eql <<~EXPECTED
            No more bottles of beer on the wall, no more bottles of beer.
            Go to the store and buy some more, 99 bottles of beer on the wall.
          EXPECTED
        }
      end
    end
  end

  describe CountdownSong do
    describe '#verse' do
      subject { CountdownSong.new(verse_template: VerseFake).verse(500) }

      it { is_expected.to eql "This is verse 500.\n" }
    end

    describe '#verses' do
      subject { CountdownSong.new(verse_template: VerseFake).verses(99, 97) }

      it {
        is_expected.to eql <<~EXPECTED
          This is verse 99.

          This is verse 98.

          This is verse 97.
        EXPECTED
      }
    end

    describe '#song' do
      subject { CountdownSong.new(verse_template: VerseFake, max: 47, min: 43).song }

      it {
        is_expected.to eql <<~EXPECTED
          This is verse 47.

          This is verse 46.

          This is verse 45.

          This is verse 44.

          This is verse 43.
        EXPECTED
      }
    end
  end
end
