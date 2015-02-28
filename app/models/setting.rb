class Setting < ActiveRecord::Base
  belongs_to :tunable, polymorphic: true
end
