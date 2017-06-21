# GenericElement
Dynamic Typing Solution compatible with JSON objects and Parallel Type Library and Functional Programming styles.

## Rationale
The library was conceived to eliminate issues relating to automatically handling JSON objects.  But there are also implications for the SPHERES architecture - essentially it allows Delphi to generate a Spheres objects so that you can use late binding, C# Like "Dynamic" objects in your Delphi code. One of the key goals however was to eliminate the need to use classes so that it would inherently support fluent styles and work with the parallel task library without fear of leaks.

A Sphere object is a Object which consists of a Value and an array of Sphere objects - ie an essentially infinitely deep object.  A Sphere object can represent an entire enterprise system down to a byte.

## to do:
Pretty much everything at this point....

