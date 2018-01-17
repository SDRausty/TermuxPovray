//-----------------------------------------
// Demo scene for some sci-fi props 
// including buildings and flying vehicles
// -----------------------------------------
// Made for Persistence of vision 3.6
//==========================================  
// Copyright 2004 Gilles Tran http://www.oyonale.com
// -----------------------------------------
// This work is licensed under the Creative Commons Attribution License. 
// To view a copy of this license, visit http://creativecommons.org/licenses/by/2.0/ 
// or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
// You are free:
// - to copy, distribute, display, and perform the work
// - to make derivative works
// - to make commercial use of the work
// Under the following conditions:
// - Attribution. You must give the original author credit.
// - For any reuse or distribution, you must make clear to others the license terms of this work.
// - Any of these conditions can be waived if you get permission from the copyright holder.
// Your fair use and other rights are in no way affected by the above. 
//==========================================  
// This picture can be rendered in one or two passes
// For the 2-pass method, render first without the reflections (Ref=0), 
// without saving the file and without aa
// and save the radiosity data (SaveRadOK=1, LoadRadOK=0)
// You can also use a lower size (1/2 for instance)
// When the first pass is completed, render again, now with reflections (Ref=1),
// with aa, with file output and at final size
// and of course load the radiosity data  (SaveRadOK=0, LoadRadOK=1)
// The 2-pass method should save some render time and RAM use.
//-----------------------------------------
#include "colors.inc"
#include "textures.inc"
#include "metals.inc"
#include "functions.inc"
#default{finish{ambient 0}}

// -----------------------------------------
// switches
// -----------------------------------------
// In the switch settings below, "0" is used to turn off a feature

#declare RadOK=2; // 0 no rad / 1 test rad / 2 final rad
#declare MediaOK=1; // media
#declare Ref=1; // reflection coefficient : 0 = no reflection in the scene
#declare SaveRadOK=0; // save radiosity data for pass 1
#declare LoadRadOK=0; // load radiosity data for pass 2

#declare BuildingsOK=1; // turn on/off all buildings
#declare Building3OK=1; // turn on/off an individual building if BuildingsOK = 1
#declare Building4OK=1;
#declare Building5OK=1;
#declare Building6OK=1;
#declare Building7OK=1;

#declare CarsOK=1; // turn on/off all cars
#declare Car1OK=1; // turn on/off an individual car if CarsOK = 1
#declare Car4OK=1; 
#declare Car5OK=1; 
#declare Car6OK=1; 
#declare Car7OK=1; 
#declare Truck1OK=1; 
#declare Truck2OK=1;

#declare BusOK=1; // bus (needs to be turned on/off separately) 


// -----------------------------------------
// settings
// -----------------------------------------
// The picture can be rendered in one pass or two passes
// In the 2-pass method, one renders first (SaveRadOK=1) the image without reflections (Ref=0) and without media (MediaOK=1)
// possibly at a lower resolution (1/2 for instance) with no antialiasing
// The second pass (LoadRadOK=1) reuses the radiosity file created by the first one and must be rendered with reflections (Ref=1)
// media (MediaOK=1), at final size with antialiasing

global_settings {
    assumed_gamma 1 // tweak if the image is too pale
    max_trace_level 20
    #if (RadOK>0)
        radiosity {
            #if (RadOK=2)
                count 400 error_bound 0.15
            #else
                count 35 error_bound 1.8
            #end
            recursion_limit 1
            low_error_factor .5 
            gray_threshold 0  
            minimum_reuse 0.015 
            brightness 1
            adc_bailout 0.01/2
            normal on
            media off
            #if (SaveRadOK=1)
                save_file "scifi.rad"
            #else
                #if (LoadRadOK=1)
                    pretrace_start 1
                    pretrace_end 1
                    load_file "scifi.rad"
                    always_sample off
                #end
            #end
        }
    #end
    
}

// -----------------------------------------
// camera
// -----------------------------------------
#declare cam_location=<400,-100,-300>;
camera {
    location cam_location
    direction z*1
    right     x*image_width/image_height
    look_at   <0,0,0>
    translate y*300
}

// -----------------------------------------
// textures and colors
// -----------------------------------------
#declare T_Clear=texture{pigment{Clear}finish{ambient 0 diffuse 0}}
#declare C_Sun=rgb <248,226,192>/255;
#declare C_Sky=rgb <90,131,255>/255;
#declare C_Sky1=rgb <231,234,243>/255;
#declare C_Sky2=rgb <47,101,255>/255;
#declare C_Sky3=(C_Sky*3+C_Sky1)/4;
#declare C_BusLight=rgb <193,198,174>/255;


// -----------------------------------------
// car colors
// -----------------------------------------
#declare Whites=array[3]; // 4% of car colours according to my observations !
#declare LightGreys=array[9];// 36%
#declare DarkGreys=array[9];// 36%
#declare Blues=array[7]; // 17%
#declare Reds=array[6]; // 5%
#declare Greens=array[4]; // 5%
#declare Noir = rgb 0; // 19%
#declare Yellow = rgb <200,150,28>/255;  
#declare Whites[0]=rgb <250,250,250>/255;
#declare Whites[1]=rgb <242,225,208>/255;
#declare Whites[2]=rgb <214,213,148>/255;

#declare DarkGreys[0]=rgb <53,53,53>/255;
#declare DarkGreys[1]=rgb <71,63,53>/255;
#declare DarkGreys[2]=rgb <74,73,63>/255;
#declare DarkGreys[3]=rgb <87,86,79>/255;
#declare DarkGreys[4]=rgb <83,83,83>/255;
#declare DarkGreys[5]=rgb <119,119,119>/255;
#declare DarkGreys[6]=rgb <135,140,124>/255;
#declare DarkGreys[7]=rgb <85,89,99>/255;
#declare DarkGreys[8]=rgb <55,55,55>/255;

#declare LightGreys[0]=rgb <158,148,148>/255;
#declare LightGreys[1]=rgb <212,212,212>/255;
#declare LightGreys[2]=rgb <168,169,156>/255;
#declare LightGreys[3]=rgb <163,178,179>/255;
#declare LightGreys[4]=rgb <243,238,223>/255;
#declare LightGreys[5]=rgb <214,202,190>/255;
#declare LightGreys[6]=rgb <155,137,137>/255;
#declare LightGreys[7]=rgb <182,184,192>/255;
#declare LightGreys[8]=rgb <227,222,195>/255;

