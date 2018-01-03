#version 3.1;

// By Jonathan Hunt <jonathan@xlcus.com>

#declare TulipHeadTexture = texture
{
  pigment
  {
    bumps

    color_map {
      [0.0 colour rgb<0.9, 0.0, 0.0>]
      [1.0 colour rgb<0.8, 0.0, 0.2>]
    }

    scale <0.005, 0.02, 0.005>
  }

  normal
  {
    bumps 0.25
    scale <0.025, 1, 0.025>
  }

  finish
  {
    phong 0.5
    phong_size 25
  }
}

#declare TulipStemTexture = texture
{
  pigment
  {
    bumps

    color_map {
      [0.0 colour rgb<0.5, 0.5, 0.4>]
      [1.0 colour rgb<0.3, 0.4, 0.1>]
    }

    scale <0.005, 0.08, 0.005>
  }

  normal
  {
    bumps 0.25
    scale <0.025, 1, 0.025>
  }

  finish
  {
    ambient 0.0
  }
}

#declare GrassTexture = texture
{
  pigment
  {
    bumps

    color_map {
      [0.0 colour rgb<0.6, 0.6, 0.6>]
      [1.0 colour rgb<0.3, 0.7, 0.2>]
    }

    scale <0.005, 0.5, 0.005>
  }

  normal
  {
    bumps 0.25
    scale <0.03, 2, 0.03>
  }

  finish
  {
    ambient 0.0
    diffuse 0.5
  }
}

#declare WindmillBladesTexture = texture
{
  pigment
  {
    colour rgb<0.2, 0.2, 0.0>
  }
}

#declare WindmillBaseTexture = texture
{
  pigment
  {
    bumps

    color_map {
      [0.0 colour rgb<0.5, 0.5, 0.4>]
      [1.0 colour rgb<0.8, 0.8, 0.8>]
    }

    scale 2
  }
}


#declare PetalBlob = blob
{
  threshold 0.5

  sphere{<0.00, 0, 0> 1.0,  1}
  sphere{<0.03, 0, 0> 0.6, -1}

  bounded_by{box{<-0.55,-0.4,-0.4>, <-0.3, 0.4, 0.4>}}
}

#declare Petal = union
{
  difference
  {
    object
    {
      PetalBlob
      scale <1, 2, 1>
    }

    plane
    {
      <0, 1, 0>, 0
    }
  }

  difference
  {
    object
    {
      PetalBlob
      scale <1, 1, 1>
    }

    plane
    {
      <0, -1, 0>, 0
    }
  }

  rotate <0, 0, 10>
  translate <0.05, 0, 0>
}

#declare TulipHead = union
{
  #declare PetalLayerLoop = 0;
  #while (PetalLayerLoop < 4)
    #declare PetalScale = 1-PetalLayerLoop / 5;
    #declare PetalLoop = 0;
    #while (PetalLoop < 3)
      object
      {
        Petal
        rotate <0, PetalLoop * 120 + PetalLayerLoop * 59, 0>
        scale <PetalScale, 1, PetalScale> 
      }
      #declare PetalLoop = PetalLoop + 1;
    #end
    #declare PetalLayerLoop = PetalLayerLoop + 1;
  #end
  texture
  {
    TulipHeadTexture
  }
}

#declare TulipStem = intersection
{
  torus
  {
    10, 0.06
    rotate <90, 0, 0>
    translate <10, 0, 0>
  } 

  box
  {
    <-2, -5, -2>
    <2, 0, 2>
  }

  texture
  {
    TulipStemTexture
  }
}

#macro Tulip(HeadAngle)
  union
  {
    object {TulipStem}
    object {TulipHead rotate <0, HeadAngle, 0>}
//object{sphere {<0, 0, 0>, 0.5 texture{TulipHeadTexture}}}
  }
#end

#declare Grass = difference
{
  torus {
    0.8, 0.1
  }
  torus {
    0.8, 0.11
    translate <0.02, 0, 0>
  }
  plane {
    < 0, 0, -1>, 0
  }
  plane {
    <-1, 0,  0>, 0
  }

  rotate <90, 0, 0>
  translate <0.9, 0, 0>
  scale <1, 2, 1>

  texture
  {
    GrassTexture
  }

  bounded_by{box{<-0.08, 0, -0.1>, <0.13, 1.7, 0.1>} rotate <0, 0, -12>}
}


#declare WindmillBlades = union
{
  box {< 2.0, -2.5, 0>, < 16.0,   0.5, 0.2>}
  box {< 2.5,  2.0, 0>, < -0.5,  16.0, 0.2>}
  box {<-2.0,  2.5, 0>, <-16.0,  -0.5, 0.2>}
  box {<-2.5, -2.0, 0>, <  0.5, -16.0, 0.2>}  

  box {<-8.0, -0.5, 0>, <8.0, 0.5, 0.2>}
  box {<-0.5, -8.0, 0>, <0.5, 8.0, 0.2>}

  cylinder {<0, 0, 0>, <0, 0, 2>, 1}

  texture
  {
    WindmillBladesTexture
  }
}

#declare WindmillBase = union
{
  cone
  {
    <0, 0, 0>, 8, <0, 20, 0>, 2
    texture
    {
      WindmillBaseTexture
    }
  }

  cylinder {<  0, -2,   0>, <  0,  0.0,   0>, 12.0}
  cylinder {<  0, -2,   0>, <  0, -8.0,   0>,  8.0}
  cylinder {< 11, -2,   0>, < 11,  3.5,   0>,  0.2}
  cylinder {<-11, -2,   0>, <-11,  3.5,   0>,  0.2}
  cylinder {<  0, -2, -11>, <  0,  3.0, -11>,  0.2}

  texture
  {
    WindmillBladesTexture
  }
}

