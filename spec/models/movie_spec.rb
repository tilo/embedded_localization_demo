require 'spec_helper'
require 'rails_helper'

I18n.locale = :en

# e.g. the model "Movie" has :title as a translated field,
#      but also has :title as a native attribute for the model.

describe Movie, type: :model do
  describe 'model has translated field with attribute of that same name' do
    let(:movie) { Movie.new }

    describe 'basic things that need to work' do
      it 'reports it translates' do
        expect(Movie.translates?).to be_truthy
      end

      it 'correctly reports the list of translated_attributes' do
        expect(Movie.translated_attributes.sort).to eq %i[description title]
      end

      it 'correctly reports the list of translated_attribute_names' do
        expect(Movie.translated_attribute_names.sort).to eq %i[description title]
      end

      it 'correcty shows the translated attribute as translated' do
        expect(Movie.translated?(:title)).to be_truthy
        expect(Movie.translated?(:description)).to be_truthy
      end

      it 'correcty shows not translated attribute' do
        expect(Movie.translated?(:other)).to be_falsy
      end
    end

    describe 'new DB records' do
      it 'correctly reports translated_locales for new record' do
        expect(movie.translated_locales).to eq [I18n.default_locale]
      end

      it 'correctly reports translation_missing for new record' do
        expect(movie.translation_missing).to be_truthy
      end

      it 'creates the accessor methods' do
        expect(movie.methods).to include(:title)
        expect(movie.methods).to include(:title=)
        expect(movie.methods).to include(:description)
        expect(movie.methods).to include(:description=)
      end

      it 'correctly reports translated field for new record for default locale' do
        expect(movie.title).to be_nil
        expect(movie.description).to be_nil
        expect(movie.description(I18n.default_locale)).to be_nil
      end

      it 'correctly reports translated field for new record for other locale' do
        expect(movie.title(:ko)).to be_nil
        expect(movie.description(:de)).to be_nil
      end

      it 'correctly reports translation_coverage for new record' do
        expect(movie.translation_coverage).to eq({})
      end

      it 'correctly reports translation_goverate for attributes of new record' do
        expect(movie.translation_coverage(:title)).to eq []
        expect(movie.translation_coverage(:description)).to eq []
      end

      it 'translated_coverage returns nil for not-translated attributes' do
        expect(movie.translation_coverage(:other)).to be_nil
      end

      it 'correctly reports translation_missing for new record' do
        expect(movie.translation_missing(:title)).to eq [:en]
        expect(movie.translation_missing(:description)).to eq [:en]
      end
    end

    describe 'DB record with pre-set fields' do
      let(:title_en) { 'Blade Runner' }
      let(:blade_runner) { Movie.new(title: title_en) }

      it 'correctly shows the attribute for new record' do
        expect(blade_runner.title).to eq title_en
      end
    end

    describe 'updated DB record' do
      let(:title_en) { 'Blade Runner' }
      let(:title_ru) { 'аЕЦСЫХИ ОН КЕГБХЧ' }
      let(:title_tr) { 'Ölüm takibi' }
      let(:title_de) { 'Der Blade Runner' }
      let(:blade_runner) { Movie.new(title: title_en) }

      describe 'updating just default locale' do
        before :each do
          movie.title = title_en
          movie.description = 'an awesome movie'
          movie.save
          movie.reload
        end

        it 'correctly reports the translated_locales' do
          expect(movie.translated_locales).to eq [:en]
        end

        # when setting all fields in the default locale's languange:
        it 'correctly reports translation_missing for updated record' do
          expect(movie.translation_missing).to eq({})
        end

        it 'correctly reports translation_missing for attributes' do
          expect(movie.translation_missing(:title)).to eq nil
          expect(movie.translation_missing(:description)).to eq nil
        end

        it 'correctly reports translated_coverage for updated record' do
          expect(movie.translation_coverage).to eq({ title: [:en], description: [:en] })
        end

        it 'correctly reports translated_coverage for attributes' do
          expect(movie.translation_coverage(:title)).to eq [:en]
          expect(movie.translation_coverage(:description)).to eq [:en]
        end
      end

      describe 'updating other locales' do
        before :each do
          movie.title = title_en
          movie.description = 'an awesome movie'
          I18n.locale = :ru
          movie.title = title_ru
          movie.set_localized_attribute(:title, :tr, title_tr)
          I18n.locale = :de
          movie.description = 'ein grossartiger Film'
          I18n.locale = I18n.default_locale # MAKE SURE you switch back to your default loale if you tweak it
          movie.save
          movie.reload
        end

        it 'correctly reports the translated_locales' do
          expect(movie.translated_locales).to eq %i[en ru tr de]
        end

        it 'can assign the translated field' do
          movie.title = title_en
          expect(movie.save).to be_truthy
          expect(movie.title).to eq title_en
          expect(movie.title(:en)).to eq title_en
        end

        # when setting all fields in additional languanges:
        it 'correctly reports values for updated record via attr(:locale)' do
          expect(movie.title(:tr)).to eq title_tr
        end

        it 'correctly reports values for updated record via getter' do
          expect(movie.get_localized_attribute(:title, :ru)).to eq title_ru
        end

        it 'correctly reports translation_coverage for updated record' do
          # what values are actually present
          expect(movie.translation_coverage).to eq({ title: %i[en ru tr], description: %i[en de] })
        end

        it 'correctly reports translation_coverage for attributes' do
          expect(movie.translation_coverage(:title)).to eq %i[en ru tr]
          expect(movie.translation_coverage(:description)).to eq %i[en de]
        end

        it 'correctly reports translation_missing for updated record' do
          # what values are missing
          expect(movie.translation_missing).to eq({ description: %i[ru tr], title: [:de] })
        end

        it 'correctly reports translation_missing for attributes' do
          expect(movie.translation_missing(:title)).to eq [:de]
          expect(movie.translation_missing(:description)).to eq %i[ru tr]
        end
      end
    end
  end
end
