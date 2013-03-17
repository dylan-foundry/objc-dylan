module: objc-test-suite
synopsis: Test suite for the objc library.

define suite objc-test-suite ()
  test objc-class-test;
  test objc-class-instance-size-test;
  test objc-selector-test;
  test objc-selector-equal-test;
  test objc-responds-to-test;
end suite;

define test objc-class-test ()
  check-equal("Can get NSObject class",
              objc/class-name(objc/get-class("NSObject")),
              "NSObject");
end test objc-class-test;

define test objc-class-instance-size-test ()
  check-true("Can get NSObject class instance size",
              objc/instance-size(objc/get-class("NSObject")) > 0);
end test objc-class-instance-size-test;

define test objc-selector-test ()
  check-equal("Can register selector",
              objc/selector-name(objc/register-selector("alloc")),
              "alloc");
end test objc-selector-test;

define test objc-selector-equal-test ()
  let sel1 = objc/register-selector("hello");
  let sel2 = objc/register-selector("world");
  let sel3 = objc/register-selector("hello");
  check-true("Same selectors are equal", sel1 = sel1);
  check-true("Same, but created separately, selectors are equal", sel1 = sel3);
  check-false("Different selects are not equal", sel1 = sel2);
end test objc-selector-equal-test;

define test objc-responds-to-test ()
  let ns-object = objc/get-class("NSObject");
  check-true("NSObject responds to description",
             objc/class-responds-to-selector(ns-object, objc/register-selector("description")));
  check-false("NSObject doesn't responds to allocFoobar",
              objc/class-responds-to-selector(ns-object, objc/register-selector("allocFoobar")));
end test objc-responds-to-test;

/*
Do something with this soon ...

define function alloc-test ()
  let c = objc/get-class("NSObject");
  let s = objc/register-selector("alloc");
  let o
    = primitive-wrap-machine-word
        (%call-c-function("objc_msgSend")
              (id :: <raw-machine-word>, sel :: <raw-machine-word>)
           => (obj :: <raw-machine-word>)
            (primitive-unwrap-machine-word(c.raw-class),
             primitive-unwrap-machine-word(s.raw-selector))
        end);
  o
end;

*/
