require "test_helper"

describe Work do
  it "can be instantiated" do
    # Arrange
    work = Work.new(category: "album", title: "test")
    work.save
    # Assert
    expect(Work.last).must_equal work
  end

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
      work = Work.new(category: "movie")
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

  describe "relations" do
    it "must have votes association" do
      work = works(:summer)
      expect(work.votes.count).must_equal 0
      expect(work.votes.count).wont_be_nil
    end

    it "must have users through votes" do
      work = works(:summer)
      vote = Vote.create(work_id: work.id, user_id: users(:grace).id)
      expect(work.votes.count).must_equal 1
      expect(work.users.first).must_equal users(:grace)
    end
  end

  describe "custom methods" do
    describe "self.all_categories" do
      it "can find all categories from existing active records" do
        # Arrange
        album = works(:wakeup)
        movie = works(:summer)
        # Act
        categories = Work.all_categories
        # Assert
        expect(categories.length).must_equal 2
        expect(categories.first).must_match "album"
        expect(categories.last).must_match "movie"
        expect(categories).must_respond_to :to_ary
      end

      it "has 3 categories if an active record of a new category is created" do
        # Arrange
        new_work = Work.create!(category: "book", title: "test book")
        # Act
        categories = Work.all_categories.sort
        expected = ["album", "book", "movie"]
        # Assert
        expect(categories.length).must_equal expected.length
        expected.each_with_index do |item, index|
          expect(categories[index]).must_equal item
        end
      end

      it "has 3 categories if several works of 1 category is created" do
        # Arrange
        new_work = Work.create!(category: "book", title: "test book")
        new_work2 = Work.create!(category: "book", title: "totally new book")
        all_works = Work.all
        # Act
        categories = Work.all_categories.sort
        expected = ["album", "book", "movie"]
        # Assert
        expect(all_works.length).must_equal 4 # 2 in test db and 2 new
        expect(categories.length).must_equal expected.length
        expected.each_with_index do |item, index|
          expect(categories[index]).must_equal item
        end
      end
    end

    describe "self.find_top" do
      it "returns records of the same category" do
        # Arrange
        top_albums = Work.find_top('album')
        # Assert
        expect(top_albums.length).must_equal 1
        expect(top_albums.first.category).must_equal "album"
      end

      it "returns no records if there are no works of such category" do
        # Arrange
        top_albums = Work.find_top('book')
        # Assert
        expect(top_albums.length).must_equal 0
        expect(top_albums).must_be_empty
      end
    end

    describe "self.split_and_sort" do
      it "returns records of the same category" do
        # Arrange
        all_albums = Work.split_and_sort('album')
        # Assert
        expect(all_albums.length).must_equal 1
        expect(all_albums.first.category).must_equal "album"
      end

      it "returns works sorted by votes count" do
        # Arrange
        album = works(:wakeup)
        new_album = Work.create!(category: "album", title: "new album")
        user = users(:grace)
        # Act
        vote = Vote.create(work_id: new_album.id, user_id: user.id)
        all_albums = Work.split_and_sort('album')

        # Assert
        expect(all_albums.length).must_equal 2
        expect(all_albums[0]).must_equal new_album
        expect(all_albums[1]).must_equal album
      end
    end

    describe "self.is_spotlight" do
      it "returns a work with maximum votes" do
        # Arrange
        album = works(:wakeup)
        new_album = Work.create!(category: "album", title: "new album")
        user = users(:grace)
        # Act
        vote = Vote.create(work_id: new_album.id, user_id: user.id)
        spotlight = Work.is_spotlight
        # Assert
        expect(spotlight).must_equal new_album
      end
    end
  end
end
 