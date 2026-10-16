#set document(title: "A Planet in a Binary Star System", author: ("Yizhou Lu", "Ruimeng Yang"))
#set page(paper: "us-letter", margin: (x: 1in, y: 0.85in))
#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true, leading: 0.7em)
#set heading(numbering: "1.")

#align(center)[
  #text(size: 20pt, weight: "bold")[A Planet in a Binary Star System]
  #v(0.4em)
  Yizhou Lu · Ruimeng Yang
]

#v(1em)
#outline()
#pagebreak()

= Introduction

A binary star system consists of two stars that orbit their common center of mass. A planet that orbits both stars is called a circumbinary planet. Its motion is far more intricate than that of a planet around a single star, because the planet feels the gravitational pull of two stars whose positions change with time. This makes such systems an interesting setting for studying orbital dynamics and for testing numerical methods.

In this project we simulate the motion of a planet in a binary star system and investigate how the planet's trajectory depends on the configuration of the system. The study is divided into two parts, summarized below.

- 2D case
  - The orbits of the binary stars
  - The direction of the planet
  - The distance of the planet from the center of mass (CM) of the binary stars
- 3D case
  - Oscillation in the $z$-axis
  - The stability of the oscillation

The bullet points under the 2D case list the hyperparameters that we tune; their choice determines the binary-star orbit, the sense in which the planet travels, and how tightly the planet is bound. In the 3D case we ask whether the planet's vertical motion remains bounded, or whether it grows without limit and the planet is eventually ejected.

= Methodology: Binary Star

== Naive cases

Two simple cases are considered:
1. Circular orbits with equal mass.
2. Circular orbits with unequal mass.

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
  v_1 = sqrt((G m_2 r_1))/(r_1+r_2), quad
  v_2 = sqrt((G m_1 r_2))/(r_1+r_2)
$

$
  omega = sqrt((G m_2)/r_1)/(r_1+r_2), quad
  T = (2 pi)/omega.
$

== Designing the orbit

Given semiaxes $a,b$ and masses $m_1,m_2$, determine the speeds at the two ends of the orbit. The derivation below uses energy conservation, the center-of-mass condition, and conservation of angular momentum. The relative position and velocity vectors $X=X_1-X_2$ and $U=U_1-U_2$ are not used here.

At the two ends of the orbit, let the separations be $a$ and $b$, and denote the corresponding speeds by $v_{1a},v_{2a},v_{1b},v_{2b}$.

Conservation of energy:

$
  1/2 m_1 v_(1a)^2 + 1/2 m_2 v_(2a)^2 - G (m_1 m_2)/a
  =
  1/2 m_1 v_(1b)^2 + 1/2 m_2 v_(2b)^2 - G (m_1 m_2)/b
  (1)
$

The center of mass and center-of-mass velocity are

$
  X_"cm" = (m_1 X_1 + m_2 X_2)/(m_1+m_2), quad
  V_"cm" = (m_1 V_1 + m_2 V_2)/(m_1+m_2).
$

Choosing the center-of-mass frame gives

$
  X_"cm" = 0 => X_1:X_2 = m_2:m_1,
  quad V_"cm" = 0 => v_1:v_2 = m_2:m_1.
$

Conservation of angular momentum:

$
  m_1 v_(1a) X_(1a) + m_2 v_(2a) X_(2a)
  =
  m_1 v_(1b) X_(1b) + m_2 v_(2b) X_(2b)
  (2)
$

where $X_{1a}+X_{2a}=a$ and $X_{1b}+X_{2b}=b$.

Applying the mass-ratio relation to equation (2),

$
  (X_1)/(X_2) = (v_1)/(v_2) = m_2/m_1
$

$
  a(v_(1a)+v_(2a)) = b(v_(1b)+v_(2b)).
$

Let

$
  v_(1a)=m_2 b u, quad v_(1b)=m_2 a u,
  quad v_(2a)=m_1 b u, quad v_(2b)=m_1 a u.
$

Substitution into equation (1) gives

$
  u^2 (m_1+m_2) b^2 - u^2 (m_1+m_2) a^2
  = 2G(m_1m_2)(1/a - 1/b).
$

Thus,

$
  u = sqrt((2G)/((m_1+m_2) a b (a+b))).
$

The resulting speeds are

$
  v_(1a) = sqrt(2G (m_2^2)/(m_1+m_2) b^2/(a b (a+b))),
  quad
  v_(2a) = sqrt(2G (m_1^2)/(m_1+m_2) b^2/(a b (a+b))).
$

The corresponding expressions at the other end follow by exchanging $a$ and $b$.

The results were checked against equations (108), (110), and (112) in the lecture notes and found to be consistent.

== Calculating the period

Observe the orbit from the point of view of $m_1$. The corresponding semiaxes are

$
  a' = (m_2)/(m_1+m_2) a, quad
  b' = (m_2)/(m_1+m_2) b.
$

By checking online, the center of the mass of the binary star is the focus of both elliptical orbits.
Therefore, assuming Kepler's laws apply to each of the stars, the period could be found. 
The results are consistent with the lecture notes, which took a more rigorous approach by transforming the binary star to the single-mass equivalent problem.

The area of the ellipse is

$
  A' = pi sqrt(a'b') ((a+b)/2).
$

Using the areal velocity, the period is

$
  T = A' ((d A')/(d t))^(-1)
    = pi/sqrt(2G) (a+b)^(3/2)/(m_1+m_2)^(1/2).
$

The period is useful for setting the total simulation time $t$, and thus setting $d t$ and `clockmax`. This expression was inferred by comparison with the period for a body orbiting a central mass; it was assumed to be correct.

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
