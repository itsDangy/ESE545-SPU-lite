//Peter Milder's code lol
module register_file #(
        parameter WIDTH=128, SIZE=128,
        localparam LOGSIZE=$clog2(SIZE)
    )(
        input [0:WIDTH-1] rt_even_data_in,
        input [0:WIDTH-1] rt_odd_data_in,
        output logic [0:WIDTH-1] ra_even_data_out,
        output logic [0:WIDTH-1] rb_even_data_out,
        output logic [0:WIDTH-1] rc_even_data_out,
        output logic [0:WIDTH-1] ra_odd_data_out,
        output logic [0:WIDTH-1] rb_odd_data_out,
        output logic [0:WIDTH-1] rc_odd_data_out,
        input [0:LOGSIZE-1] ra_even_addr_in,
        input [0:LOGSIZE-1] rb_even_addr_in,
        input [0:LOGSIZE-1] rc_even_addr_in,
        input [0:LOGSIZE-1] rt_even_addr_in,
        input [0:LOGSIZE-1] ra_odd_addr_in,
        input [0:LOGSIZE-1] rb_odd_addr_in,
        input [0:LOGSIZE-1] rc_odd_addr_in,
        input [0:LOGSIZE-1] rt_odd_addr_in,
        input wr_en_even, wr_en_odd,
    );
    logic [0-SIZE-1][0:WIDTH-1] mem;

    always_comb begin
        ra_even_data_out <= mem[ra_even_addr_in];
        rb_even_data_out <= mem[rb_even_addr_in];
        rc_even_data_out <= mem[rc_even_addr_in];

        ra_odd_data_out <= mem[ra_odd_addr_in];
        rb_odd_data_out <= mem[rb_odd_addr_in];
        rc_odd_data_out <= mem[rc_odd_addr_in];

        if (wr_en_even)
            mem[rt_even_addr_in] <= rt_even_data_in;
        
        if (wr_en_odd)
            mem[rt_odd_addr_in] <= rt_odd_data_in;
    end
endmodule