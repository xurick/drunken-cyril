class UsersController < ApplicationController
  
  # this is an Authorization mechanism
  before_filter :signed_in_user, except: [:new, :create]
  before_filter :correct_user, except: [:new, :create]

  def show

    # creating the addresses instance without saving to DB, if the user does not yet have
    # an addresses record
    #@user.addresses.build if @user.addresses.blank?

    @site = @user.sites.find_by_user_id(@user.id)

    # ditto for weekday hours
    days_of_week = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday) 
    days_of_week.each do |day_of_week|
      weekday_hours = @user.send("#{day_of_week.downcase}_business_hours")
      weekday_hours.build(:day_of_week => day_of_week) if weekday_hours.blank?
    end
  end

  def new
    @user = User.new
  end

  def create
    # if parame[:user] not empty, then it means it was created using the proper form
    # otherwise a request to create guest user
    @user = params[:user] ? User.new(params[:user]) : User.new_guest
    if @user.save
      # migrate guest data over to new non-guest user
      current_user.move_to(@user) if current_user && current_user.guest?

      # sign in the user upon signup
      sign_in @user
      if request.xhr?
        # respond to ajax request, ie create guest user via ajax post
        render :text => @user.id
      else
        # respond to normal request, ie sign up via proper form
        flash[:success] = 'Congratulations on making the first step to make your site mobile friendly!'
        redirect_to @user
      end
    else
      if request.xhr?
        render :text => ''
      else
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    debugger
    days_of_week = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday) 
    days_of_week.each do |day_of_week| 
      params[:user][(day_of_week.downcase+'_business_hours_attributes').to_sym][:"0"][:open_time] = Time.parse(params[:user][(day_of_week.downcase+'_business_hours_attributes').to_sym][:"0"][:"open_time(5i)"])
      params[:user][(day_of_week.downcase+'_business_hours_attributes').to_sym][:"0"][:close_time] = Time.parse(params[:user][(day_of_week.downcase+'_business_hours_attributes').to_sym][:"0"][:"close_time(5i)"])
      params[:user][(day_of_week.downcase+'_business_hours_attributes').to_sym][:"0"].delete(:"open_time(5i)")
      params[:user][(day_of_week.downcase+'_business_hours_attributes').to_sym][:"0"].delete(:"close_time(5i)")
    end

    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else # model did not get updated successfully
      if params[:action] == 'edit'
        render 'edit'
      else
        render 'show'
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to root_url(:subdomain => false)
  end

  private

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      # the following flash does not work, why?
      flash[:error] = 'You cannot access someone else\'s account'
      redirect_to root_url(:subdomain => current_user.name)
    end
  end

end
