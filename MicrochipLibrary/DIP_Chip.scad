resolution = .1;

// There is probably a better way to make this but this works for now
module bend(angle, thickness, wideness, length) {
	angle = angle % 360;
	difference() {
		cylinder(r=length+thickness, h=wideness, center=true, $fs=resolution);
		cylinder(r=length, h=wideness+1, center=true, $fs=resolution);

		difference() {
			rotate([0,0,0]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
			if (angle > 90) {
				rotate([0,0,-angle]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
			}
		}
		if (angle < 360-72)
		difference() {
			rotate([0,0,72]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
			rotate([0,0,-angle]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
		}

		if (angle < 360-144)
		difference() {
			rotate([0,0,144]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
			rotate([0,0,-angle]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
		}

		if (angle < 360-216)
		difference() {
			rotate([0,0,216]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
			rotate([0,0,-angle]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
		}
		if (angle < 360-288)
		difference() {
			rotate([0,0,288]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
			rotate([0,0,-angle]) translate([(thickness+length)/2,(thickness+length)/2,0]) cube([thickness+length,thickness+length,wideness+1], center = true);
		}
	}
}


module pin (angle=13, metalThickness=.27, metalWidth=1.27, pinWidth=.4, pinlength=3.3, metalLength = 4, angleLength = .5, chopleft=0, chopright=0) {
	sliceangle = 60;


	sliceangle = 90-atan2(angleLength , (metalWidth - pinWidth) / 2 );
	// sliceangle = 0;
	difference () {
		union(){
			cube([10,metalWidth,metalThickness], center=true);
			translate([-5,0,0]){
				
				rotate([0,angle-90,0]) {
					// Fill in the gap caused by rotation with a bent angle
					//rotate([90,-90,0]) bend(90-angle, metalThickness/2, metalWidth, 0);

					// Create the metal top half and angle to the pin
					difference() {
						translate([-(metalLength/2),0,0]) cube([metalLength,metalWidth,metalThickness], center=true);
						translate([-metalLength,(pinWidth)/2 ,-metalThickness]) rotate ([0,0,sliceangle]) cube([metalLength+metalWidth,metalLength+metalWidth,metalThickness+1]);
						translate([-metalLength,-(pinWidth)/2 ,-metalThickness]) rotate ([0,0,270-sliceangle]) cube([metalLength+metalWidth,metalLength+metalWidth,metalThickness+1]);
					}

					// Pin
					translate([-metalLength-(pinlength/2),0,0]) cube([pinlength,pinWidth,metalThickness], center=true);
				}	
			}
		}
		if (chopleft) translate([0,-15-(pinWidth/2),0]) cube([30,30,30], center = true);
		if (chopright) translate([0,15+(pinWidth/2),0]) cube([30,30,30], center = true);
	}
}

module pin2 (angle=13, metalThickness=.27, metalWidth=1.27, pinWidth=.4, pinlength=3.3, metalLength = 3, angleLength = .5, chopleft=0, chopright=0) {
	sliceangle = 60;


	sliceangle = 90-atan2(angleLength , (metalWidth - pinWidth) / 2 );
	// sliceangle = 0;
	difference () {
		union(){
			cube([10,metalWidth,metalThickness], center=true);
			translate([-5,0,0]){
				
				rotate([0,angle-90,0]) {
					// Fill in the gap caused by rotation with a bent angle
					// rotate([90,-90,0]) bend(90-angle, metalThickness/2, metalWidth, 0);

					rotate([0,0,90]) linear_extrude(height=metalThickness, center=true) polygon(points=[[-metalWidth/2,0],[metalWidth/2,0],[metalWidth/2,metalLength],[pinWidth/2, metalLength+angleLength], [pinWidth/2, metalLength+angleLength+pinlength],[-pinWidth/2, metalLength+angleLength+pinlength],[-pinWidth/2, metalLength+angleLength], [-metalWidth/2,metalLength]], paths=[[0,1,2,3,4,5,6,7]]);

				}	
			}
		}
		if (chopleft) translate([0,-15-(pinWidth/2),0]) cube([30,30,30], center = true);
		if (chopright) translate([0,15+(pinWidth/2),0]) cube([30,30,30], center = true);
	}
}

module chip() {
	pincount = 14; // actually the number of pins on one side minus one
	pinspacing = 3;
	pinAngle = 13;

	for ( i = [1 : pincount] )
	{
	    // chopbegin = 0;
	    // chopend = 0;
	    translate([0, (i-1)*pinspacing, 0]) {
		    color("gray") rotate([0,0,0]) pin2(angle=pinAngle, chopleft=i==1, chopright=i==pincount);
		    color("gray") rotate([0,0,180]) pin2(angle=pinAngle, chopleft=i==pincount, chopright=i==1);
		}
	}

	casePadding = 3;
	caseLength = (pincount-1) * pinspacing + casePadding;

	color("black") translate([0,caseLength/2 - (casePadding/2),0]) cube([8,caseLength,3], center=true);
}



// module arc() {
// 	steps = 100;
// 	angle = 30;

// 	anglePerStep = angle / steps

// 	for ( i = [0 : steps]) {

// 	}
// }



// arc

// pin2();

chip();
