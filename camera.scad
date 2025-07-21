use <parameterized_clip.scad>;

width=38;
height=38;
depth=32;

thickness=1.5;

module usbc() {
    cube([10, 4.5, 10]);
}

module hdmi() {
    cube([15.5, 6.5, 10]);
}

module lens_mount() {
    cylinder(r=7.5, h=20);
    translate([-8, -8, 0]) {
            cube([16, 16, 3]);
    }
    translate([-22/2, -2, 0]) {
            cube([22, 4, 3]);
    }
    translate([2, -22/2, 0]) {
        rotate([0, 0, 90]) {
            cube([22, 4, 3]);
        }
    }
}

module camera_inner() {
    cube([width, height, depth]);
    translate([6.5, 19, -10]) {
        rotate([0, 0, 90]) {
            usbc();
        }
    }

    translate([width-1, 18, -10]) {
        rotate([0, 0, 90]) {
            hdmi();
        }
    }

    translate([width / 2, height / 2, depth]) {
            lens_mount();
    }
}

module box(width, height, depth, thickness) {
    difference() {
        cube([width, height, depth]);
        translate([thickness, thickness, thickness]) {
            cube([width - 2 * thickness, height - 2 * thickness, depth - 2 * thickness]);
        }
    }
}

module tripod_mount() {
    difference() {
        cube([16, 16, 14]);
        translate([8, 8, 0]) {
            cylinder(12, 3.5, 3.5);
        }
        translate([8, 8, 0]) {
            cylinder(1, 4, 3.5);
        }
    }
}

box_margin = 2;

centre_offset = box_margin/2 + thickness;
box_width = width + box_margin + 2*thickness;
box_height = height + box_margin + 2*thickness;
box_depth = depth + box_margin + 2*thickness;

module casing() {

    box_margin = 2;

    centre_offset = box_margin/2 + thickness;
    box_width = width + box_margin + 2*thickness;
    box_height = height + box_margin + 2*thickness;
    box_depth = depth + box_margin + 2*thickness;

    difference(){
        box(box_width, box_height, box_depth, thickness);
        
        translate([centre_offset, centre_offset, centre_offset]) {
            camera_inner();
        }
    };
}

clip_width = 5;
clip_length = 10;
clip_thickness = thickness;;
clip_arm_width = 1.5;
clip_body_length = 0;
tab_protrusion = 0.8;
clip_male_female_delta = 0.25;

module back() {
    intersection() {
        casing();
        cube([box_width*2, box_height*2, box_depth/2]);
    }
    translate([box_width-thickness/2, box_height/2, box_depth/2]) {
        rotate([0, -90, 0]) {
            male_clip(clip_length, clip_width, clip_thickness, clip_arm_width, clip_body_length, tab_protrusion, false, false);
        }
    }
    translate([thickness/2, box_height/2, box_depth/2]) {
        rotate([0, -90, 0]) {
            male_clip(clip_length, clip_width, clip_thickness, clip_arm_width, clip_body_length, tab_protrusion, false, false);
        }
    }
}

module front() {
        difference() {
                translate([8, 8, 0]) {
            cylinder(8, 3, 3);
        }    union() {
                difference() {
                    casing();                
                    translate([-box_width, -box_height, -box_depth/2]) {
                        cube([box_width*3, box_height*3, box_depth]);
                    }
                }
                translate([-thickness, box_height/2 - 5, box_depth/2]) {
                    cube([thickness, 10, box_depth/2]);
                }

                translate([box_width, box_height/2 - 5, box_depth/2]) {
                    cube([thickness, 10, box_depth/2]);
                }

                translate([box_width/2-8,-14,box_depth]) {
                    rotate([-90,0,0]) {
                        tripod_mount();
                    }
                }
            }

            translate([box_width-thickness/2, box_height/2, box_depth/2]) {
                rotate([0, -90, 0]) {
                    female_clip(clip_length, clip_width, clip_thickness, clip_arm_width, clip_body_length, tab_protrusion, false, false, clip_male_female_delta);
                }
            }

            translate([thickness/2, box_height/2, box_depth/2]) {
                rotate([0, -90, 0]) {
                    female_clip(clip_length, clip_width, clip_thickness, clip_arm_width, clip_body_length, tab_protrusion, false, false, clip_male_female_delta);
                }
            }
        }
}

module explode(distance = [0, 0, $t* 10], center = false, enable = true) {
    if(enable){
        offset = center ? (($children * distance) / 2 - distance / 2) * -1 : [0, 0 , 0];
        for(i = [0 : 1 : $children - 1]) {
            translate(i * distance + offset) {
                children(i);
            }
        }
    } else {
        children();
    }
}

explode() {
    //front();
    back();
};