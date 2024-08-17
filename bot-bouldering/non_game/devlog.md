Welcome to the devlog for one of my ideas for the GMTK Jam 2024. It was a mess, things weren't working, and I'll be documenting it all because it helps me think through the problems. Hopefully it's fun/instructive for others to read too!

## What's the idea?

The theme of this year's jam was **Built to Scale**. 

At first, I thought it was a difficult theme and couldn't really come up with ideas. I'd already planned to start working on it _tomorrow_, taking the night off (after already doing 6 game jams the past few weeks). So I just exercised, watched some YouTube videos, planned to watch an episode of a series ... and then my brain finally came up with ideas.

Where I started with nothing, I suddenly had a list of ~25 "maybes". 

That's obviously too much, but that's what you do at the start of the ideation phase: write _everything_ down, sort out the best things later.

The next morning, I woke up and took an hour or so (9 AM to 10 AM) to sort out the good from the bad. I ended up with ~5 most promising ideas, of which I had to just randomly pick one because I couldn't decide.

That idea was "Bot Bouldering".

* You control a little robot that is tasked with _scaling_ this mountain / rock climbing wall.
* Unfortunately, you can only give instructions by drawing on a piece of paper.
* Obviously, the paper is not the same size as the mountain, so you'll have to constantly estimate how long your lines need to be to make it work.
* There are dangers on the mountain (making you lose lives), there are walls you must simply go around, and you have to reach the top.

Sounded doable, right? Could be a cute little robot, could be a simple intuitive challenge. 

I was wrong.

## The issues, the issues

### The mountain/wall

The mountain generation proved troublesome.

* It's easy to "chunk" the generation so that it only loads the next part once you reach it. (Which is far less heavy on the computer than generating the entire thing from the start.)
* But it's not easy to guarantee there's a way to the top.
* Or to make it look good, instead of a noisy mess => but the more you "control the randomness" ... the less it's actually randomly generated, of course.

### The creative drawing

Then the drawing proved troublesome.

* If we allow players to start drawing _anywhere_, then we can't move the robot based on absolute coordinates. (As in, simply convert the coordinates on the paper to the real world by scaling, and we're done.)
* Instead, we have to do _relative_ movement => every frame, the robot checks the vector between its current point on your drawn line and the next one, and moves along that _vector_. This is slightly imprecise, but the error is too small to notice.
* But wait! Now we're scanning the points from _bottom to top_---the intuitive way, like climbing a mountain. But if we allow players to circle back, or draw _anything_, then we'll encounter multiple points at a time and it won't make sense! Argh, we need to go in order of _line_ instead, and require the player to start a new line close to the old one.
* The movement works now, but we can never convert it _back_ to absolute coordinates---everything is relative to where the robot started and how the canvas was when you drew. It works, but it will probably not work tomorrow when some new feature needs to be added.

### The core game design

Then the game itself proved troublesome.

* Now there's no urgency. You can just do nothing, or draw very safe lines, and it's not really a game.
* So, let's add some rising lava or something! You must stay ahead of it.
* But ... so far the game was turn-based/more "slow": you had X seconds to draw your lines, _then_ it would call them final and move the robot. Once it was done moving, your canvas cleared, next turn. This doesn't work when you need to react quickly all the time!

Aaaargh. I needed to make a decision: **is this game supposed to be slow and strategical, or fast and action-y?**

* We can zoom in quite a bit, follow your drawn lines _in realtime_, and you must constantly redraw to stay ahead of the lava. The canvas is literally _on_ your robot, it's constantly rotating, and you're right there in the action.
* Or we can do the opposite. We zoom aaaall the way out: you see the entire climbing wall all the time, and you draw your entire path through it in one go (before it's executed).

With my last effort of the day, I tried the first one first. I got the game to switch to real time quite easily, actually, because I'd kept up a very clean and modular code structure. But ... it turned out to be the wrong choice.

See, the original idea _was_ to challenge the player to "judge how and where to draw their lines (to overcome the climbing challenges)". But if we make it fast and zoomed-in, then you have no clue where you're going, and you're only trying to be as _fast_ as possible. That's just not the original vision for the game. It doesn't fit. 

The obvious issue is that there's _no incentive_ for the player to draw longer lines or be any more strategical than "go up, go up, go up".

At that point, you start to think of many ways to _incentivize_ the player, of course.

* Maybe every stroke has a min/max length. (Hard to communicate, annoying to work with---"hey, why isn't my line registering? I drew a short line right there!")
* Maybe you must use all your ink before it does anything. (A contrived mechanic. "I just want to go up! Now I have to draw random circles just to make the ink run out!")
* Maybe it is still on a timer, so you get exactly 20 seconds, which means drawing a single short line is wasteful. (A slow mechanic. Even if you're very engaged and active, you'll still often just be waiting for that timer to run out so you start moving again.)

No, all the tricks in the world would not save that.

### The next iteration

Now, after a very long day of non-stop work, I could see that I should've completely leaned into the original vision.

* The screen simply shows your paper on the left, and the entire climbing wall on the right.
* The generation for the wall is less random and more purposeful, to ensure it looks nice and always has the same level of challenge.
* You simply get X ink and Y pencils. You draw your entire path through this (as you think it will work). Once out of ink, your job is over and the robot starts moving.
* If you reach the top, and timed it almost perfectly with your final line/point, you win. 

Yes, this idea _could've_ worked more fast-paced and realtime, but then it shouldn't have been a solo climbing game. It should probably have been platforming or shooter, more actively fighting off enemies. _Then_ it would've been a cool challenge if you could only move or shoot by _drawing_ your paths and stuff. An idea for another time; or take it from me, if this inspires you ;)

But no, in its current form, and with only ~2 days left, I decided to go for that slower strategical version of the idea.

What had to change?

* I pulled out the chunk generation code and replaced it with a different generation algorithm => place specific types, with min/max distances between them, and ensure there is never just a straight path upwards.
  * Now I could also more easily add moving enemies / more complex obstacles, because of the smaller confined space. In the other idea, the mountain was far too big and moving enemies would've had to receive pathfinding or something to matter, which is of course not doable in this timeframe.
* I turned off all the realtime stuff I'd experimented with. Now it waits until you depleted your ink again.
* The camera now focuses differently to get the entire wall in view, and keep the paper in the other half of the screen.
* Most of my work adding special types of pencils still mattered---my work adding all sorts of obstacles was mostly down the drain, because they just didn't matter anymore. (Of course I kept it in the project, but all disabled/unused.)

I really don't like re-doing nearly 16 hours of work the next day. I seriously considered dropping this altogether and just making another idea from my ~5 promising ones.

All night, I had doubts about this. Was it stupid to start another idea almost halfway into a 4-day jam? Or was it the only wise choice, because this idea clearly turned out more complicated and frustrating than expected? Or, as my experience tells me, is it just natural for every idea to reveal ugly problems once you work on it, and switching to another idea that seems "simple" will just repeat the same loop?

I just couldn't decide.

Especially when you have a hyperactive brain (like me), having many options can just ... freeze you. The final few hours of the first day, I just _could not decide what to do_. Hence why I wrote this devlog instead, tried to take a break, and just went to bed early. I knew nothing productive would happen in this state.

## The next day

@TODO