# Represent the outcome of the method with a status object.

# actually there are 3 possible outcomes: true, false and error
def import_purchase(date, title, user_email)
  user = User.find_by_email(user_email)
  if user.purchased_titles.include?(title)
    false
  else
    purchase = user.purchases.create(title: title, purchased_at: date)
    true
  end
end

# let's model it as a status instead
class ImportStatus
  def self.success() new(:success) end
  def self.redundant() new(:redundant) end
  def self.failed(error) new(:failed, error) end

  attr_reader :error

  def initialize(status, error=nil)
    @status = status
    @error = error
  end

  def success?
    @status == :success
  end

  def redundant?
    @status == :redundant
  end

  def failed?
    @status == :error
  end
end

def import_purchase_using_status(date, title, user_email)
  begin
    user = User.find_by_email(user_email)
    if user.purchased_titles.include?(title)
      ImportStatus.redundant
    else
      purchase = user.purchases.create(title: title, purchased_at: date)
      ImportStatus.success
    end
  rescue => error
    ImportStatus.failed(error)
  end
end

# clearer and easier to work with at the call site:
def use_importer()
  result = import_purchase_using_status(date, title, user_email)
  if result.success?
    send_book_invitation_email(user_email, title)
  elsif result.redundant?
    logger.info("Skipped #{title} for #{user_email}")
  else
    logger.error("Error while importing #{title} for #{user_email}: #{result.error}")
  end
end