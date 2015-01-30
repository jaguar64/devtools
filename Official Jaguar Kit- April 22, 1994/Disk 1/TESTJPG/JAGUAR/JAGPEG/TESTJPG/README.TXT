Enclosed is the 2/18/94 release of the sample program TESTJPG meant to
be used with the JAGPEG tools (DEJAG and TGAJAG). 

-----------------------------------------------------------------------------
Entire contents are Copyright 1993, 1994 by Atari Corp. All rights reserved.
-----------------------------------------------------------------------------

TESTJPG is a sample program for the Jaguar that demonstrates how to take the
files created with the TGAJAG tools and use them in a program with the DEJAG
routine and tools.

Before looking at the sample program, you should already be familiar with
the TGAJAG and DEJAG files and tools.

This sample program is similar to the programs in the EXAMPLES directory for
the most part, except that it sets up the video a bit differently with a
16-bit RGB mode instead of 16-bit CRY, and a creates a 16-bit RGB bitmap
object instead of an 8-bit palette-based object.  This is, of course, to
accomodate the JPEG pictures which the program displays.

The interesting parts of this are in the TEST.S file, which sets up and calls
the DEJAG routine to display the pictures.  It switches back and forth between
two different pictures which were compressed with different quality settings.
One of the pictures is the default 75% quality, the other is set to only 25%
but still manages to look reasonably decent.

Also take a look at the MAKEFILE, which shows how the .JAG picture files are
included in the program, as well as the DEJAG routine's .BIN file and .DAT files.
It also shows how you can specify a command input file for the ALN linker to get
around the 128-byte MSDOS commandline length limitation.

If there are any questions, comments, bugs, or awestruck praise regarding this
demo program which you'd like to throw my way, contact me at any or all of the
following:

Mike Fulton
Atari Corporation
1196 Borregas Ave.
Sunnyvale, CA  94089
Tel: (408) 745-8821
Fax: (408) 745-2088
Compuserve: 75300,1141
GEnie: MIKE-FULTON
Internet E-mail: 75300.1141@compuserve.com

