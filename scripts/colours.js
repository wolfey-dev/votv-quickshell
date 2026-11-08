function colour(start, end, steps, index) {
    const colours = [];

    let start_rgb = start.match(/\d+/g);
    let start_r = parseInt(start_rgb[0]);
    let start_g = parseInt(start_rgb[1]);
    let start_b = parseInt(start_rgb[2]);
    
    let end_rgb = end.match(/\d+/g);
    let end_r = end_rgb[0];
    let end_g = end_rgb[1];
    let end_b = end_rgb[2];

    let r_diff = start_r - end_r
    let g_diff = start_g - end_g
    let b_diff = start_b - end_b

    if (r_diff < 0) {
        r_diff = r_diff * - 1;
    }
    if (g_diff < 0) {
        g_diff = g_diff * - 1;
    }
    if (b_diff < 0) {
        b_diff = b_diff * - 1;
    }

    //console.log(r_diff, g_diff, b_diff)

    let r_step_increment = r_diff / steps
    let g_step_increment = g_diff / steps
    let b_step_increment = b_diff / steps

    //console.log(r_step_increment, g_step_increment, b_step_increment)
    //console.log("start color =" + start_rgb)

    //console.log(start_r)


    let current_r_step_increment = r_step_increment * index
    let current_g_step_increment = g_step_increment * index
    let current_b_step_increment = b_step_increment * index

    let stepped_r = 0
    let stepped_g = 0
    let stepped_b = 0
    
    //console.log("crsi" + current_r_step_increment)

    if (start_r > end_r) {
        stepped_r = Math.round(parseInt(start_r) - current_r_step_increment)
    }
    else {
        stepped_r = Math.round(current_r_step_increment + parseInt(start_r))

    }
    
    if (start_g > end_g) {
        stepped_g = Math.round(parseInt(start_g) - current_g_step_increment)
    }
    else {
        stepped_g = Math.round(current_g_step_increment + parseInt(start_g))

    }

    if (start_b > end_b) {
        stepped_b = Math.round(parseInt(start_b) - current_b_step_increment)

    }
    else {
        stepped_b = Math.round(current_b_step_increment + parseInt(start_b))

    }

    //console.log(stepped_r)
    

    //console.log("math" + i + " " + current_r_step_increment + "+" + start_r)
    //console.log("step" + i + " " + Math.round(stepped_r))

    
    //const colour = [stepped_r + "," + stepped_g + "," + stepped_b]

    //let colour = stepped_r

    
    //console.log("step" + i + " " + colour)

    console.log("thing"
        + stepped_r.toString(16).padStart(2, "0")
        + stepped_g.toString(16).padStart(2, "0")
        + stepped_b.toString(16).padStart(2, "0"))

    return "#"
        + stepped_r.toString(16).padStart(2, "0")
        + stepped_g.toString(16).padStart(2, "0")
        + stepped_b.toString(16).padStart(2, "0")

        
        
    }
    
    


// colour(rgb(153,0,25), 10, rgb(20,255,0))