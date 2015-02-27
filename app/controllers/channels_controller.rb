class ChannelsController < ApplicationController
  # before_action :set_channel, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  # GET /channels
  # GET /channels.json
  def index
    @channels = Channel.all
  end

  def personal
    @channels = current_user.channels
    render :index
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    @channel = Channel.find params[:id]
    posts = @channel.fetch
    @channel.posts.create posts.sort_by{|post| post[:published_at]} unless posts.empty?
  end

  # GET /channels/new
  def new
    @channel = current_user.channels.build
    #Channel.new
  end

  # GET /channels/1/edit
  def edit
  end

  # POST /channels
  # POST /channels.json
  def create
    @channel = current_user.channels.build channel_params
    # Channel.new(channel_params)

    respond_to do |format|
      if @channel.save
        format.html { redirect_to @channel, notice: 'Channel was successfully created.' }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channels/1
  # PATCH/PUT /channels/1.json
  def update
    respond_to do |format|
      if @channel.update channel_params
        format.html { redirect_to @channel, notice: 'Channel was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to channels_url, notice: 'Channel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def channel_params
      params.require(:channel).permit(:title, :source_url)
    end

    def authorize_user
      @channel = current_user.channels.find_by id: params[:id]

      msg = t('devise.failure.unauthenticated')
      redirect_to root_path, alert: msg unless @channel
    end
end
