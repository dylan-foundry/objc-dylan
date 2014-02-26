module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define C-subtype <objc/method> (<C-statically-typed-pointer>)
end;

define inline function as-raw-method (objc-method :: <objc/method>)
  primitive-unwrap-c-pointer(objc-method)
end;

define sealed method \=
    (method1 :: <objc/method>, method2 :: <objc/method>)
 => (equal? :: <boolean>)
  method1.pointer-address = method2.pointer-address
end;

define function objc/method-name (objc-method :: <objc/method>)
 => (objc-method-selector :: <objc/selector>)
  let raw-objc-selector
    = primitive-wrap-machine-word
        (%call-c-function ("method_getName")
              (raw-method :: <raw-machine-word>)
           => (name :: <raw-machine-word>)
            (objc-method.as-raw-method)
         end);
  let type-encoding
    = primitive-raw-as-string
        (%call-c-function ("method_getTypeEncoding")
              (raw-method :: <raw-machine-word>)
           => (encoding :: <raw-machine-word>)
            (objc-method.as-raw-method)
         end);
  make(<objc/selector>,
       address: raw-objc-selector,
       encoding: type-encoding)
end;
