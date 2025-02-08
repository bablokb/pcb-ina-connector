// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): enclosure for INA3221-connector.
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

function conn_holder_x() = 21.0;
function conn_holder_y() = 68.0;

// --- conn_holder   ---------------------------------------------------------

module conn_holder() {
  pcb_holder(x_pcb=conn_holder_x(),
             y_pcb=conn_holder_y());
}
