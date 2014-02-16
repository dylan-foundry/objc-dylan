module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define constant $shadow-class-registry :: <table> = make(<table>);
define constant $class-registry :: <table> = make(<table>);

define C-subtype <objc/class> (<C-statically-typed-pointer>)
end;

define inline function as-raw-class (objc-class :: <objc/class>)
  primitive-unwrap-c-pointer(objc-class)
end;

define sealed method \=
    (class1 :: <objc/class>, class2 :: <objc/class>)
 => (equal? :: <boolean>)
  class1.pointer-address = class2.pointer-address
end;

define sideways method print-object
    (c :: <objc/class>, stream :: <stream>)
 => ()
  format(stream, "{<objc/class> %s}", objc/class-name(c));
end;

define function objc/register-shadow-class
    (objc-class :: <objc/class>, shadow-class :: subclass(<objc/instance>))
 => ()
  $shadow-class-registry[objc-class.pointer-address] := shadow-class;
  $class-registry[shadow-class] := objc-class;
end;

define function objc/shadow-class-for
    (raw-objc-class :: <machine-word>)
 => (shadow-class :: subclass(<objc/instance>))
  $shadow-class-registry[raw-objc-class]
end;

define function objc/class-for-shadow
    (shadow-class :: subclass(<objc/instance>))
 => (objc-class :: <objc/class>)
  $class-registry[shadow-class]
end;

define function objc/get-class (name :: <string>)
 => (objc-class :: false-or(<objc/class>))
  let raw-objc-class
    = primitive-wrap-machine-word
        (%call-c-function ("objc_getClass")
              (name :: <raw-byte-string>)
           => (object :: <raw-machine-word>)
            (primitive-string-as-raw(name))
         end);
  if (raw-objc-class ~= 0)
    make(<objc/class>, address: raw-objc-class)
  else
    #f
  end if
end;

define function objc/class-name (objc-class :: <objc/class>)
 => (objc-class-name :: <string>)
  primitive-raw-as-string
      (%call-c-function ("class_getName")
            (objc-class :: <raw-machine-word>)
         => (name :: <raw-byte-string>)
          (objc-class.as-raw-class)
       end)
end;

define function objc/class-responds-to-selector?
    (objc-class :: <objc/class>, selector :: <objc/selector>)
 => (well? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("class_respondsToSelector")
        (objc-class :: <raw-machine-word>,
         selector :: <raw-machine-word>)
     => (well? :: <raw-boolean>)
      (objc-class.as-raw-class,
       selector.as-raw-selector)
    end);
end;

define function objc/instance-size (objc-class :: <objc/class>)
 => (objc-instance-size :: <integer>)
  raw-as-integer
      (%call-c-function ("class_getInstanceSize")
            (objc-class :: <raw-machine-word>)
         => (size :: <raw-machine-word>)
          (objc-class.as-raw-class)
       end)
end;

define function objc/get-class-method
    (objc-class :: <objc/class>, selector :: <objc/selector>)
 => (method? :: false-or(<objc/method>))
  let raw-method
    = primitive-wrap-machine-word
        (%call-c-function ("class_getClassMethod")
             (objc-class :: <raw-machine-word>,
              selector :: <raw-machine-word>)
          => (method? :: <raw-machine-word>)
           (objc-class.as-raw-class,
            selector.as-raw-selector)
         end);
  if (raw-method ~= 0)
    make(<objc/method>, address: raw-method)
  else
    #f
  end if
end;

define function objc/get-instance-method
    (objc-class :: <objc/class>, selector :: <objc/selector>)
 => (method? :: false-or(<objc/method>))
  let raw-method
    = primitive-wrap-machine-word
        (%call-c-function ("class_getInstanceMethod")
             (objc-class :: <raw-machine-word>,
              selector :: <raw-machine-word>)
          => (method? :: <raw-machine-word>)
           (objc-class.as-raw-class,
            selector.as-raw-selector)
         end);
  if (raw-method ~= 0)
    make(<objc/method>, address: raw-method)
  else
    #f
  end if
end;

define function objc/allocate-class-pair
    (super-class :: subclass(<objc/instance>),
     class-name :: <string>)
 => (objc-class :: <objc/class>)
  let super-class = objc/class-for-shadow(super-class);
  let raw-class
    = primitive-wrap-machine-word
        (%call-c-function ("objc_allocateClassPair")
             (super-class :: <raw-machine-word>,
              class-name :: <raw-byte-string>,
              extra-bytes :: <raw-machine-word>)
          => (objc-class :: <raw-machine-word>)
           (super-class.as-raw-class,
            primitive-string-as-raw(class-name),
            integer-as-raw(0))
         end);
  make(<objc/class>, address: raw-class)
end;

define function objc/register-class-pair
    (objc-class :: <objc/class>)
 => ()
  %call-c-function ("objc_registerClassPair")
      (objc-class :: <raw-machine-word>)
   => (nothing :: <raw-c-void>)
    (objc-class.as-raw-class)
  end;
end;

define function objc/add-method
    (objc-class :: <objc/class>,
     selector :: <objc/selector>,
     implementation :: <c-function-pointer>,
     types :: <string>)
 => (added? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("class_addMethod")
         (objc-class :: <raw-machine-word>,
          selector :: <raw-machine-word>,
          implementation :: <raw-machine-word>,
          types :: <raw-byte-string>)
      => (added? :: <raw-boolean>)
       (objc-class.as-raw-class,
        selector.as-raw-selector,
        primitive-unwrap-c-pointer(implementation),
        primitive-string-as-raw(types))
     end)
end;
