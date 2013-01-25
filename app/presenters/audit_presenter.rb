class AuditPresenter
  attr_reader :audit

  def initialize(audit)
    raise TypeError unless audit.kind_of? Audited::Audit
    @audit = audit
  end

  def date
    @audit.created_at.to_date
  end

  def formatted_time
    @audit.created_at.strftime "%l:%I%P"
  end

  def user
    @user ||= User.find(@audit.user_id)
  end

  def action
    if @audit.audited_changes.keys == ["risk_level"]
      "#{@audit.action} risk level".titleize
    else
      "#{@audit.action} #{@audit.auditable_type}".titleize
    end
  end

  def details
    @audit.audited_changes.to_s
  end
end
