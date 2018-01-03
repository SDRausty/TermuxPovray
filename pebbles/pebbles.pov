#version 3.6;

// By Jonathan Hunt <jonathan@xlcus.com>

#include "functions.inc"

/****************************************************************************/

#declare FeatureRadiosity = true; // Set to true to enable radiosity.
#declare FeatureFocalBlur = true; // Set to true to enable focal blur.

#declare FeatureLoadPositions = false; // Set to true to cache the pebble positions.
#declare FeatureSavePositions = false; // Set to true to reload the cached positions.
#declare PositionsFilename = "pebblecache.dat";

#declare PebbleCount = 768;      // The total number of pebbles in the scene.
#declare BigPebbleCount = 256;   // How many of these are large filler pebbles.
#declare PebbleMaxRadius = 3;    // The largest pebble size.
#declare PebbleMinRadius = 0.5;  // The smallest pebble size.
#declare PebbleSizeExponent = 3; // How quickly the size drops off.

#declare RandPeb = seed(70); // The seed for the pebble shapes and placement.
#declare RandPat = seed(83); // The seed for the pebble patterns.
#declare RandCol = seed(12); // The seed for the pebble colour schemes.

/****************************************************************************/

camera
{
  location <0, 10, -39>
  look_at <0, 0, -21>
  angle 55

  #if (FeatureFocalBlur)
    aperture 0.25
    blur_samples 256
    focal_point<0, 0, -21>  
    confidence 0.95
    variance 1/256
  #end
}

/****************************************************************************/

#if (FeatureRadiosity)
  global_settings {
    radiosity {
      pretrace_start 0.08
      pretrace_end   0.01
      count 500

      normal on

      nearest_count 10
      error_bound 0.02
      recursion_limit 1

      low_error_factor 0.2
      gray_threshold 0.0
      minimum_reuse 0.015
      brightness 1

      adc_bailout 0.01/2
    }
  }
#else
  light_source
  {
    <80, 160, -80>
    color rgb<1, 1, 1>
  }
#end

/****************************************************************************/

// The basic texture that all of the pebbles have.  A very fine bump pattern
// to add a bit of roughness, and a finish with ambient turned off and diffuse
// at maximum in preparation for the radiosity.
#declare PebbleNormalAndFinish = texture
{
    normal
    {
      bumps 0.2
      scale 0.005
    }

    finish
    {
      diffuse 1.0
      ambient 0.0
    }
}

/****************************************************************************/

// This will be our light source when radiosity is turned on.
// A very slightly orange sky.
sky_sphere
{
  pigment
  {
    color rgb<1, 0.95, 0.85>
  }
}

/****************************************************************************/

#declare PebbleShapeTemplateCount = 6;   // The number of base shape templates we want to use.
#declare PebbleShapeVariationCount = 20; // How many variations of each templates shall we generate.

#declare PebbleShapeCount = PebbleShapeTemplateCount * PebbleShapeVariationCount;

// A macro to generate a random pebble shape of the specified template type.
#macro GenerateShape(TypeIndex)
  #switch (TypeIndex)
    #case (0) // This shape template generates flattened spheres.
      #declare Result = sphere
      {
        <0, 0, 0>, 1
        scale <0.8, 0.2 + rand(RandPeb) * 0.2, 1>
      }
    #break
    #case (1) // This shape template generates skewed rounded cuboids.
      #declare Result = superellipsoid
      {
        <0.4, 0.7>
        matrix
        <
          1, 0, 0,
          0, 1, 0.5,
          0, 0, 1,
          0, 0, 0
        >
        scale <0.5, 0.4, 0.8>
      }
    #else
      // This shape template generates knobbly spheres and is the default so that we
      // can weight in favour of this shape by specifying a larger template count.
      #declare NoiseXScale = 1.0 + rand(RandPeb) * 0.5;
      #declare NoiseYScale = 1.0 + rand(RandPeb) * 0.5;
      #declare NoiseZScale = 1.0 + rand(RandPeb) * 0.5;
      #declare NoiseXOffset = rand(RandPeb) * 256;
      #declare NoiseYOffset = rand(RandPeb) * 256;
      #declare NoiseZOffset = rand(RandPeb) * 256;
      #declare Result = isosurface
      {
        function { f_sphere(x, y, z, 1) + f_noise3d(x * NoiseXScale + NoiseXOffset, y * NoiseYScale + NoiseYOffset, z * NoiseZScale + NoiseZOffset) * 0.5 }
        contained_by { sphere { 0, 1 } }
        max_gradient 1.8
        scale <1, 0.6 + rand(RandPeb) * 0.2, 1>
      }
    #break
  #end

  Result
