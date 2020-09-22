# frozen_string_literal: true

module ActionTracer
  module MonkeyPatches
    module AbstractController
      module Base
        private

        # Monkey patch to log filters
        def process_action(action, *args)
          super.tap { ActionTracer.logging(self) }
        end
      end
    end
  end
end
