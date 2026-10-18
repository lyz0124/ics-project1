#set document(title: "A Planet in a Binary Star System", author: ("Yizhou Lu", "Ruimeng Yang"))
#set page(paper: "a4", margin: (x: 1in, y: 0.85in), numbering: "1")
#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true, leading: 0.7em)
#set heading(numbering: "1.")
#set math.equation(numbering: "(1)")

#align(center)[
  #text(size: 20pt, weight: "bold")[A Planet in a Binary Star System]
  #v(0.4em)
  Yizhou Lu · Ruimeng Yang
]

#v(1em)
#outline()
#pagebreak()

= Introduction

A binary star system consists of two stars that orbit their common center of mass. We study a planet in this system. Its motion is far more intricate than that of a planet around a single star, because the planet feels the gravitational pull of two stars whose positions change with time. This makes such systems an interesting setting for studying orbital dynamics and for testing numerical methods.

// In a binary star system, two stars rotate around the center of mass, due to the gravitational force between two stars. In this two-body system, the orbits are always circular or elliptical. 

In this project we simulate the motion of a planet in a binary star system and investigate how the planet's trajectory depends on the configuration of the system. A planet usually has far less mass than the stars, so the gravitational force from the planet is small enough that the orbits of binary stars are hardly affected by the planet, keeping elliptical. On the other hand, the orbit of the planet could be complex, due to the two gravitational forces of roughly the same order both affecting the planet.

The study is divided into two parts, summarized below.

- 2D case
  - The orbits of the binary stars
  - The direction of the planet
  - The distance of the planet from the center of mass (CM) of the binary stars
- 3D case
  - Oscillation in the $z$-axis
  - The stability of the oscillation

In the 2D case, all three bodies are fixed on the x-y plane, by setting their initial velocities and positions all with 0 z-component, they are guaranteed to stay on the plane, since the gravitational forces also stay on the x-y plane. The bullet points under the 2D case list the hyperparameters that we tune; their choice determines the binary-star orbit, the sense in which the planet travels, and how tightly the planet is bound. 

In the 3D case, we place the planet in the center of mass of the binary stars, and study its motion along the z axis, with the binary stars still fixed to the x-y plane. We expect to see an oscillation with specific initial conditions, and study the stability of it afterwards.

= Equations

== The orbits of binary stars

Two simple cases are considered:
1. Circular orbits with equal mass.
2. Circular orbits with unequal mass.

Then, the more general form of elliptical orbits with unequal masses are discussed.

=== Circular orbits with equal mass

For $m_1=m_2=m$, with each star at distance $r$ from the center of mass,
by balancing the central force with the gravity, we have the velocity

$
  v = sqrt((G m)/(4r))
$

$
  omega = sqrt((G m)/(4r^3)), quad T = (2 pi)/omega
$

=== Circular orbits with unequal mass

For $m_1>m_2$, the center-of-mass distances satisfy

$
  r_1/r_2 = m_2/m_1.
$

The orbital speeds (similarly obtained by balancing central force with gravity) and angular velocity are

$
  v_1 = sqrt(G m_2 r_1)/(r_1+r_2), quad
  v_2 = sqrt(G m_1 r_2)/(r_1+r_2)
$

$
  omega = sqrt((G m_2)/r_1)/(r_1+r_2), quad
  T = (2 pi)/omega.
$

=== Designing the general orbits

Given semiaxes $a,b$ (where $a$ is the longest distance the two binary stars can reach, and $b$ is the shortest distance similarly) and masses $m_1,m_2$, determine the speeds at the two ends of the orbit.
#footnote[See the appendix for illustration of the variables.]

Denote the corresponding velocities when the binary stars are at the ends of $a$ and $b$ respectively by $v_(1a), v_(2a),v_(1b),v_(2b)$.
#footnote[The relative position and velocity vectors $X=X_1-X_2$ and $U=U_1-U_2$ are not used here.]
Denote capital letters $X$ and $V$ as vectors, while lower case letters $x$ and $v$ stand for magnitudes.