#end

#declare PebbleShapes = array[PebbleShapeCount]

// Generate an array of random pebble shapes by creating multiple variations of each template type.
#declare PebbleShapeTemplateLoop = 0;
#while (PebbleShapeTemplateLoop < PebbleShapeTemplateCount)
  #declare PebbleShapeVariationLoop = 0;
  #while (PebbleShapeVariationLoop < PebbleShapeVariationCount)
    #declare PebbleShapes[PebbleShapeTemplateLoop * PebbleShapeVariationCount + PebbleShapeVariationLoop] = GenerateShape(PebbleShapeTemplateLoop);
    #declare PebbleShapeVariationLoop = PebbleShapeVariationLoop + 1;
  #end
  #declare PebbleShapeTemplateLoop = PebbleShapeTemplateLoop + 1;
#end

/****************************************************************************/

#declare PebblePatternCount = 6;
#declare PebblePatterns = array[PebblePatternCount]

// A selection of base patterns for the pebbles.
#declare PebblePatterns[0] = pigment
{
  wrinkles
  scale 0.02
  noise_generator 2
}
#declare PebblePatterns[1] = pigment
{
  bozo
  turbulence 2.0
  scale 0.05
  noise_generator 2
}
#declare PebblePatterns[2] = pigment
{
  bozo
  turbulence 4.0
  scale 0.1
  noise_generator 3
}
#declare PebblePatterns[3] = pigment
{
  wrinkles
  turbulence 1.0
  scale 0.05
}
#declare PebblePatterns[4] = pigment
{
  granite
  turbulence 0.2
  scale 0.15
}
#declare PebblePatterns[5] = pigment
{
  granite
  scale 0.6
  turbulence 2.0
}

/****************************************************************************/

#declare PebbleColourCount = 15;
#declare PebbleColours = array[PebbleColourCount]