#declare Blues[0]=rgb <43,36,46>/255;
#declare Blues[1]=rgb 0.5*<5,74,91>/255;
#declare Blues[2]=rgb 0.4*<86,108,149>/255;
#declare Blues[3]=rgb <37,51,78>/255;
#declare Blues[4]=rgb <61,60,65>/255;
#declare Blues[5]=rgb 0.5*<34,38,82>/255;
#declare Blues[6]=rgb 0.2*<49,51,141>/255;

#declare Reds[0]=rgb 0.4*<113,61,59>/255;
#declare Reds[1]=rgb <43,16,15>/255;
#declare Reds[2]=rgb <67,15,18>/255;
#declare Reds[3]=rgb <62,13,17>/255;
#declare Reds[4]=rgb <97,49,50>/255;
#declare Reds[5]=rgb <120,53,50>/255;

#declare Greens[0]=rgb 0.25*<27,69,57>/255;
#declare Greens[1]=rgb 0.25*<29,71,52>/255;
#declare Greens[2]=rgb 0.5*<24,41,35>/255;

// -----------------------------------------
// sun
// -----------------------------------------
#declare LightPos=vaxis_rotate(vaxis_rotate(-z*10000,x,70),y,60);
light_source {LightPos C_Sun*3.5}

// -----------------------------------------
// sky and haze
// -----------------------------------------
sky_sphere{pigment{gradient y color_map{[0 C_Sky*0.05] [0.4 C_Sky]}} scale 2 translate -y}

#if (MediaOK=1)
    box{
        <-1000,-1000,-1000>, <1000,700,2000>
        texture{pigment{Clear}finish{ambient 0 diffuse 0}}
        hollow
        interior{
            media{
                scattering{2,C_Sky*0.00025 extinction 1}
            }
        }
    }
#end

// -----------------------------------------
// Buildings
// -----------------------------------------
// 5 buildings, roughly 400 units high
// note 1 : they are mirrored vertically 
// note 2 : they are (badly) uv-mapped
// 

#if (BuildingsOK=0)
    #declare Building3OK=0;
    #declare Building4OK=0;
    #declare Building5OK=0;
    #declare Building6OK=0;
    #declare Building7OK=0;
#end

#declare Diff=1; // general diffusion parameter
#declare T_default=texture{pigment{White*0.9}finish{ambient 0 diffuse 1}}
#declare T_default=texture{pigment{rgb Diff}finish{ambient 0 diffuse 1}}
#declare P_Hull=pigment{image_map{jpeg "shiphull" interpolate 2}}
#declare N_Hull=normal{bump_map{jpeg "shiphull" interpolate 2} bump_size 0.5}
#declare P_Metal01=pigment{image_map{jpeg "rust_01" interpolate 2}}
#declare P_Metal03=pigment{image_map{jpeg "rust_02" interpolate 2}}
#declare P_Concrete03=pigment{image_map{jpeg "concrete_03" interpolate 2}}
#declare P_Concrete04=pigment{image_map{jpeg "concrete_04" interpolate 2}}
#declare P_Concrete05=pigment{image_map{jpeg "concrete_05" interpolate 2}}

// -----------------------------------------
// Building 3
// -----------------------------------------
#declare V_WorldBoundMin = <-1.507240, 0.000000, -1.451370>;
#declare V_WorldBoundMax = <1.451370, 14.329500, 1.503610>;
#declare yB=400;
#if (Building3OK=1)
    #debug "building 3\n"
    #declare T_Concrete = texture{
        pigment{
            average
            pigment_map{
                [4 P_Concrete05 scale 1/10]
                [3 P_Metal03 scale 1/10]
                [1 P_Hull scale 2/10]
            }
        }
        normal{N_Hull scale 2/10}
        finish{ambient 0 diffuse Diff}
        scale 0.5
    }
    
    #declare T_Glass=texture{
        pigment{Black}
        finish{ambient 0 diffuse 0 reflection Ref*0.9}
    }
    #declare T_Metal=texture{
        T_Chrome_3C finish{ambient 0 reflection Ref*0.3}
    }
    #include "build03_o.inc"
    #declare Build3a=union{
        object{ P_cube1_Concrete }
        object{ P_cube1_Glass }
        object{ P_cube1_Metal }
        scale yB/V_WorldBoundMax.y
    }
    #declare Build3=union{
        object{Build3a}
        object{Build3a scale <1,-1,1>}
        union{
            object{Build3a}
            object{Build3a scale <1,-1,1>}
            translate -y*yB*1.5
        }
    }
#else
    #declare Build3a=box{V_WorldBoundMin,V_WorldBoundMax scale yB/V_WorldBoundMax.y texture{T_default}}
    #declare Build3=union{
        box{V_WorldBoundMin,V_WorldBoundMax}
        box{V_WorldBoundMin,V_WorldBoundMax scale <1,-1,1>} 
        scale yB/V_WorldBoundMax.y         
        scale 0.8
        texture{T_default}
    }
#end

// -----------------------------------------
// Building 4
// -----------------------------------------
#declare V_WorldBoundMin = <-1.750000, 0.000000, -1.570000>;
#declare V_WorldBoundMax = <2.271270, 19.298000, 2.370040>;
#declare yB=400;
#if (Building4OK=1)
    #debug "building 4\n"
    #declare T_Concrete = texture{
        pigment{
            average
            pigment_map{
                [4 P_Concrete03 scale 1/10]
                [3 P_Metal01 scale 1/10]
                [1 P_Hull scale 2/10]
            }
        }
        normal{N_Hull scale 2/10}
        finish{ambient 0 diffuse Diff}
        scale 0.5
    }
    #declare T_Glass=texture{
        pigment{Black}
        finish{ambient 0 diffuse 0 reflection Ref*0.9}
    }
    #declare T_Metal=texture{
        T_Chrome_3C finish{ambient 0 reflection Ref*0.3}
    }
    #include "build04_o.inc"
    #declare Build4a=union{
        object{ P_cylinder1_Concrete }
        object{ P_cylinder1_Glass }
        object{ P_cylinder1_Metal }
        scale yB/V_WorldBoundMax.y rotate -y*10
    }
    #declare Build4=union{
        object{Build4a}
        object{Build4a scale <1,-1,1>}
        union{
            object{Build4a}
            object{Build4a scale <1,-1,1>}
            translate -y*yB*1.5
        }
     }