By the conservation of energy (including kinetic energy and gravitational potential energy) we have:

$
  1/2 m_1 v_(1a)^2 + 1/2 m_2 v_(2a)^2 - G (m_1 m_2)/a
  =
  1/2 m_1 v_(1b)^2 + 1/2 m_2 v_(2b)^2 - G (m_1 m_2)/b
$ <energy>

The center of mass and center-of-mass velocity are

$
  X_"cm" = (m_1 X_1 + m_2 X_2)/(m_1+m_2), quad
  V_"cm" = (m_1 V_1 + m_2 V_2)/(m_1+m_2).
$

Since there is no external force on the binary star system (ignoring the planet for the time being), the binary star system can be seen as a inertial frame of reference. Therefore, we can always set its velocity and position to zero. Thus we have:

$
  X_"cm" = 0 => x_1:x_2 = m_2:m_1,
  quad V_"cm" = 0 => v_1:v_2 = m_2:m_1.
$

Similarly, there is no external torgue on the system. Then by the conservation of angular momentum:

$
  m_1 v_(1a) x_(1a) + m_2 v_(2a) x_(2a)
  =
  m_1 v_(1b) x_(1b) + m_2 v_(2b) x_(2b)
$ <amomentum>

where $x_(1a)+x_(2a)=a$ and $x_(1b)+x_(2b)=b$.

Applying the mass-ratio relation to @amomentum,

$
  (x_1)/(x_2) = (v_1)/(v_2) = m_2/m_1
$

$
  a(v_(1a)+v_(2a)) = b(v_(1b)+v_(2b)).
$

By the ratios, let

$
  v_(1a)=m_2 b u, quad v_(1b)=m_2 a u,
  quad v_(2a)=m_1 b u, quad v_(2b)=m_1 a u.
$

Substitution into @energy gives

$
  u^2 (m_1+m_2) b^2 - u^2 (m_1+m_2) a^2
  = 2G(m_1m_2)(1/a - 1/b).
$

Thus,

$
  u = sqrt((2G)/((m_1+m_2) a b (a+b))).
$

Plug $u$ back and we have the resulting speeds:

$
  v_(1a) = sqrt(2G (m_2^2)/(m_1+m_2) b^2/(a b (a+b))),
  quad
  v_(2a) = sqrt(2G (m_1^2)/(m_1+m_2) b^2/(a b (a+b))).
$ <velocity>

The corresponding expressions at the other end follow by exchanging $a$ and $b$. Meanwhile, the positions are given by

$
  x_(1a) = m_2/(m_1+m_2) a, quad
  x_(2a) = m_1/(m_1+m_2) a.
$ <position>

The results were checked against equations (108), (110), and (112) in the lecture notes and found to be consistent.

== The period of binary stars

Observe the orbit from the point of view of $m_1$. The corresponding semiaxes are

$
  a' = (m_2)/(m_1+m_2) a, quad
  b' = (m_2)/(m_1+m_2) b.
$

It is known that the center of the mass of the binary star is the focus of both elliptical orbits [1].
Therefore, assuming Kepler's laws apply to each of the stars, the period could be found. 

The area of the ellipse is

$
  A' = pi sqrt(a'b') ((a+b)/2).
$

Considering the area swept in $d t$ as a triangle, the areal velocity should be

$
  (d A')/(d t) = 1/2 v_(1 a)a'
$

Using the areal velocity, the period is

$
  T = A' ((d A')/(d t))^(-1)
    = pi/sqrt(2G) (a+b)^(3/2)/(m_1+m_2)^(1/2).
$

The period is useful for setting the total simulation time $t$, and thus setting $d t$ and `clockmax`. 
The results turned out to be consistent with the lecture notes, which took a more rigorous approach by transforming the binary star to the single-mass equivalent problem.

== Three bodies including the planet

After all, the problem is a three-body system. Therefore, by the Newton's second law and the formula for gravitation, all the bodies follow these rules:

For each body $i$, we have:

