# A basic shooter
I made this game because I wanted to have a project on godot.

## Controls
- **Shoot**: left/right click, space
- **Pause**: escape, middle click
- **Nuke** (remove 20% of total points): K

## Save encoding
Highscores are saved in the file _highscores.save_ in binary format. It is a successions of strings and integers encoded by [`FileAccess.store_var()`](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html#class-fileaccess-method-store-var), strings being the pseudonym of the player and integers their score.

## Credits
- Fonts: 
	+ Game's font: [lilita one on google font](https://fonts.google.com/specimen/Lilita+One)
	+ Logo's font: TF2 fonts
- Sound effects:
	+ Enemy killed: [Bubble pop (pixabay)](https://pixabay.com/sound-effects/search/bubble%20pop/)
	+ Player hit: [TF2 critical hit](https://www.myinstants.com/en/instant/tf2-critical-hit-33843/)
	+ Nuke: [Jakito's warth (ULTRAKILL)](https://www.myinstants.com/en/instant/jakitos-wrath-97155/?utm_source=copy&utm_medium=share)
	+ Milestone reached: [coinssss](https://www.myinstants.com/en/instant/coinssss-93535/?utm_source=copy&utm_medium=share)
- [explosion generation](https://explode.moth.monster/) (unused gif)
- [LeRetardatN](https://github.com/Lecodeurenretard) made everything else.