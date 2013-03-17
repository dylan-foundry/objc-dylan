module: objc
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <objc/selector> (<object>)
  constant slot raw-selector :: <machine-word>,
    required-init-keyword: selector:;
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