$
  (d X_i)/(d t) = V_i, quad
  (d V_i)/(d t) = sum_(j!=i) (G m_j)/r_(i j)^3 (X_j-X_i)
$ <nbody>

For the planet at a far distance from the binary star orbits, the stars could be regarded as a single star with their total mass. For a planet to rotate around in a circular orbit, by balancing the central force and the gravitational force, the velocity of the plane should be

$
  v=sqrt(G(m_1+m_2)/r)
$

where $r$ is the distance from the planet to the center of mass of the binary stars.

= Numerical Methods

== Updating rules

Following the general rules of the N-body system (@nbody), we evolve the three bodies on a discrete time grid, taking the Euler's method. For each body $i$,

$
  X_i (t + Delta t) = X_i (t) + V_i (t) Delta t,
$

$
  V_i (t + Delta t) = V_i (t) + sum_(j!=i) (G m_j)/r_(i j)^3 (X_j-X_i) Delta t,
$

where $V$ and $X$ are 3D vectors.

== Setup and conventions

Assume all binary stars orbit counter-clockwise. All planets start on the positive $x$-axis, with initial velocity along the $y$-axis. The sign of the initial velocity controls the planet's direction: use a negative sign for clockwise cases.

The reference parameters are set based on the real values of the Sun and the Earth. Specifically, we take $G$ to be the real accurate value, and $m_"ref"$ (`mm` in code) the same order ($10^30$ kg) with the Sun, $m_"planet"$ (`mp` in code) the same order ($10^24$ kg) with the Earth, omitting the mantissa. The masses of the binary stars are not exactly the $m_"ref"$, and the setup will be explained later. The reference distance $x_"ref"$ (`xx` in code) is set to be the same order as the Sun-Earth distance ($10^8$ meters).

```matlab
G = 6.6743e-11; % m^3*kg^-1*s^-2
mm = 1e30;      % reference mass, kg
mp = 1e24;      % mass of planet, kg
xx = 1e8;       % reference distance, m
```

// For the close, medium, and far cases, respectively, the planet's distance is scaled by $op("rpFactor") = 1.5, 3, 5$, and its speed is divided by $sqrt(op("rpFactor"))$ so that the planet remains on a circular orbit about the binary's total mass.

// The cases considered are:

// #table(
//   columns: 4,
//   [*Binary-star orbit*], [*Masses*], [*Planet direction*], [*Distance*],
//   [Circular], [Equal], [Counter-clockwise or clockwise], [Close / medium / far],
//   [Circular], [Unequal], [Counter-clockwise or clockwise], [Close / medium / far],
//   [Elliptical], [Unequal], [Counter-clockwise or clockwise], [Close / medium / far],
// )


The simulations are generated by the most general case function `generate_2d_general(mRatio, abRatio, rpFactor, revDirection)`, which builds the initial state of the elliptical, unequal-mass case from the reference values `mm` and `xx` together with these four parameters. To keep the formulas readable we write $q$ for `mRatio`, $k$ for `abRatio`, and $f$ for `rpFactor`. Therefore, the naive cases can be simply done by setting $q$ and $k$ to $1$ based on needs. The initial conditions goes through the following setup:

+ *Masses and semiaxes (`mRatio` and `abRatio`).* The total mass is fixed at $2 m_"ref"$ and split in the ratio $m_1 : m_2 = q : 1$, while the initial positions satisfy $a : b = k : 1$ and $a + b = 2 x_"ref"$. Thus

  $
    m_1 = (2q)/(1+q) m_"ref", quad m_2 = 2/(1+q) m_"ref",
  $

  $
    a = (2 k)/(1+k) x_"ref", quad b = 2/(1+k) x_"ref".
  $

+ *Star initial state.* The stars are placed on the $x$-axis with distance $a$ on opposite sides of the origin,

  $
    X_1 = (x_(1a), 0, 0), quad X_2 = (-x_(2a), 0, 0),
  $

  where the $x$ are derived in @position.

  Their velocities are derived by @velocity and the directions are chosen so that the binary stars rotates counter-clockwise,

  $
    V_1 = (0, v_(1a), 0), quad V_2 = (0, -v_(2a), 0).
  $

