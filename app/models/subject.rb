class Subject < ApplicationRecord
  # de de test nen doan nay xu ly uniqueness, so cau hoi, so cau pass sau
  validates %i(name duration question_number score_pass), presence: true
  validates :description, length: {maximum: Settings.max_length}
  validates %i(duration question_number score_pass),
            numericality: {only_integer: true}
end
