CapInsetImageGenerator
======================

An OS X tool for generating resizable images with cap insets

I was creating a bunch of resizable background images from the images of a designer I'm working with
that make use of the iOS UIImage resizableImageWithCapInsets: API, and found it quite tedious.

Simple usage: open an image file, specify the insets you want, and then save. You can also paste or drag the
image onto the source, and copy the resizable image (after selecting it). 

Cap insets are in points, not pixels. Specifying Use Retina will use 2 pixels per point.

If the insets for both sides of a dimension are set to zero, the entire image in that dimension will be used.

The code for creating the UIEdgeInsets is also generated, in points.
