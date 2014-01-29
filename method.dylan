module: objc
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <objc/method> (<object>)
  constant slot raw-method :: <machine-word>,
    required-init-keyword: method:;
end;

define function objc/method-name (objc-method :: <objc/method>)
 => (objc-method-selector :: <objc/selector>)
  let raw-objc-selector
    = primitive-wrap-machine-word
        (%call-c-function ("method_getName")
              (name :: <raw-machine-word>)
           => (object :: <raw-machine-word>)
            (primitive-unwrap-machine-word(objc-method.raw-method))
         end);
  make(<objc/selector>, selector: raw-objc-selector)
end;
