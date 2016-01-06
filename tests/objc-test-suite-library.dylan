module: dylan-user

define library objc-test-suite
  use common-dylan;
  use objective-c;
  use testworks;
  use io;

  export objc-test-suite;
end library;

define module objc-test-suite
  use common-dylan;
  use objective-c;
  use testworks;
  use format;
  use streams;

  export objc-test-suite;
end module;
