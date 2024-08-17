# Vanguardimensio

A grid-based battler / fighter.

## Setup

* A grid with a clear "our side" and "their side", with some monsters set up.
* Along the borders (left/right/bottom/up) are "dimensions": arrows + label + icon.

## Objective

The game ends when one side is defeated. If that's the opponent, you win and go to the next level. If that's you, you lost.

## Gameplay

Turns go in order of "haste" or whatever, which is also a thing that the dimensions can modify.

If it's your turn, you move a unit, and then it automatically attacks. By default, attacks hit the area _in front_ of the character, by as much as their range.

If it's an opponent's turn ... you do the exact same thing :p Enemies, however, can have hidden intentions. You can only see those ahead of time if you make them bigger.

It's all about positioning yourself and the opponent strategically. ("If I move there, I have more health, but less damage.")



@IDEA: You always fight YOURSELF? (As in, the exact same units as your own loadout.)

@IDEA: The First/Last unit you defeat is then added to _your_ army for the next level. (Or only if you defeat them in a certain way, or keep them in some _capture_ square for a while, which has downsides for you?)

Dimensions = 
* Size (X/Y)
* Position (X/Y)
* Rotation
* Health
* Damage
* Movement Range
* Attack Range
* Rotatoin
* Haste
* Sight => can this somehow play a role? Maybe very tiny things are just overlooked and not attacked?