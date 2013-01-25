module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library objc
  use dylan;
  use common-dylan;

  export objc;
end library;

define module objc
  use dylan-direct-c-ffi;
  use common-dylan, exclude: { format-to-string };

  export <objc/class>,
         objc/get-class,
         objc/class-name,
         objc/class-responds-to-selector;

  export <objc/selector>,
         objc/register-selector,
         objc/selector-name;
end module;