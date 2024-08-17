# To-Do Crucial

CONFIG => create the global config again, move values over

MAP:
* Close the game loop => if you die, restart => if you reach the mountain top, great!
* Having rising lava that will kill you
* Create the option for the bot to follow your lines _as you go_, in real time.


# To-Do Later

* MAP: bigger chunk sizes, spawn fewer powerups, make powerups smaller
  * Perhaps I want more extremes in blockade size: either a wall is HUGE or it's quite tiny, but not a scattering of in-between ones.
  * Otherwise, locking sizes and rotation to fixed intervals (e.g. only quarter turns) should make it a bit more orderly.
  * Be more zoomed in by default; we never want to see _too much_ of the mountain
  * This would also require somewhat slower movement from the player
* Pick fonts
* Create actual icons for UI + nice update animation + use
* Add a SHADER + DECORATIONS to make the grey mountain NICER => also make it smaller and smaller as you near the top
* Actually _spawn_ the player on the fly, then connect the separate elements properly (bot and paper should know about each other), and switch to the delayed `activate` structure again
* More pencil types?? => NO, we actually need fewer, and NOT being able to choose them is far more interesting and less overwhelming.
  * SHOOT: stands still, rotates in direction and shoots. (Or shoots a single bullet that follows the line?)
  * TELEPORT: or some other special thing that you can ONLY use if you're walking with this line

@IDEA: We really need a TIME PRESSURE or CONSTANT THREAT, otherwise you can just always take safe routes and chill your way up the mountain ... => the most common thing here is rising LAVA or something; a more unique approach would be that enemy bot.

@IDEA: A min/max ink for which you have to use each pencil?

@IDEA: Maybe, in solo player, you also get to see some random drawing by the computer. Which they follow/execute at the same time as you. And it's your job to NOT collide with them or something.

@IDEA: Make something very useful like "jump" simply deplete your total ink faster?

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