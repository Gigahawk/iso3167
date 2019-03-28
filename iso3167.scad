iso3167_A = [
    "l1", 80,
    "l2", (104+113)/2,
    "l3", 170,
    "b1", 10,
    "b2", 20.0,
    "r", 24,
    "h", 4.0
];

iso3167_B = [
    "l1", 60.0,
    "l2", (106+110)/2,
    "l3", 150,
    "b1", 10,
    "b2", 20.0,
    "r", 60.0,
    "h", 4.0
];

function hash(h, k)=
(
    h[search([k], [for(i=[0:2:len(h)-2])h[i]])[0]*2+1]
);

module iso3167(
    l1 = undef,
    l2 = undef,
    l3 = undef,
    b1 = undef,
    b2 = undef,
    r = undef,
    h = undef,
    type = "A") {

    m_l1 = (l1 != undef) ? l1 : (type=="A" ? hash(iso3167_A,"l1") : type=="B" ? hash(iso3167_B, "l1") : undef);
    m_l2_max = (l2 != undef) ? l2 : (type=="A" ? hash(iso3167_A,"l2") : type=="B" ? hash(iso3167_B, "l2") : undef);
    m_l3 = (l3 != undef) ? l3 : (type=="A" ? hash(iso3167_A,"l3") : type=="B" ? hash(iso3167_B, "l3") : undef);
    m_b1 = (b1 != undef) ? b1 : (type=="A" ? hash(iso3167_A,"b1") : type=="B" ? hash(iso3167_B, "b1") : undef);
    m_b2 = (b2 != undef) ? b2 : (type=="A" ? hash(iso3167_A,"b2") : type=="B" ? hash(iso3167_B, "b2") : undef);
    m_r = (r != undef) ? r : (type=="A" ? hash(iso3167_A,"r") : type=="B" ? hash(iso3167_B, "r") : undef);
    m_h = (h != undef) ? h : (type=="A" ? hash(iso3167_A,"h") : type=="B" ? hash(iso3167_B, "h") : undef);

    neck_cut_width = (m_b2 - m_b1)/2;

    theta = acos((m_r - neck_cut_width)/m_r);
    fillet_width = sin(theta);
    m_l2 = ((m_l2_max - m_l1)/2 >= fillet_width) ? m_l2_max : m_l3 - 2*fillet_width ;

    neck_cut_xoff = (m_l3 - m_l1)/2;
    neck_cut_yoff = (m_b2 - neck_cut_width);

    neck_fillet_xoff1 = neck_cut_xoff;
    neck_fillet_xoff2 = m_l3 - neck_cut_xoff;
    neck_fillet_yoff1 = -m_r + neck_cut_width;
    neck_fillet_yoff2 = neck_cut_yoff + m_r;


    linear_extrude(height=m_h) {
        difference() {
            // Bounding rectangle
            square([m_l3, m_b2]);

            // Neck area
            translate([neck_cut_xoff, 0])
                square([m_l1, neck_cut_width]);
            translate([neck_cut_xoff, neck_cut_yoff])
                square([m_l1, neck_cut_width]);


            translate([neck_fillet_xoff1, neck_fillet_yoff1])
                circle(r=m_r);
            translate([neck_fillet_xoff1, neck_fillet_yoff2])
                circle(r=m_r);
            translate([neck_fillet_xoff2, neck_fillet_yoff1])
                circle(r=m_r);
            translate([neck_fillet_xoff2, neck_fillet_yoff2])
                circle(r=m_r);
        }
    }
};

module iso3167_clamp(
    l1 = undef,
    l2 = undef,
    l3 = undef,
    b1 = undef,
    b2 = undef,
    r = undef,
    h = undef,
    depth = undef,
    width = undef,
    outer_width = undef,
    outer_depth = undef,
    tri_width = undef,
    tol = 0.3,
    hole_dia = 3.2,
    nut_width = 5.5,
    nut_depth = 3,
    type = "A") {


    m_l1 = (l1 != undef) ? l1 : (type=="A" ? hash(iso3167_A,"l1") : type=="B" ? hash(iso3167_B, "l1") : undef);
    m_l2_max = (l2 != undef) ? l2 : (type=="A" ? hash(iso3167_A,"l2") : type=="B" ? hash(iso3167_B, "l2") : undef);
    m_l3 = (l3 != undef) ? l3 : (type=="A" ? hash(iso3167_A,"l3") : type=="B" ? hash(iso3167_B, "l3") : undef);
    m_b1 = (b1 != undef) ? b1 : (type=="A" ? hash(iso3167_A,"b1") : type=="B" ? hash(iso3167_B, "b1") : undef);
    m_b2 = (b2 != undef) ? b2 : (type=="A" ? hash(iso3167_A,"b2") : type=="B" ? hash(iso3167_B, "b2") : undef);
    m_r = (r != undef) ? r : (type=="A" ? hash(iso3167_A,"r") : type=="B" ? hash(iso3167_B, "r") : undef);
    m_h = (h != undef) ? h : (type=="A" ? hash(iso3167_A,"h") : type=="B" ? hash(iso3167_B, "h") : undef);

    neck_cut_width = (m_b2 - m_b1)/2;

    theta = acos((m_r - neck_cut_width)/m_r);
    fillet_width = sin(theta);
    m_l2 = ((m_l2_max - m_l1)/2 >= fillet_width) ? m_l2_max : m_l3 - 2*fillet_width ;

    m_depth = (depth != undef) ? depth : (m_l3 - m_l2)/1;
    m_width = (width != undef) ? width :  m_b2 + tol*2;
    m_outer_depth = (outer_depth != undef) ? outer_depth : m_b2 * 2;
    m_outer_width = (outer_width != undef) ? outer_width : m_width * 3;
    m_tri_width = (tri_width != undef) ? tri_width :  m_b2;
    m_tri_depth = m_tri_width / 2;

    echo(m_depth);

    difference() {
        linear_extrude(height=m_h) {
            difference() {
                square([m_outer_width, m_outer_depth]);

                translate([(m_outer_width - m_width)/2, m_outer_depth - m_depth])
                    square([m_width, m_depth]);

                translate([m_outer_width/2, (m_outer_depth - m_depth)/2])
                    polygon(points=[
                        [-m_tri_width/2, m_tri_depth/2],
                        [m_tri_width/2, m_tri_depth/2],
                        [0, -m_tri_depth/2]]);
            }
        }

        translate([0, m_outer_depth - m_depth/2, m_h/2])
            rotate([0, 90, 0])
                union() {
                    translate([0,0,-0.0001])
                        cylinder(d=hole_dia, h=m_outer_width + 0.0002);

                    translate([0,0, (m_outer_width - m_width)/2 - nut_depth + 0.0001])
                        cylinder(r=nut_width/2/cos(180/6) + 0.05, h=nut_depth, $fn=6);

                    translate([0,0, m_outer_width - (m_outer_width - m_width)/2 - 0.0001])
                        cylinder(r=nut_width/2/cos(180/6) + 0.05, h=nut_depth, $fn=6);
                }
    }
}
