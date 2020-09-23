# frozen_string_literal: true

module ActionTracer
  module MonkeyPatches
    module AbstractController
      module Callbacks
        def process_action(*args)
          ActionTracer.returner.enable
          super
          ActionTracer.returner.disable
          ActionTracer.logging(self)
        end
      end
    end
  end
end
