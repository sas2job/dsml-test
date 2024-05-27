class LeaveRequest < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :status, inclusion: { in: statuses.keys }

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :reason, presence: true

  def translated_status
    I18n.t("activerecord.attributes.leave_request.statuses.#{status}")
  end
end
