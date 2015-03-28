// Note: may have to split this into pieces in order to print it on some printers
// A Flash Forge Creator's bed is only 150mm wide; similar for Makerbot Rep 2
// It may be possible to print this in a way where the base fits on the bed even while the rest sits outside the envelope.
// However, the Flash Forge and the Rep 2 are both physically limited to 150mm anywhere above the plate

// Measurements. Units are mm.
// The front of the speaker is something like a rounded square.
// Width of the front at its widest part
front_center_width = 134.7;
// Width of the front at the point where it sharply transitions to the other pside of the square
front_edge_width = 110.0;
// Distance from one "corner" of the rounder square the its opposite corner (redundant measurement)
front_max_diam = 152.5; // 6"
// the rear of the faceplate becomes a circle. This is the only part that actually NEEDS to sit inside the enclosure.
rear_faceplate_diam = 124.0;
// Diameter of the large magnet that sits at the bottom of the speaker
rear_base_diam = 78.3;
// The base has only a small section, then a large rubber band widens the piece.
rear_base_height = 5.0;

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
wall_thickness = 6;
// make the sphere larger to accomodate the speaker's guts
radial_padding = 10;
// maximum thickness of wire to support for wire routing
wire_thickness = 4;
main_tolerance = 0.7;

module face_hole() 
{
	// create one of the 4 mounting holes for later subtraction from the faceplate
	rotate([0, 0, 45]) translate([front_max_diam/2-corner_mount_inset-corner_mount_length/2, 0, 0]) hull() {
		translate([(corner_mount_length-corner_mount_width)/2, 0, 0]) cylinder(r=corner_mount_width/2, h=plate_thickness);
		translate([-(corner_mount_length-corner_mount_width)/2, 0, 0]) cylinder(r=corner_mount_width/2, h=plate_thickness);
	}
}

module face_holes()
{
	union() {
		rotate([0, 0, 0])   face_hole();
		rotate([0, 0, 90])  face_hole();
		rotate([0, 0, 180]) face_hole();
		rotate([0, 0, 270]) face_hole();
	}
}

module face_plate()
{
	// create the faceplate with mounting holes to later subtract from the enclosure
	translate([0, 0, 0]) difference() {
		cylinder(r=front_max_diam/2, h=plate_thickness);
		face_holes();
	}
}

module wire_route()
{
	// create a shape to subtract from the enclosure to accomodate wire routing
	translate([0, -wire_thickness/2, 0]) cube(size=[front_max_diam/2+radial_padding, wire_thickness, front_max_diam/2+radial_padding], center=false);
}

module sphere_enclosure()
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

module min_enclosure()
{
	// The spherical enclosure is too large for some printers, so try a more minimal enclosure.
	// In the design, everything behind the faceplate will fit inside the enclosure, but the faceplate itself may extend beyond the rest of the enclosure.
	difference() {
		hull() {
			cylinder(r=rear_faceplate_diam/2+wall_thickness, h=height_to_plate+wall_thickness+plate_thickness);
			translate([0, 0, wall_thickness+height_to_plate]) face_holes();
		}
		translate([0, 0, wall_thickness]) cylinder(r=rear_faceplate_diam/2+main_tolerance, h=height_to_plate);
		translate([0, 0, wall_thickness+height_to_plate]) face_plate();
		translate([0, 0, height_to_plate+wall_thickness-28]) wire_route();
	}
}

min_enclosure();
