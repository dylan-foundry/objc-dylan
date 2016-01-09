module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define C-subtype <objc/selector> (<C-statically-typed-pointer>)
  constant slot selector-type-encoding :: <string> = "",
    init-keyword: encoding:;
end;

define inline function as-raw-selector (objc-selector :: <objc/selector>)
  primitive-unwrap-c-pointer(objc-selector)
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
        (%call-c-function ("sel_registerName")
              (name :: <raw-byte-string>)
           => (object :: <raw-machine-word>)
            (primitive-string-as-raw(name))
         end);
  make(<objc/selector>, encoding: encoding, address: raw-objc-selector)
end;

define function objc/selector-name (objc-selector :: <objc/selector>)
 => (selector-name :: <string>)
  primitive-raw-as-string
      (%call-c-function ("sel_getName")
            (objc-selector :: <raw-machine-word>)
         => (name :: <raw-byte-string>)
          (objc-selector.as-raw-selector)
       end)
end;

define sealed method \=
    (sel1 :: <objc/selector>, sel2 :: <objc/selector>)
 => (equal? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("sel_isEqual")
        (sel1 :: <raw-machine-word>,
         sel2 :: <raw-machine-word>)
     => (equal? :: <raw-boolean>)
      (sel1.as-raw-selector, sel2.as-raw-selector)
    end)
end;
