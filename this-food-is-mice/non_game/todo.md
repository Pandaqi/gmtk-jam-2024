
# To-Do (Monday)

GAME LOOP
* A game over screen + Menu screen

GRAPHICS / FEEDBACK:
(_Style = Everything has the same bite shape out of it + a rat's tail around it (for stroke/shadow/divider instead)_)
* Animate UI changes
* Give textual feedback where possible
* Draw some more random foods to use
* @IDEA: Splashes of water/"mess" on the floor that will ruin your movement---but also the mice? (Or that's when they always leave footprints/water splashy sounds?)

FIXES:
* @FIX: Scale the MapTracker area from player depending on their size
* @BUG: Query_Position not doing a great job spreading stuff out => Maybe just save the "best pos we had so far" and return that if it fails? (Or we use the underlying grid approach?)
* @QOL: Some bounds to prevent mice from flying away _too far_? (Kicker should have smaller range anyway)
* @QOL: Also flash a health bar for obstacles. (Though that GIVES AWAY that they've been bitten. => Just build it, we can always turn it off or delay it.)
* @QOL: Tween the appearance of new stuff in the world ( + a bit nicer mouse death tween)
* @BUG: If you're holding a tool (space down) while you upgrade, you don't properly let go of it => when coming out of the upgrade, it should re-run the button_pressed function for tool? What's a clean way for this?

TOOLS:
* Auto-scale area radii of tools to match. => Listen to factor on ToolType itself, and a scalar in Config
* Then SHOW the radius of your current object => RadiusViewer node, maybe a new shader that does a BANDED circle (like a bullseye?)

CREATE NEW TOOLS (functionality + graphics):
* Tool3 = Fire (kills in an area, but recharges slowly/one-time use)
* Tool5 = Scalar => scales the effect (strength and radius) of the next tool you grab
* Tool6 = AutoRepel => without doing anything, mice are kept away from your current position
  * This is really useful, but also overpowered if you can just sit around your final pie and do this => this only works for invisible mice (or visible ones, one of the two), or has a limited duration
* Tool7 = Mover => if you press space, all obstacles within range will teleport closer to you (single-use, limited power, but very useful to keep stuff together)
* @IDEA: Give the "overpowered" ones a "hold_move_speed" => you permanently walk slower while holding it, such as the exterminator?





# To-Do (Tuesday)

* Juice: Audio (very sparse bg music, mouse death, score change, level change/new tool unlock, tool change, slam)
* Simple game marketing
* Playtest, finetune, actually get something fun.



@IDEA: The idea of "nests" from which they all spawn (which you can only find with magnifying glass), or mice actually being INSIDE cupboards?

DISCARDED IDEA: There's not really a difference between "invisible" and "this thing died" to the player, is there?
* Objects _also_ become invisible if too small? => They also have MagnifyTracker + Body, but they simply start at max health