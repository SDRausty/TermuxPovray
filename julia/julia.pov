#version 3.0;

// By Jonathan Hunt <jonathan@xlcus.com>

camera {
  location <0, 0.1, -1.9>
  look_at <0.28, 0.15, 0>
}

light_source {
  <80, 80, -160>
  color rgb<0.9, 0.9, 0.9>
}

light_source {
  <80, 80, -160>
  color rgb<0.1, 0.1, 0.1>
  shadowless
}

sky_sphere {
  pigment {
    gradient y
    color_map {
      [0.0 color rgb<0.8, 1.0, 1.0>]
      [0.3 color rgb<0.5, 1.0, 1.0>]
      [1.0 color rgb<0.0, 0.5, 1.0>]
    }
  }
}

plane {
  y, 0
  pigment {color rgb<1, 1, 1>}
  finish {
    reflection 1
    ambient 0
    diffuse 0
  }
  normal {
    bumps 0.2 scale 0.01
  }
}

plane {
  -y, -500
  pigment {
    bozo
    turbulence .6
    omega 0.7
    color_map {
      [0.0 color rgbt<1, 1, 1, 0>]
      [0.8 color rgbt<1, 1, 1, 1>]
    }
    scale 500
    rotate <5, -15, 0>
  }
  finish { ambient 1 diffuse 0 }
}

julia_fractal {
  <-0.383, 0.2, -0.73, 0.025>
  quaternion
  sqr
  max_iteration 10
  precision 4096
  slice <0, 0, 0, 1>, 0
  pigment {
    gradient x
    color_map {
      [0/6 rgb<1, 0, 0>]
      [1/6 rgb<1, 1, 0>]
      [2/6 rgb<0, 1, 0>]
      [3/6 rgb<0, 1, 1>]
      [4/6 rgb<0, 0, 1>]
      [5/6 rgb<1, 0, 1>]
      [6/6 rgb<1, 0, 0>]
    }
    scale 2
    translate <-4.45, 0, 0>
  }
  rotate <0, 90, 0>
  normal {granite 0.8 scale 0.03}
  finish {diffuse 0.9 ambient 0.1}
}

julia_fractal {
  <-0.95, -0.2, 0.1, -0.1>
  quaternion
  sqr
  max_iteration 8
  precision 4096
  slice <0, 0, 0, 1>, 0
  pigment {
    gradient x
    color_map {
      [0/6 rgb<1, 0, 0>]
      [1/6 rgb<1, 1, 0>]
      [2/6 rgb<0, 1, 0>]
      [3/6 rgb<0, 1, 1>]
      [4/6 rgb<0, 0, 1>]
      [5/6 rgb<1, 0, 1>]
      [6/6 rgb<1, 0, 0>]
    }
    scale 2
    translate <-4, 0, 0>
  }
  scale <0.1, 0.1, 0.1>
  rotate<45, 0, 90>
  translate<-0.09, -0.001, -1.55>
  normal {crackle 0.5 scale 0.005}
  finish {diffuse 0.9 ambient 0.1}
}

julia_fractal {
  <0.55, 0.2, -0.3, -0.1>
  quaternion
  sqr
  max_iteration 5
  precision 4096
  slice <0, 0, 0, 1>, 0
  pigment {
    gradient x
    color_map {
      [0/6 rgb<1, 0, 0>]
      [1/6 rgb<1, 1, 0>]
      [2/6 rgb<0, 1, 0>]
      [3/6 rgb<0, 1, 1>]
      [4/6 rgb<0, 0, 1>]
      [5/6 rgb<1, 0, 1>]
      [6/6 rgb<1, 0, 0>]
    }
    scale 0.5
    translate <4.2, 0, 0>
    rotate <0, 10, 5>
  }
  scale <0.1, 0.1, 0.1>
  rotate<0, -10, 90>
  translate<0.10, -0.041, -1.64>
  normal {crackle 0.2 scale 0.005}
  finish {diffuse 0.9 ambient 0.1}
}

julia_fractal {
  <-0.08, 0.1, -0.9, -0.1>
  quaternion
  sqr
  max_iteration 7
  precision 4096
  slice <0, 0, 0, 1>, 0
  pigment {
    gradient x
    color_map {
      [0/6 rgb<1, 0, 0>]
      [1/6 rgb<1, 1, 0>]
      [2/6 rgb<0, 1, 0>]
      [3/6 rgb<0, 1, 1>]
      [4/6 rgb<0, 0, 1>]
      [5/6 rgb<1, 0, 1>]
      [6/6 rgb<1, 0, 0>]
    }
    scale 2
    translate <5, 0, 0>
    rotate<0, 0, 0>
  }
  scale <0.2, 0.05, 0.1>
  rotate <0, 40, 0>
  translate<0.054, -0.02, -1.2>
  normal {granite 0.4 scale 0.01}
  finish {diffuse 0.9 ambient 0.1}
}