+ *Planet initial state.* The planet starts on the positive $x$-axis at star 1 (which is unrealistic and will be corrected in step 4), moving along the $y$-axis with the speed of a circular orbit about the total mass at that radius,

  $
    X_3 = (x_(1a), 0, 0), quad
    V_3 = (0, v_p, 0), quad
    v_p = sqrt(G (m_1+m_2)/(r_(1a))).
  $

+ *Distance scaling (`rpFactor`).* The planet's distance is multiplied by $f$ and its speed is divided by $sqrt(f)$,
  #footnote[The left arrow means updating the value, which is essentially the `=` sign in Matlab language.]

  $
    X_3 arrow.l f X_3, quad V_3 arrow.l V_3/sqrt(f).
  $ 

  Since $v prop 1/sqrt(r)$, this keeps the planet on a circular orbit while moving it to $f$ times its original distance. Larger $f$ therefore places the planet farther from the binary (the "far" case) with a correspondingly smaller orbital speed.

+ *Direction (`revDirection`).* If `revDirection` is true, the planet's velocity is reversed,

  $
    V_3 arrow.l -V_3,
  $

  so the planet travels clockwise while the binary still rotates
  counter-clockwise. 

= Validation

There are no external force on the 3-body system, so the total momentum should be conserved. Therefore, we use momentum to validate the simulation. If the total momentum reaches $10%$ away from the initial momentum, we throw a warnimg message in the code. Usually, a sudden turn of the planet indicates a numerical error, and we have to refine the timesteps to produce more accurate results.

= Results and Discussion (2D cases)

In all following figures of the trails in this section, the red and green lines stand for the binary stars, and the blue lines are the planet.

== Batch running and legacy mode

We first run the simulations in batches to find interesting patterns.
These were the results in the presentation.
The first version of the code set some initial conditions differently as described above, which we will call "legacy mode" from now on.
However, the N-body simulation was still correct in this version, and the results were interesting, so they are still kept being discussed here.

The first version of the code used the following configuration:

- Binary-star orbits and masses:
  - Circular orbit, equal mass: $q=1, space k=1$.
  - Circular orbit, unequal mass: $q=1.5, space k=1$.
  - Elliptical orbit, unequal mass: $q=1.5, space k=2.5$.
- Distance scaling: $f = 1.3, space 2, space 5$.
- Planet speed
  - $v_p$ was set to $v_1$ rather than to the speed of a circular orbit, $sqrt(G(m_1+m_2)/r_p)$. 
  - $v_p$ did not scale with $sqrt(f)$.

It was also found in batch running (in either legacy mode or normal mode) that setting the planet in the opposite direction of the binary stars has a higher chance of finding an interesting pattern that the planet rotates instead of crashing to a star or escape the binary-star system. 

== Equal mass, circular orbit

This pattern is first found in the legacy mode when $q=1, space k=1, space f=2$ but with $v_p=v_1$, and the planet travelling clockwise (opposite to the binary stars), which is shown in the 6th figure below.
Then, different initial $v_p$'s are tried by scaling $v_1$ with a factor, as the captions under the graphs indicate. 
#footnote[The titles embedded in the images follow the pattern: \
m\<`mRatio`\>-ab\<`abRatio`\>-rpf\<`rpFactor`\>-rev\<`revDirection`\>-vp\<`vplanet`\> \
Setting `vplanet` to 0 means standard mode, while giving it a speed imitates legacy mode.]

