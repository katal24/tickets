class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_logged_in, only: [:new, :create, :edit, :update]

  def index
    @events = Event.all
    @events = @events.select{|event| event.event_date > Date.parse(params[:filterDate][:start]) } if params[:filterDate].present? && params[:filterDate][:start].present?
    @events = @events.select{|event| event.event_date < Date.parse(params[:filterDate][:stop]) } if params[:filterDate].present? && params[:filterDate][:stop].present? 
  end

  # GET /events/1
  # GET /events/1.json
  def show
    print "@@@@@@@@@@@@@@@@@"
    @nr = params["nr"] if params["nr"].present?
    @typ = params["typ"] if params["typ"].present?
    @tickets = Ticket.where(event_id: @event.id)
    @events = Event.all
  end

  def new
    @event = Event.new
    @events = Event.all    
  end

  def edit
  end

  def create
    event_params = params.require(:event).permit(:artist, :description, :price_low, :price_high, :event_date, :can_return, :of_age)
    @event = Event.new(event_params)

    if @event.save
      flash[:komunikat] = 'Event został poprawnie stworzony.'
      redirect_to "/events/#{@event.id}"
    else
      render 'new'
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update

      if @event.update(event_params)
        redirect_to @event, notice: 'Ticket was successfully updated.'
      else
        render :edit
      end
  end

  def is_admin?
    signed_in? ? current_user.admin : false
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    puts "set_event"
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:artist, :description, :price_low, :price_high, :event_date, :can_return, :of_age)
  end

  def check_logged_in
    authenticate_or_request_with_http_basic("Ads") do |username, password|
      username == "admin" && password == "admin"
  end

  def signed_in?
    !!current_user
  end
  end
    
  helper_method :is_admin?
end
