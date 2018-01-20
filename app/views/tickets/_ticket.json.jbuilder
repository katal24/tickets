json.extract! ticket, :id, :name, :seat_id_seq, :address, :price, :email_address, :event_id, :ticket, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
