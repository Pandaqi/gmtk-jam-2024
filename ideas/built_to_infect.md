# Built to Infect

A game about spreading a _Virus_. Alternative themes could be spreading _Religion_, or _Cult_, or just _Ideas_.

**Theme Application:**
* The virus wants to spread and scale to the max
* The different zoom levels of the world

## Setup

You get a randomized _world_ => multiple spaces, multiple countries, all connected.

* Normally, when zoomed out, you only get a very barebones overview of what's happening in each country.
* But you can scale every section, or rather _zoom in/out a specific country_, to get more details and to interact.

This world is a **grid** (of rectangles or hexagons). Movement and actions are grid-based and timed. 

(Why? To keep it orderly and rule-based, especially if multiplayer. To allow loads of units in loads of countries while being cheap to compute.)

## Objective

You are either the VIRUS (progressively built/design the best virus) or the HEALERS (prevent this from happening)

The game ends once all people have either been infected, definitely healed, or died. Whoever has majority (infected/healed) wins.

If _local multiplayer_, these roles are spread across the players, and the role of who may _switch country_ changes (or it's up to a vote).

## Gameplay

On your turn, you input your movement. All other entities show their intentions.

* At the high level, this moves you from country to country. At mid level, from city to city. At low level, within the actual city/level/terrain itself. => The entire game is a simulation that can be SPED UP/SLOWED DOWN at will. Changing levels can be 1 second to the player, but 1 day in-game.
* Touching an entity/sharing a space with them will heal them.
* You can press one key (it'd be ARROWS + SPACE for singleplayer) for a special action.

The things you pick up and select will "built" your virus design over time, giving special bonuses like faster move speed, faster switching between levels, infecting those on adjacent squares too.

The grid also simply has squares that do stuff by default, such as "when you enter this cell, you infect those adjacent"

Different countries/cities have different base properties that change how infection works there.