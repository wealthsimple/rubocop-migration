module Egad
  CLI = Cri::Command.define do
    name "egad"
    summary "Identify common Ruby/Rails pitfalls in your code"

    run do |opts, args, cmd|
      if !opts.present? && !args.present?
        puts cmd.help
        exit 0
      end
    end
  end

  CLI.add_command Cri::Command.new_basic_help
end
