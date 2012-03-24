require File.dirname(__FILE__) + '/../spec_helper'

describe MoviesController do

  describe "#index" do
    
    before :each do
      @params = {:ratings => {'PG' => '1', 'R' => '1'}, :sort => 'title'}
      @params.each{|k,v| session[k] = v }
    end

    it "should find movies by ratings from session[:ratings]" do 
      Movie.should_receive(:find_all_by_rating).
        with( satisfy{|ratings| ratings.sort == %w(PG R)}, anything )
      get :index, @params
    end

    it "should set session[:ratings] if selected ratings list has changed" do
      params = @params.merge(:ratings => {'PG' => '1', 'G' => '1'})
      get :index, params
      session[:ratings].should == {'PG' => '1', 'G' => '1'}
      response.should redirect_to(movies_path(params))
    end

    it "should order movies by session[:sort] parameter" do
      Movie.should_receive(:find_all_by_rating).with( anything, {:order => :title} )
      get :index, @params
    end

    it "should set session[:sort] if sort parameter has changed" do
      params = @params.merge(:sort => 'release_date')
      get :index, params
      session[:sort].should == 'release_date'
      response.should redirect_to(movies_path(params))
    end
    
  end

  describe '#create' do
    
    it 'should create a movie' do
      lambda {
        post :create, :movie => {:title => 'Cube', :rating => 'R'}
      }.should change(Movie, :count).by(1)
    end

    it 'should redirect to movies list' do
      post :create, :movie => {:title => 'Cube', :rating => 'R'}
      response.should redirect_to(movies_path)
    end

  end

  describe '#update' do

    before :each do
      @movie = Movie.create! :title => 'Amelie'
    end
    
    it 'should update movie' do
      post :update, :id => @movie.id, :movie => {:title => 'Cleopatra'}
      @movie.reload.title.should == 'Cleopatra'
    end

    it 'should redirect to movie details' do
      post :update, :id => @movie.id, :movie => {}
      response.should redirect_to(movie_path(@movie))
    end

  end

  describe '#destroy' do
    
    before :each do
      @movie = Movie.create! :title => 'Amelie'
    end
    
    it 'should delete movie' do
      lambda {
        post :destroy, :id => @movie.id
      }.should change(Movie, :count).by(-1)
    end

    it 'should redirect to movies list' do
      post :destroy, :id => @movie.id
      response.should redirect_to(movies_path)
    end

  end

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