// A selection of different colour schemes for the pebbles.
#declare PebbleColours[0] = color_map
{
  [0.0 color rgb<0.7, 0.7, 0.7>]
  [0.7 color rgb<0.8, 0.8, 0.8>]
  [1.0 color rgb<1, 1, 1>]
}
#declare PebbleColours[1] = color_map
{
  [0.0 color rgb<0.5, 0.5, 0.5>]
  [0.3 color rgb<0.9, 0.9, 0.9>]
  [0.8 color rgb<1.0, 1.0, 1.0>]
  [1.0 color rgb<1.0, 1.0, 0.5>]
}
#declare PebbleColours[2] = color_map
{
  [0.0 color rgb<0.4, 0.4, 0.6>]
  [0.2 color rgb<1.0, 1.0, 1.0>]
  [0.7 color rgb<0.9, 0.9, 1.0>]
  [1.0 color rgb<0.8, 0.8, 0.4>]
}
#declare PebbleColours[3] = color_map
{
  [0.0 color rgb<0.6, 0.4, 0.4>]
  [0.4 color rgb<0.8, 0.7, 0.6>]
  [0.6 color rgb<0.8, 0.7, 0.7>]
  [1.0 color rgb<1.0, 1.0, 1.0>]
}
#declare PebbleColours[4] = color_map
{
  [0.0 color rgb<0.8, 0.6, 0.4>]
  [0.3 color rgb<0.8, 0.7, 0.5>]
  [0.8 color rgb<1.0, 0.9, 0.8>]
  [1.0 color rgb<1.0, 1.0, 1.0>]
}
#declare PebbleColours[5] = color_map
{
  [0.0 color rgb<0.0, 0.0, 0.0>]
  [0.3 color rgb<0.5, 0.5, 0.6>]
  [0.7 color rgb<0.6, 0.6, 0.6>]
  [0.8 color rgb<0.9, 0.9, 1.0>]
  [1.0 color rgb<1.0, 1.0, 1.0>]
}
#declare PebbleColours[6] = color_map
{
  [0.0 color rgb<0.7, 0.4, 0.4> ]
  [0.3 color rgb<0.8, 0.8, 0.75>]
  [0.7 color rgb<0.9, 0.9, 0.85>]
  [0.8 color rgb<0.9, 0.9, 0.9> ]
  [1.0 color rgb<1.0, 1.0, 1.0> ]
}
#declare PebbleColours[7] = color_map
{
  [0.0 color rgb<0.0, 0.0, 0.0>]
  [0.2 color rgb<0.7, 0.7, 0.7>]
  [0.7 color rgb<0.6, 0.6, 0.6>]
  [0.8 color rgb<0.9, 0.9, 0.9>]
  [1.0 color rgb<1.0, 1.0, 1.0>]
}
#declare PebbleColours[8] = color_map
{
  [0.0 color rgb<0.5, 0.5, 0.5>]
  [0.2 color rgb<0.6, 0.6, 0.6>]
  [0.4 color rgb<0.7, 0.7, 0.7>]
  [0.6 color rgb<0.8, 0.8, 0.8>]
  [0.8 color rgb<0.9, 0.9, 0.9>]
  [1.0 color rgb<1.0, 1.0, 1.0>]
}
#declare PebbleColours[9] = color_map
{
  [0.00 color rgb<0.5, 0.5, 0.5>  ]
  [0.25 color rgb<0.7, 0.7, 0.73> ]
  [0.50 color rgb<0.8, 0.8, 0.8>  ]
  [0.75 color rgb<1.0, 0.97, 0.97>]
  [1.00 color rgb<1.0, 1.0, 1.0>  ]
}
#declare PebbleColours[10] = color_map
{
  [0.0 color rgb<0.3, 0.2, 0.0>]
  [0.2 color rgb<0.7, 0.6, 0.5>]
  [0.7 color rgb<0.9, 0.8, 0.6>]
  [0.8 color rgb<0.9, 0.9, 0.9>]
  [1.0 color rgb<1.0, 1.0, 1.0>]
}
#declare PebbleColours[11] = color_map
{
  [0.0 color rgb<0.1, 0.1, 0.1>]
  [0.3 color rgb<0.6, 0.6, 0.6>]
  [0.7 color rgb<0.8, 0.8, 0.8>]
  [1.0 color rgb<0.9, 0.9, 0.9>]
}
#declare PebbleColours[12] = color_map
{
  [0.0 color rgb<0.8, 0.8, 0.8>]
  [1.0 color rgb<1.0, 1.0, 1.0>]
}
#declare PebbleColours[13] = color_map
{
  [0.0 color rgb<0.7, 0.7, 0.7>]
  [1.0 color rgb<0.9, 0.9, 0.9>]
}
#declare PebbleColours[14] = color_map
{
  [0.0 color rgb<0.6, 0.6, 0.6>]
  [1.0 color rgb<0.8, 0.8, 0.8>]
}

/****************************************************************************/

#declare DecalColourCount = 5;
#declare DecalColours = array[DecalColourCount]

// A selection of different colour schemes for the dirt/speckle/line overlays.
#declare DecalColours[0] = color_map
{
  [0.0 color rgb<0.8, 0.8, 0.8>]
  [0.4 color rgb<0.95, 0.95, 0.95>]
  [1.0 color rgb<1, 1, 1>]
}
#declare DecalColours[1] = color_map
{
  [0.0 color rgbt<0.5, 0.5, 0.5, 0>]
  [0.4 color rgbt<0.2, 0.2, 0.2, 0.6>]
  [1.0 color rgbt<0, 0, 0, 0.6>]
}
#declare DecalColours[2] = color_map
{
  [0.5 color rgbt<0, 0, 0, 1.0>]
  [1.0 color rgbt<0, 0, 0, 0.5>]
}
#declare DecalColours[3] = color_map
{
  [0.0 color rgbt<1, 1, 1, 1.0>]
  [1.0 color rgbt<1, 1, 1, 0.5>]
}
#declare DecalColours[4] = color_map
{
  [0.5 color rgbt<0.2, 0.2, 0.2, 1.0>]
  [1.0 color rgbt<0.2, 0.2, 0.2, 0.0>]
}

