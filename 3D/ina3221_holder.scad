// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): enclosure for INA3221-breakout.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-ina-connector
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>

include <dimensions.scad>
include <pcb_holder.scad>

// dimensions   --------------------------------------------------------------

function ina3221_holder_x() = 38.354;
function ina3221_holder_y() = 22.86;
function ina3221_holder_s() =  2.54;

// --- ina3221_holder   ------------------------------------------------------

module ina3221_holder() {
  pcb_holder(x_pcb=ina3221_holder_x(),
             y_pcb=ina3221_holder_y(),
             x_screw=ina3221_holder_s(),
             y_screw=ina3221_holder_s(),
             screws=[1,1,0,0]);
}