#else
    #declare Build4=union{
        box{V_WorldBoundMin,V_WorldBoundMax}
        box{V_WorldBoundMin,V_WorldBoundMax scale <1,-1,1>}
        scale yB/V_WorldBoundMax.y 
        scale 0.8
        texture{T_default}
    }
#end

// -----------------------------------------
// Building 5
// -----------------------------------------
#declare V_WorldBoundMin = <-2.037450, 0.000000, -1.999650>;
#declare V_WorldBoundMax = <2.005100, 19.204000, 2.024570>;
#declare yB=400;
#declare T_ConcreteB5 = texture{
    pigment{
        average
        pigment_map{
            [4 P_Concrete04 scale 1/10]
            [3 P_Metal01  scale 4/10]
            [1 P_Hull scale 2/10]
        }
    }
    normal{N_Hull scale 2/10}
    finish{ambient 0 diffuse Diff}
    scale 0.15
}

#if (Building5OK=1)
    #debug "building 5\n"
    #declare T_Concrete=texture{T_ConcreteB5}
    #declare T_Glass=texture{
        pigment{Black}finish{reflection Ref}
    }
    #include "build05_o.inc"
    #declare Build5a=union{
        object{ P_cube1_Concrete }
        object{ P_cube1_Glass }
        scale yB/V_WorldBoundMax.y
    }
    #declare Build5=union{
        object{Build5a}
        object{Build5a scale <1,-1,1>}
        union{
            object{Build5a}
            object{Build5a scale <1,-1,1>}
            translate -y*yB*1.5
        }
     }
#else
    #declare Build5=union{
        box{V_WorldBoundMin,V_WorldBoundMax}
        box{V_WorldBoundMin,V_WorldBoundMax scale <1,-1,1>}
        scale yB/V_WorldBoundMax.y 
        scale 0.8
        texture{T_default}
    }
#end

// -----------------------------------------
// Building 6
// -----------------------------------------
#declare V_WorldBoundMin = <-2.163690, 0.000000, -2.163690>;
#declare V_WorldBoundMax = <2.163690, 23.207899, 2.163690>;
#declare yB=400;
#if (Building6OK=1)
    #debug "building 6\n"
    #declare T_Concrete = texture{
        pigment{
            average
            pigment_map{
                [4 P_Concrete03 scale 1/10]
                [3 P_Metal01 scale 1/10]
                [1 P_Hull scale 2/10]
            }
        }
        normal{N_Hull scale 2/10}
        finish{ambient 0 diffuse Diff}
        scale 0.5
    }
    #declare T_Concrete2 = texture{
        pigment{
            average
            pigment_map{
                [2 checker Black,Orange scale 1/20]
                [4 P_Concrete03 scale 1/10]
                [3 P_Metal01 scale 1/10]
                [1 P_Hull scale 2/10]
            }
        }
        normal{N_Hull scale 2/10}
        finish{ambient 0 diffuse Diff}
        scale 0.5
    }
    #declare T_Glass=texture{
        pigment{Black}
        finish{ambient 0 diffuse 0 reflection Ref*0.9}
    }
    #declare T_Metal=texture{
        T_Chrome_3C finish{ambient 0 reflection Ref*0.3}
    }
    #include "build06_o.inc"
    #declare Build6a=union{ 
        object{ P_cube1_Concrete }
        object{ P_cube1_Concrete2 }
        object{ P_cube1_Glass }
        object{ P_cube1_Metal }
        scale yB/V_WorldBoundMax.y
    }
    #declare Build6=union{
        object{Build6a}
        object{Build6a scale <1,-1,1>}
        union{
            object{Build6a}
            object{Build6a scale <1,-1,1>}
            translate -y*yB*1.5
        }
     }
#else
    #declare Build6=union{
        box{V_WorldBoundMin,V_WorldBoundMax}
        box{V_WorldBoundMin,V_WorldBoundMax scale <1,-1,1>}
        scale yB/V_WorldBoundMax.y 
        scale 0.8
        texture{T_default}
    }
#end

// -----------------------------------------
// Building 7
// -----------------------------------------
#declare V_WorldBoundMin = <-1.326690, -0.004045, -1.041920>;
#declare V_WorldBoundMax = <1.208000, 6.321690, 1.559110>;
#declare yB=300;
#if (Building7OK=1)
    #debug "building 7\n"
    #declare T_Concrete = texture{
        pigment{
            average
            pigment_map{
                [4 P_Concrete03 scale 1/10]
                [3 P_Metal01 scale 1/10]
                [1 P_Hull scale 1/15]
            }
        }
        normal{N_Hull scale 1/15}
        finish{ambient 0 diffuse Diff}
        scale 0.5
    }
    #declare T_Concrete2 = texture{
        pigment{
            average
            pigment_map{
                [5 checker Black,SkyBlue*0.6 scale 1/100]
                [2 P_Concrete03 scale 1/10]
                [3 P_Metal01 scale 1/10]
                [1 P_Hull scale 2/10]
            }
        }
        normal{N_Hull scale 2/10}
        finish{ambient 0 diffuse Diff}
        scale 0.5
    }
    #declare T_Concrete3 = texture{
        pigment{
            average
            pigment_map{
                [5 checker Red*0.5,ForestGreen*0.5 rotate z*45 scale 1/20]
                [2 P_Concrete03 scale 1/10]
                [3 P_Metal01 scale 1/10]
                [1 P_Hull scale 2/10]
            }
        }
        normal{N_Hull scale 2/10}
        finish{ambient 0 diffuse Diff}
        scale 0.5
    }
    #declare T_Glass=texture{
        pigment{Black}
        finish{ambient 0 diffuse 0 reflection Ref*0.9}
    }
    #declare T_Metal=texture{
        pigment{P_Metal01 scale 1/50}
        finish{ambient 0 diffuse 1}
    }
    #include "build07_o.inc"
    #declare Build7a=union{
        object{ P_cube1_Concrete }
        object{ P_cube1_Concrete2 }
        object{ P_cube1_Concrete3 }
        object{ P_cube1_Glass }
        object{ P_cube1_Metal }
         scale yB/V_WorldBoundMax.y
    }
    #declare Build7=union{
        object{Build7a}
        object{Build7a scale <1,-1,1>}
        union{
            object{Build7a}
            object{Build7a scale <1,-1,1>}
            translate -y*yB*1.5
        }
     }
#else
    #declare Build7=union{
        box{V_WorldBoundMin,V_WorldBoundMax}
        box{V_WorldBoundMin,V_WorldBoundMax scale <1,-1,1>}
        scale yB/V_WorldBoundMax.y 
        scale 0.8
        texture{T_default}
    }
