class ChannelsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user,
                only: [:edit, :update, :toggle_public, :destroy]

  # GET /channels
  def index
    if params[:tag]
      @tag = params[:tag]
      # @channels = Channel.tagged_with params[:tag]
      @channels = Channel.published_and_personal_for(current_user).tagged_with params[:tag]
    else
      @channels = Channel.published
    end
  end

  def personal
    @channels = current_user.channels
    render :index
  end

  # GET /channels/1
  def show
    @channel = Channel.find params[:id]
    flash.now[:notice] = t 'flash.queue'
    Channel.delay.fetch_by_id @channel.id
  end

  # GET /channels/new
  def new
    @channel = current_user.channels.build
    @channel.build_setup
  end

  # GET /channels/1/edit
  def edit
  end

  # POST /channels
  def create
    @channel = current_user.channels.build channel_params
    # Channel.new(channel_params)
    if @channel.save
      redirect_to @channel, notice: t('flash.create.success')
    else
      render :new
    end
  end

  # PATCH/PUT /channels/1
  def update
    if @channel.update channel_params
      redirect_to @channel, notice: t('flash.update.success')
    else
      render :edit
    end
  end

  # PATCH
  def toggle_public
    if @channel.update public: not(@channel.public)
      redirect_to @channel, notice: t('flash.update.success')
    else
      redirect_to @channel, alert: t('flash.error')
    end
  end

  # DELETE /channels/1
  def destroy
    @channel.destroy
    redirect_to root_path, notice: t('flash.destroy.success')
  end

  private

  def set_channel
    @channel = Channel.find params[:id]
  end

  def channel_params
    params.require(:channel).permit :title, :source_url, :public, :tag_list,
      setup_attributes: [:max_price, :shift_days, :stop_words]
  end

  def authorize_user
    @channel = current_user.channels.find_by id: params[:id]

    msg = t 'devise.failure.unauthenticated'
    redirect_to root_path, alert: msg unless @channel
  end
end
