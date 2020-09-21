# frozen_string_literal: true

module ActionTracer
  module MonkeyPatches
    module AbstractController
      module Base
        def process(action, *args)
          ActionTracer.returner.enable
          super
          ActionTracer.returner.disable
        end
      end
    end
  end
end