#end
#declare rd=seed(2);

// -----------------------------------------
// cars
// -----------------------------------------
// cars and trucks
// Note : only the trucks are (badly) uv-mapped

#debug "Cars\n"
#declare nCars=7;
#declare Cars=array[nCars];
#declare Car=box{-1,1 scale <1.4/2,1.4/2,4/2> texture{pigment{White}}}
#declare i=0;
#while (i<nCars)
    #declare Cars[i]=object{Car}
    #declare i=i+1;
#end

#if (CarsOK=0)
    #declare Car1OK=0; 
    #declare Car4OK=0; 
    #declare Car5OK=0; 
    #declare Car6OK=0; 
    #declare Car7OK=0; 
    #declare Truck1OK=0; 
    #declare Truck2OK=0;
#end

// -----------------------------------------
// car 1 (classic car)
// -----------------------------------------
#if (Car1OK=1)
    #declare T_Paint = texture{pigment{Blues[3]}finish{ambient 0 diffuse 0.8 specular 1 roughness 1/1000 reflection {0.2*Ref, 0.8*Ref }}}
    #declare T_T_Chrome = texture{T_Chrome_1B finish{ambient 0 reflection 0.25*Ref}}
    #declare T_T_Glass = texture{pigment{rgbf <0.6,0.9,0.96,0.7>} finish{ambient 0 diffuse 0.1 specular 1 roughness 1/1000 reflection{0.1*Ref,0.5*Ref}}}
    #declare T_T_Hlight = texture{T_T_Glass}
    #declare T_T_Motor = texture{T_Chrome_1C finish{ambient 0 reflection 0.25*Ref}}
    #declare T_T_Rlight = texture{pigment{rgbf <1,0,0,0.6>} finish{ambient 0 diffuse 1 reflection Ref*0.2}}
    #declare T_default = texture{T_Paint}
    #declare T_Hlight2 = texture{T_T_Glass}
    
    #declare V_WorldBoundMin = <-2.331450, -0.177594, -1.023210>;
    #declare V_WorldBoundMax = <2.543850, 1.081610, 1.023210>;

    #declare Intensity=3;
    #declare Flame= difference{
        sphere{0,1}
        plane{y,0} 
        hollow
        texture{
            pigment{Clear}
            finish{ambient 0 diffuse 0}
        }
        interior {
            media {
                emission 2*Intensity
                density {
                    spherical 
                    color_map {
                        [0 rgb 0]
                        [1 rgb <1,0.9,0.8>]
                    }
                    scale <1,0.4,1>
                    translate -y*0.1
                }
            }      
            media {
                emission 1*Intensity
                density {
                    pigment_pattern{
                        function {min(1,max(0,y))}
                        turbulence 0.1
                        lambda 4
                    }                    
                    color_map {
                        [0.0 rgb <1,.5,.05>]
                        [0.8 rgb 0]
                    }
                    scale 0.4*<1,1,1>
                }            
            } 
        }
        scale <0.2,3,0.2>*0.7
        rotate z*90
        translate <-1.8,0.2324,0>
    }

    #debug "Car1a\n"
    #include "car1d_o.inc"
    #declare Cars[0]=union{
        object{ P_cube2_Hlight2 }
        object{ P_cube2_Paint }
        object{ P_cube2_T_Chrome }
        object{ P_cube2_T_Glass }
        object{ P_cube2_T_Hlight }
        object{ P_cube2_T_Motor }
        object{ P_cube2_T_Rlight }
        object{ P_cube2_default }
        object{ Flame }
        rotate y*-90
        translate y*0.2
        scale 1.7 
    }
#end


// -----------------------------------------
// car 4 (nose car)
// -----------------------------------------
#if (Car4OK=1)
    #declare V_WorldBoundMin = <-0.578364, -1.226680, -0.903809>;
    #declare V_WorldBoundMax = <0.954183, 0.837164, 3.047830>;
    
    #debug "Car4a\n"
    #declare T_Exhaust = texture{pigment{DarkGreys[8]}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0,0.2*Ref}}}
    #declare T_Paint = texture{pigment{Reds[2]}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0,0.5*Ref}}}
    #declare T_Rlight = texture{pigment{Red*0.2}finish{ambient 0 diffuse 1}}
    #declare T_Hlight = texture{pigment{White*0.5}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0.3*Ref,Ref}}}
    #declare T_Glass = texture{pigment{rgbf <0.9,0.9,0.96,0.9>} finish{ambient 0 diffuse 0.1 specular 1 roughness 1/1000 reflection{0.1*Ref,0.5*Ref}}}
    #declare T_Chrome = texture{pigment{rgb <1,0.9,0.8>*0.7} finish{ambient 0 diffuse 1 brilliance 5 metallic specular 1 roughness 1/200 reflection{0.1*Ref, 0.5*Ref}}}

    #declare Intensity=4;
    #declare Flame= difference{
        sphere{0,1}
        plane{y,0} 
        hollow
        texture{
            pigment{Clear}
            finish{ambient 0 diffuse 0}
        }
        interior {
            media {
                emission 2*Intensity
                density {
                    spherical 
                    color_map {
                        [0 rgb 0]
                        [1 rgb <1,0.9,0.8>]
                    }
                    scale <1,0.4,1>
                    translate -y*0.1
                }
            }      
            media {
                emission 1*Intensity
                density {
                    pigment_pattern{
                        function {min(1,max(0,y))}
                        turbulence 0.1
                        lambda 4
                    }                    
                    color_map {
                        [0.0 rgb <1,.5,.05>]
                        [0.8 rgb 0]
                    }
                    scale 0.4*<1,1,1>
                }            
            } 
        }
        scale <0.2,3,0.2>*0.7
        rotate -x*90
    }

    #declare Flames=union{
        object{Flame translate <0.3869,-0.3826,-0.08>}
        object{Flame translate <0,-0.3826,-0.08>}
        object{Flame translate <0.3869,-0.81,0>}
        object{Flame translate <0,-0.81,0>}
        translate -z*0.4
    }

    #include "car4_o.inc"
    #declare Cars[2]=union{
        object{ P_cube1_Chrome }
        object{ P_cube1_Exhaust }
        object{ P_cube1_Glass }
        object{ P_cube1_Hlight }
        object{ P_cube1_Paint }
        object{ P_cube1_Rlight }
        object{ Flames }
        translate y*1.1-z*1
        scale 1.6
    }
#end    