/****************************************************************************/

#declare DecalPatternCount = 17;
#declare DecalPatterns = array[DecalPatternCount]

// A selection of different dirt/speckle/line textures which will be
// overlayed over the base textures to make them more interesting.
#declare DecalPatterns[0] = pigment
{
  wrinkles
  scale 0.1
  noise_generator 2
  pigment_map
  {
    [0.75 color rgbt <1, 1, 1, 1> ]
    [0.85 PebblePatterns[0] color_map { DecalColours[0] } ]
  }
}
#declare DecalPatterns[1] = pigment
{
  wrinkles
  scale 0.1
  noise_generator 2
  pigment_map
  {
    [0.75 color rgbt <1, 1, 1, 1> ]
    [0.85 PebblePatterns[0] color_map { DecalColours[1] } ]
  }
}
#declare DecalPatterns[2] = pigment
{
  marble
  scale 2
  turbulence 0.5

  pigment_map
  {
    [0.92 color rgbt <1, 1, 1, 1> ]
    [0.96 PebblePatterns[0] color_map { DecalColours[0] } ]
  }
}
#declare DecalPatterns[3] = pigment
{
  marble
  scale 2
  turbulence 4

  pigment_map
  {
    [0.95 color rgbt <1, 1, 1, 1> ]
    [1.00 PebblePatterns[0] scale 5 color_map { DecalColours[2] } ]
  }
}
#declare DecalPatterns[4] = pigment
{
  bozo
  scale 0.2
  noise_generator 3
  pigment_map
  {
    [0.85 color rgbt <1, 1, 1, 1> ]
    [0.9 PebblePatterns[0] color_map { DecalColours[0] } ]
  }
}
#declare DecalPatterns[5] = pigment
{
  bozo
  scale 0.2
  noise_generator 2
  turbulence 1
  pigment_map
  {
    [0.75 color rgbt <1, 1, 1, 1> ]
    [0.80 PebblePatterns[0] color_map { DecalColours[1] } ]
  }
}
#declare DecalPatterns[6] = pigment
{
  bozo
  scale 0.2
  noise_generator 3
  turbulence 2
  pigment_map
  {
    [0.85 color rgbt <1, 1, 1, 1> ]
    [0.9 PebblePatterns[0] color_map { DecalColours[0] } ]
  }
}
#declare DecalPatterns[7] = pigment
{
  bozo
  scale 0.2
  noise_generator 2
  turbulence 4
  pigment_map
  {
    [0.75 color rgbt <1, 1, 1, 1> ]
    [0.80 PebblePatterns[0] color_map { DecalColours[1] } ]
  }
}
#declare DecalPatterns[8] = pigment
{
  marble
  scale 0.1
  turbulence 1

  pigment_map
  {
    [0.90 color rgbt <1, 1, 1, 1> ]
    [1.00 PebblePatterns[0] scale 5 color_map { DecalColours[0] } ]
  }
}
#declare DecalPatterns[9] = pigment
{
  marble
  scale 0.1
  turbulence 1

  pigment_map
  {
    [0.75 color rgbt <1, 1, 1, 1> ]
    [0.80 PebblePatterns[0] scale 5 color_map { DecalColours[2] } ]
  }
}
#declare DecalPatterns[10] = pigment
{
  wrinkles
  scale 0.5
  noise_generator 2
  pigment_map
  {
    [0.6 color rgbt <1, 1, 1, 1> ]
    [0.7 PebblePatterns[2] color_map { DecalColours[3] } ]
  }
}
#declare DecalPatterns[11] = pigment
{
  wrinkles
  scale 0.5
  noise_generator 2
  pigment_map
  {
    [0.7 color rgbt <1, 1, 1, 1> ]
    [0.8 PebblePatterns[2] scale 4 color_map { DecalColours[4] } ]
  }
}
#declare DecalPatterns[12] = pigment
{
  crackle
  scale 0.2
  noise_generator 2
  pigment_map
  {
    [0.5 color rgbt <1, 1, 1, 1> ]
    [0.7 PebblePatterns[2] color_map { DecalColours[0] } ]
  }
}
#declare DecalPatterns[13] = pigment
{
  crackle
  scale 0.1
  noise_generator 2
  pigment_map
  {
    [0.5 color rgbt <1, 1, 1, 1> ]
    [0.7 PebblePatterns[2] color_map { DecalColours[1] } ]
  }
}
#declare DecalPatterns[14] = pigment
{
  waves
  scale 0.02
  noise_generator 3
  turbulence 2

  pigment_map
  {
    [0.65 color rgbt <1, 1, 1, 1> ]
    [1.0 PebblePatterns[2] color_map { DecalColours[0] } ]
  }
}
#declare DecalPatterns[15] = pigment
{
  quilted
  scale 0.5
  noise_generator 3
  turbulence 1

  pigment_map
  {
    [0.4 color rgbt <1, 1, 1, 1> ]
    [0.6 PebblePatterns[2] color_map { DecalColours[0] } ]
  }
}
#declare DecalPatterns[16] = pigment
{
  quilted
  scale 0.5
  noise_generator 3
  turbulence 1

  pigment_map
  {
    [0.3 color rgbt <1, 1, 1, 1> ]
    [0.6 PebblePatterns[2] color_map { DecalColours[1] } ]
  }
}

