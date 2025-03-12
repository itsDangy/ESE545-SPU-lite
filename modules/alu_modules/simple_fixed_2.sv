module Simple_Fixed_2 #(
        localparam WIDTH=128,
    )(

        input [0:31] instruction,
        input [0:WIDTH-1] RA_data_in,
        input [0:WIDTH-1] RB_data_in,
        input [0:WIDTH-1] RC_data_in,
        output [0:WIDTH-1] RT_data_out,

    );

    logic [0:6] Immediate7;
    assign Immediate7 = instruction[11:17];
    
    logic [0:31] s;
    logic [0:31] t;
    logic [0:31] r;

    always_comb begin
        if (instruction[4:7] == 4'b1111) begin
            //Rotate Word Immediate - roti (RI7)
            s := {25{Immediate7[0]},Immediate7} & 32'h0000001F;

            for (int j = 0; j <= 15 ; j = j + 4 ) begin
                t := RA_data_in[32*j:32*j+31];

                for (int b = 0; b <= 31 ; b = b + 1 ) begin
                    if (b + s < 32) begin
                        r[b] := t[b+s];
                    end else begin
                        r[b] := t[b+s-32];
                    end
                end
                rt_data_out[32*j:32*j+31] = r;
            end

        end else if (instruction[4:7] == 4'b1011) begin
            if (instruction[8:10] == 3'b000) begin
                //Rotate Word - rot (RR)
                for (int j = 0; j <= 15 ; j = j + 4 ) begin
                    s := RB_data_in[32*j:32*j+31] & 32'h0000001F;
                    t := RA_data_in[32*j:32*j+31];

                    for (int b = 0; b <= 31 ; b = b + 1 ) begin
                        if (b + s < 32) begin
                            r[b] := t[b+s];
                        end else begin
                            r[b] := t[b+s-32];
                        end
                    end
                    rt_data_out[32*j:32*j+31] = r;
                end

            end else if (instruction[8:10] == 3'b011) begin
                //Shift Left Halfword - shl (RR)
                for (int j = 0; j <= 15 ; j = j + 4 ) begin
                    s := RB_data_in[32*j:32*j+31] & 32'h0000003F;
                    t := RA_data_in[32*j:32*j+31];

                    for (int b = 0; b <= 31 ; b = b + 1 ) begin
                        if (b + s < 32) begin
                            r[b] := t[b+s];
                        end else begin
                            r[b] := 1'b0;
                        end
                    end
                    rt_data_out[32*j:32*j+31] = r;
                end
            end
        end else begin
            //do nothing
        end
    end
    
endmodule