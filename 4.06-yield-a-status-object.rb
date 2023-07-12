# Represent the outcome of the method with a status object with callback-style methods, and yield that object to callers.

# this pattern is an extension of the last one
# but instead of returning an ImportStatus object, we yield one
class ImportStatus
  def self.success() new(:success) end
  def self.redundant() new(:redundant?) end
  def self.failed(error) new(:failed, error) end

  def initialize(status, error = nil)
    @status = status
    @error = error
  end

  def on_success
    yield if @status == :success
  end

  def on_redundant
    yield if @status == :redundant
  end

  def on_failed
    yield(error) if @status == :error
  end
end

def import_purchase(date, title, user_email)
  begin
    user = User.find_by_email(user_email)
    if user.purchased_titles.include?(title)
      yield ImportStatus.redundant
    else
      purchase = user.purchases.create(title: title, purchased_at: date)
      yield ImportStatus.success
    end
  rescue => error
    yield ImportStatus.failed(error)
  end
end

# and then the client code becomes a series of callbacks within a block

def use_import_purchase()
  import_purchase(date, title, user_email) do |result|
    result.on_success do
      send_book_invitation_email(user_email, title)
    end
    result.on_redundant do
      logger.info("Skipped #{title} for #{user}")
    end
    result.on_failed do |error|
      logger.error "Error importing #{title} for #{user_email}: #{error}"
    end
  end
end
