# WordMaker

Note that this is an "alpha" version of this app.  I expect to make a lot of changes and there are probably still a lot of ways to break it.  However, it should be functional enough to use.

NOTE: the Letters and Symbols have been moved to a subdirectory to keep from cluttering the Props folder, and the file structure of all Letters, Symbols and WingDings has changed!

If you've used an older version of this program, you need to remove all Fonts and WingDings.  I have provided a file to do this for you called 'MakerCleaner.exe'.  Download it and run it from anywhere.  It will ask you where your VRToolbox directory is and prompt you for the different versions to delete.  Feel free to do so if you're not sure: if the files are not there then it moves on.  

.For pre-ver3.0, it deletes all files and folders, under the props folder, named Letters_* or Symbols_* .

.For 3.0 to 4.0, it removes all files and folders, under the props\Labels folder, named Letters_* or Symbols_* .

.WingDings are simply removed; there was no version difference until now.

.All of the old Font and WingDing files will cause issues, so please remove them all.

I have removed 2 fonts from the distribution zip file,  until I have a chance to fix them.  I have repaired the Comic Font and it's now available along with the dev supplied Orbitron Font.  However, you should note that my fonts have a large "pologon count" (meaning that they have a pretty big performance impact) so you're better off using the Orbitron font.  I expect to bring back the Archivo_Black font after I've had a chance to build some missing symbols for it.   I probably won't bring back the Cambridge version as it has the highest hit.



  https://steamcommunity.com/app/488040/discussions/ 
     


---------

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

						
If VRToolbox is NOT running, you can write directly to the Session Room so that your Words will be there the next time that you enter VRToolbox.

Once in VR with your new Words, you can resize or reposition them by grabbing the first character and using the ingame thumbpad buttons.

Put up a label or lines of text, place a WingDing, like a ThumbsUp, where you want it. Then link/lock the WingDing to the first letter of your text and the WingDing will now move and resize with the rest of the text.

I've added a rudimentary Glossary text file called 'RudimentaryGlossary' to help explain what the values are and what they do, but you'll need to experiment.  Don't forget to upload some screen shots of what you do!

Atm, there's only one font and the initial spacing values are pre-loaded into the config.ini file.  Spacing is a little different for everyone, so expect to tweak them.


Notes and limitations:  

The performance impact on the dev supplied Orbitron font is minimal but my fonts have a performance hit. You'll need to take it easy when using them.   

Letter objects are 'Universal'.  Any changes to 'font' or color will be applied to ALL letters, no matter what room they've been saved to.

All values need to be in '0.0' format.  Meaning that there must always be a number on both sides of the decimal point.  I'll be cleaning this up soon.

Letter spacing needed depends on the font being used.  I've included a text file called 'Letter Spacing' that has the values that I've used.  They'll get you close but you'll probably want to tweak them.  

Letter spacing, once written, stays with those Words no matter what font or color that you change to. If you want to change the spacing, you need to re-write your words using different spacing.  

We've added entries from the  "WingDings" and "WebDings" fonts.  Find them in the "Props" menu in VRToolbox.  (After you've copied them: see the button in program) Includes a Happy Face, pointers, a few lines of different sizes and some other things.  I hope to add more in time. You can use this app to change their color. 



Keep in mind that you need to restart VRToolbox to see any changes to color or fonts!

