class LeaveRequest < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :status, inclusion: { in: statuses.keys }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :reason, presence: true
  validate :end_date_cannot_be_before_start_date

  def translated_status
    I18n.t("activerecord.attributes.leave_request.statuses.#{status}")
  end

  private

  def end_date_cannot_be_before_start_date
    return if start_date.blank? || end_date.blank?

    return unless end_date < start_date

    errors.add(:end_date,
               I18n.t('activerecord.errors.models.leave_request.attributes.end_date.cannot_be_before_start_date'))
  end
end
