module: objc
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <objc/instance> (<object>)
  constant slot raw-instance :: <machine-word>,
    required-init-keyword: instance:;
end;

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
