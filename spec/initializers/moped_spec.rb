require 'spec_helper'

describe Moped do
  describe '#retry_connection' do
    let(:block) { lambda {} }

    it 'should retry block up to 3 failed attempts due to Moped::Errors::ConnectionFailure' do
      block.stub(:call).and_raise(Moped::Errors::ConnectionFailure)
      block.should_receive(:call).exactly(3).times
      begin
        Moped.retry_connection(&block)
      rescue Moped::Errors::ConnectionFailure
      end
    end

    it 'should retry block up to a given number of Moped::Errors::ConnectionFailure' do
      block.stub(:call).and_raise(Moped::Errors::ConnectionFailure)
      block.should_receive(:call).exactly(4).times
      begin
        Moped.retry_connection(4, &block)
      rescue Moped::Errors::ConnectionFailure
      end
    end
  end
end

