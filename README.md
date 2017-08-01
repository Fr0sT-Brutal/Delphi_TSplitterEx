TSplitterEx
===========

Extended version of TSplitter that has clickable area and able to toggle visibility of linked control.

Delphi 7+ supported.

Demo app included.

Could be used with standard TSplitter **without installing new components**.

Screenshots
-----------

![](./Screens/screencast.gif?raw=true)

Usage
-----

  * Add this line before form definition: `TSplitter = class(TSplitterEx);`
  * Place usual `TSplitter` on a form, set `Align` properties of splitter and neighbour controls as usual
  * Assign `Splitter1.ToggleControl` to control you want to toggle
  * Prepare an image (I borrowed one from Firefox panel toggler)
  * Call `Splitter1.SetImages(ImageShown, ImageHidden);` where `ImageShown` is `TImage` with image for state when ToggleControl is shown and `ImageHidden` is for state when it is hidden
  * Assign `Splitter1.HotColor` (optional)
  * Assign `Splitter1.DenyDrag` (optional, if you wish to disable splitter dragging and leave only toggling)
  * Enjoy
	
Notes
-----

  * If `ToggleControl.Align` is `alClient`, the splitter will change width of a Parent control instead. Thus you can toggle controls that go after the splitter.
