class Timer < ApplicationRecord
	validates :identifier, length: { is: 15 }, null: false, uniqueness: true, format: { without: /\H/,
		message: "only allow hexadecimal values" }
end
