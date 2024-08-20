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

I made those changes I wrote down. Or, well, most of them. I felt very tired and demotivated, because the idea just wasn't coming along and because I'd been doing non-stop stressful game jams for 3 weeks now. As noon approached, I felt all the energy was just gone. Despite all my discipline and good habits, I just _could not work on the game anymore_.

I didn't want to sit still, however. I had to keep momentum and just do _something_. 

That morning, we discovered that several mice had been living in our cupboard (under the stairs). So ... I just started on a different game idea that could _also_ fit the jam, about finding and chasing away _mice_. Which are obviously very small, so you can only see them if you scale up the world with your magnifying glass.

I worked on this the rest of the day. I actually got quite far and briefly saw a possibility to send in both games to the jam. I could have, I think, if I hadn't been so incredibly tired and sick.

But no, when the day was done, I knew I shouldn't keep trying new prototypes. I should just stick with the bot scaling game I started, finish it "as well as I can", and submit that.

There's not much interesting to say about this day. Any progress or thoughts on that other (mice-chasing) game will be in its own devlog, if I finish and publish that game.

## The next day

I struggled to make more progress. But, somehow, someway, I did!

* I implemented all simple obstacles I could come up with. (And disabled/removed the ones that made no sense anymore.)
* I implemented more pencils, now that I saw what we actually needed in the new idea.
* I fixed a lot of tiny (but annoying) bugs.
* I added the entire UI, tutorial, and overall gameplay loop.
* I added the progression system (so that the mountain slowly gets bigger, slowly unlocks more stuff, etcetera)

The biggest two challenges were **the core game loop** and **making it look nice**.

### The Core Gameplay Loop

So far, the core gameplay was as follows.

* Draw a path from your starting position to the finish.
* Use whatever pencils or methods you want: when ink runs out, the bot starts moving.
* If you reach the finish in any way, shape or form, you succeed and go to the next level. 
* In any other situation, you lose a life but you just continue from where you are.

This is easily "exploitable" though. 

* If you're lucky, the line from start to finish might just be a straight one with no obstacles.
* You can always use the "easiest" pencil (which is the one that just jumps from point to point, without interacting)
* In other words, the best strategy is the most boring and repetitive one.

As such, I tweaked a few core ideas to add much more interest.

* You have to use every pencil _equally much_. The bot only starts moving once every color/pencil type has _roughly_ the same amount of ink on your canvas.
* There are 1--3 stars in the level itself. You need to collect those stars before reaching the finish.

The first rule was surprisingly hard to implement well, but did solve the issue in the simplest way possible. You are now required to use every pencil, which forces you to be creative and find ways to snuck "harder" pencils in there. The player can just check their ink meter for relative levels, so there's no extra bookkeeping or calculation needed from them. With one simple rule, the game became much more interesting.

The second rule is a very typical and simple way to add side-quests and pull a player in different directions. Those stars are very unlikely to be lined-up with the finish, so you _have_ to weave your way through and around the mountain before reaching the finish.

This made the game far better ... but also far _harder_. I changed all my other numbers to make the game easier.

* Good powerups (such as star/finish) are bigger, bad ones smaller.
* You start with more lives.
* You start with a perfectly straight canvas => the canvas only starts to randomly rotate a bit to the left/right (making it far harder to draw correctly) later.
* The mountain grows in size (and new stuff is unlocked) at a slower rate.

At this point, I felt the game was actually a game and just the right amount of challenging.

Now I had to make it look and feel much better.

### The look

It turned out surprisingly hard to make a _randomly generated mountain_ (with any shape, size, contents, etcetera) look good consistently. I just really struggled to find my way through that. Probably because I am so used to either manually drawing the entire thing (which obviously gives you complete control over the final image before it even reaches your game engine), or completely randomly generating more abstract or grid-based worlds (such as puzzles or from perlin noise)

In this case, however, there was no grid, and the game isn't abstract: the mountain has to look somewhat like a mountain, and be placed in some sort of environment.

I ended up doing a lot of work with _shaders_ and _line randomization_ to get something usable.

* The edges of the mountain are divided into X points. These are then randomly pulled left/right (according to some noise texture from Godot) to give wobbly edges.
* There's a shader below the mountain that creates a fuzzy/noisy shadow, to prevent the mountain just being flat at the bottom and not blending with the terrain at all.
* There's a blue sky, a green floor, and both are much bigger than needed in case the player zooms out a lot.
* The sky gets moving clouds, the floor gets random grass, and the mountain gets these random "cracks (of stone)" within it.

