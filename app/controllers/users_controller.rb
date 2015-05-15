# encoding: utf-8
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to users_url,
                      notice: I18n.t('activerecord.attributes.user.messages.created', name: @user.name)
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    current_password = params.delete(:current_password)
    unless @user.authenticate(current_password)
      @user.errors.add(:current_password, t('activerecord.errors.models.user.attributes.current_password.invalid'))
    end
    p '==============================='
    p current_password

    respond_to do |format|
      if @user.errors.empty? and @user.update(user_params)
        format.html { redirect_to users_url,
                                  notice: t('activerecord.attributes.user.messages.updated', name: @user.name) }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      @user.destroy
      flash[:notice] = t('activerecord.attributes.user.messages.deleted', user: @user.name)
    rescue StandardError => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html do
        redirect_to users_url,
                    notice: t('activerecord.attributes.user.messages.deleted', name: @user.name)
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end