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

Reference parameters:

```matlab
G = 6.6743e-11; % m^3*kg^-1*s^-2
mm = 1e30;      % reference mass, kg
mp = 1e24;      % mass of planet, kg
xx = 1e8;       % reference distance, m
```

For the close, medium, and far cases, respectively, the planet's distance is scaled by $op("rpFactor") = 1.5, 3, 5$, and its speed is divided by $sqrt(op("rpFactor"))$ so that the planet remains on a circular orbit about the binary's total mass.

The cases considered are:

#table(
  columns: 4,
  [*Binary-star orbit*], [*Masses*], [*Planet direction*], [*Distance*],
  [Circular], [Equal], [Counter-clockwise or clockwise], [Close / medium / far],
  [Circular], [Unequal], [Counter-clockwise or clockwise], [Close / medium / far],
  [Elliptical], [Unequal], [Counter-clockwise or clockwise], [Close / medium / far],
)

=== Initial conditions from the parameters

The simulations are generated by the most general case function
`generate_2d_general(mRatio, abRatio, rpFactor, revDirection)`, which builds the
initial state of the elliptical, unequal-mass case from the reference values
`mm` and `xx` together with these four parameters. To keep the formulas
readable we write $m_"ref"$ for `mm`, $x_"ref"$ for `xx`, $q$ for `mRatio`,
$k$ for `abRatio`, and $f$ for `rpFactor`.

*Masses and semiaxes.* The total mass is fixed at $2 m_"ref"$ and split in the
ratio $m_1 : m_2 = q : 1$, while the initial positions satisfy
$a : b = k : 1$ and $a + b = 2 x_"ref"$. Thus

$
  m_1 = (2q)/(1+q) m_"ref", quad m_2 = 2/(1+q) m_"ref",
$

$
  a = (2 k)/(1+k) x_"ref", quad b = 2/(1+k) x_"ref".
$

*Star initial state.* The stars are placed on the $x$-axis with distance $a$ on opposite sides of the origin,

$
  X_1 = (r_(1a), 0, 0), quad X_2 = (-r_(2a), 0, 0),
$

$
  r_(1a) = a (m_2)/(m_1+m_2), quad r_(2a) = a (m_1)/(m_1+m_2).
$

Their speeds follow from the energy and angular-momentum results derived above,

$
  v_(1a) = (sqrt(2G) m_2 b)/(sqrt((m_1+m_2) a b (a+b))),
  quad
  v_(2a) = (sqrt(2G) m_1 b)/(sqrt((m_1+m_2) a b (a+b))),
$

and the directions are chosen so that the binary rotates counter-clockwise,

$
  V_1 = (0, v_(1a), 0), quad V_2 = (0, -v_(2a), 0).
$

*Planet initial state.* The planet starts on the positive $x$-axis at star 1,
moving along the $y$-axis with the speed of a circular orbit about the total
mass at that radius,

$
  X_3 = (r_(1a), 0, 0), quad
  V_3 = (0, v_p, 0), quad
  v_p = sqrt(G (m_1+m_2)/(r_(1a))).
$

*Distance scaling (`rpFactor`).* The planet's distance is multiplied by $f$ and
its speed is divided by $sqrt(f)$,
#footnote[The left arrow means updating the value, which is essentially the `=` sign in Matlab language.]

$
  X_3 arrow.l f X_3, quad V_3 arrow.l V_3/sqrt(f).
$ 

Since $v prop 1/sqrt(r)$, this keeps the planet on a circular orbit while
moving it to $f$ times its original distance. Larger $f$ therefore places the
planet farther from the binary (the "far" case) with a correspondingly smaller
orbital speed.

*Direction (`revDirection`).* If `revDirection` is true, the planet's velocity
is reversed,

$
  V_3 arrow.l -V_3,
$

so the planet travels clockwise while the binary still rotates
counter-clockwise. 

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