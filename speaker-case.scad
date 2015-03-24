// Measurements. Units are mm.

// The front of the speaker is something like a rounded square.
// Width of the front at its widest part
front_center_width = 134.7;
// Width of the front at the point where it sharply transitions to the other pside of the square
front_edge_width = 110.0;
// Distance from one "corner" of the rounder square the its opposite corner (redundant measurement)
front_max_diam = 152.5; // 6"

// There is an oval-shaped mounting hole at each corner with primary axis towards the center of the front
// distance mounting hole starts from the corner
corner_mount_inset = 4.0;
// size of mounting hole ellipse
corner_mount_width = 5.3;
corner_mount_length = 7.5;
// distance from the back of the speaker to the rear-most face of the mounting plate
height_to_plate = 52.8;
plate_thickness = 5.5;

// enclosure settings
wall_thickness = 13;
// make the sphere larger to accomodate the speaker's guts
radial_padding = 10;
// maximum thickness of wire to support for wire routing
wire_thickness = 4;

module face_hole() 
{
	// create one of the 4 mounting holes for later subtraction from the faceplate
	rotate([0, 0, 45]) translate([front_max_diam/2-corner_mount_inset-corner_mount_length/2, 0, 0]) hull() {
		translate([(corner_mount_length-corner_mount_width)/2, 0, 0]) cylinder(r=corner_mount_width/2, h=plate_thickness);
		translate([-(corner_mount_length-corner_mount_width)/2, 0, 0]) cylinder(r=corner_mount_width/2, h=plate_thickness);
	}
}

module face_plate()
{
	// create the faceplate with mounting holes to later subtract from the enclosure
	translate([0, 0, 0]) difference() {
		cylinder(r=front_max_diam/2, h=plate_thickness);
		rotate([0, 0, 0])   face_hole();
		rotate([0, 0, 90])  face_hole();
		rotate([0, 0, 180]) face_hole();
		rotate([0, 0, 270]) face_hole();
	}
}

module wire_route()
{
	// create a shape to subtract from the enclosure to accomodate wire routing
	translate([0, -wire_thickness/2, 0]) cube(size=[front_max_diam/2+radial_padding, wire_thickness, front_max_diam/2+radial_padding], center=false);
}

module enclosure()
{
	// create a speherical enclosure for the speaker
	difference() {
		sphere(r=front_max_diam/2+radial_padding);
		sphere(r=front_max_diam/2+radial_padding - wall_thickness);
		translate([0, 0, radial_padding*3.3]) union() {
			translate([0, 0, plate_thickness]) cylinder(r=front_max_diam/2, h=front_max_diam/2);
			face_plate();
		}
		wire_route();
	}
}

enclosure();
