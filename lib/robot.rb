class Robot
  
  def self.five_minutely
  end
  
  def self.hourly
  end
  
  def self.daily
  end
  
  def self.weekly
  end
  
  def self.monthly
  end
  
  def self.logger
    @logger ||= Logger.new "#{RAILS_ROOT}/log/robot.log"
  end
  
  def self.perform(msg)
    logger.info "[#{Time.now}] Performing task: #{msg}"
    yield
    logger.info "[#{Time.now}] Completed task: #{msg}"
  rescue Exception => err
    logger.error "ERROR while #{msg}: #{err}\n#{err.backtrace.join('\n')}"
  end
end