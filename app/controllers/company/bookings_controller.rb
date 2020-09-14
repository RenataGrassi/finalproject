class Company::BookingsController < ApplicationController
  
  def index
    
    if params[:search].nil?
      @bookings = Booking.where(product: current_user.company.products).order(date: :asc)
    else
      @dates = build_dates
      case @dates.size
      when 1
        @bookings = Booking.where(product: current_user.company.products, date: @dates[0]).order(date: :asc)
      else
        @bookings = Booking.where(product: current_user.company.products, date: @dates[0]..@dates[2]).order(date: :asc)
      end
    end
  end

  def show
    @booking = Booking.find(params[:id])
    authorize @booking, policy_class: CompanyBookingPolicy
  end
  
  def edit
    @booking = Booking.find(params[:id])
    authorize @booking, policy_class: CompanyBookingPolicy
  end

  def update
    @booking = Booking.find(params[:id])
    authorize @booking, policy_class: CompanyBookingPolicy
    @booking.canceled = true
    @booking.save
    redirect_to company_booking_path(@booking.id)
  end

  def dashboard
    @bookings = Booking.all
    authorize @bookings
  end
  private

  def build_dates
    # Build dates from form params
    return nil unless params[:search]
    dates = params[:search][:start_date].split(" ")
  end

end
