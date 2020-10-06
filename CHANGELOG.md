## 0.2.1

* Fix not to raise error when controllers does not have action definitions.

## 0.2.0

* Stop using TracePoint and just override ActiveSupport::Callbacks::CallTemplate
We don't necessary passing environment variable anymore!
