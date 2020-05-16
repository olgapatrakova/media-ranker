require "test_helper"

describe Work do
  it "has the required fields" do
    # Arrange
    new_work = works(:summer)
    [:category, :title, :creator, :publication_year, :description].each do |f|
      
      # Assert
      expect(new_work).must_respond_to f
    end
  end

  describe 'validations' do
    it "is valid when all fields are filled" do
      work = works(:summer)
      result = work.valid?

      expect(result).must_equal true
    end

    it "fails validation when there is no title" do
      work = works(:missing_title)
      expect(work.valid?).must_equal false
      expect(work.errors.messages.include?(:title)).must_equal true
      expect(work.errors.messages[:title].include?("can't be blank")).must_equal true
    end

    it "fails validation when the title already exists" do
      work = Work.create(title: 'Summer Select') # title from fixtures
      expect(work.valid?).must_equal false
      expect(work.errors.messages.include?(:title)).must_equal true
      expect(work.errors.messages[:title].include?("has already been taken")).must_equal true
    end
  end
end
 