module: objc
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <objc/class> (<object>)
  constant slot raw-class :: <machine-word>,
    required-init-keyword: class:;
end;

define class <objc/selector> (<object>)
  constant slot raw-selector :: <machine-word>,
    required-init-keyword: selector:;
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
  make(<objc/class>, class: raw-objc-class)
end;

define function objc/class-name (objc-class :: <objc/class>)
  primitive-raw-as-string
      (%call-c-function ("class_getName")
            (objc-class :: <raw-machine-word>)
         => (name :: <raw-byte-string>)
          (primitive-unwrap-machine-word(objc-class.raw-class))
       end)
end;

define function objc/register-selector (name :: <string>)
 => (objc-selector :: <objc/selector>)
  let raw-objc-selector
    = primitive-wrap-machine-word
        (%call-c-function ("sel_registerName")
              (name :: <raw-byte-string>)
           => (object :: <raw-machine-word>)
            (primitive-string-as-raw(name))
         end);
  make(<objc/selector>, selector: raw-objc-selector)
end;

define function objc/selector-name (objc-selector :: <objc/selector>)
  primitive-raw-as-string
      (%call-c-function ("sel_getName")
            (objc-class :: <raw-machine-word>)
         => (name :: <raw-byte-string>)
          (primitive-unwrap-machine-word(objc-selector.raw-selector))
       end)
end;