#declare Windmill = union
{
  object
  {
    WindmillBase
  }
  object
  {
    WindmillBlades
    rotate < 0, 0, -15>
    rotate <15, 0,   0>
    translate <0, 18, -6>
    rotate <0, 20, 0>
  }
}

#declare Sky = sky_sphere
{
  pigment
  {
    bozo
    turbulence 0.65
    octaves 6
    omega 0.7
    lambda 2
    color_map {
      [0.0 color rgb<0.5, 0.5, 0.5>]
      [1.0 color rgb<0.5, 0.7, 1.0>]
    }
    rotate <0, 30, 0>
    rotate <73, 0, 0>
    scale <0.2, 0.1, 0.1>
  }

  pigment
  {
    bozo
    turbulence 0.65
    octaves 6
    omega 0.7
    lambda 2
    color_map {
      [0.0 color rgbt<1.0, 1.00, 1, 0>]
      [1.0 color rgbt<0.5, 0.66, 1, 0.2>]
    }
    rotate <0, 30, 0>
    rotate <70, 0, 0>
    scale <0.2, 0.1, 0.1>
  }
}

camera
{
  right  x
  up 4/3*y

  location <0, 0, -3.0>
  look_at <0, 0, 0>

  aperture 0.25
  blur_samples 256
  focal_point<0,0,0>  
  confidence 0.9999
  variance 0
}

#declare  R1 = seed(123);
#declare LightLoop = 0;
#while (LightLoop < 100)
  light_source
  {
    <800-rand(R1)*1600, 400, 800-rand(R1)*1600>
    color rgb<0.037, 0.037, 0.037>
  }

  #declare LightLoop = LightLoop + 1;
#end

sky_sphere {Sky}

union
{

  plane
  {
    <0, 1, 0>, -4

    pigment {colour rgb <0, 0.5, 0>}
    finish {ambient 1.0 diffuse 0.0}
  }

  object {Tulip(65) rotate <0, 0, -25> rotate <0, -25, 0> translate <-0.7, -0.1,  0.0>}
  object {Tulip(30) rotate <0, 0, -40> rotate <0, -10, 0> translate <-0.2, -1.2,  0.0>}
  object {Tulip(70) rotate <0, 0, -15> rotate <0,   0, 0> translate < 1.8, -2.8,  3.8>}
  object {Tulip(20) rotate <0, 0,   0> rotate <0,   0, 0> translate < 3.0,  1.2, 20.0>}
  object {Tulip( 0) rotate <0, 0,   0> rotate <0,   0, 0> translate < 4.2, -2.0,  7.0>}

  #declare R1 = seed(129);
  #declare TulipLoop = 0;
  #while (TulipLoop < 640)
    object
    {
      Tulip(60+rand(R1)*360)
      rotate <0, 0, -25-rand(R1)*10> // Lean
      rotate <0, -rand(R1)*10, 0>    // Rotate
      translate <rand(R1)*20, -rand(R1)*1, rand(R1)*40>
      rotate <0, -45, 0>
      rotate <-5, 0, 0>
      translate <2, -0.7, 3>
    }
    #declare TulipLoop = TulipLoop + 1;
  #end

  #declare TulipLoop = 0;
  #while (TulipLoop < 64)
    object
    {
      Tulip(60+rand(R1)*360)
      rotate <0, 0, -30-rand(R1)*10> // Lean
      rotate <0, -rand(R1)*10, 0>    // Rotate
      translate <-rand(R1)*20, -rand(R1)*1, rand(R1)*10>
      rotate <0, -45, 0>
      rotate <-5, 0, 0>
      translate <-0.5, -1.5, 5>
    }
    #declare TulipLoop = TulipLoop + 1;
  #end

  #declare R1 = seed(696);
  #declare GrassLoop = 0;
  #while (GrassLoop < 4096)
    object
    {
      Grass
      rotate <-30 + 60*rand(R1), 0, -30 + 60*rand(R1)>
      rotate <0, 360*rand(R1), 0>
      scale <1 + rand(R1), 0.5 + rand(R1), 1 + rand(R1)>
      translate <-10 + 20*rand(R1), -4, rand(R1)*20>
    }
    #declare GrassLoop = GrassLoop + 1;
  #end


  object
  {
    Windmill
    translate <18, 9, 80>
  }

  #declare R1 = seed(60);
  #declare GrassLoop = 0;
  #while (GrassLoop < 48)
    object
    {
      Grass
      rotate <0, -140+100*rand(R1), 0>
      scale <20, 1+1.5*rand(R1), 8>
      translate <GrassLoop - 22, (48-GrassLoop)/24, 40>
    }
    #declare GrassLoop = GrassLoop + 1;
  #end


  #declare R1 = seed(19);
  #declare GrassLoop = 0;
  #while (GrassLoop < 128)
    object
    {
      Grass
      scale <2, (64 - abs(GrassLoop - 64))/64+1, 2>
      rotate <0, -90, -90 + GrassLoop * 2>
      translate <-20+GrassLoop/24+4*rand(R1), 2+6*rand(R1), 36>
    }
    #declare GrassLoop = GrassLoop + 1;
  #end
}
