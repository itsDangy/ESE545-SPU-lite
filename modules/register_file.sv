//Peter Milder's code lol
module register_file #(
        parameter WIDTH=128, SIZE=128,
        localparam LOGSIZE=$clog2(SIZE)
    )(
        input [WIDTH-1:0] rt_even_data_in,
        input [WIDTH-1:0] rt_odd_data_in,
        output logic [WIDTH-1:0] ra_even_data_out,
        output logic [WIDTH-1:0] rb_even_data_out,
        output logic [WIDTH-1:0] rc_even_data_out,
        output logic [WIDTH-1:0] ra_odd_data_out,
        output logic [WIDTH-1:0] rb_odd_data_out,
        output logic [WIDTH-1:0] rc_odd_data_out,
        input [LOGSIZE-1:0] ra_even_addr_in,
        input [LOGSIZE-1:0] rb_even_addr_in,
        input [LOGSIZE-1:0] rc_even_addr_in,
        input [LOGSIZE-1:0] rt_even_addr_in,
        input [LOGSIZE-1:0] ra_odd_addr_in,
        input [LOGSIZE-1:0] rb_odd_addr_in,
        input [LOGSIZE-1:0] rc_odd_addr_in,
        input [LOGSIZE-1:0] rt_odd_addr_in,
        input wr_en_even, wr_en_odd,
        input clk
    );
    logic [SIZE-1:0][WIDTH-1:0] mem;

    always_ff @(posedge clk) begin
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