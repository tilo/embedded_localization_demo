require 'spec_helper'
require 'rails_helper'

I18n.locale = :en

# e.g. the model "Genre" has :name as a translated field,
#      but does not have :name as a native attribute for the model.
#      It is only defined as a virtual attribute in the :i18n hash.
describe Genre, type: :model do
  describe 'model has translated field without attribute of that same name' do
    let(:genre) { Genre.new }

    describe 'basic things that need to work' do
      it 'reports it translates' do
        expect(Genre.translates?).to be_truthy
      end

      it 'correctly reports the list of translated_attributes' do
        expect(Genre.translated_attributes.sort).to eq %i[description name]
      end

      it 'correctly reports the list of translated_attribute_names' do
        expect(Genre.translated_attribute_names.sort).to eq %i[description name]
      end

      it 'correcty shows the translated attribute as translated' do
        expect(Genre.translated?(:name)).to be_truthy
        expect(Genre.translated?(:description)).to be_truthy
      end

      it 'correcty shows not translated attribute' do
        expect(Genre.translated?(:other)).to be_falsy
      end
    end

    # describe 'new DB records' do
    #   it 'correctly reports translated_locales for new record' do
    #     genre.translated_locales.should eq [I18n.default_locale]
    #   end

    #   it 'correctly reports translation_missing for new record' do
    #     genre.translation_missing.should be_truthy
    #   end

    #   it 'creates the accessor methods' do
    #     genre.methods.should include(:name)
    #     genre.methods.should include(:name=)
    #     genre.methods.should include(:description)
    #     genre.methods.should include(:description=)
    #   end

    #   it 'correctly reports translated field for new record for default locale' do
    #     genre.name.should be_nil
    #     genre.description.should be_nil
    #     genre.description(I18n.default_locale).should be_nil
    #   end

    #   it 'correctly reports translated field for new record for other locale' do
    #     genre.name(:ko).should be_nil
    #     genre.description(:de).should be_nil
    #   end

    #   it 'correctly reports translation_coverage for new record' do
    #     genre.translation_coverage.should eq({})
    #   end

    #   it 'correctly reports translation_goverate for attributes of new record' do
    #     genre.translation_coverage(:name).should eq []
    #     genre.translation_coverage(:description).should eq []
    #   end

    #   it 'translated_coverage returns nil for not-translated attributes' do
    #     genre.translation_coverage(:other).should be_nil
    #   end

    #   it 'correctly reports translation_missing for new record' do
    #     genre.translation_missing.should
    #     genre.translation_missing(:name).should eq [:en]
    #     genre.translation_missing(:description).should eq [:en]
    #   end
    # end

    # describe 'DB record with pre-set fields' do
    #   let(:genre_name_en) { 'Science Fiction' }
    #   let(:scifi) { Genre.new(name: genre_name_en) }

    #   it 'correctly shows the attribute for new record' do
    #     expect(scifi.name).to eq genre_name_en
    #   end
    # end

    # describe 'updated DB record' do
    #   let(:genre_name_en) { 'Science Fiction' }
    #   let(:genre_name_jp) { 'サイエンスフィクション' }
    #   let(:genre_name_ko) { '공상 과학 소설' }
    #   let(:scifi) { Genre.new(name: genre_name_en) }

    #   describe 'updating just default locale' do
    #     before :each do
    #       genre.name = genre_name_en
    #       genre.description = 'an awesome genre'
    #       genre.save
    #       genre.reload
    #     end

    #     it 'correctly reports the translated_locales' do
    #       genre.translated_locales.should eq [:en]
    #     end

    #      # when setting all fields in the default locale's languange:
    #     it 'correctly reports translation_missing for updated record' do
    #       genre.translation_missing.should eq({})
    #     end

    #     it 'correctly reports translation_missing for attributes' do
    #       genre.translation_missing(:name).should eq nil
    #       genre.translation_missing(:description).should eq nil
    #     end

    #     it 'correctly reports translated_coverage for updated record' do
    #       genre.translation_coverage.should == { name: [:en], description: [:en] }
    #     end

    #     it 'correctly reports translated_coverage for attributes' do
    #       genre.translation_coverage(:name).should eq [:en]
    #       genre.translation_coverage(:description).should eq [:en]
    #     end
    #   end

    #   describe 'updating other locales' do
    #     before :each do
    #       genre.name = genre_name_en
    #       genre.description = 'an awesome genre'
    #       I18n.locale = :jp
    #       genre.name = genre_name_jp
    #       genre.set_localized_attribute(:name, :ko, genre_name_ko)
    #       I18n.locale = :de
    #       genre.description = 'ein grossartiges Genre'
    #       I18n.locale = I18n.default_locale # MAKE SURE you switch back to your default locale if you tweak it
    #       genre.save
    #       genre.reload
    #     end

    #     it 'correctly reports the translated_locales' do
    #       genre.translated_locales.should eq %i[en jp ko de]
    #     end

    #     it 'can assign the translated field' do
    #       genre.name = genre_name_en
    #       genre.save.should be_truthy
    #       genre.name.should eq genre_name_en
    #       genre.name(:en).should eq genre_name_en
    #     end

    #     # when setting all fields in additional languanges:
    #     it 'correctly reports values for updated record via attr(:locale)' do
    #       genre.name(:ko).should eq genre_name_ko
    #     end

    #     it 'correctly reports values for updated record via getter' do
    #       genre.get_localized_attribute(:name, :jp).should eq genre_name_jp
    #     end

    #     it 'correctly reports translation_coverage for updated record' do
    #         # what values are actually present
    #       genre.translation_coverage.should == { name: %i[en jp ko], description: %i[en de] }
    #     end

    #     it 'correctly reports translation_coverage for attributes' do
    #       genre.translation_coverage(:name).should eq %i[en jp ko]
    #       genre.translation_coverage(:description).should eq %i[en de]
    #     end

    #     it 'correctly reports translation_missing for updated record' do
    #        # what values are missing
    #       genre.translation_missing.should == { description: %i[jp ko], name: [:de] }
    #     end

    #     it 'correctly reports translation_missing for attributes' do
    #       genre.translation_missing(:name).should eq [:de]
    #       genre.translation_missing(:description).should eq %i[jp ko]
    #     end
    #   end
    # end
  end
end
