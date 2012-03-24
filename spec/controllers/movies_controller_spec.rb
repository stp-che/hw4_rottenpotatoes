require File.dirname(__FILE__) + '/../spec_helper'

describe MoviesController do

  describe "#similars_by_director" do

    before :each do
      @movie = mock("mov", :director => "Ingmar Bergman", :similars_by_director => nil) 
      @mov_without_director = mock "mov1", :title => 'Pulp Fiction', :director => nil
    end

    it "should find Movie with specified id" do
      Movie.should_receive(:find).with('7').and_return(@movie)
      get :similars_by_director, :id => 7
    end

    it "should call similars_by_director for movie" do
      @movie.should_receive(:similars_by_director)
      Movie.stub(:find).and_return(@movie)
      get :similars_by_director, :id => 1
    end

    it "should redirect to home page unless movie has no director" do
      Movie.stub(:find).and_return(@mov_without_director)
      get :similars_by_director, :id => 1
      response.should redirect_to(movies_path)
    end

  end

end
