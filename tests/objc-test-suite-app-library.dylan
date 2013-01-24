module: dylan-user

define library objc-test-suite-app
  use testworks;
  use objc-test-suite;
end library;

define module objc-test-suite-app
  use testworks;
  use objc-test-suite;
end module;