// -----------------------------------------
// car 5 (boat car)
// -----------------------------------------
#if (Car5OK=1)
    #declare T_default = texture{pigment{Blues[0]}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0,0.5*Ref}}}
    #declare T_Rearlight = texture{pigment{Red*0.2}finish{ambient 0 diffuse 1}}
    #declare T_ReactorIn = texture{pigment{bozo color_map{[0 Red*0.2][1 White*0.2]}} finish{ambient 0 diffuse 1}}
    #declare T_Mirror = texture{pigment{Black}finish{ambient 0 diffuse 0 roughness 1/30 reflection 1*Ref}}
    #declare T_Headlight = texture{pigment{White*0.5}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0.3*Ref,Ref}}}
    #declare T_Glass = texture{pigment{rgbf <0.9,0.9,0.96,0.9>} finish{ambient 0 diffuse 0.1 specular 1 roughness 1/1000 reflection{0.1*Ref,0.5*Ref}}}
    #declare T_Chrome = texture{pigment{rgb <1,0.9,0.8>*0.7} finish{ambient 0 diffuse 1 brilliance 5 metallic specular 1 roughness 1/200 reflection{0.1*Ref, 0.5*Ref}}}

    #declare Intensity=3;
    #declare Flame= difference{
        sphere{0,1}
        plane{y,0} 
        hollow
        texture{
            pigment{Clear}
            finish{ambient 0 diffuse 0}
        }
        interior {
            media {
                emission 2*Intensity
                density {
                    spherical 
                    color_map {
                        [0 rgb 0]
                        [1 rgb <1,0.9,0.8>]
                    }
                    scale <1,0.4,1>
                    translate -y*0.1
                }
            }      
            media {
                emission 1*Intensity
                density {
                    pigment_pattern{
                        function {min(1,max(0,y))}
                        turbulence 0.1
                        lambda 4
                    }                    
                    color_map {
                        [0.0 rgb <1,.5,.05>]
                        [0.8 rgb 0]
                    }
                    scale 0.4*<1,1,1>
                }            
            } 
        }
        scale <0.2,3,0.2>*0.9
        rotate z*90
        scale <1,0.8,1>
        
    }

    #declare Flames=union{
        object{Flame translate <0,-0.166471,0.3835>}
        object{Flame translate <0,-0.166471,-0.3835>}
        translate x*-1.6
    }

    #declare V_WorldBoundMin = <-2.367380, -0.440462, -0.988990>;
    #declare V_WorldBoundMax = <2.089100, 1.630210, 0.989146>;
    #debug "Car5a\n"
    #include "car5_o.inc"
    #declare Cars[1]=union{
        object{ P_cube2_Chrome }
        object{ P_cube2_Glass }
        object{ P_cube2_Headlight }
        object{ P_cube2_Mirror }
        object{ P_cube2_ReactorIn }
        object{ P_cube2_Rearlight }
        object{ P_cube2_default }
        object{ Flames }
        translate y*0.2
        scale 1.4
        rotate -y*90
    }
#end

// -----------------------------------------
// car 6 (speeder car with bulb canopy)
// -----------------------------------------
#if (Car6OK=1)
    #declare V_WorldBoundMin = <-1.817420, -0.026592, -1.289770>;
    #declare V_WorldBoundMax = <2.914590, 1.447330, 1.289770>;

    #declare T_Reactor = texture{pigment{LightGreys[3]}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0,0.2*Ref}}}
    #declare T_Paint = texture{
        pigment{Reds[5]*0.45+Orange*0.45}
        finish{
            ambient 0 diffuse 1 specular 1 roughness 1/40 metallic brilliance 3 
            reflection{0,0.3*Ref fresnel on}
        }
    }
    #declare T_Rlight = texture{pigment{Red*0.2}finish{ambient 0 diffuse 1}}
    #declare T_Hlight = texture{pigment{White*0.5}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0.3*Ref,Ref}}}
    #declare T_Glass = texture{pigment{rgbf <0.4,0.9,0.96,0.6>/2} finish{ambient 0 diffuse 0.1 specular 1 roughness 1/1000 reflection{0*Ref,0.9*Ref}}}
    #declare T_Chrome = texture{pigment{rgb <1,0.9,0.8>*0.7} finish{ambient 0 diffuse 1 brilliance 5 metallic specular 1 roughness 1/200 reflection{0.1*Ref, 0.5*Ref}}}

    #declare Intensity=3;
    #declare Flame= difference{
        sphere{0,1}
        plane{y,0} 
        hollow
        texture{
            pigment{Clear}
            finish{ambient 0 diffuse 0}
        }
        interior {
            media {
                emission 2*Intensity
                density {
                    spherical 
                    color_map {
                        [0 rgb 0]
                        [1 rgb <1,0.9,0.8>]
                    }
                    scale <1,0.4,1>
                    translate -y*0.1
                }
            }      
            media {
                emission 1*Intensity
                density {
                    pigment_pattern{
                        function {min(1,max(0,y))}
                        turbulence 0.1
                        lambda 4
                    }                    
                    color_map {
                        [0.0 rgb <1,.5,.05>]
                        [0.8 rgb 0]
                    }
                    scale 0.4*<1,1,1>
                }            
            } 
        }
        scale <0.2,3,0.2>*0.9
        rotate z*90
        translate <-1.1,0.25,0>
        
    }
    
    #debug "Car6a\n"
    #include "car6_o.inc"
    #declare Cars[3]=union{
        object{ P_cube2_Chrome }
        object{ P_cube2_Glass }
        object{ P_cube2_Hlight }
        object{ P_cube2_Paint interior{ior 10}}
        object{ P_cube2_Reactor }
        object{ P_cube2_Rlight }
        object{ Flame }
        scale 1.4
        rotate -y*90
    }
#end

