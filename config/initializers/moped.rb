module Moped
  def self.retry_connection(max_retries=3, &method_with_mongo)
    tries = 0
    begin
      method_with_mongo.call(self)
    rescue Moped::Errors::ConnectionFailure
      tries += 1

      tries < max_retries ? retry : raise
    end
  end
end

