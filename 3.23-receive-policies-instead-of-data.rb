# Receive a block or Proc which will determine the policy for that edge case.

require 'fileutils'

# problems with this function:
# - it's dominated by handling of edge cases
# - (true, true) is not obvious from the call site
# - rigid: what if we wanted to log a special format?
# main culprit: it tries to specify policies using data; it should use behaviour instead
def delete_files_data(files, ignore_errors=false, log_errors=false)
  files.each do |file|
    begin
      File.delete(file)
    rescue => error
      puts error.message if log_errors
      raise unless ignore_errors
    end
  end
end

def use_delete_files_data()
  FileUtils.touch 'does_exist'
  delete_files_data(['does_not_exist', 'does_exist'], true, true)
end

use_delete_files_data()

# advantages with this function:
# - flexible, decouples error handling from implementation
def delete_files_policy(files)
  files.each do |file|
    begin
      File.delete(file)
    rescue => error
      if block_given? then yield(file, error) else raise end
    end
  end
end

def use_delete_files_policy()
  FileUtils.touch 'does_exist'
  delete_files_policy(['does_not_exist', 'does_exist']) do |file, error|
    puts error.message
  end
end

use_delete_files_policy()

# this version explicitly defines the block
# works quite well as long as we have one policy
def delete_files_policy_refactored(files, &error_policy)
  error_policy ||= ->(file, error) { raise error }
  files.each do |file|
    begin
      File.delete(file)
    rescue => error
      error_policy.call(file, error)
    end
  end
end

# having multiple Proc arguments is rather uncommon in Ruby
def delete_files_policy_hash(files, options = {})
  error_policy = options.fetch(:on_error) { ->(file, error) { raise error }}
  symlink_policy = options.fetch(:on_symlink) { ->(file, error) { File.delete(file) } }
  files.each do |file|
    begin
      if File.symlink?(file)
        symlink_policy.call(file)
      else
        File.delete(file)
      end
    rescue => error
      error_policy.call(file, error)
    end
  end
end

def use_delete_files_policy_hash()
  FileUtils.touch 'does_exist'
  delete_files_policy_hash(
    ['does_not_exist', 'does_exist'],
    on_error: ->(file, error) { warn error.message },
    on_symlink: ->(file) { File.delete(File.realpath(file)) }
  )
end

use_delete_files_policy_hash()

