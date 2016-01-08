Module: cocoa-open-window
Synopsis: Basic Cocoa bindings
Author:  Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define objc-selector @alloc
  parameter target :: <objc/class>;
  result obj :: <objc/instance>;
  selector: "alloc";
  type-encoding: "@#:";
end;

define objc-selector @init
  parameter target :: <objc/instance>;
  result obj :: <objc/instance>;
  selector: "init";
  type-encoding: "@@:";
end;

define objc-shadow-class <NSNotification> (<NSObject>) => NSNotification;

define objc-selector @applicationDidFinishLaunching/
  parameter target :: <objc/instance>;
  parameter notification :: <NSNotification>;
  selector: "applicationDidFinishLaunching:";
  type-encoding: "v@:@";
end;

ignore(%send-@applicationDidFinishLaunching/);

define objc-shadow-class <NSResponder> (<NSObject>) => NSResponder;
define objc-shadow-class <NSApplication> (<NSResponder>) => NSApplication;

define objc-selector @shared-application
  parameter target :: <objc/class>;
  result application :: <NSApplication>;
  selector: "sharedApplication";
  type-encoding: "@#:";
end;

define objc-selector @set-delegate/
  parameter target :: <NSApplication>;
  parameter delegate :: <NSObject>;
  selector: "setDelegate:";
  type-encoding: "v@:@";
end;

define objc-selector @run
  parameter target :: <NSApplication>;
  selector: "run";
  type-encoding: "v@:";
end;

define objc-shadow-class <NSWindow> (<NSResponder>) => NSWindow;

define objc-selector @make-key-and-order-front
  parameter target :: <NSWindow>;
  parameter sender :: <NSObject>;
  selector: "makeKeyAndOrderFront:";
  type-encoding: "v@:@";
end;
