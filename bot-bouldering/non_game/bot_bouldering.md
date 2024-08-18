# To-Do Crucial

UI:
* Include fonts I picked
* Create the ink bar in the center (multi-color, perfectly centered)
* Create the horizontal list of pencils next to it => hover to show tooltip
* Create treasure/lives display too

PROGRESSION:
* Unlock stuff as we go, raise the size of the mountain (and the available ink) every time
* A game over screen + semblance of a tutorial
* => Tooltips for elements on the mountain

GAMEPLAY:
* Figure out gravity/freefall mechanic. Probably ...
  * Going out of bounds just falls down to the ground and you go again.
  * Give the player that one button to "let go" and fall, until they press the button again.
* Auto-Move enemies
* Keep only powerups that actually work now. Add: TELEPORT and BOMB (removes obstacles/enemies in close range)



* Create auto-freefall mechanic => you let go, once you're "below" the map, your freefall resets
* Create the option for an obstacle to "auto-move" => it will draw a random line from its position through the mountain, and then auto-follow at a speed the player can see
* Create the actual UI + tooltips

* Progression => bigger and bigger mountains, more and more pencils/obstacles
* I want gravity/freefalling/bouldering to be more of a thing => maybe there's a BATTERY aspect? You can only stay clung to the wall for as long as you have battery?
  * Maybe you need to collect certain stars along the way? Because now you have too much of a straight goal ("get to finish, everything else is optional")
    * And the "you must finish perfectly is nice but also a bit clunky?" => Nah, it's nice actually, it allows me to give _too much ink_ by default and it's still a challenge.
    * Perhaps a BETTER way would be to say "every pencil must be used equally much?" => so it constantly checks if the ink of all pencils is within each other's range, and if so, it starts moving.
      * And in that case, that "progress bar" in the center should show ALL COLORS, sorted from low to high, so you can see exactly how often things are used.
  * TELEPORT OBSTACLES do feel like a great addition here, because they'd force you to rethink where your character is right now.

* Now I could also more easily add moving enemies / more complex obstacles.
* Maybe you can make multiple drawings? And switch to a backup plan? => Or you need to be able to do SOMETHING to still influence what your robot is currently doing?
  * Maybe that's where bouldering comes in. You have a single button to "let go" of the map, and to "cling to it" again.
  * Going out of bounds just means you let go and fall back to ground level? Not that you die immediately?
* Player could really start _anywhere_ (not close to finish) right? => Though this automatically happens when you fail your first try
  * Just use LIVES for this => every failed attempt costs a life, but you get 3 lives at the start, and can get more while climbing of course.

# To-Do Later



* Include the fonts I picked
* Create actual icons for UI + nice update animation + use
* Can I display the actual progress along a line while the robot is moving?
* Add a SHADER + DECORATIONS to make the grey mountain NICER 



@IDEA: Maybe, in solo player, you also get to see some random drawing by the computer. Which they follow/execute at the same time as you. And it's your job to NOT collide with them or something.

@IDEA: Make something very useful like "jump" simply deplete your total ink faster?



# To-Do Very Optional



# Ideas for the more realtimy/actiony version

* More pencil types??
  * SHOOT: stands still, rotates in direction and shoots. (Or shoots a single bullet that follows the line?)
  * TELEPORT: or some other special thing that you can ONLY use if you're walking with this line

Don't make the mountain rectangular => make it smaller and smaller as you near the top

* Different Rules
  * Maybe health is more continuous, and bumping into solid stuff will reduce it? (Or bumping into something will make you enter freefall?)
  * After each line, it auto-switches to the next pencil, no exceptions. (Think that's simply bugged now.)
  * You can't draw new lines while it's still following the current one. (Though there must be some benefit to drawing longer lines then?)
  * When you deplete the ink of _that pencil_, it switches to another one?
  * @IDEA: A min/max ink for which you have to use each pencil?
    * The same penalty is incurred for every line, no matter how long or short. This incentivizes you to use the full length of every stroke.

* Turn the canvas viewer into a dotted outline or just something nicer
* The canvas just looks ugly and awkward now if it's _wide_ => should probably always be tall, like an A4 paper.

@IDEA (For the realtime/actiony version): Zooming in/out should really scale your entire BOT => so if you zoom in, you get more detail/precision, but you're also much bigger?

@IDEA: While you're drawing, your bot will _slowly_ slide downwards more and more, to put extra pressure and challenge on you? (Or maybe this is related to lives or status => if it's damaged/battery empty, it will start sliding.)


# Bot Bouldering

A _robot climbing_ competition where your instructions must be sketched on paper.

**Theme Interpretation:**
* You're literally building these bots/instructions to scale a wall.
* Viewing scale also matters (either the wall or your paper must be tiny at one time)

## Setup

* A front-view of a randomly generated rock climbing wall. (FRONT view, not side-view like _Getting Over It_ and such.)
  * Alternatively, there's a separate phase at first where players _place_ the holds or create the wall.
* Every player has their bot standing at the bottom.
* Every player has some empty _graph paper_.

## Objective

Reach the top / get as far as possible. (Or be the _first_ to do it in multiplayer.)

## Gameplay

You can scale either the _paper_ or the _wall_, but never both at the same time.

You have several pencils with which you can draw on your _paper_.

* One pencil tells the robot to simply move following its line.
* Another tells it to _jump_ from start to end point of each line.
* Another tells it to let go.
* Etcetera.

Perhaps you can also draw special blocks or components onto the graph at specific moments, but that's a stretch goal. 

In any case, both drawing and switching tools must be doable by keys/gamepad, not only mouse. And you have a **strict timer**.

Then the climb starts.

* Every robot simply executes these instructions on the paper from bottom to top.
* You hope you created the right input and get far.

(This would mean the robot components are very simple fixed instructions: jump in current direction, rotate X degrees, float for Y seconds, etcetera. The wall itself should also help by having many "safe points", backups, automatic elements, etcetera.)

(In addition to drawing the entire path, you can also draw INSIDE those special powerup/action blocks you placed. That graph then also determines how that specific action plays out over time.)

In **multiplayer**, the players would be ranked by how far they are (winner->loser). You still draw simultaneously, but later players have an _extended timer_, to give them an advantage in case of collisions or seeing how others solve the same problem.