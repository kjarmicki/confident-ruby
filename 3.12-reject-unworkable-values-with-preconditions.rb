# Reject unacceptable values early, using precondition clauses.

require 'date'

class Employee
  attr_accessor :name
  attr_reader :hire_date

  def initialize(name, hire_date)
    @name = name,
    self.hire_date = hire_date
  end

  # here precondition is just a glorified setter, it guards the invariants of the object
  def hire_date=(new_hire_date)
    raise TypeError, "Invalid hire date" unless new_hire_date.is_a?(Date)
    @hire_date = new_hire_date
  end

  def due_for_tie_pin?
    raise "Missing hire date!" unless hire_date
    ((Date.today - hire_date) / 365).to_i >= 10
  end

  def covered_by_pension_plan?
    ((hire_date&.year) || 2000) < 2000
  end

  def bio
    if hire_date
      "#{name} has been a Yoyodyne employee since #{hire_date.year}"
    else
      "#{name} is a proud Yoyodyne employee"
    end
  end
end
