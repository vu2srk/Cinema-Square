class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  
  
  def findMovie
    q = params[:q]
    agent = Mechanize.new
    page = agent.get('http://www.imdb.com/find?q='+q)
    @response = page.content
    doc = Hpricot(@response)
    title = doc.search("title").innerHTML
    if (title == "IMDb Search")
      isMovie = false
      popularTitles = doc.at("b[text()='Popular Titles']")
      popularTitles = popularTitles && popularTitles.parent
      otherTitles = doc.at("b[text()='Titles (Exact Matches)']")
      otherTitles = otherTitles && otherTitles.parent
      if (popularTitles != nil)
        results = popularTitles.next_node.search("a").join("~")
      end
      if (otherTitles != nil)
        (results != nil)?(results += otherTitles.next_node.search("a").join("~")):(results =otherTitles.next_node.search("a").join("~"))  
      end
      if (popularTitles == nil and otherTitles == nil)
        results = "Oops. I don't think this is a movie"
      end
    else
      if (doc.search("meta[@content*='http://www.imdb.com/title/']").length > 0)
        results = doc.search("td[@id='img_primary']").innerHTML + doc.search("td[@id='overview-top']").innerHTML
      else
        results = "Oops. I don't think this is a movie!"
      end
    end
    respond_to do |format|
      format.json {render :json => results.to_json, :status => :ok}
    end
  end
  
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
