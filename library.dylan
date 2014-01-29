module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library objc
  use dylan;
  use common-dylan;

  export objc;
end library;

define module objc
  use dylan-direct-c-ffi, export: all;
  use common-dylan, exclude: { format-to-string };

  export <objc/class>,
         objc/get-class,
         objc/instance-size,
         objc/class-name,
         objc/class-responds-to-selector?,
         objc/get-class-method,
         objc/get-instance-method,
         raw-class;

  export <objc/selector>,
         objc/register-selector,
         objc/selector-name,
         raw-selector;

  export <objc/method>,
         objc/method-name,
         raw-method;

  export <objc/instance>,
         objc/instance-class,
         objc/instance-class-name,
         raw-instance;
end module;
