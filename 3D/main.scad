// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Main object with INA3221 plus three connectors.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-ina-connector
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>

include <dimensions.scad>
include <conn_holder.scad>
include <ina3221_holder.scad>

// --- fetch dimensions   ----------------------------------------------------

conn_x = pcb_holder_dim(conn_holder_x());
conn_y = pcb_holder_dim(conn_holder_y());
ina_x  = pcb_holder_dim(ina3221_holder_x());
ina_y  = pcb_holder_dim(ina3221_holder_y());

base_z = b + 2 + 1.6;         // b (bottom) + z_support + z_pcb
cover_z = base_z + 10.8 + b;  // base_z + height above pcb + b (top)

// offsets for support walls
wall_x_off = 4.5 + w4;    // from pcb-edge + wall pcb_holder

// position and dimensions cutouts
wall1_x_off = wall_x_off + w2;
wall1_x    = 24.8 - wall_x_off;
wall2_x_off = wall1_x_off;
wall2_x    = 34.3 - wall_x_off;

// switches
switch_d = 6;
switch_x_off = 31; // from outer edge of pcb_holder
switch_y_off = 6;  //from outer edge of pcb-holder

// stemma
stemma_x = 8.0;
stemma_z = 3.2;

// --- main module with 3x connection-holder and 1x INA3221-holder   ---------
module main() {
  ymove(conn_y/2+conn_x/2) zrot(90) conn_holder();
  xmove(-conn_y/2-conn_x/2) conn_holder();
  xmove(+conn_y/2+conn_x/2) conn_holder();
  ymove(-conn_y/2+ina_x/2) zrot(-90) ina3221_holder();
}

// --- bottom: an extrusion of a projection of the hull of all objects   -----

module bottom() {
  projection()
    hull() {
      main();
    };
}

// ---- top: upper side of cover   --------------------------------------------

module top() {
  projection() hull() {
    color("blue") xmove(-conn_y/2-conn_x-w2/2-gap/2)
                                    cuboid([w2,conn_y,1],anchor=BOTTOM+CENTER);
    color("blue") xmove(+conn_y/2+conn_x+w2/2+gap/2)
                                    cuboid([w2,conn_y,1],anchor=BOTTOM+CENTER);
    color("blue") ymove(+conn_y/2+conn_x+w2/2+gap/2)
                                    cuboid([conn_y,w2,1],anchor=BOTTOM+CENTER);
    color("blue") ymove(-conn_y/2-w2/2-gap/2)
                      cuboid([conn_y+2*conn_x+2*w2,w2,1],anchor=BOTTOM+CENTER);
  }
}

// --- base   -----------------------------------------------------------------

module base() {
  linear_extrude(height=b) bottom();
  main();
}

// --- connector support walls   ----------------------------------------------

module conn_support_walls() {
  xmove(-conn_y/2+w2/2+wall_x_off)
                       cuboid([w2,conn_x,cover_z-base_z],anchor=BOTTOM+CENTER);
  xmove(+conn_y/2-w2/2-wall_x_off)
                       cuboid([w2,conn_x,cover_z-base_z],anchor=BOTTOM+CENTER);
}

// --- cutouts ina-connector   ------------------------------------------------

module conn_cutouts() {
    ymove(conn_y/2+conn_x+w4/2-fuzz)
    union() {
      move([-conn_y/2 + wall1_x/2 + wall1_x_off,0,b])
                    cuboid([wall1_x,w4,cover_z-base_z-b],anchor=BOTTOM+CENTER);
      move([+conn_y/2 - wall2_x/2 - wall2_x_off,0,b])
                    cuboid([wall2_x,w4,cover_z-base_z-b],anchor=BOTTOM+CENTER);
    }
}

// --- cover   ----------------------------------------------------------------

module cover() {
  difference() {
    linear_extrude(height=cover_z) top();
    zmove(b) linear_extrude(height=cover_z) bottom();
    // cutouts for connectors
    conn_cutouts();
    zrot(90)  conn_cutouts();
    zrot(-90) conn_cutouts();
    // cutouts switches
    move([-conn_y/2+switch_x_off,conn_y/2+conn_x-switch_y_off,-fuzz])
                     cylinder(h=b+2*fuzz,d=switch_d);
    zrot(90) move([-conn_y/2+switch_x_off,conn_y/2+conn_x-switch_y_off,-fuzz])
                     cylinder(h=b+2*fuzz,d=switch_d);
    zrot(-90) move([-conn_y/2+switch_x_off,conn_y/2+conn_x-switch_y_off,-fuzz])
                     cylinder(h=b+2*fuzz,d=switch_d);
    // cutout stemma
    zmove(cover_z-base_z-stemma_z) ymove(-conn_y/2-w2/2)
                         cuboid([stemma_x,w4,stemma_z],anchor=BOTTOM+CENTER);
  }
  // support walls
  ymove(conn_y/2+conn_x/2) conn_support_walls();
  xmove(conn_x/2+conn_y/2) zrot(90) conn_support_walls();
  xmove(-conn_x/2+-conn_y/2) zrot(90) conn_support_walls();
  ymove(-conn_y/2+ina_x/2) xmove(+conn_x/2-w4)
                     cuboid([w2,ina_x,cover_z-base_z],anchor=BOTTOM+CENTER);
}

// ---- final object: all holders combined with the base   --------------------

//base();
//zmove(cover_z) yrot(180)
cover();