/****************************************************************************/

// This macro is a quick, dirty and inaccurate intersection test for two pebbles.
// It projects a ray from the centre of one pebble towards the centre of the other,
// and then back the other way to see if the surface of the pebbles overlap on this
// line.  It works in most cases if the pebbles aren't too different from spheres,
// and so is adequate for this scene.
#macro Overlaps(ACentre, A, BCentre, B)
  #if (vlength(ACentre-BCentre) > PebbleMaxRadius*2)
    #declare Result = false;
  #else
    #declare Dir = vnormalize(BCentre-ACentre);
    #declare AEdge = trace(A, BCentre + Dir * 100, -Dir);
    #declare BEdge = trace(B, ACentre - Dir * 100, Dir);
    #declare Result = (vdot(AEdge, Dir) >= vdot(BEdge, Dir));
  #end
  Result
#end

/****************************************************************************/

#declare Pebbles = array[PebbleCount]; // The pebbles are stored in here as they are generated.
#declare YSpread = 62; // The depth of the region in which the pebbles are places.
#declare XSpread = 60; // The width of the region in which the pebbles are places.

// The pebbles are sorted into a flat (non-recursive) space partition map
// as they are generated to speed up the intersection tests.
#declare MapYSize = int(YSpread/(PebbleMaxRadius*2))+1;
#declare MapXSize = int(XSpread/(PebbleMaxRadius*2))+1;
#declare Map = array[MapYSize][MapXSize][PebbleCount];
#declare MapCentres = array[MapYSize][MapXSize][PebbleCount];
#declare MapTotals = array[MapYSize][MapXSize];

// Clear the spare partition map.
#declare MapYLoop = 0;
#while (MapYLoop < MapYSize)
  #declare MapXLoop = 0;
  #while (MapXLoop < MapXSize)
    #declare MapTotals[MapYLoop][MapXLoop] = 0;
    #declare MapXLoop = MapXLoop + 1;
  #end
  #declare MapYLoop = MapYLoop + 1;
#end

/****************************************************************************/

// Open the position cache file if we need to.
#if (FeatureLoadPositions)
  #fopen PositionsFile PositionsFilename read
#else
  #if (FeatureSavePositions)
    #fopen PositionsFile PositionsFilename write
  #end
