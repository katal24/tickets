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
    @nr = params["nr"] if params["nr"].present?
    @typ = params["typ"] if params["typ"].present?
    @price = params["price_typ"] if params["price_typ"].present?
    if is_admin?
      @tickets = Ticket.where(event_id: @event.id)
    elsif signed_in?
      @tickets = Ticket.where(event_id: @event.id, user_id: current_user.id)
    end
    
    if signed_in?
      @users = []
      @tickets.each do |ticket|
        @users << get_user_by_id(ticket.user_id)
      end
    end
    @events = Event.all
  end

  def can_buy?
    print "buyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
    print @tickets.count < 5
    @tickets.count < 5 || is_admin?
  end

  def new
    @event = Event.new
    @events = Event.all    
  end

  def edit
  end

  def get_user_by_id(id)
    User.find(id)    
  end

  def to_hash(str, arr_sep=',', key_sep=':')
    hash = {}
    array = str.split(arr_sep)
    letter = "A"
    @prices = []
    array.each do |e|
      key_value = letter
      arr = e.split(key_sep)
      first = Integer(arr[0])      
      second = arr[1].to_f
      @prices << second
      third = []
      hash[letter] = [first, second, third]
      letter = letter.next
    end
    print "HASHHHHHHHHHHHHHHHHHH"
    print hash
    return hash
  end

  def create
    @event = Event.new(event_paramsy)
    if params[:event][:place].
    pars = params;
    hash = to_hash pars[:event][:place]
    # devise_parameter_sanitizer.for(:event) do |u|
    #   u.permit(:place, :artist, :description, :price_low, :price_high, :event_date, :can_return, :of_age)
    # end
    event_paramsy = pars.require(:event).permit(:place, :artist, :description, :price_low, :price_high, :event_date, :can_return, :of_age).permit!()
    event_paramsy["place"] = hash
    event_paramsy["price_high"] = @prices.max
    event_paramsy["price_low"] = @prices.min
    
        print event_paramsy
        print "!!!!!!!!!!!!!"
      print @event
      print "end end end end end"
    end
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
    params.require(:event).permit(:artist, :description, :price_low, :price_high, :event_date, :can_return, :of_age, :place)
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
  helper_method :can_buy?  
end
