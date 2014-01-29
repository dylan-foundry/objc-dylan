module: objc
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <objc/class> (<object>)
  constant slot raw-class :: <machine-word>,
    required-init-keyword: class:;
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
    make(<objc/class>, class: raw-objc-class)
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
          (primitive-unwrap-machine-word(objc-class.raw-class))
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
      (primitive-unwrap-machine-word(objc-class.raw-class),
       primitive-unwrap-machine-word(selector.raw-selector))
    end);
end;

define function objc/instance-size (objc-class :: <objc/class>)
 => (objc-instance-size :: <integer>)
  raw-as-integer
      (%call-c-function ("class_getInstanceSize")
            (objc-class :: <raw-machine-word>)
         => (size :: <raw-machine-word>)
          (primitive-unwrap-machine-word(objc-class.raw-class))
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
           (primitive-unwrap-machine-word(objc-class.raw-class),
            primitive-unwrap-machine-word(selector.raw-selector))
         end);
  if (raw-method ~= 0)
    make(<objc/method>, method: raw-method)
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
           (primitive-unwrap-machine-word(objc-class.raw-class),
            primitive-unwrap-machine-word(selector.raw-selector))
         end);
  if (raw-method ~= 0)
    make(<objc/method>, method: raw-method)
  else
    #f
  end if
end;
