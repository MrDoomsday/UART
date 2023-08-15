//  Package: defs
//
package defs;

    function automatic bit [31:0] calc_baud_limit(bit [31:0] sys_freq, bit [31:0] baudrate);
        real limit = sys_freq/(8*baudrate) - 1;
        return int'(limit);
    endfunction
    
endpackage: defs
