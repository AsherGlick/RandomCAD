// A simple stand for miniature figurines 

baseDiameter = 40;
pegDiameter = 3.5;
pegOffset = 7;
pegHeight = 4;
baseThickness = 2;

resolution = 10;

translate([0,0,baseThickness/2]){
	cylinder(r=baseDiameter/2, h=baseThickness, center=true, $fn=50);
	translate([0,0,.5])
	difference() {
		cylinder(r=baseDiameter/2, h=baseThickness, center=true, $fn=50);
		cylinder(r=baseDiameter/2-1, h=baseThickness+1, center=true, $fn=50);
	}
	translate([0,pegOffset,pegHeight/2 + baseThickness/2]) {
		cylinder(r=pegDiameter/2, h=pegHeight, center=true, $fn=20);
	}
}