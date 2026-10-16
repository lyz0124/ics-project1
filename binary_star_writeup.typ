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

== Binary star orbits

Two simple cases are considered:
1. Circular orbits with equal mass.
2. Circular orbits with unequal mass.

Then, the more general form of elliptical orbits with unequal masses are discussed.

=== Circular orbits with equal mass

For $m_1=m_2=m$, with each star at distance $r$ from the center of mass,

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

The orbital speeds and angular velocity are

$
  v_1 = sqrt(G m_2 r_1)/(r_1+r_2), quad
  v_2 = sqrt(G m_1 r_2)/(r_1+r_2)
$

$
  omega = sqrt((G m_2)/r_1)/(r_1+r_2), quad
  T = (2 pi)/omega.
$

=== Designing the general orbits

Given semiaxes $a,b$ and masses $m_1,m_2$, determine the speeds at the two ends of the orbit. The derivation below uses energy conservation, the center-of-mass condition, and conservation of angular momentum. The relative position and velocity vectors $X=X_1-X_2$ and $U=U_1-U_2$ are not used here.

At the two ends of the orbit, let the separations be $a$ and $b$, and denote the corresponding speeds by $v_(1a), v_(2a),v_(1b),v_(2b)$.

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
  X_"cm" = 0 => X_1:X_2 = m_2:m_1,
  quad V_"cm" = 0 => v_1:v_2 = m_2:m_1.
$

Similarly, there is no external torgue on the system. Then by the conservation of angular momentum:

$
  m_1 v_(1a) X_(1a) + m_2 v_(2a) X_(2a)
  =
  m_1 v_(1b) X_(1b) + m_2 v_(2b) X_(2b)
$ <amomentum>

where $X_(1a)+X_(2a)=a$ and $X_(1b)+X_(2b)=b$.

Applying the mass-ratio relation to @amomentum,

$
  (X_1)/(X_2) = (v_1)/(v_2) = m_2/m_1
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
$

The corresponding expressions at the other end follow by exchanging $a$ and $b$.

The results were checked against equations (108), (110), and (112) in the lecture notes and found to be consistent.

=== Calculating the period

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

== Three bodies: the planet



= Numerical Methods

We evolve the three bodies on a discrete time grid. For each body $i$,

$
  X_i (t + d t) = X_i (t) + V_i (t) d t,
$

$
  V_i (t + d t) = V_i (t) + A_i (t) d t,
$

repeated $3000$ times.

The simulation (`binary_star_v1.m`) integrates the three-body problem directly in SI units. We store the positions and velocities in state arrays $bold(x)$ and $bold(v)$ and update them every step by Newtonian gravity.

*Force evaluation.* Each step we sum the pairwise gravitational accelerations over all body pairs $(i,j)$:

$
  bold(a)_i = sum_(j != i) G m_j (bold(x)_j - bold(x)_i)/abs(bold(x)_j - bold(x)_i)^3.
$

Both partners are updated with the reaction, so the total momentum is conserved exactly.

*Time integration.* We use explicit Euler with a kick-then-drift (symplectic) order,

$
  bold(v)_i arrow.r.long bold(v)_i + bold(a)_i d t, quad
  bold(x)_i arrow.r.long bold(x)_i + bold(v)_i d t,
$

with a fixed step $d t = T\/1000$ and $3000$ steps (three full periods), where $T$ is set from the period formulas above. The reference scales ($G$, $m_m$, $x_x$) keep the numbers well conditioned. Positions and velocities are appended to history arrays $t s a v e$, $x s a v e$, $v s a v e$ for plotting and trails.

= Results: 2D

== Setup and conventions

Assume all binary stars orbit counter-clockwise. All planets start on the positive $x$-axis, with initial velocity along the $y$-axis. The sign of the initial velocity controls the planet's direction: use a negative sign for clockwise cases.

Reference parameters:

```matlab
G = 6.6743e-11; % m^3*kg^-1*s^-2
mm = 1e30;      % reference mass, kg
mp = 1e24;      % mass of planet, kg
xx = 1e8;       % reference distance, m
```

For the close, medium, and far cases, respectively, multiply the planet's initial velocity by $1.3$, $2$, and $5$.

The cases considered are:

#table(
  columns: 4,
  [*Binary-star orbit*], [*Masses*], [*Planet direction*], [*Distance*],
  [Circular], [Equal], [Counter-clockwise or clockwise], [Close / medium / far],
  [Circular], [Unequal], [Counter-clockwise or clockwise], [Close / medium / far],
  [Elliptical], [Unequal], [Counter-clockwise or clockwise], [Close / medium / far],
)

== Circular orbit, equal mass

```matlab
m0 = mm;
r = xx;
v0 = sqrt(G*m0/4/r);
omega = sqrt(G*m0/(4*r^3));

m = [m0 m0 mp];
x = [r 0 0; -r 0 0; r 0 0];
v = [0 v0 0; 0 -v0 0; 0 v0 0];
T = 2*pi/omega;
```

#figure(
  caption: [Simulation plots for the circular-orbit, equal-mass case.]
)[
  #align(center)[_Insert plots from the presentation or simulation here._]
]

== Circular orbit, unequal mass

```matlab
mRatio = 1.5;
m1 = mm * 2 * mRatio / (mRatio + 1);
m2 = mm * 2 * 1 / (mRatio + 1);
r1 = xx * 2 * 1 / (mRatio + 1);
r2 = xx * 2 * mRatio / (mRatio + 1);
v1 = sqrt(G*m2*r1)/(r1+r2);
v2 = sqrt(G*m1*r2)/(r1+r2);
omega = sqrt(G*m2/r1)/(r1+r2);

m = [m1 m2 mp];
x = [r1 0 0; -r2 0 0; r1 0 0];
v = [0 v1 0; 0 -v2 0; 0 v1 0];
T = 2*pi/omega;
```

#figure(
  caption: [Simulation plots for the circular-orbit, unequal-mass case.]
)[
  #align(center)[_Insert plots from the presentation or simulation here._]
]

== Elliptical orbit, unequal mass

```matlab
mRatio = 1.5;
m1 = mm * 2 * mRatio / (mRatio + 1);
m2 = mm * 2 * 1 / (mRatio + 1);
abRatio = 2.5;
a = xx * 2 * abRatio / (abRatio + 1);
b = xx * 2 * 1 / (abRatio + 1);
r1a = a * 2 * 1 / (mRatio + 1);
r2a = a * 2 * mRatio / (mRatio + 1);
v1a = sqrt(2*G)*m2*b/sqrt((m1+m2)*a*b*(a+b));
v2a = sqrt(2*G)*m1*b/sqrt((m1+m2)*a*b*(a+b));

m = [m1 m2 mp];
x = [r1a 0 0; -r2a 0 0; r1a 0 0];
v = [0 v1a 0; 0 -v2a 0; 0 v1a 0];
T = 2*pi * sqrt((a+b)^3) / sqrt(2*G*(m1+m2));
```

#figure(
  caption: [Simulation plots for the elliptical-orbit, unequal-mass case.]
)[
  #align(center)[_Insert plots from the presentation or simulation here._]
]

= Results: 3D

#figure(
  caption: [Three-dimensional simulation results.]
)[
  #align(center)[_Insert the 3D simulation plots here._]
]

= Future Discussion

1. More elliptical orbits.
2. Adjust the planet's initial velocity (direction and magnitude).
3. Try to find more patterns.

= Reference

[1] Lecture 13: Binary Star Systems, Masses of Stars (https://sites.ualberta.ca/~pogosyan/teaching/ASTRO_122/lect13/lecture13.html)