// -----------------------------------------
// car 7 (classic car with keel)
// -----------------------------------------
#if (Car7OK=1)
    
    #declare V_WorldBoundMin = <-1.824800, -0.207535, -1.012980>;
    #declare V_WorldBoundMax = <2.266020, 1.866860, 1.012980>;
    #declare T_Mirror = texture{pigment{Black}finish{ambient 0 diffuse 0 roughness 1/30 reflection 1}}
    #declare T_Exhaust = texture{pigment{DarkGreys[8]}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0,0.2*Ref}}}
    #declare T_Paint = texture{
        pigment{LightGreys[8]}
        finish{
            ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0,0.5*Ref}
        }
    }
    #declare T_Rlight = texture{pigment{Red*0.2}finish{ambient 0 diffuse 1}}
    #declare T_Hlight = texture{pigment{White*0.5}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0.3*Ref,Ref}}}
    #declare T_Glass = texture{pigment{rgbf <0.9,0.9,0.96,0.9>} finish{ambient 0 diffuse 0.1 specular 1 roughness 1/1000 reflection{0.1*Ref,0.5*Ref}}}
    #declare T_Chrome = texture{pigment{rgb <1,0.9,0.8>*0.7} finish{ambient 0 diffuse 1 brilliance 5 metallic specular 1 roughness 1/200 reflection{0.1*Ref, 0.5*Ref}}}
    #declare T_Slight = texture{pigment{Orange*0.2}finish{ambient 0 diffuse 1}}
    #declare T_default = texture{T_Paint}

    #declare Intensity=3;
    #declare Flame= difference{
        sphere{0,1}
        plane{y,0} 
        hollow
        texture{
            pigment{Clear}
            finish{ambient 0 diffuse 0}
        }
        interior {
            media {
                emission 2*Intensity
                density {
                    spherical 
                    color_map {
                        [0 rgb 0]
                        [1 rgb <1,0.9,0.8>]
                    }
                    scale <1,0.4,1>
                    translate -y*0.1
                }
            }      
            media {
                emission 1*Intensity
                density {
                    pigment_pattern{
                        function {min(1,max(0,y))}
                        turbulence 0.1
                        lambda 4
                    }                    
                    color_map {
                        [0.0 rgb <1,.5,.05>]
                        [0.8 rgb 0]
                    }
                    scale 0.4*<1,1,1>
                }            
            } 
        }
        scale <0.2,3,0.2>*0.8
        rotate z*90
        
    }

    #declare Flames=union{
            object{Flame translate <-1.25,0.48,-0.22>}
            object{Flame translate <-1.25,0.48,0.22>}
    }

    #debug "Car7a\n"
    #include "car7_o.inc"
    #declare Cars[4]=union{
        object{ P_cube2_Chrome }
        object{ P_cube2_Exhaust }
        object{ P_cube2_Glass }
        object{ P_cube2_Hlight }
        object{ P_cube2_Mirror }
        object{ P_cube2_Paint }
        object{ P_cube2_Rlight }
        object{ P_cube2_Slight }
        object{ P_cube2_default }
        object{ Flames }
        scale 1.6
        rotate -y*90
    }

#end

// -----------------------------------------
// truck 1 (boxy one)
// -----------------------------------------
#if (Truck1OK=1)
    #declare V_WorldBoundMin = <-5.008890, -1.144870, -1.146160>;
    #declare V_WorldBoundMax = <2.620000, 1.122500, 1.146160>;
    #declare T_Paint = texture{pigment{average pigment_map{[1 P_Metal01 scale 1/4][2 Blues[6]]}}finish{ambient 0 diffuse 1 metallic brilliance 1 specular 0.4 roughness 1/30}}
    #declare T_Rlight = texture{pigment{Red*0.2}finish{ambient 0 diffuse 1}}
    #declare T_Hlight = texture{pigment{White*0.5}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0.3*Ref,Ref}}}
    #declare T_Glass = texture{pigment{rgbf <0.9,0.9,0.96,0.9>} finish{ambient 0 diffuse 0.1 specular 1 roughness 1/1000 reflection{0.1*Ref,0.5*Ref}}}
    #declare T_Chrome = texture{pigment{rgb <1,0.9,0.8>*0.7} finish{ambient 0 diffuse 1 brilliance 5 metallic specular 1 roughness 1/200 reflection{0.4*Ref, 0.99*Ref}}}
    #declare T_Metal = texture{pigment{average pigment_map{[1 P_Metal01 scale 1/10][1 DarkGreys[2]]}}finish{ambient 0 diffuse 0.6 metallic brilliance 4 specular 0.4 roughness 1/30}}

    #declare Intensity=3;
    #declare Flame= difference{
        sphere{0,1}
        plane{y,0} 
        hollow
        texture{
            pigment{Clear}
            finish{ambient 0 diffuse 0}
        }
        interior {
            media {
                emission 2*Intensity
                density {
                    spherical 
                    color_map {
                        [0 rgb 0]
                        [1 rgb <1,0.9,0.8>]
                    }
                    scale <1,0.4,1>
                    translate -y*0.1
                }
            }      
            media {
                emission 1*Intensity
                density {
                    pigment_pattern{
                        function {min(1,max(0,y))}
                        turbulence 0.1
                        lambda 4
                    }                    
                    color_map {
                        [0.0 rgb <1,.5,.05>]
                        [0.8 rgb 0]
                    }
                    scale 0.4*<1,1,1>
                }            
            } 
        }
        scale <0.25,4,0.25>
        rotate z*90
    }
    #declare Flames=union{
        object{Flame translate <0,0.46,0.41>}
        object{Flame translate <0,0.46,-0.41>}
        object{Flame translate <0,-0.35,0.41>}
        object{Flame translate <0,-0.35,-0.41>}
        translate -x*3.8
    }
    #debug "Truck 1a\n"
    #include "truck1_o.inc"
    #declare Cars[5]=union{
        object{ P_cube1_Chrome }
        object{ P_cube1_Glass }
        object{ P_cube1_Hlight }
        object{ P_cube1_Metal }
        object{ P_cube1_Paint }
        object{ Flames }
        translate y*1.1+x
        scale 1.7
        rotate -y*90
    }

#end

