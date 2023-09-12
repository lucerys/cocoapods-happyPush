
$_options_ = Pod::Command::Repo::Push.options

module CocoaPodsDisablePodspecValidations
  module PushCommandMixin

    push_command_class = Pod::Command::Repo::Push

    def push_command_class.options
      [
        ['--skip-podspec-validation', 'HappyPush: Lint skips validating the podspec'],
      ].concat($_options_)
    end

    methods_to_override = push_command_class.instance_methods + push_command_class.private_instance_methods
    methods_to_override.each do |method_name|
      if method_name.to_s == "initialize"
        define_method(method_name) do |*args, &blk|
          first_arg = args[0]
          @skip_podspec_validation = first_arg.flag?('skip-podspec-validation', false)
          super(*args, &blk)
        end
      end

      if method_name.to_s == "validate_podspec_files"
        define_method(method_name) do |*args, &blk|
          Pod::UI.puts "HappyPush: skip podspec validation." if @skip_podspec_validation
          super(*args, &blk) unless @skip_podspec_validation
        end
      end
    end


  end
end

module Pod
  class Command
    class Repo < Command
      class Push < Repo
        prepend ::CocoaPodsDisablePodspecValidations::PushCommandMixin
      end
    end
  end
end
