# To-Do (Tuesday)

# Future To-Do

* Extra visuals to show freefalling or not
* [IS THIS FIXED?] @FIX: Find whatever error is causing those tweens to be destroyed again before starting => is it the UIElement tween? Because we advance level just before restarting and that triggers stuff? => Only happens on GAME WIN, not GAME LOSE!


# Ideas for the more realtimy/actiony version

DISCARDED IDEAS:
* Maybe you can make multiple drawings? And switch to a backup plan? => Or you need to be able to do SOMETHING to still influence what your robot is currently doing?
* @IDEA: Make something very useful like "jump" simply deplete your total ink faster?
* Maybe there's a BATTERY aspect? You can only stay clung to the wall for as long as you have battery?
* @IDEA: Maybe, in solo player, you also get to see some random drawing by the computer. Which they follow/execute at the same time as you. And it's your job to NOT collide with them or something.



OBSTACLE IDEAS:
* @IDEA: Enemy Pause? => As it says, the enemies simply stop moving for the rest of this turn => Good idea, but would have to wait until moving enemies are actually introduced, and I don't have time to write a clean system for that

* More pencil types??
  *   * CIRCLE => Follows your line, but this stroke must always be a circle => NAH, anything that forbids the line you currently draw is ANNOYING, because you're suddenly not drawing anymore/locked out/your line does nothing and you don't know why.
  * SHOOT: stands still, rotates in direction and shoots. (Or shoots a single bullet that follows the line?)
  * TELEPORT: or some other special thing that you can ONLY use if you're walking with this line


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