// -----------------------------------------
// truck 2 (with side reactors)
// -----------------------------------------
#if (Truck2OK=1)
    #declare V_WorldBoundMin = <-1.975230, -0.354250, -3.138580>;
    #declare V_WorldBoundMax = <1.975230, 1.482000, 3.133740>;
    #declare T_Paint = texture{pigment{Greens[1]}finish{ambient 0 diffuse 1 metallic brilliance 1 specular 0.4 roughness 1/30 reflection{0.1*Ref,0.5*Ref}}}
    #declare T_Paint2 = texture{pigment{image_map{jpeg "csign33" interpolate 2} scale <-1.3,1,1>/16}finish{ambient 0 diffuse 0.6 metallic brilliance 1 specular 0.4 roughness 1/30}}
    #declare T_Rlight = texture{pigment{Red*0.2}finish{ambient 0 diffuse 1}}
    #declare T_Hlight = texture{pigment{White*0.5}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30 reflection{0.3*Ref,Ref}}}
    #declare T_Glass = texture{pigment{rgbf <0.7,0.9,0.96,0.9>} finish{ambient 0 diffuse 0.1 specular 1 roughness 1/1000 reflection{0.1*Ref,0.5*Ref}}}
    #declare T_Chrome = texture{T_Paint} //texture{pigment{rgb <1,0.9,0.8>*0.7} finish{ambient 0 diffuse 1 brilliance 2 metallic specular 1 roughness 1/200 reflection{0*Ref, 0.2*Ref}}}
    #declare T_Reactor = texture{pigment{DarkGreys[2]}finish{ambient 0 diffuse 1 metallic brilliance 1 specular 0.4 roughness 1/30}}
    #declare T_default=texture{T_Reactor}
    #declare Intensity=3;
    #declare Flame= difference{
        sphere{0,1}
        plane{y,0} 
        hollow
        texture{
            pigment{Clear}
            finish{ambient 0 diffuse 0}
        }
        interior {
            
            media {
                emission 2*Intensity
                density {
                    spherical 
                    color_map {
                        [0 rgb 0]
                        [1 rgb <1,0.9,0.8>]
                    }
                    scale <1,0.4,1>
                    translate -y*0.1
                }
            }      
            media {
                emission 1*Intensity
                density {
                    pigment_pattern{
                        function {min(1,max(0,y))}
                        turbulence 0.1
                        lambda 4
                    }                    
                    color_map {
                        [0.0 rgb <1,.5,.05>]
                        [0.8 rgb 0]
                    }
                    scale 0.4*<1,1,1>
                }            
            } 
        }
        scale <0.2,3,0.2>
        rotate -x*90
    }

    #declare Flames=union{
        object{Flame translate <1.69,-0.1025,0>}
        object{Flame translate <-1.69,-0.1025,0>}
        translate -z*2.5
    }

    #debug "Truck 2a\n"
    #include "truck2_o.inc"
    #declare Cars[6]=union{
        object{ P_cube2_Chrome }
        object{ P_cube2_Glass }
        object{ P_cube2_Hlight }
        object{ P_cube2_Paint }
        object{ P_cube2_Paint2 }
        object{ P_cube2_Reactor }
        object{ P_cube2_Rlight }
        object{ P_cube2_default }
        object{ Flames }
        scale 1.7
    }

#end            


// -----------------------------------------
// Bus
// -----------------------------------------
#if (BusOK=1)
    #declare F_Paint=finish{
        ambient 0 
        diffuse 0.7 
        specular 1 
        roughness 1/1000 
        reflection {0,0.4*Ref} 
    }
    #declare F_BrushedMetal=finish{
        ambient 0 
        diffuse 0.6 
        metallic
        brilliance 1
        specular 0.1 
        roughness 1/20
        reflection {0,0.1*Ref} 
    }
    #declare T_Paint = texture{// body paint
        pigment_pattern{
            gradient z
            rotate x*45
            scale 10
            translate z*8
        }
        texture_map{
            [0.95
                gradient y
                texture_map{
                    [0.6 pigment{White}finish{F_BrushedMetal}]
                    [0.6 pigment{White*0.1}finish{F_Paint}]
                    [0.7 pigment{White*0.1}finish{F_Paint}]
                    [0.7 pigment{rgb <1,0.3,0.2>}finish{F_Paint}]
                    [0.8 pigment{rgb <1,0.3,0.2>}finish{F_Paint}]
                    [0.8 pigment{rgb <247,197,27>/255}finish{F_Paint}]
                }
            ]
            [0.95 pigment{SkyBlue}finish{F_BrushedMetal}]
        }
        scale 0.5
    } 
    // use the transparent glass if necessary (takes longer to render)
    // for instance when using the version with interior lighting
    #declare T_Glass = texture{
//        pigment{rgbf <0.6,0.9,0.96,0.6>} // for transparent glass
        pigment{rgb <0.6,0.9,0.96>} 
        finish{ambient 0 diffuse 0.1 specular 1 roughness 1/1000 
            reflection{0.1*Ref,0.5*Ref}
        }
    }
    #declare T_Metal = texture{pigment{DarkGreys[2]}finish{ambient 0 diffuse 1 metallic brilliance 4 specular 0.4 roughness 1/30}}

    #declare Intensity=3;
    #declare Flame= difference{
        sphere{0,1}
        plane{y,0} 
        hollow
        texture{
            pigment{Clear}
            finish{ambient 0 diffuse 0}
        }
        interior {
            media {
                emission 2*Intensity
                density {
                    spherical 
                    color_map {
                        [0 rgb 0]
                        [1 rgb <1,0.9,0.8>]
                    }
                    scale <1,0.4,1>
                    translate -y*0.1
                }
            }      
            media {
                emission 1*Intensity
                density {
                    pigment_pattern{
                        function {min(1,max(0,y))}
                        turbulence 0.1
                        lambda 4
                    }                    
                    color_map {
                        [0.0 rgb <1,.5,.05>]
                        [0.8 rgb 0]
                    }
                    scale 0.4*<1,1,1>
                }            
            } 
        }
        scale <0.25,4,0.25>*0.5
        rotate -x*90
    }

    #declare V_WorldBoundMin = <-2.088460, -0.543148, -5.648700>;
    #declare V_WorldBoundMax = <2.088460, 2.074820, 0.168207>;

    #debug "bus wagon\n"
    #include "bus_o.inc"
    #declare Bus_Wagon=union{
        object{ P_cube1_Glass }
        object{ P_cube1_Metal }
        object{ P_cube1_Paint }
    }
    #declare V_WorldBoundMin = <-0.693440, 0.165479, -0.002704>;
    #declare V_WorldBoundMax = <0.693422, 1.337700, 2.596930>;

    #debug "bus head\n"
    #include "bushead_o.inc"
    #declare Bus_Head=union{
        object{ P_cube1_cut4_Glass }
        object{ P_cube1_cut4_Metal }
        object{ P_cube1_cut4_Paint }
        object{Flame translate <0,-0.13,1.1>}
    }

    #declare V_WorldBoundMin = <-0.608794, 0.079604, -1.761380>;
    #declare V_WorldBoundMax = <0.608890, 1.330880, 0.168207>;
    #debug "bus tail\n"
    #include "bustail_o.inc"
    #declare Bus_Tail=union{
        object{ P_cube1_cut2_Metal }
        object{ P_cube1_cut2_Paint }
    }

    #declare BusStraight=union{
        object{Bus_Head}
        object{Bus_Wagon}
        object{Bus_Wagon translate -z*5.68}
        object{Bus_Wagon translate -z*5.68*2}
        object{Bus_Wagon translate -z*5.68*3}
        object{Bus_Wagon translate -z*5.68*4}
        object{Bus_Wagon translate -z*5.68*5}
        object{Bus_Tail translate -z*5.68*6}
        scale 2.5
    }
    // the following bus is not used in the image
    // it's the same as above, but with only 3 wagons and it's turning
    #declare Bus_Angle=-15;
    #declare BusTurn=union{
        object{Bus_Head}
        union{
            object{Bus_Wagon}
            union{
                object{Bus_Wagon}
                union{
                    object{Bus_Wagon}
                    object{
                        Bus_Tail 
                        rotate y*Bus_Angle
                        translate -z*5.68
                    }
                    rotate y*Bus_Angle
                    translate -z*5.68
                }
                rotate y*Bus_Angle
                translate -z*5.68
            }
            rotate y*Bus_Angle
        }
        scale 2.5
    }
    // this bus is not used in the image
    // same bus as above but with interior lighting
    //
    #declare BusLight=light_group{
        object{Bus_Wagon}
        light_source{<0,1,-2.5> C_BusLight*3 media_interaction off}
        global_lights on
    }
    #declare BusStraightLight=union{
        object{Bus_Head}
        object{BusLight}
        object{BusLight translate -z*5.68}
        object{BusLight translate -z*5.68*2}
        object{BusLight translate -z*5.68*3}
        object{BusLight translate -z*5.68*4}
        object{BusLight translate -z*5.68*5}
        object{BusLight translate -z*5.68*6}
        scale 2.5
    }
    #declare BusTurnLight=union{
        object{Bus_Head}
        union{
            object{BusLight}
            union{
                object{BusLight}
                union{
                    object{BusLight}
                    object{
                        Bus_Tail 
                        rotate y*Bus_Angle
                        translate -z*5.68
                    }
                    rotate y*Bus_Angle
                    translate -z*5.68
                }
                rotate y*Bus_Angle
                translate -z*5.68
            }
            rotate y*Bus_Angle
        }
        scale 2.5
    }
