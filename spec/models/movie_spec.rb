require File.dirname(__FILE__) + '/../spec_helper'

describe Movie do

  describe "#similars_by_director" do

    before :each do
      ["Avatar|James Cameron", 'Titanic|James Cameron', 'Terminator|James Cameron', 
       'Dune', 'Blue Velvet', 'Twin Peaks|David Lynch'].each do |movie|
        title, director = movie.split '|'
        Movie.create! :title => title, :director => director
      end
    end

    it 'should return a list of movies of the same director' do
      mov = Movie.find_by_title 'Titanic'
      mov.similars_by_director.map(&:title).sort.should == %w(Avatar Terminator)
    end

    it 'should return empty list if director is blank' do
      mov = Movie.find_by_title 'Dune'
      mov.similars_by_director.should == []
    end

  end

end