#let L122-images = (
  (file: "m1-ab1-rpf2-rev1-vp173304.png",   caption: $v_p= 0.3v_1$),
  (file: "m1-ab1-rpf2-rev1-vp346608.png",   caption: $v_p= 0.6v_1$),
  (file: "m1-ab1-rpf2-rev1-vp519912.png",   caption: $v_p= 0.9v_1$),
  (file: "m1-ab1-rpf2-rev1-vp548796.png",   caption: $v_p= 0.95v_1$),
  (file: "m1-ab1-rpf2-rev1-vp571903.2.png", caption: $v_p= 0.99v_1$),
  (file: "m1-ab1-rpf2-rev1-vp577680.png",   caption: $v_p= 1.0v_1$),
  (file: "m1-ab1-rpf2-rev1-vp589233.6.png", caption: $v_p= 1.02v_1$),
  (file: "m1-ab1-rpf2-rev1-vp693216.png",   caption: $v_p= 1.2v_1$),
  (file: "m1-ab1-rpf2-rev1-vp866520.png",   caption: $v_p= 1.5v_1$),
)

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 12pt,
    align: center + bottom,
    ..L122-images.map(item => [
      #image("./figures/v1/L122type/" + item.file, width: 100%)
      #text(size: 8pt, fill: luma(80), item.caption)
    ])
  ), 
  caption: [Equal mass, circular orbit binary stars with different $v_p/v_1$ ratios 
  #footnote[The red and green trails of the binary stars overlap.]
  ],
  placement: auto
) <L122-orbits>

It can be seen from @L122-orbits that only a small range of initial $v_p$ around $1.0 v_1$ yields a regular pattern. 
Tuning the initial velocity too high will give the planet too much kinetic energy and causing it to escape from the binary stars. 

On the other hand, lowewr initial velocities yields more chaotic trails for the planet, with the curves reaching variable distances from the center of mass.
This might be because the gravity from the stars have more significant influences over the inertia of the planet, and therefore the phases of the binary stars matters more.

It is worth noticing that the planet is mostly closer to one star when $r_p/r_1$ is small.
@L122-distance shows the distance from the planet to the stars over time, with the $v_p=v_1$, which corresponds to the 6th case above in @L122-orbits.

#figure(
  image("figures/v1/L122type/dist-m1-ab1-rpf2-rev1-vp577680.png"),
  caption: [Distance from the planet to the 2 stars when $v_p=v_1$]
) <L122-distance>

== Unequal mass, circular orbit

#let B221-images = (
  (file: "m1.5-ab1-rpf1.3-rev1-vp0.png", caption: $f=1.3$),
  (file: "m1.5-ab1-rpf1.5-rev1-vp0.png", caption: $f=1.5$),
  (file: "m1.5-ab1-rpf1.7-rev1-vp0.png", caption: $f=1.7$),
)

#figure(
  grid( columns: (1fr, 1fr, 1fr),
    gutter: 12pt,
    align: center + bottom,
    ..B221-images.map(item => [
      #image("./figures/v1/B221type/" + item.file, width: 100%)
      #text(size: 8pt, fill: luma(80), item.caption)
    ])
  ),
  caption: [Orbits of the planet in unequal-mass binary stars with different $f$]
) <B221-orbits>

@B221-orbits shows the similar pattern when the masses of the binary stars are unequal, while the $v_p$ is scaled properly to the "ideal" circular speed based on $f$. 
Since $m_1!=m_2$, the orbits of the binary stars differ. 
When $f$ is small enough, it is possible that the planet always rotate around the inner star. 
This could be caused by 3 reasons:
+ The small $f$ yields small $v_p$, thus the acceleration by gravity is more significant to the velocity of the planet.
+ The inner star has larger mass, so the gravity from that star is larger.
+ The planet start close to the heavier inner star, with the other star on the opposite side of the origin. The long distance to the lighter star yields smaller gravity from that star. 

== Unequal mass, elliptical orbits

It could be still possible to find the planet rotating dominated by one star when the binary stars are elliptical. 
As shown in @elliptical-orbits, setting the planet in the opposite direction of the binary stars is still more likely to let the planet rotate regularly. 
The binary star parameters are set to $q=1.5, space k=2.5$.

Setting the planet close enough (i.e. setting $f$ to be small enough) helps the planet to rotate around a single star, barely affected by the other star, as indicated in the "$f=1.2$, opposite" case in @elliptical-orbits.
However, in the simulations, we failed to find a case where the planet switches significantly between two stars regularly. 

