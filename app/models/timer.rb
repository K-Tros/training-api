class Timer < ApplicationRecord
	validates :identifier, length: { is: 15 }, null: false, uniqueness: true
end
