TSplitterEx
===========

Extended version of TSplitter that has clickable area and able to toggle visibility of linked control.

Delphi 7+ supported.

Demo app included.

Could be used with standard `TSplitter` **without installing new components**.

Screenshots
-----------

![](./Screens/screencast.gif?raw=true)

Properties
----------
  * `ToggleControl: TControl` - linked control that will be toggled on splitter click
  * `ResizeControl: TControl` - (optional) control that will be resized too on splitter click. If `ToggleControl.Align` is `alClient` and this property is not set, `ToggleControl.Parent` will be resized. Set this property to resize other control.
  * `DenyDrag: Boolean` - (optional) if True, splitter will ignore mouse dragging (if you want only toggle and not resize). You must change `Splitter.Cursor` to default one by yourself.
  * `HotColor: TColor` - (optional) color a Splitter will have when a mouse is over.
  
Methods
-------
  * `Toggle` - toggle the control
  * `SetImages` - Init click image and calculate click area from image's dimensions

Usage
-----

  * Add this line before form definition: `TSplitter = class(TSplitterEx);`
  * Place usual `TSplitter` on a form, set `Align` properties of splitter and neighbour controls as usual
  * Assign `Splitter1.ToggleControl` to control you want to toggle
  * Prepare an image (I borrowed one from Firefox panel toggler)
  * Call `Splitter1.SetImages(ImageShown, ImageHidden);` where `ImageShown` is `TImage` with image for state when ToggleControl is shown and `ImageHidden` is for state when it is hidden
  * Assign optional fields
  * Enjoy
	
Notes
-----

  * If `ToggleControl.Align` is `alClient`, the splitter will change width of a parent control instead. Thus you can toggle controls that go after the splitter.