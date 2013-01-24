module: dylan-user

define library objc-test-suite
  use common-dylan;
  use objc;
  use testworks;

  export objc-test-suite;
end library;

define module objc-test-suite
  use common-dylan, exclude: { format-to-string };
  use objc;
  use testworks;

  export objc-test-suite;
end module;
