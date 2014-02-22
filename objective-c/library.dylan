module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library objective-c
  use dylan;
  use common-dylan;
  use c-ffi;
  use io;

  export objective-c;
end library;

define module objective-c
  use c-ffi, export: all;
  use dylan-direct-c-ffi, export: all;
  use common-dylan, exclude: { format-to-string };
  use format;
  use format-out;
  use print, import: { print-object };
  use streams;

  export <objc/class>,
         objc/get-class,
         objc/super-class,
         objc/instance-size,
         objc/class-name,
         objc/class-responds-to-selector?,
         objc/get-class-method,
         objc/get-instance-method;

  export objc/register-shadow-class,
         objc/shadow-class-for;

  export objc/allocate-class-pair,
         objc/register-class-pair,
         objc/add-method;

  export <objc/selector>,
         objc/register-selector,
         objc/selector-name;

  export <objc/method>,
         objc/method-name;

  export <objc/instance>,
         objc/instance-class,
         objc/instance-class-name,
         objc/make-instance,
         objc/associated-object,
         objc/set-associated-object,
         objc/remove-associated-objects;

  export $OBJC-ASSOCIATION-ASSIGN,
         $OBJC-ASSOCIATION-RETAIN-NONATOMIC,
         $OBJC-ASSOCIATION-COPY-NONATOMIC,
         $OBJC-ASSOCIATION-RETURN,
         $OBJC-ASSOCIATION-COPY;

  export <objc/protocol>,
         objc/get-protocol,
         objc/protocol-name,
         objc/conforms-to-protocol?,
         objc/add-protocol;

  export \objc-shadow-class-definer,
         \objc-class-definer,
         \objc-protocol-definer,
         \send;

  export <NSObject>,
         <<NSObject>>,
         $nil;
end module;
