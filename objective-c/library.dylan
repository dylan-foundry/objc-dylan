module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library objective-c
  use dylan;
  use common-dylan;
  use c-ffi;

  export objective-c;
end library;

define module objective-c
  use c-ffi, export: all;
  use dylan-direct-c-ffi, export: all;
  use common-dylan, exclude: { format-to-string };

  export <objc/class>,
         objc/get-class,
         objc/instance-size,
         objc/class-name,
         objc/class-responds-to-selector?,
         objc/get-class-method,
         objc/get-instance-method;

  export objc/register-shadow-class,
         objc/shadow-class-for;

  export <objc/selector>,
         objc/register-selector,
         objc/selector-name;

  export <objc/method>,
         objc/method-name;

  export <objc/instance>,
         <objc/instance-address>,
         objc/instance-class,
         objc/instance-class-name,
         objc/raw-instance-class,
         objc/make-instance,
         objc/associated-object,
         objc/set-associated-object,
         objc/remove-associated-objects;

  export $OBJC-ASSOCIATION-ASSIGN,
         $OBJC-ASSOCIATION-RETAIN-NONATOMIC,
         $OBJC-ASSOCIATION-COPY-NONATOMIC,
         $OBJC-ASSOCIATION-RETURN,
         $OBJC-ASSOCIATION-COPY;

  export \objc-shadow-class-definer,
         \objc-protocol-definer,
         \objc-msgsend;

  export <ns/object>,
         <<ns/object>>,
         $nil;
end module;
