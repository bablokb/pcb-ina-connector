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
ina_y  = pcb_holder_dim(ina3221_holder_y());

// --- main module with 3x connection-holder and 1x INA3221-holder   ---------
module main() {
  ymove(conn_y/2+conn_x/2) zrot(90) conn_holder();
  xmove(-conn_y/2-conn_x/2) conn_holder();
  xmove(+conn_y/2+conn_x/2) conn_holder();
  ymove(-conn_y/2+ina_y/2) ina3221_holder();
}

// --- base: an extrusion of a projection of the hull of all objects   -------

module base() {
  linear_extrude(height=b) projection() 
    hull() {
      main();
    };
}

// ---- final object: all holders combined with the base   --------------------

base();
main();