#let elliptical-images = (
  (file: "m1.5-ab2.5-rpf1.2-rev0-vp0.png", caption: $f=1.2$),
  (file: "m1.5-ab2.5-rpf2-rev0-vp0.png",   caption: $f=2$),
  (file: "m1.5-ab2.5-rpf3-rev0-vp0.png",   caption: $f=3$),
  (file: "m1.5-ab2.5-rpf1.2-rev1-vp0.png", caption: [$f=1.2$, opposite]),
  (file: "m1.5-ab2.5-rpf2-rev1-vp0.png",   caption: [$f=2$, opposite]),
  (file: "m1.5-ab2.5-rpf3-rev1-vp0.png",   caption: [$f=3$, opposite]),
)

#figure(
  grid( columns: (1fr, 1fr, 1fr),
    gutter: 12pt,
    align: center + bottom,
    ..elliptical-images.map(item => [
      #image("./figures/v1/elliptical/" + item.file, width: 100%)
      #text(size: 8pt, fill: luma(80), item.caption)
    ])
  ),
  caption: [Orbits of the planet in elliptical binary stars with different $f$.]
) <elliptical-orbits>

== Distances

To explore how the distance from the planet to the origin matters to the orbit of the planet, we set $f=3, 4, 5, 7$ respectively with the binary stars staying $q=2, k=4$, the planet travelling the opposite direction with the binary stars. 
We started at $f=3$ to avoid the planet travelling between the stars and eventually crashing. 

#let distance-images = (
  (file: "m2-ab4-rpf3-rev1-vp0.png", caption: $f=3$),
  (file: "m2-ab4-rpf4-rev1-vp0.png", caption: $f=4$),
  (file: "m2-ab4-rpf5-rev1-vp0.png", caption: $f=5$),
  (file: "m2-ab4-rpf7-rev1-vp0.png", caption: $f=7$),
)

#figure(
  grid( columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 12pt,
    align: center + bottom,
    ..distance-images.map(item => [
      #image("./figures/v1/distance/" + item.file, width: 100%)
      #text(size: 8pt, fill: luma(80), item.caption)
    ])
  ),
  caption: [Distance from the planet to the binary stars with different $f$.]
) <distance-plots>

As shown in @distance-plots, as $f$ grows larger, the planet orbit behaves more like a circle. 
When $f=3$ in this case, the planet get attracted and goes inwards.
When $f=4$, the planet orbits outside of the binary star orbits, but the planet orbit is not very close to a circle.
When $f=5,7$, the planet gets closer to a circular orbit with only a small deviation.
However, there is no specific threshold for the behavior. 


= Results and Discussion (3D cases)

In the 3D case, we set the planet intially at the origin for all simulations. We then set the following:

- Case 1 (the base case): $q=1, k=2$. The planet has an initial velocity along the positive $z$-axis, with magnitude $v_(1a)$. 
- Case 2: Based on case 1, we give the planet an additional initial velocity on the $y$-axis, setting $V_p (0)=(0, 0.01 v_(1a), v_(1a))$.
- Case 3: Based on case 1, we set $q=1.1$ instead.

#let three-d-images = (
  (file: "3d-m1-ab2.png",     caption: [Case 1 (the base case)]), 
  (file: "3d-m1-ab2-per.png", caption: [Case 2]), 
  (file: "3d-m1.1-ab2.png",   caption: [Case 3]),
)

#figure(
  grid( columns: (1fr, 1fr, 1fr),
    gutter: 12pt,
    align: center + bottom,
    ..three-d-images.map(item => [
      #image("./figures/v1/3d/" + item.file, width: 100%)
      #text(size: 8pt, fill: luma(80), item.caption)
    ])
  ),
  caption: [Three-dimensional simulation results.]
) <3d-plots>

From @3d-plots and viewing them in live animation
#footnote[I did not export the animations as videos, but they are explained here by words.]
, we can conclude from each case:

