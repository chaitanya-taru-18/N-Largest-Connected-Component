# N-Largest-Connected-Component
Haskell based approach to find Largest Connected Component.

Consider a small binary image (or matrix) that is represented as a list of lists which contains
only the numbers 0 or 1, e.g.,<br>
> [[0,0,0,0,1,1],<br>
[1,1,1,1,1,0],<br>
[1,1,0,0,1,0],<br>
[1,1,0,0,1,1],<br>
[1,0,1,1,1,1]]<br>


We wish to find the number of pixels in the largest connected component of such images
(there can of course be more than one component with the same largest number). A connected
component is a cluster of pixels that contain the same value and there is a path from
each pixel to each other pixel inside that cluster. A path is formed from a start pixel by moving
either horizontally (one element left or right in the same inner list) or vertically (one list up
or down in the outer list without changing the position in the inner list) to the next pixel until
the end pixel is reached (this is 4-pixel connected, i.e. no diagonal movement). The number
of elements in the largest connected component for the value 0 in the above example is 4
(among the 4 components). It is 19 for the value 1 (there is only one component).
