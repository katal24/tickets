class EventDateValidator < ActiveModel::Validator
    def validate(record)
      if !record.event_date
        record.errors.add(:event_date, "Event date can't be empty")
      elsif record.event_date < Date.today
        record.errors.add(:event_date, "Event date can't be in past")
      end
    end
  end