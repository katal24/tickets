class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update]

  # GET /tickets
  # GET /tickets.json
  def index
    if signed_in?
      if is_admin?
        @tickets = Ticket.all
      else
        @tickets = Ticket.where(user_id: current_user.id)
      end
      
        @users = []
        @events = []
        @tickets.each do |ticket|
          @users << get_user_by_id(ticket.user_id)
          @events << get_event_by_id(ticket.event_id)          
        end
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show

    if params[:filterTicket].present?
      @ticket = Ticket.find(params[:filterTicket][:nr])
    end

    @event = get_event_by_id(@ticket.event_id)
    @user = get_user_by_id(@ticket.user_id)
  end

  # GET /tickets/new
  def new
    @ticket = current_user.tickets.new
    @events = Event.all
  end

  # GET /tickets/1/edit
  def edit
    @ticket = current_user.tickets.find_by(id: params[:id])
    @events = Event.all    
  end

  # POST /tickets
  # POST /tickets.json
  def create
    if current_user && current_user.cash && current_user.cash >= params[:ticket][:price].to_f
      @ticket = current_user.tickets.create(ticket_params)
          @event = get_event_by_id(@ticket.event_id)
          seat = @ticket.seat_id_seq
          @event.place[seat[0]][2] << seat[1..3].to_i
          @event.save
          @ticket.save
          current_user.cash -= @ticket.price
          current_user.save
          print @ticket.price
          redirect_to @ticket, notice: 'Ticket was successfully created.'
      else 
        redirect_to request.referrer, notice: 'No money on the account.'
        # format.json { render :show, status: :created, location: @ticket }        
      end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @user = get_user_by_id(@ticket.user_id)
    @event = get_event_by_id(@ticket.event_id)

    seat = @ticket.seat_id_seq
    @event.place[seat[0]][2].delete(seat[1..3].to_i)
    @event.save

    @user.cash += count_return(@event.event_date, @ticket.price)
    @user.save

    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_user_by_id(id)
    User.find(id)    
  end

  def get_event_by_id(id)
    Event.find(id)    
  end

  def count_return(date, price)
    ret = 0;
    price = price.to_f
    date_period = Date.today - date

    if date_period < 1.days
      print "1 dzien"
      ret = 0.9*price
    end
    if date_period < 15.days
      print "15 dzien"      
      ret = 0.7*price
    end
    if 
      print "duzo dzien"
      ret = 0.4*price
    end
    return ret
  end

  def is_admin?
    signed_in? ? current_user.admin : false
  end

  def signed_in?
    !!current_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id]) if params[:id].present?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      # locale {
      #   print "*"
      #   print ticket.price

      # }
      print "****"
      print params[:ticket] if params[:ticket].present?
      print "**"
      
      params.require(:ticket).permit(:seat_id_seq, :price, :event_id, :user_id)
    end

    def correct_user
      @ticket = current_user.tickets.find_by(id: params[:id])
      redirect_to tickets_path, notice: "Nie jesteś uprawniony do edycji tego biletu" if @ticket.nil? && current_user.admin.nil?
    end

    helper_method :is_admin?
    helper_method :signed_in?
end
