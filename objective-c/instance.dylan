module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define C-mapped-subtype <objc/instance> (<C-statically-typed-pointer>)
  import-map <objc/instance>,
    import-function:
      method (address :: <objc/instance>) => (objc-instance :: <objc/instance>)
        objc/make-instance(address.pointer-address)
      end;
end;

define sealed method \=
    (instance1 :: <objc/instance>, instance2 :: <objc/instance>)
 => (equal? :: <boolean>)
  instance1.pointer-address = instance2.pointer-address
end;

define inline function objc/make-instance
    (raw-instance :: <machine-word>)
 => (objc-instance :: <objc/instance>)
  let raw-objc-class = objc/raw-instance-class(raw-instance);
  let shadow-class = objc/shadow-class-for(raw-objc-class);
  make(shadow-class, address: raw-instance)
end;

define function objc/instance-class (objc-instance :: <objc/instance>)
 => (objc-class :: <objc/class>)
  let raw-objc-class
    = primitive-wrap-machine-word
        (primitive-cast-pointer-as-raw
          (%call-c-function ("object_getClass")
                (objc-instance :: <raw-c-pointer>)
             => (objc-class :: <raw-c-pointer>)
              (primitive-unwrap-c-pointer(objc-instance))
           end));
  make(<objc/class>, address: raw-objc-class)
end;

define inline function objc/raw-instance-class (objc-instance :: <machine-word>)
 => (raw-objc-class :: <machine-word>)
  primitive-wrap-machine-word
    (primitive-cast-pointer-as-raw
      (%call-c-function ("object_getClass")
            (objc-instance :: <raw-c-pointer>)
         => (objc-class :: <raw-c-pointer>)
          (primitive-cast-raw-as-pointer
             (primitive-unwrap-machine-word(objc-instance)))
       end))
end;

define function objc/instance-class-name (objc-instance :: <objc/instance>)
 => (objc-class-name :: <string>)
   primitive-raw-as-string
      (%call-c-function ("object_getClassName")
            (objc-instance :: <raw-c-pointer>)
         => (name :: <raw-byte-string>)
          (primitive-unwrap-c-pointer(objc-instance))
       end)
end;

define generic objc/associated-object
    (objc-instance :: <objc/instance>, key)
 => (objc-instance :: <objc/instance>);

define inline method objc/associated-object
    (objc-instance :: <objc/instance>, key :: <string>)
 => (objc-instance :: <objc/instance>)
  objc/associated-object-inner(objc-instance,
                               primitive-wrap-machine-word
                                 (primitive-cast-pointer-as-raw
                                    (primitive-string-as-raw(key))))
end;

define method objc/associated-object
    (objc-instance :: <objc/instance>, key :: <machine-word>)
 => (objc-instance :: <objc/instance>)
  objc/associated-object-inner(objc-instance, key);
end;

define inline function objc/associated-object-inner
    (objc-instance :: <objc/instance>, key :: <machine-word>)
 => (objc-instance :: <objc/instance>)
  let raw-associated-object
    = primitive-wrap-machine-word
        (primitive-cast-pointer-as-raw
          (%call-c-function ("objc_getAssociatedObject")
                (objc-instance :: <raw-c-pointer>,
                 key :: <raw-machine-word>)
             => (associated-object :: <raw-c-pointer>)
              (primitive-unwrap-c-pointer(objc-instance),
               primitive-unwrap-machine-word(key))
           end));
  if (raw-associated-object ~= 0)
    objc/make-instance(raw-associated-object);
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
  objc/set-associated-object-inner(objc-instance,
                                   primitive-wrap-machine-word
                                     (primitive-cast-pointer-as-raw
                                        (primitive-string-as-raw(key))),
                                   value, association-policy);
end;

define method objc/set-associated-object
    (objc-instance :: <objc/instance>, key :: <machine-word>,
     value :: <objc/instance>, association-policy :: <integer>)
 => ()
  objc/set-associated-object-inner(objc-instance, key, value,
                                   association-policy);
end;

define inline function objc/set-associated-object-inner
    (objc-instance :: <objc/instance>, key :: <machine-word>,
     value :: <objc/instance>, association-policy :: <integer>)
 => ()
  %call-c-function ("objc_setAssociatedObject")
      (objc-instance :: <raw-c-pointer>,
       key :: <raw-c-pointer>,
       value :: <raw-c-pointer>,
       association-policy :: <raw-c-unsigned-int>)
   => (nothing :: <raw-c-void>)
    (primitive-unwrap-c-pointer(objc-instance),
     primitive-cast-raw-as-pointer(primitive-unwrap-machine-word(key)),
     primitive-unwrap-c-pointer(value),
     integer-as-raw(association-policy))
  end;
end;

define function objc/remove-associated-objects
    (objc-instance :: <objc/instance>)
 => ()
  %call-c-function ("objc_removeAssociatedObjects")
      (objc-instance :: <raw-c-pointer>)
   => (nothing :: <raw-c-void>)
    (primitive-unwrap-c-pointer(objc-instance))
  end;
end;
