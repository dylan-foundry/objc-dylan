module: objc-test-suite
synopsis: Test suite for the objc library.

define test objc-class-test ()
  check-equal("Can get NSObject class",
              objc/class-name(objc/get-class("NSObject")),
              "NSObject");
  check-false("Can't get invalid class",
              objc/get-class("Does Not Exist"));
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
  check-false("Different selectors are not equal", sel1 = sel2);
end test objc-selector-equal-test;

define test objc-responds-to-test ()
  let ns-object = objc/get-class("NSObject");
  check-true("NSObject responds to description",
             objc/class-responds-to-selector?(ns-object, objc/register-selector("description")));
  check-false("NSObject doesn't responds to allocFoobar",
              objc/class-responds-to-selector?(ns-object, objc/register-selector("allocFoobar")));
end test objc-responds-to-test;

define test objc-get-class-method-test ()
  let ns-object = objc/get-class("NSObject");
  let description-SEL = objc/register-selector("description");
  let description-method = objc/get-class-method(ns-object, description-SEL);
  check-equal("NSObject has a class method 'description'",
              objc/method-name(description-method), description-SEL);
  let bad-method-SEL = objc/register-selector("allocFoobar");
  check-false("NSObject doesn't have a class method 'allocFoobar'",
              objc/get-class-method(ns-object, bad-method-SEL));
end test objc-get-class-method-test;

define test objc-get-instance-method-test ()
  let ns-object = objc/get-class("NSObject");
  let description-SEL = objc/register-selector("description");
  let description-method = objc/get-instance-method(ns-object, description-SEL);
  check-equal("NSObject has an instance method 'description'",
              objc/method-name(description-method), description-SEL);
  let bad-method-SEL = objc/register-selector("allocFoobar");
  check-false("NSObject doesn't have an instance method 'allocFoobar'",
              objc/get-instance-method(ns-object, bad-method-SEL));
end test objc-get-instance-method-test;


define function alloc-nsobject () => (objc-instance :: <objc/instance>)
  let ns-object = objc/get-class("NSObject");
  let alloc-selector = objc/register-selector("alloc");
  let raw-instance
    = primitive-wrap-machine-word
        (%objc-msgsend (ns-object.as-raw-class, alloc-selector.as-raw-selector)
             ()
          => (obj :: <raw-machine-word>)
           ()
         end);
  objc/make-instance(raw-instance)
end;

define test objc-alloc-test ()
  let objc-instance = alloc-nsobject();
  check-true("Newly created object is an instance of <ns/object>",
             instance?(objc-instance, <ns/object>));
end test objc-alloc-test;

define test objc-msgsend-test ()
  let objc-instance = alloc-nsobject();
  let rcs = objc/register-selector("retainCount");
  let rc
    = raw-as-integer
        (%objc-msgsend (objc-instance.as-raw-instance, rcs.as-raw-selector)
             ()
          => (count :: <raw-c-signed-int>)
          ()
         end);
  check-equal("Newly created object has a retain count of 1",
              rc, 1);
end test objc-msgsend-test;

define test objc-instance-class-test ()
  let objc-instance = alloc-nsobject();
  let class-name = objc/class-name(objc/instance-class(objc-instance));
  check-equal("Newly created object has the correct class",
              class-name, "NSObject");
end test objc-instance-class-test;

define test objc-instance-class-name-test ()
  let objc-instance = alloc-nsobject();
  check-equal("Newly created object has the correct class name",
              objc/instance-class-name(objc-instance), "NSObject");
end test objc-instance-class-name-test;

define test objc-associated-objects-test ()
  let objc-instance = alloc-nsobject();
  check-equal("Newly created object hasn't got associated object",
              objc/associated-object(objc-instance, "foobar"), $nil);
  objc/set-associated-object(objc-instance, "foobar", objc-instance, $OBJC-ASSOCIATION-ASSIGN);
  check-equal("Adding an associated object works",
              objc/associated-object(objc-instance, "foobar"), objc-instance);
  objc/remove-associated-objects(objc-instance);
  check-equal("Removing associated objects works",
              objc/associated-object(objc-instance, "foobar"), $nil);
end test objc-associated-objects-test;

define suite objc-test-suite ()
  test objc-class-test;
  test objc-class-instance-size-test;
  test objc-selector-test;
  test objc-selector-equal-test;
  test objc-responds-to-test;
  test objc-get-class-method-test;
  test objc-get-instance-method-test;
  test objc-alloc-test;
  test objc-msgsend-test;
  test objc-instance-class-test;
  test objc-instance-class-name-test;
  test objc-associated-objects-test;
end suite;
