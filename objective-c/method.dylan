module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define C-subtype <objc/method> (<C-statically-typed-pointer>)
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
        (primitive-cast-pointer-as-raw
          (%call-c-function ("method_getName")
                (raw-method :: <raw-c-pointer>)
             => (name :: <raw-c-pointer>)
              (primitive-unwrap-c-pointer(objc-method))
           end));
  let type-encoding
    = primitive-raw-as-string
        (%call-c-function ("method_getTypeEncoding")
              (raw-method :: <raw-c-pointer>)
           => (encoding :: <raw-byte-string>)
            (primitive-unwrap-c-pointer(objc-method))
         end);
  make(<objc/selector>,
       address: raw-objc-selector,
       encoding: type-encoding)
end;