#else                                                    
    #declare BusStraight=box{<-5,0,-5.6*2.5*4>,<5,5,0> texture{pigment{Cyan}}}
    #declare BusTurn=object{BusStraight}
    #declare BusStraightLight=object{BusStraight}
    #declare BusTurnLight=object{BusStraight}
#end

// -----------------------------------------
// Car placement
// -----------------------------------------
#if (CarsOK=1)
    #macro RandZ()
        <0.5-rand(rd),0.5-rand(rd),(0.5-rand(rd))*2>*20
    #end
    #macro RandX()
        <(0.5-rand(rd))*2,(0.5-rand(rd))*8,(0.5-rand(rd))*2>*10
    #end
    #declare rd=seed(4610);
    #declare Car= box{<-0.8,0,-2>,<0.8,1.6,2>}

    // -----------------------------------------
    // Foreground speeder
    // -----------------------------------------
    object{Cars[3] scale 1.5 rotate y*90 rotate x*-30 translate <384,202,-285> no_shadow}
    // -----------------------------------------
    // Car lines
    // -----------------------------------------
    #declare i=-200;
    // lines extend on the x axis
    union{
        #while (i < 400)
            #declare j=100;
            #while (j<800)
                object{Cars[int(nCars*rand(rd))] scale 2 rotate -y*90 rotate z*(0.5-rand(rd))*5 translate <i,j,-50>+RandX() no_shadow}
                object{Cars[int(nCars*rand(rd))] scale 2 rotate y*90 rotate z*(0.5-rand(rd))*5 translate <i,j,-100>+RandX() no_shadow}
                object{Cars[int(nCars*rand(rd))] scale 2 rotate -y*90 rotate z*(0.5-rand(rd))*5 translate <i,j,-150>+RandX() no_shadow}
                object{Cars[int(nCars*rand(rd))] scale 2 rotate y*90 rotate z*(0.5-rand(rd))*5 translate <i,j,-200>+RandX() no_shadow}
                object{Cars[int(nCars*rand(rd))] scale 2 rotate -y*90 rotate z*(0.5-rand(rd))*5 translate <i,j,-250>+RandX() no_shadow}
                #declare j=j+100;
            #end
            #declare i=i+100;
        #end
    }
#end


// -----------------------------------------
// Placement bus
// -----------------------------------------
object{BusStraight scale 1.5 rotate y*180 translate <150,155,-250>}
object{BusStraight scale 1.5 rotate y*90 translate <320,265,-223>}

// -----------------------------------------
// Placement buildings
// -----------------------------------------

#if (BuildingsOK=1)
    object{Build5 scale 1.5 scale <1,1,1> rotate y*0 translate -z*230-y*390+x*50} 

    object{Build7 rotate y*90 scale 1.4 translate -z*270-x*200+y*150} 
    
    object{Build3 scale 1.4 scale <4,1,-1> rotate y*90 translate -x*300+z*100-y*100} 
    object{Build5 scale 1.3 scale <4,1,1> rotate -y*90 translate -x*300-z*200-y*100} 
    object{Build5 scale 1.6 rotate y*90 translate -x*230-z*240-y*100} 
    object{Build4 scale 1.4 rotate y*90 translate -x*220-z*100} 
    object{Build4 scale 1.2 scale <-1,1,1> rotate y*0 translate -x*200-z*150-y*60}
    object{Build3 scale 1.2 rotate y*-90 translate -x*180-z*100} 
    object{Build7 rotate -y*90 scale 1.4 translate -x*70+y*100} 
    object{Build7 scale 1.4} // main
    object{Build7 rotate y*90 scale 1.4 translate x*70+y*50} 
    object{Build7 rotate -y*90 scale 1.4 translate x*100+y*50+z*250} 
    object{Build5 scale 1.4 translate x*140} 
    object{Build6 scale 1.6 translate x*230-y*100} 
    object{Build4 scale 1.4 rotate -y*180 translate x*260+z*100} 
    // bridge
    object{Build3 scale 1.4 rotate y*0 scale <0.4,3,0.1> rotate x*90 rotate y*0 translate -x*150-z*225+y*155} 

#end

// -----------------------------------------
// Ground plane
// -----------------------------------------
plane {y,-300 texture{pigment{P_Concrete03} finish{ambient 0 diffuse 0.1}}}