#end

// Generate the pebbles.
#declare PebbleLoop = 0;
#while (PebbleLoop < PebbleCount)

  // Pick a random shape.
  #declare PebbleShapeIndex = int(rand(RandPeb)*PebbleShapeCount);

  // Try and find a valid position for it until we succeed.
  #declare PositionOK = false;
  #declare Attempts = 0;
  #while (!PositionOK)
    // Pick a random distance away from the camera.
    #declare Yu = pow(rand(RandPeb), 2);
    // Pick a random left/right position, but scale by the
    // distance to bring it into the camera view.
    #declare Xu = (rand(RandPeb)-0.5) * (Yu+0.2);

    #if (PebbleLoop < BigPebbleCount)
      // We're generating the filler pebbles so pick the maximum size.
      #declare CandidateScale = PebbleMaxRadius;
      // Pick a height starting at 0, but moving down to -1 as we get towards
      // the end of the filler pebbles.  If we're having trouble, move down
      // even more as the attempts increase.
      #declare H = -PebbleMaxRadius * PebbleLoop / BigPebbleCount - Attempts / 256;
    #else
      // Generate a size for the normal pebbles, starting with the maximum
      // size and dropping down to the minimum size along a power curve.
      #declare CandidateScale = PebbleMinRadius + pow(1 - (PebbleLoop-BigPebbleCount) / (PebbleCount-BigPebbleCount), PebbleSizeExponent) * (PebbleMaxRadius-PebbleMinRadius);
      // Pick a height starting at 0, but moving up to 1 as we get towards
      // the end of the pebbles.  If we're having trouble, move up even more
      // as the attempts increase.
      #declare H = PebbleMinRadius * (PebbleLoop-BigPebbleCount) / (PebbleCount-BigPebbleCount) + Attempts / 4096;
    #end
  
    // Pick a random rotation.
    #declare CandidateRotation = <rand(RandPeb)*30-15, rand(RandPeb)*360, rand(RandPeb)*30-15>;

    // Generate the position vector.
    #declare CandidateCentre = <Xu*XSpread, H, Yu*YSpread-YSpread/2>;

    #if (FeatureLoadPositions)
      // If we're loading cached positions, just overwrite the previously
      // calculated data with the data from the file.
      #read (PositionsFile, PebbleShapeIndex, CandidateScale, CandidateRotation, CandidateCentre)
    #end

    // Declare our candidate object by combining all of the data.
    #declare Candidate = object
    {
      PebbleShapes[PebbleShapeIndex]
      scale CandidateScale
      rotate CandidateRotation
      translate CandidateCentre
    }

    // Now we need to check this candidate object against any pebbles that
    // we've placed down already.  We only need to check the ones near
    // by, so work out which space partition map section we need to check.
    #declare MapY = int(Yu*YSpread/(PebbleMaxRadius*2));
    #declare MapX = int((Xu*XSpread+XSpread/2)/(PebbleMaxRadius*2));

    // Loop over the pebbles in this section.
    #declare Total = MapTotals[MapY][MapX];
    #declare PositionOK = true;
    #declare CheckLoop = 0;
    #while (CheckLoop < Total & PositionOK & !FeatureLoadPositions)
      // Check each one for an overlap.
      #if (Overlaps(CandidateCentre, Candidate, MapCentres[MapY][MapX][CheckLoop], Map[MapY][MapX][CheckLoop]))
        // If we overlap, then this candidate is invalid, so stop checking it
        #declare PositionOK = false;
      #end
      #declare CheckLoop = CheckLoop + 1;
    #end

    // If the position was ok, we'll drop out of the loop, but otherwise prepare for the next attempt.
    #declare Attempts = Attempts + 1;
  #end

  // We're out of the loop, so we've found a valid position.

  #if (!FeatureLoadPositions & FeatureSavePositions)
    // If we're caching positions, then save the data to the file.
    #write (PositionsFile, PebbleShapeIndex, ",", CandidateScale, ",", CandidateRotation, ",", CandidateCentre, ",\n")
  #end

  // Show our progress in the debug output.
  #debug concat(str(PebbleLoop, 0, 0), " ", str(CandidateScale, 0, 2), " ", str(Attempts, 0, 0), "\n")

  // Store the valid pebble away.
  #declare Pebbles[PebbleLoop] = Candidate;

  // Now we also need to add it to the space partition map.  We add it to the
  // section it's centre is located in and also the neighbours in case it
  // overlaps the edge of the section.
  #declare StartYDelta = MapY-1;
  #if (StartYDelta < 0)
    #declare StartYDelta = 0;
  #end
  #declare EndYDelta = MapY+1;
  #if (EndYDelta >= MapYSize)
    #declare EndYDelta = MapYSize-1;
  #end
  #declare StartXDelta = MapX-1;
  #if (StartXDelta < 0)
    #declare StartXDelta = 0;
  #end
  #declare EndXDelta = MapX+1;
  #if (EndXDelta >= MapXSize)
    #declare EndXDelta = MapXSize-1;
  #end

  #declare MapYLoop = StartYDelta;
  #while (MapYLoop <= EndYDelta)
    #declare MapXLoop = StartXDelta;
    #while (MapXLoop <= EndXDelta)
      #declare Total = MapTotals[MapYLoop][MapXLoop];
      #declare MapCentres[MapYLoop][MapXLoop][Total] = CandidateCentre;
      #declare Map[MapYLoop][MapXLoop][Total] = Candidate;
      #declare MapTotals[MapYLoop][MapXLoop] = Total + 1;
  
      #declare MapXLoop = MapXLoop + 1;
    #end
    #declare MapYLoop = MapYLoop + 1;
  #end

  // We're done for this pebble, so move on to the next.
  #declare PebbleLoop = PebbleLoop + 1;
