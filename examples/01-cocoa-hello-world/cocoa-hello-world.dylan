Module: cocoa-hello-world
Synopsis: 
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define function finished-launching (self, cmd, notification)
  format-out("Hello, world!\n");
  force-out();
  exit-application(0);
end;

define C-callable-wrapper finished-launching-c-wrapper of finished-launching
  parameter self :: <ns/object>;
  parameter cmd :: <objc/selector>;
  parameter notification :: <ns/object>;
end;

define objc-class <my-delegate> (<ns/object>) => MyDelegate
  bind @applicationDidFinishLaunching/ => finished-launching-c-wrapper ("v@:@");
end;

define function main (name :: <string>, arguments :: <vector>)
  let delegate = send(send($MyDelegate, @alloc), @init);
  let app = send($NSApplication, @shared-application);
  send(app, @set-delegate/, delegate);
  send(app, @run);
end function main;

main(application-name(), application-arguments());
