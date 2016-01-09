module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define C-subtype <objc/selector> (<C-statically-typed-pointer>)
  constant slot selector-type-encoding :: <string> = "",
    init-keyword: encoding:;
end;

define sideways method print-object
    (s :: <objc/selector>, stream :: <stream>)
 => ()
  format(stream, "{<objc/selector> %s}", objc/selector-name(s));
end;

define function objc/register-selector
    (name :: <string>, encoding :: <string>)
 => (objc-selector :: <objc/selector>)
  let raw-objc-selector
    = primitive-wrap-machine-word
        (primitive-cast-pointer-as-raw
          (%call-c-function ("sel_registerName")
                (name :: <raw-byte-string>)
             => (object :: <raw-c-pointer>)
                (primitive-string-as-raw(name))
           end));
  make(<objc/selector>, encoding: encoding, address: raw-objc-selector)
end;

define function objc/selector-name (objc-selector :: <objc/selector>)
 => (selector-name :: <string>)
  primitive-raw-as-string
      (%call-c-function ("sel_getName")
            (objc-selector :: <raw-c-pointer>)
         => (name :: <raw-byte-string>)
          (primitive-unwrap-c-pointer(objc-selector))
       end)
end;

define sealed method \=
    (sel1 :: <objc/selector>, sel2 :: <objc/selector>)
 => (equal? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("sel_isEqual")
        (sel1 :: <raw-c-pointer>,
         sel2 :: <raw-c-pointer>)
     => (equal? :: <raw-boolean>)
      (primitive-unwrap-c-pointer(sel1),
       primitive-unwrap-c-pointer(sel2))
    end)
end;
