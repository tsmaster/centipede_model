INCHES= 25.4;

BODY_SEGMENT_SIZE = 1 * INCHES;
CARVE_SEGMENT_SIZE = 1.2 * INCHES;

SPACING = INCHES * .8;

FLAT_DEPTH = INCHES * 0.35;

SEGMENTS = 16;

LINK_OUTER_RADIUS = 0.25 * INCHES;
LINK_INNER_RADIUS = 0.125 * INCHES;
LINK_HOLLOW_MULT = 1.2;

EYE_RADIUS = 0.28 * BODY_SEGMENT_SIZE;
EYE_SIZE = 0.25 * BODY_SEGMENT_SIZE;

MAX_ANGLE = 11;

module base_body() {
  intersection () {
    translate([0, 0, 0.5*INCHES - FLAT_DEPTH]) {
      cube([2*INCHES, 2*INCHES, 1*INCHES], true);
    };
    union() {
      sphere(d=BODY_SEGMENT_SIZE, $fn=40);
      // legs
      translate([0, 0, -FLAT_DEPTH]) {
	rotate([0, 90, 0]) {
	  donut(BODY_SEGMENT_SIZE * 0.40, BODY_SEGMENT_SIZE * .72);
        }
	}
    }
  }
}

module base_body_minus_tail() {
  difference() {
    base_body();
    tail_neg();
  }
}

module base_body_minus_head() {
  difference() {
    base_body();
    head_neg();
  }
}


module base_body_minus_head_and_tail() {
  difference() {
    base_body();
    union() {
      head_neg();
      tail_neg();
    }
  }
}


module tail_neg() {
  union() {
    translate([SPACING, 0, 0]) {
      sphere(d = CARVE_SEGMENT_SIZE);
    };

    translate([SPACING / 2.0 - LINK_OUTER_RADIUS * 0.25, 0, 0]) {
      rotate([90, 0, 0]) {
        donut(0.1, LINK_OUTER_RADIUS * LINK_HOLLOW_MULT);
      }
    }
  }
}

module head_neg() {
  translate([-SPACING / 2.0 - LINK_OUTER_RADIUS * 0.65, 0, 0]) {
    donut(0.1, LINK_OUTER_RADIUS * LINK_HOLLOW_MULT);
  }
}

module tail_links() {
  translate([SPACING / 2.0 - LINK_OUTER_RADIUS * 0.75, 0, 0]) {
    rotate([10, 0, 0]){
      donut(LINK_INNER_RADIUS, LINK_OUTER_RADIUS);
    }
    rotate([-10, 0, 0]) {
      donut(LINK_INNER_RADIUS, LINK_OUTER_RADIUS);
    }
  }
}

module eyes() {
  translate([-EYE_RADIUS, EYE_RADIUS, EYE_RADIUS]) {
    sphere(d= EYE_SIZE, $fn = 32);
  }
  translate([-EYE_RADIUS, -EYE_RADIUS, EYE_RADIUS]) {
    sphere(d= EYE_SIZE, $fn = 32);
  }
}

module head_links() {
  translate([-SPACING / 2.0, 0, 0]) {
    rotate([90, 0, 0]) {
      donut(LINK_INNER_RADIUS, LINK_OUTER_RADIUS);
    }
  }

  if ($preview) {
    // debug axis
    translate([-SPACING / 2.0 - (LINK_INNER_RADIUS + LINK_OUTER_RADIUS) / 2.0, 0, 0]) {
      #cube([0.1, 0.1, 40], true);
    }
  }
}

module body_segment(has_tail_connector, has_head_connector, has_eyes) {
  // has_tail_connector means that this is a head segment with a connection to a tail

  // tail
  if ((has_tail_connector == 0) && (has_head_connector == 1)) {
    union() {
      base_body_minus_head();
      head_links();
    }
  }
  if ((has_tail_connector == 1) && (has_head_connector == 0)) {
    union() {
      base_body_minus_tail();
      tail_links();
      eyes();
    }
  }
  if ((has_tail_connector == 1) && (has_head_connector == 1)) {
    union() {
      base_body_minus_head_and_tail();
      tail_links();
      head_links();
    }
  }
}

