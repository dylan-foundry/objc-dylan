module: objc
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <objc/instance> (<object>)
  constant slot raw-instance :: <machine-word>,
    required-init-keyword: instance:;
end;

define sealed method \=
    (instance1 :: <objc/instance>, instance2 :: <objc/instance>)
 => (equal? :: <boolean>)
  instance1.raw-instance = instance2.raw-instance
end;

define constant $nil = make(<objc/instance>,
                            instance: as(<machine-word>, 0));

define function objc/instance-class (objc-instance :: <objc/instance>)
 => (objc-class :: <objc/class>)
  let raw-objc-class
    = primitive-wrap-machine-word
        (%call-c-function ("object_getClass")
              (name :: <raw-machine-word>)
           => (object :: <raw-machine-word>)
            (primitive-unwrap-machine-word(objc-instance.raw-instance))
         end);
  make(<objc/class>, class: raw-objc-class)
end;

define function objc/instance-class-name (objc-instance :: <objc/instance>)
 => (objc-class-name :: <string>)
   primitive-raw-as-string
      (%call-c-function ("object_getClassName")
            (name :: <raw-machine-word>)
         => (object :: <raw-machine-word>)
          (primitive-unwrap-machine-word(objc-instance.raw-instance))
       end);
end;

define generic objc/associated-object
    (objc-instance :: <objc/instance>, key)
 => (objc-instance :: <objc/instance>);

define inline method objc/associated-object
    (objc-instance :: <objc/instance>, key :: <string>)
 => (objc-instance :: <objc/instance>)
  objc/associated-object(objc-instance,
                         primitive-wrap-machine-word(primitive-string-as-raw(key)))
end;

define method objc/associated-object
    (objc-instance :: <objc/instance>, key :: <machine-word>)
 => (objc-instance :: <objc/instance>)
  let raw-associated-object
    = primitive-wrap-machine-word
        (%call-c-function ("objc_getAssociatedObject")
              (objc-instance :: <raw-machine-word>,
               key :: <raw-machine-word>)
           => (associated-object :: <raw-machine-word>)
            (primitive-unwrap-machine-word(objc-instance.raw-instance),
             primitive-unwrap-machine-word(key))
         end);
  if (raw-associated-object ~= 0)
    make(<objc/instance>, instance: raw-associated-object)
  else
    $nil
  end if;
end;

define constant $OBJC-ASSOCIATION-ASSIGN = 0;
define constant $OBJC-ASSOCIATION-RETAIN-NONATOMIC = 1;
define constant $OBJC-ASSOCIATION-COPY-NONATOMIC = 3;
define constant $OBJC-ASSOCIATION-RETURN = #o1401;
define constant $OBJC-ASSOCIATION-COPY = #o1403;

define generic objc/set-associated-object
    (objc-instance :: <objc/instance>, key,
     value :: <objc/instance>, association-policy :: <integer>)
 => ();

define inline method objc/set-associated-object
    (objc-instance :: <objc/instance>, key :: <string>,
     value :: <objc/instance>, association-policy :: <integer>)
 => ()
  objc/set-associated-object(objc-instance,
                             primitive-wrap-machine-word(primitive-string-as-raw(key)),
                             value, association-policy);
end;

define method objc/set-associated-object
    (objc-instance :: <objc/instance>, key :: <machine-word>,
     value :: <objc/instance>, association-policy :: <integer>)
 => ()
  %call-c-function ("objc_setAssociatedObject")
      (objc-instance :: <raw-machine-word>,
       key :: <raw-machine-word>, value :: <raw-machine-word>,
       association-policy :: <raw-c-unsigned-int>)
   => (nothing :: <raw-c-void>)
    (primitive-unwrap-machine-word(objc-instance.raw-instance),
     primitive-unwrap-machine-word(key),
     primitive-unwrap-machine-word(value.raw-instance),
     integer-as-raw(association-policy))
  end;
end;

define function objc/remove-associated-objects
    (objc-instance :: <objc/instance>)
 => ()
  %call-c-function ("objc_removeAssociatedObjects")
      (objc-instance :: <raw-machine-word>)
   => (nothing :: <raw-c-void>)
    (primitive-unwrap-machine-word(objc-instance.raw-instance))
  end;
end;
