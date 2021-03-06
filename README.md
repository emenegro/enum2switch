enum2switch
===========

OS X action to generate a switch case from a given C/Objective-C enumeration. The generated action can be used
in a service that uses the selected text as input and copies the output in the clipboard.

A fully functional service can be downloaded from [here](https://www.dropbox.com/s/m9z0z72n2g5pvmt/Enum2Switch.zip). Double click on it to install and it will be accessible from the Services contextual menu, in every app. The generated switch will be copied in the clipboard.

Example
-------

	typedef NS_ENUM(NSUInteger, WeekDay) {

	    WeekDayMonday, 
	    WeekDayTuesday, 
	    WeekDayWednesday, 
	    WeekDayThursday, 
	    WeekDayFriday, 
	    WeekDaySaturday,
	    WeekDaySunday
	};


	WeekDay expression = <#value#>;
	switch (expression) {

		case WeekDayMonday:
			break;

		case WeekDayTuesday:
			break;

		case WeekDayWednesday:
			break;

		case WeekDayThursday:
			break;

		case WeekDayFriday:
			break;

		case WeekDaySaturday:
			break;

		case WeekDaySunday:
			break;

		default:
			break;
	}

Supported enum format
---------------------

> enum {
 }

> enum {
 } Name;

> enum Name {
 };

> enum Name : Type {
 };

> NS_ENUM(Type, Name) {
 };

Installation
------------

1. Open the Xcode project and build.
2. Open the `Products` folder, right click on `Enum2Switch.action` > `Show in Finder`.
3. Double click to install in Automator and use as desired.