The biggest thing here, surprisingly, was adding a tiny layer of grass _on top_ of the bottom line of the mountain. Just some random leaves and blades of grass that stick out and cover the first few pixels of the mountain. This really anchored the mountain well and made it look more whole. (As opposed to all the other grass that is behind it.)

More shaders, more tweaks, more fiddling with colors or sizes, until it looked "good enough".

I was extremely tired and went to bed. (After I _scratched out_ the note about trying to finish the mice game in time for the jam deadline too.)

## The Final Day

I woke up early, telling myself "just a few more hours, then you submit it and can finally take a break". Somehow, that worked.

I added all the sound effects, I fixed the final remaining bugs, I finally added the moving enemies. (Not really because the game needed it, but simply because it'd been on my to-do list for 3 days now and I wanted to see if I knew _how_ to do this.)

I _finally_ created a sprite (and walking animation) for the bot, which _finally_ allowed me to completely finish the tutorial and some other assets. (They were just using some placeholder until now, which is often that default Godot icon you get with every project :p)

There was one final problem, though, that reared its ugly head when I could finally playtest the game in its full glory. (Or, let's be real, its "at least it looks more polished than before"-glory.)

The game ended whenever you reached the finish and had your stars. This means ... you could draw loads of extra nonsense lines, knowing you'd never reach them anyway! Once you hit the finish, you won, the rest of the drawing didn't matter.

So I brought back an old rule I implemented two days ago: you must finish _perfectly_. Your drawing must be (almost) done by the time you hit the finish. This requires you to plan out your lines much better, and adding nonsense lines at the end will just ... not let you win.

This made the game much harder again, which is why I thought (at time of submission) it was _too hard_. But I had no time or energy to change that anymore, so it'd have to do.

I did what I could to get the difficulty right, which mostly came down to starting the game with _no special obstacles_ and _the right duo of pencils_: the regular one, and one that instantly stops once you hit something. Yes, that second one was invented purely to let you finish anyway (if you use that line as the final line), even if your drawing isn't done yet. It actually turned out to be a great starting pencil/addition to the game, so that was fine.

The game was still too hard, didn't look amazing, and wasn't that fun to play. But at least it was done and as good as I could make it. I didn't even have the energy to let others playtest it, partially because I _knew_ it would reveal bugs or major oversights, and I'd feel endlessly guilty for knowing them but not fixing them :p (There were actually people around _expecting_ me to ask them, because they knew I needed to test a game on the day of the deadline. But I didn't feel it anymore.)

With a few hours to go, I decided to submit and be done with this shit.

## Conclusion

This might all sound a bit negative or pessimistic. _Why even do the jam if you hate the process/deadline/stress? It's optional! There isn't even a prize!_

I'd never felt this before. I'd never felt _this tired_ and _this frozen_ before, and the ideas that kept failing and just not being fun obviously didn't help. 

I'd hoped that, by doing other game jams for 3 weeks prior, I'd be completely prepared and primed for my best game for the GMTK Jam. Instead, I was burned out and didn't want to program a game ever again :p

Lesson learned. Many lessons learned, actually. The severity of my "exhaustion" surprised and shocked me, honestly, and I knew I had to just take the foot off the gas and let this game be whatever it ends up being. Otherwise I might've actually given myself nasty lasting consequences from overworking myself and being too stressed out.

At least I participated and submitted something. Something incredibly different than any other game I ever made before, which challenged my skills.

The biggest benefit, actually, was the ideation. I came up with several _great_ game ideas thanks to the theme. But I knew I couldn't execute them in the timeframe, so I just wrote them down elsewhere "for later". While I write this, still incredibly tired and disappointed with the jam, I _already_ feel a bit of motivation to start making those other ideas once I'm well-rested again.

It's the same thing all game devs say whenever they're like "I AM DONE WITH MY SHITTY GAME". We don't hate making games---we still love it. It's just that making games is _so hard_ and sometimes _so repetitive/crushing_, that we can get tired and frustrated with it if we don't vary our lifestyle.

Looking back, I think the game could've been much better with a few simple tweaks---but that's the benefit of a few more days worth of good sleep, of course. The stars could've gone away now; the game was interesting enough without them. I should've been more lenient about what it means to "roughly" match ink or finish. I should've found a slightly better explanation/execution of _bouldering_ and _freefalling_, to actually make it feel like climbing.

Maybe I'll do that update at my next "update all half-finished game jam games", but I doubt it. The idea just turned out to be too contrived and it doesn't feel promising enough to work longer on it.

No, all my other jam games---even the ones I made in only a single day---are better and have a much more promising list of "future improvements". As it turns out, my physical and mental limit for non-stop game creation is 2.5 weeks :p

Until the next devlog,

Pandaqi