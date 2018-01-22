class BirthValidator < ActiveModel::Validator
    def validate(record)
      if record.birth > Date.today
        record.errors.add(:birth, "Data musi być z przeszłości")
      end
    end
  end