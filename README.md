# WordMaker

Note that this is an "alpha" version of this app.  I expect to make a lot of changes and there are probably still a lot of ways to break it.  However, it should be functional enough to use.

Welcome to WordMaker for VRToolbox!

Use this to create labels or other 3d text in VR.

To install, it unzips into a directory called WordMaker: just unzip to your directory or drive of choice and run the exe.  I recommend making a shortcut to the exe on your desktop.
The first time that you run it, you will need to write the Letter Objects to the VRToolbox Props directory.  It should detect that you don't have the fonts installed and offer to copy them for you. 

You can add your text to the current Session.room if VRToolbox is NOT running, or write to a room that I call 'Words.Room' if it is.
You can add as much as you'd like, but each time that you press the 'Write' button, it starts your text at the beginning coordinates.  You will need to drag the strings off of each other in VR.

To see your Words:

-always save your current room over the existing Words.room file before Writing, in order to add your new Words to your active room.

-go to the 'Rooms' tab of the main VRToolbox Settings window and click the 'Save' button.  

-navigate to 'Documents\My Games\VR Toolbox\save\Words.room'.  Make sure that you've got everything arranged how you'd like (in VR) and then save it back to the room, overwriting the Words.room file.  

-Write your words to the Words.room file by pressing the button on WordMaker.

-find the 'Load' button on the Settings page of VRToolbox and click it.

-navigate back to 'Documents\My Games\VR Toolbox\save\Words.room'

Once in VR with your new Words, you can resize or reposition them by grabbing the first character and using the ingame thumbpad buttons.						
If VRToolbox is NOT running, you can write directly to the Session Room so that your Words will be there the next time that you enter VRToolbox.



Notes and limitations:  

The performance impact has not yet been evaluated.  I'm not seeing any, but I'm not writing more than a few lines.
Letter objects are 'Universal'.  Any changes to 'font' or color will be applied to ALL letters, no matter what room they've been saved to.

All values need to be in '0.0' format.  Meaning that there must always be a number on both sides of the decimal point.  I'll be cleaning this up soon.

Letter spacing needed depends on the font being used.  These are what I use; they'll get you close.  Feel free to experiment. 

Archivo Black:  x=  0.3,  y= 0.7  /  Cambria:   x= 0.26,  y= 0.7  /  Comic:   x=   1.0,  y=1.4

Letter spacing, once written, stays with those Words no matter what font or color that you change to.  If you have Cambria Words and change to Comic font, the spacing will be off.  You will need to re-write your words using different spacing.  In time, I will probably modify the letters so that all fonts are the same size, but it's tedious work at best and I'm still waiting to see what the dev's will offer.  I'd like to have "native" support for their stuff first.

Certain symbols are "off limits" at this time.  They are symbols used in the programming language and I need to code those for asc characters.  These are the Slash, Backslash, single and double quotes.   I'll fix this soon.  Atm, they are simply missing.  There are a few others that I did not code, yet.  Like the caret: ^    I'll add them if there are any requests for them. 

Certain symbols were not included with the Archivo_Black font used:  I've subbed in Cambria versions.

I've added entries from the  "WingDings" and "WebDings" fonts.  Find them in the "Props" menu in VRToolbox.  (After you've copied them: see prompts) Includes a Happy Face, pointers and a few other things.  I plan to add more, including general purpose lines. You can use this app to change their color.  Keep in mind that you need to restart VRToolbox to see the changes.

Keep in mind that you need to restart VRToolbox to see any changes to color or fonts!