#end

// Close the position cache file if we need to.
#if (FeatureLoadPositions | FeatureSavePositions)
  #fclose PositionsFile
#end

// Now that we've worked out where all the pebbles are going to be,
// we need to output them.
#declare PebbleLoop = 0;
#while (PebbleLoop < PebbleCount)
  object
  {
    // Retrieve the stored shape
    Pebbles[PebbleLoop]

    texture
    {
      // Add the default texture
      PebbleNormalAndFinish

      pigment
      {
        // Select a random pattern.
        PebblePatterns[rand(RandPat)*PebblePatternCount]
        color_map
        {
          // Choose a random colour scheme.
          PebbleColours[rand(RandCol)*PebbleColourCount]
        }
      }

      // Randomize the pattern's position and rotation.
      translate <rand(RandPat)*100, rand(RandPat)*100, rand(RandPat)*100>
      rotate <rand(RandPat)*360, rand(RandPat)*360, rand(RandPat)*360>
    }

    // Decide randomly which of the dirt/speckle/line overlay textures we want to use. 
    #declare DecalLoop = 0;
    #while (DecalLoop < DecalPatternCount)
      #if (rand(RandPat) < 0.2)
        texture
        {
          PebbleNormalAndFinish
          DecalPatterns[DecalLoop]
          translate <rand(RandPat)*100, rand(RandPat)*100, rand(RandPat)*100>
          rotate <rand(RandPat)*360, rand(RandPat)*360, rand(RandPat)*360>
        }
      #end
      #declare DecalLoop = DecalLoop + 1;
    #end
  }
  #declare PebbleLoop = PebbleLoop + 1;
#end

/****************************************************************************/

// Add a base plane with one of the pebble patterns, just in
// case there are any slight gaps in the placement.
plane
{
  y, -1

  texture
  {
    PebbleNormalAndFinish

    pigment
    {
      PebblePatterns[0]
      color_map
      {
        PebbleColours[0]
      }
    }
  }

  #declare DecalLoop = 0;
  #while (DecalLoop < DecalPatternCount)
    texture
    {
      PebbleNormalAndFinish
      DecalPatterns[DecalLoop]
    }
    #declare DecalLoop = DecalLoop + 1;
  #end
}

/****************************************************************************/

