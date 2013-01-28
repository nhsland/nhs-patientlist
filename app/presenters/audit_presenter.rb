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
    case @audit.auditable_type
      when "Membership"
        membership_output
      when "ToDoItem"
        to_do_item_output
      else
        ""
    end
  end

  private
  def to_do_item_output
    if @audit.action == 'create'
      created_to_do_item_output
    else
      if @audit.audited_changes.keys == ["state"]
        updated_to_do_item_output
      else
        handed_over_to_do_item_output
      end
    end
  end

  def created_to_do_item_output
    "To do item #{@audit.audited_changes['description']} created"
  end

  def updated_to_do_item_output
    "State changed from #{@audit.audited_changes['state'][0]} to #{@audit.audited_changes['state'][1]}"
  end

  def handed_over_to_do_item_output
    to_do_item = ToDoItem.unscoped.find(@audit.auditable_id)
    patient_list = PatientList.find(@audit.audited_changes['patient_list_id'][1])
    "#{to_do_item.description} handed over to patient list: #{patient_list.name}"
  end

  def membership_output
    if @audit.action == 'create'
      created_membership_output
    elsif @audit.action == 'update'
      updated_risk_level_output
    else
      destroyed_membership_output
    end
  end

  def created_membership_output
    patient_list = PatientList.find(@audit.audited_changes['patient_list_id'])
    "Added to patient list: #{patient_list.name}"
  end

  def updated_risk_level_output
    "Risk level changed from #{@audit.audited_changes['risk_level'][0]} to #{@audit.audited_changes['risk_level'][1]}"
  end

  def destroyed_membership_output
    patient_list = PatientList.find(@audit.audited_changes['patient_list_id'])
    "Removed from patient list: #{patient_list.name}"
  end
end