- In case 1, the planet oscillates along the $z$-axis periodically. 
  The acceleration of the planet depends both on the phase of the binary stars and the $z$ position of the planet itself. 
  Specifically, the farther the stars are, the smaller the acceleration; the farther the planet is away from the origin, the larger the acceleration.
  This makes sense as the angles of gravitational forces and the distance of the bodies change.
- Case 2 indicates that case 1 is not a stable state. 
  Giving a small pertubation to the horizontal velocity of the planet causes significant difference in its orbit.
- Case 3 indicates that the oscillation happens only when the binary stars are of equal mass. 
  Even slightly tuning $q=1.1$ causes the planet to escape in this case. 
  Crashes or other patterns are also possible, but the osciallation is broken.

= Conclusion

We modelled a planet in a binary star system as a three-body problem and evolved it
with the Euler method, using the initial conditions derived from energy, momentum, and
angular-momentum conservation, see @energy and @velocity. Momentum conservation served as the
validation criterion of the code.

In the 2D cases, the planet's trajectory turned out to be strongly sensitive to all of the
tuned parameters:

- Around a circular, equal-mass binary, only a narrow band of initial speeds near $v_p approx v_1$
  gives a regular orbit (@L122-orbits); too large a speed lets the planet escape, while too small
  a speed produces chaotic trails.
- For unequal masses (@B221-orbits) and for elliptical orbits (@elliptical-orbits), the planet
  can be captured by the heavier inner star when its initial distance is small enough, since it
  starts close to that star with a small speed.
- Sending the planet in the direction opposite to the binary stars is consistently more likely to
  produce a regular rotating orbit, and a larger $f$ makes the planet's orbit increasingly close to
  a circle (@distance-plots), as expected from treating the binary as a single mass.

In the 3D cases, a planet released from the center of mass with a velocity along $z$ oscillates
along the $z$-axis when the binary stars are equal in mass and on a circular orbit (@3d-plots).
The oscillation is, however, not stable: a small horizontal perturbation (case 2) drastically
changes the orbit, and even a $10%$ mass difference (case 3) destroys the oscillation, ending in an
escape or a crash. Thus the observed oscillation is a delicate, symmetric configuration rather than
a robust feature of the system.

= Future Discussion

The three-body system is generally not solvable[2]. 
Though this project restricts the problem by setting a solved binary-star system with a much smaller mass (the planet), it turns out that the behavior of the planet is still complex to study. 
This project could be extended in the following ways:

For the 2D case:
- The initial velocity of the planet was always set along the $y$-axis. However, more directions could be tested.
- The positions of the planet and the binary stars always start on the $x$-axis. 
  There are more possible phases for the planet according to the binary stars. 
  What's more, $q$ was set always larger than 1, letting the planet to start on the side with heavier star. 
  It could be different if the planet is initally closer to the lighter star.
- The elliptical-orbit binary stars are highly tunable. 
  It could be possible to find more patterns in this case. 
  It remains unknown if there are possibilities that the orbit of the planet transforms between two or more patterns (for example, rotating around one star for some time and around another star for some time).

For the 3D case:
- Instead of studying the oscillation starting from the origin, the stability of the patterns seen in 2D cases given a $z$-axis component in the planet's initial velocity could also be discussed.

= Reference

[1] University of Alberta. _Lecture 13: Binary Star Systems, Masses of Stars._ https://sites.ualberta.ca/~pogosyan/teaching/ASTRO_122/lect13/lecture13.html\
[2] EBSCO. _Three-Body Problem._ https://www.ebsco.com/research-starters/history/three-body-problem/

#pagebreak()
// Appendix: restart heading numbering and use letters instead of digits.
#counter(heading).update(0)
#set heading(numbering: (..nums) => {
  let nums = nums.pos()
  let letters = nums.map(n => numbering("A", n))
  letters.join(".") + "."
})

= Appendix

The handwritten notes below record the derivation of the initial conditions and the
simulation plan described in the _Equations_ and _Numerical Methods_ sections.

#figure(
  image("Mynotes.jpg", width: 100%),
  caption: [Handwritten notes taken while deriving the equations and planning the simulations.]
) <appendix-notes>