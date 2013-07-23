require 'rspec'

describe '#failed_attempts' do

  it 'should return 0 if failed_attempts is nil' do
    user_no_failed_attempts = User.new
    user_no_failed_attempts['failed_attempts'].should be_nil
    user_no_failed_attempts.failed_attempts.should == 0
  end
end