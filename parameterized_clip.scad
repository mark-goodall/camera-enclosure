// parameterized_clip.scad
// Copyright (c)2023 DP design / Daniel Perry
// place this file in the correct OpenSCAD library directory for your operating system,
// then add:
// use parameterized_clip.scad
// to your code


clip_width = 10;
clip_length = 20;
clip_thickness = 20;
clip_arm_width = 1;
clip_body_length = 4;
tab_protrusion = 0.8;
clip_male_female_delta = 0.25;
angled_clip_Boolean = true;    // need a larger clip_thickness to make sense
locking_clip_Boolean = true;

$fs = 0.2;
$fa = 4;

test_body1();
translate([0, 50,0]) test_body2();
//test_body3();

module test_body1() {
    difference() {
        union() {
            cube([30, 20, 5], center = true);
            translate([14.9, 0, -0.5*(5-3)]) male_clip(clip_length, clip_width, 3, clip_arm_width, clip_body_length, tab_protrusion, false, false);

        }
        translate([-15.1, 0, -0.5*(5-3)]) female_clip(clip_length, clip_width, 3, clip_arm_width, clip_body_length, tab_protrusion, false, false, clip_male_female_delta);
    }
}

module test_body2() {   // angled clip
    difference() {
        union() {
            cube([30, 20, 30], center = true);
            translate([14.9, 0, 0]) male_clip( 20, 10, 20, 1, 0, 0.8, true, false );
        }
        translate([-15.1, 0, 0]) female_clip( 20, 10, 20, 1, 0, 0.8, true, false, clip_male_female_delta );
    }
}

module test_body3() {   // angled clip
    difference() {
        union() {
            cube([30, 20, 30], center = true);
            translate([14.9, 0, 0]) male_clip( 20, 10, 20, 1, 0, 0.8, true, true );
        }
        translate([-15.1, 0, 0]) female_clip( 20, 10, 20, 1, 0, 0.8, true, true, clip_male_female_delta );
    }
}


// male_clip( clip_length, clip_width, clip_thickness, clip_arm_width, clip_body_length, tab_protrusion, angled_clip_Boolean, locking_clip_Boolean );
// translate([0, 30, 0])
//      female_clip( clip_length, clip_width, clip_thickness, clip_arm_width, clip_body_length, tab_protrusion, angled_clip_Boolean, locking_clip_Boolean, clip_male_female_delta );

module female_clip(clength, cwidth, cthick, carmw, cbodyl, tabp, acBool, lcBool, delta) {
    tab_dist_from_end = 4;
    tab_radius = 4 + delta;
    blocker_length = 2*tab_radius + 2;
    difference() {
        union() {
            hull() {
                translate([clength - 0.5*carmw, -0.5*(cwidth - carmw), 0]) cylinder( h = cthick + delta, d = carmw + delta, center = true );
                translate([1, -0.5*(cwidth - carmw), 0]) cube([2, carmw + delta, cthick + delta], center = true);
            // }
            // hull() {
                translate([clength - 0.5*carmw, 0.5*(cwidth - carmw), 0]) cylinder( h = cthick + delta, d = carmw + delta, center = true );
                translate([1, 0.5*(cwidth - carmw), 0]) cube([2, carmw + delta, cthick + delta], center = true);
            }
            translate([0.5*cbodyl, 0, 0]) cube([cbodyl, cwidth, cthick + delta], center = true);

            difference() {
                translate([clength - tab_dist_from_end, -0.5*cwidth + tab_radius - tabp, 0]) cylinder(h = cthick + delta, r = tab_radius, center = true);
                translate([clength - tab_dist_from_end, -0.5*cwidth + 0.5*carmw + 0.5*blocker_length, 0]) 
                    cube([blocker_length, blocker_length, cthick + 2], center = true);
                if (lcBool) {
                    translate([clength - 0.5*blocker_length - tab_dist_from_end, -0.5*blocker_length, 0])
                        cube([blocker_length, blocker_length, cthick + 2], center = true);
                }
            }
            difference() {
                translate([clength - tab_dist_from_end, 0.5*cwidth - (tab_radius - tabp), 0]) cylinder(h = cthick + delta, r = tab_radius, center = true);
                translate([clength - tab_dist_from_end, 0.5*cwidth - 0.5*carmw - 0.5*blocker_length, 0]) 
                    cube([blocker_length, blocker_length, cthick + 2], center = true);
                if (lcBool) {
                    translate([clength - 0.5*blocker_length - tab_dist_from_end, cwidth - 0.5*blocker_length, 0])
                        cube([blocker_length, blocker_length, cthick + 2], center = true);
                }
            }
        }
        if (acBool) {
            translate([0.5*clength, 0, -0.5*cthick])  rotate([0, 55, 0])
                cube([clength/(2*sin(55)), 2*cwidth, 5*cthick], center = true );
        }

    }
}

module male_clip(clength, cwidth, cthick, carmw, cbodyl, tabp, acBool, lcBool ) {
    tab_dist_from_end = 4;
    tab_radius = 4;
    blocker_length = 2*tab_radius + 2;
    difference() {
        union() {
            hull() {
                translate([clength - 0.5*carmw, -0.5*(cwidth - carmw), 0]) cylinder( h = cthick, d = carmw, center = true );
                translate([1, -0.5*(cwidth - carmw), 0]) cube([2, carmw, cthick], center = true);
            }
            hull() {
                translate([clength - 0.5*carmw, 0.5*(cwidth - carmw), 0]) cylinder( h = cthick, d = carmw, center = true );
                translate([1, 0.5*(cwidth - carmw), 0]) cube([2, carmw, cthick], center = true);
            }
            translate([0.5*cbodyl, 0, 0]) cube([cbodyl, cwidth, cthick], center = true);

            difference() {
                translate([clength - tab_dist_from_end, -0.5*cwidth + tab_radius - tabp, 0]) cylinder(h = cthick, r = tab_radius, center = true);
                translate([clength - tab_dist_from_end, -0.5*cwidth + 0.5*carmw + 0.5*blocker_length, 0]) 
                    cube([blocker_length, blocker_length, cthick + 2], center = true);
                if (lcBool) {
                    translate([clength - 0.5*blocker_length - tab_dist_from_end, -0.5*blocker_length, 0])
                        cube([blocker_length, blocker_length, cthick + 2], center = true);
                }
            }
            difference() {
                translate([clength - tab_dist_from_end, 0.5*cwidth - (tab_radius - tabp), 0]) cylinder(h = cthick, r = tab_radius, center = true);
                translate([clength - tab_dist_from_end, 0.5*cwidth - 0.5*carmw - 0.5*blocker_length, 0]) 
                    cube([blocker_length, blocker_length, cthick + 2], center = true);
                if (lcBool) {
                    translate([clength - 0.5*blocker_length - tab_dist_from_end, cwidth - 0.5*blocker_length, 0])
                        cube([blocker_length, blocker_length, cthick + 2], center = true);
                }
             }
        }
        if (acBool) {
            translate([0.5*clength, 0, -0.5*cthick])  rotate([0, 55, 0])
                cube([clength/(2*sin(55)), 2*cwidth, 5*cthick], center = true );
        }
    }
}