module centipede() {
  translate([-SPACING * (SEGMENTS - 1) / 2.0, 0, 0]) {

    // head
    body_segment(1, 0, 1);

    /*
    for (i = [1:SEGMENTS-1]) {
      translate([i * SPACING, 0, 0]) {
        body_segment(1, 1, 0);
      }
      }*/

    // tail
    translate([(SEGMENTS -1) * SPACING, 0, 0]) {
      body_segment(0, 1, 0);
      }
  }
}


module spiral_centipede() {
  x = 100;
  y = 0;
  a = 270;

  translate([x, y, 0]) {
    rotate([0, 0, a]) {
      // tail
      body_segment(0, 1, 0);
    }
  }

  spiral_centipede_rest(x, y, a, SEGMENTS - 1);
}

module spiral_centipede_rest(x, y, a, remain_count) {
  new_x = x + SPACING * cos(a - 180);
  new_y = y + SPACING * sin(a - 180);

  new_r = sqrt(x * x + y * y);
  new_circumference = 2*PI * new_r;
  steps_at_new_radius = new_circumference / SPACING;
  angle_at_new_radius = 360 / steps_at_new_radius;

  // interpolate to a radius that's bigger by, say, two spacings

  outside_r = new_r + SPACING * 2;
  outside_circumference = 2 * PI * outside_r;
  steps_at_outside_radius = outside_circumference / SPACING;
  angle_at_outside_radius = 360 / steps_at_outside_radius;

  mid_steps = (steps_at_outside_radius + steps_at_new_radius) / 2.0;

  inc_angle = angle_at_new_radius + (angle_at_outside_radius - angle_at_new_radius) / mid_steps;
  //inc_angle = angle_at_new_radius;

  //echo("new_r", new_r, "outside r", outside_r);
  //echo("new steps", steps_at_new_radius, "outside steps", steps_at_outside_radius);

  new_a = a + inc_angle;

  translate([new_x, new_y, 0]) {
    rotate([0, 0, new_a]) {
      if (remain_count == 1) {
        body_segment(1, 0, 0);
      } else {
        body_segment(1, 1, 0);
      }
    }
  }

  if (remain_count > 1) {
    spiral_centipede_rest(new_x, new_y, new_a, remain_count - 1);
  }
}


module circular_centipede() {
  x = 100;
  y = 0;
  a = 270;

  translate([x, y, 0]) {
    rotate([0, 0, a]) {
      // tail
      body_segment(0, 1, 0);
    }
  }

  circular_centipede_rest(x, y, a, SEGMENTS - 1);
}

module circular_centipede_rest(x, y, a, remain_count) {
  new_x = x + SPACING * cos(a - 180);
  new_y = y + SPACING * sin(a - 180);

  new_a = a + MAX_ANGLE;

  translate([new_x, new_y, 0]) {
    rotate([0, 0, new_a]) {
      if (remain_count == 1) {
        body_segment(1, 0, 0);
      } else {
        body_segment(1, 1, 0);
      }
    }
  }

  if (remain_count > 1) {
    circular_centipede_rest(new_x, new_y, new_a, remain_count - 1);
  }
}





//centipede();
//spiral_centipede();
circular_centipede();

module donut(hole_rad, out_rad) {
  rotate_extrude(angle = 360, convexity = 2, $fn=32) {
    // rad_a is the radius from the middle of the hole to the middle of the bread
    // rad_b is the radius from the middle of the bread to the surface of the bread
    rad_a = (hole_rad + out_rad) / 2.0;
    rad_b = rad_a - hole_rad;
    translate([rad_a, 0, 0]) {
      circle(r = rad_b, $fn=32);
    }
  }
}

/*
donut(1 * INCHES, 2 * INCHES);

translate([1.5 * INCHES, 0, 0]) {
  rotate([90, 0, 0]) {
    donut(1 * INCHES, 2 * INCHES);
  }
}
*/
