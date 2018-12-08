Branch [AlignedDimensions](https://github.com/zbyna/pl_Shapes/tree/AlignedDimensions) contains huge upgrade of original CodeTyphon 6.1 package [pl_Shapes]( http://www.pilotlogic.com/sitejoom/index.php/wiki?id=294) for use in my closed source application Product Drawing.

# Changes
## General:
- add using antialiasing drawing with [bgrabitmap]( https://github.com/bgrabitmap)
- add proper transparency to all shapes
- add support for Drag and Drop shape to shape
- add possibility to use aligned dimensions for shapes (switchable)
  - external
  - internal
- fix flickering issues during resize
- fix saving shapes on disk
- fix dataStream (TMemoryStream compression) in base object
- add posibility to paint whole object to custom canvas (needed for print)
## TplDrawPicture:
- expand  for using png and jpg formats
- add pictureFileName property 
- add showBorder property 
- add stretch and transparent funcionality

![](https://i.imgur.com/m8hpI7W.png)
