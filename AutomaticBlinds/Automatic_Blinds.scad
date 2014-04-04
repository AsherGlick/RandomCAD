//
// settings
//
show_extras = true;

motor_mountsize_x = 24;
motor_mountsize_y = 12;
motor_mountsize_z = 29;

motor_diameter = 12;
motor_flat = 10;

track_width = 40;

tire_diameter = 42;
tire_height = 20;
motor_offset_z = 3;
motor_height = 12;

undercarrage_thickness = 8; // does not scale well
undercarrage_length = track_width - motor_mountsize_y/2 + tire_diameter/2;

support_beem_thickness = 8;

// 
resolution = 15;

module motor_slot(slot_height) {
	intersection() {
		cylinder(r = motor_diameter/2, h = slot_height+1, center = true);
			cube([motor_diameter, motor_flat,motor_mountsize_z+1], center=true);
	}
}


module servo(screwlength) {

	mountingplate_hole_offset_x = -.3;
	mountingplate_hole_offset_y = 1;
	mountingplate_hole_diameter = 3;

	servo_width = 17;
	servo_length = 31;
	servo_height = 28.4;

	mountingplate_height = 2.5;
	// mountingplate_legnth = servo_length + 10;
	mountingplate_legnth = 42.8;
	mountingplate_width = servo_width;

	servo_axel_offset = 8.2;
	servo_axel_height = 3;

	servo_top_height = 9;
	translate([0,-servo_length/2+servo_axel_offset,-servo_height/2+mountingplate_height+servo_top_height]) {
		union() {
			//gearbox
			cube([servo_width, servo_length, servo_height], center = true);
			
			//mounting plate
			translate([0,0,servo_height/2-mountingplate_height/2-servo_top_height]) {
				difference() {
					cube([mountingplate_width, mountingplate_legnth, mountingplate_height], center = true);
					translate([mountingplate_width/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_y,mountingplate_legnth/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_x,0])
						cylinder(r=mountingplate_hole_diameter/2, h=mountingplate_height+1, center=true, $fn=resolution);
					translate([-(mountingplate_width/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_y),mountingplate_legnth/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_x,0])
						cylinder(r=mountingplate_hole_diameter/2, h=mountingplate_height+1, center=true, $fn=resolution);
					translate([mountingplate_width/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_y,-(mountingplate_legnth/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_x),0])
						cylinder(r=mountingplate_hole_diameter/2, h=mountingplate_height+1, center=true, $fn=resolution);
					translate([-(mountingplate_width/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_y),-(mountingplate_legnth/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_x),0])
						cylinder(r=mountingplate_hole_diameter/2, h=mountingplate_height+1, center=true, $fn=resolution);
				}
				translate([mountingplate_width/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_y,mountingplate_legnth/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_x,mountingplate_height/2-screwlength/2])
					cylinder(r=mountingplate_hole_diameter/2*.8, h=screwlength, center=true, $fn=resolution);
				translate([-(mountingplate_width/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_y),mountingplate_legnth/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_x,mountingplate_height/2-screwlength/2])
					cylinder(r=mountingplate_hole_diameter/2*.8, h=screwlength, center=true, $fn=resolution);
				translate([mountingplate_width/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_y,-(mountingplate_legnth/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_x),mountingplate_height/2-screwlength/2])
					cylinder(r=mountingplate_hole_diameter/2*.8, h=screwlength, center=true, $fn=resolution);
				translate([-(mountingplate_width/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_y),-(mountingplate_legnth/2-mountingplate_hole_diameter/2 - mountingplate_hole_offset_x),mountingplate_height/2-screwlength/2])
					cylinder(r=mountingplate_hole_diameter/2*.8, h=screwlength, center=true, $fn=resolution);

			}

			//Shaft

			translate([0,servo_length/2 - servo_axel_offset,servo_height/2+servo_axel_height/2]) {
				cylinder(r=2,h=6, center = true, $fn=resolution);
			}
		}
	}
}

module _tire() {
	cylinder(r=tire_diameter/2,h=tire_height);
}


module _track() {
	translate([0,track_width/2,30]){
		cube([300,track_width,60], center = true);
		translate([0,0,-30]) {
			cylinder(r=3, h=10, center=true);
		}
	}
}


module undercarrage() {
	boltsize = 5;
	difference() {
		cube([motor_mountsize_x,undercarrage_length,undercarrage_thickness]);
		// the +.00001 is a hack to prevent the difference 
		translate([motor_mountsize_x/2,undercarrage_length - track_width/2,undercarrage_thickness+.1]){
			servo(undercarrage_thickness+boltsize);
		}
	}
	if (show_extras){
		translate([motor_mountsize_x/2,undercarrage_length - track_width/2,undercarrage_thickness]){
			color("green", 0.5) servo(undercarrage_thickness+boltsize);
		}
	}
}
module support_beem () {
	cube([motor_mountsize_x,support_beem_thickness,motor_mountsize_z+motor_offset_z+tire_height]);
}

module blinds_mount()
{
	translate([motor_mountsize_x/2, motor_mountsize_y/2, motor_mountsize_z/2]) {
		difference() {
			cube([motor_mountsize_x,motor_mountsize_y,motor_mountsize_z], center = true);
			motor_slot(motor_mountsize_z);
		}
		if (show_extras) {
			translate([0,0,motor_offset_z+(motor_mountsize_z-motor_height)/2]) {
				color("blue",0.5) motor_slot(motor_height);
			}
		}
	}
	translate([0,motor_mountsize_y,0]) {
		undercarrage();
	}
	translate([0,undercarrage_length+motor_mountsize_y,0]) {
		support_beem();
	}

	if (show_extras) {
		
		translate([motor_mountsize_x/2,motor_mountsize_y/2,motor_mountsize_z+motor_offset_z]) {
			color("blue",0.5) _tire();
		}
		translate([motor_mountsize_x/2,motor_mountsize_y/2+tire_diameter/2,2+motor_mountsize_z]) {
			color("white",0.5) _track();
		}
	}

}

blinds_mount();


// undercarrage();

// rotate([-90,180,0]) {
// 	servo(10);
// }