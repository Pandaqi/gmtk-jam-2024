# To-Do


REALLY LEAN INTO THE BIG/SMALL and MICE ARE INVISIBLE theme, otherwise I'm just redoing the same game I did many times before.

MAP:
* Use query_position to properly spawn things apart from each other (including distance from edge)
* Create proper design for the objects/tools => anything else (tool-less) is just random food
  * Yes, just create a few tools for food stuffies, which is what we'll use to fill the array at the start.


# To-Do Later

FIXES:
* Magnifier should be bigger (which is far more helpful) and NOT show ourselves => and perhaps multiple tools should have magnifier; set a min_num and max_num on types, listen to it while spawning
* Scale the bites with mouse size (so really tiny mice are also hard to hear + see from bites alone)

GAME LOOP:
* You should be rewarded for removing mice somehow. (You get bigger / you get faster / you get an extra tool => like the "Mario eats a mushroom" animation)
  * And the "target mice" before you get an upgrade moves every time, but is always visible in the UI

TOOLS:
* Auto-scale the area radius to match game scale. (Exterminator is too large, for example)
* The EXPLANATION of tools should either be perma-visible (on the thing itself, on cupboards, whatever) => or it should flash up when you grab the thing.
  * Or, if we're unlocking it over time anyway, then we should just show a tutorial for when it unlocks.
* Animation/Sketches for what it looks like => Maybe when we have exterminator, we hold a broom/spoon, and it would mean slamming it down in the direction of nearest mouse.
  * **Yes, every tool should see us holding something different.** (Maybe do the wavy "arms above the head" movement from PlateUp.)
* Tool3 = Fire (kills in an area, but recharges slowly/one-time use)
* Tool5 = Scalar => scales the effect (strength and radius) of the next tool you grab
* Tool6 = AutoRepel => without doing anything, mice are kept away from your current position
  * This is really useful, but also overpowered if you can just sit around your final pie and do this => this only works for invisible mice (or visible ones, one of the two), or has a limited duration
* Tool7 = Mover => if you press space, all obstacles within range will teleport closer to you (single-use, limited power, but very useful to keep stuff together)

FEEDBACK:
* Give textual feedback

DISCARDED IDEA: There's not really a difference between "invisible" and "this thing died" to the player, is there?
* Objects _also_ become invisible if too small? => They also have MagnifyTracker + Body, but they simply start at max health


@IDEA: Splashes of water/"mess" on the floor that will ruin your movement---but also the mice? (Or that's when they always leave footprints/water splashy sounds?)