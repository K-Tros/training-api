class Config < ApplicationRecord
	validates :description, presence: true, uniqueness: true
end
