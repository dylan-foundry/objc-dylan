Module: cocoa-hello-world
Synopsis: Basic Cocoa bindings
Author:  Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define objc-selector @alloc
  parameter target :: <objc/class>;
  result obj :: <objc/instance>;
  selector: "alloc";
end;

define objc-selector @init
  parameter target :: <objc/instance>;
  result obj :: <objc/instance>;
  selector: "init";
end;

define objc-shadow-class <ns/notification> (<ns/object>) => NSNotification;

define objc-selector @applicationDidFinishLaunching/
  parameter target :: <objc/instance>;
  parameter notification :: <ns/notification>;
  selector: "applicationDidFinishLaunching:";
end;

ignore(%send-@applicationDidFinishLaunching/);

define objc-shadow-class <ns/responder> (<ns/object>) => NSResponder;
define objc-shadow-class <ns/application> (<ns/responder>) => NSApplication;

define objc-selector @shared-application
  parameter target :: <objc/class>;
  result application :: <ns/application>;
  selector: "sharedApplication";
end;

define objc-selector @set-delegate/
  parameter target :: <ns/application>;
  parameter delegate :: <ns/object>;
  selector: "setDelegate:";
end;

define objc-selector @run
  parameter target :: <ns/application>;
  selector: "run";
end;

