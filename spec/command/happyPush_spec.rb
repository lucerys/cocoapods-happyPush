require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Happypush do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ happyPush }).should.be.instance_of Command::Happypush
      end
    end
  end
end

