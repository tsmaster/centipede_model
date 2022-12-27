# centipede_model

![image](https://user-images.githubusercontent.com/72338/209610306-2264f984-596d-4490-bd5e-8b6ee9b3f775.png)

Friends have made fancy articulated dragons, and how hard could it be to make my own? Looking at one of the printed dragons, I saw that the connection was basically just a set of loops, like a chain, or something like the articulated toy snakes I remember from my childhood.

Looking at a YouTube video https://www.youtube.com/watch?v=tneMHQrGz3U of a dragon being printed, you can see how the segments (or "beads") connect - a vertical loop and a horizontal loop.

I took inspiration from the Atari arcade game of Centipede, and made a few variations of this toy. The original arcade game might have had 12 segments in a centipede, so that might be the version you want if you're that kind of stickler.

I used OpenSCAD for the modeling - a sphere for each segment, toruses (torii?) for the links and also for the legs, and more spheres for the eyes. I needed to carve out negative spaces which were also spheres and toruses. 

I just guessed at dimensions, and the first test that came off the printer felt really good, so I didn't play around much with dimensions after that. If I carved out more negative space so that the beads could have a bigger angle between them, I could probably print even longer centipedes. As it is, without juggling things around, I have about 11 degrees to work with to coil the centipede around on the build plate. I wanted to coil it tighter, and actually spiral the centipede around itself, but getting the math right for a discrete number of "beads" to get a constant clearance (2 inches, in this case) from the next wrap was more than I could do today. Turns out, a 16-segment centipede is plenty long enough, and does not require anything more than a circular arc to fit on my print bed.

Also contributing to my impatience - I ran into confusing error messages out of OpenSCAD for a bit - the vertical torus negative space that I carve out of the horizontal link space had an inner diameter of 0 for a while - a donut with a radius 0 hole is still a donut, still a torus, right? Well, apparently, OpenSCAD (or maybe CGAL?) would have none of it, saying my shapes were not closed surfaces. I googled the error message, and got some inspiration from an old forum post where somebody else was having issues with zero-sized geometry. Also, somebody was ranting on the forum about how slow OpenSCAD is, and how slow functional programming is, and we should all go back to a language named after a dead Frenchman.

The guy had a point - OpenSCAD (I'm willing to believe CGAL, in fact) can get slow to generate STLs if you've got a lot of geometry. So, 16 segments is probably plenty.

OpenSCAD model description files as well as STL files are provided - should be pretty easy to decide how many segments you want to print out, there's a constant at the top of the .scad file.
