module moduleName #(
        localparam WIDTH=128,
    )(

        input [0:31] instruction,
        input [0:WIDTH-1] RA_data_in,
        input [0:WIDTH-1] RB_data_in,
        input [0:WIDTH-1] RC_data_in,
        output [0:WIDTH-1] RT_data_out,

);

    logic [0:8] c;
    logic [0:8] b;

    always_comb begin
        if (instruction[0:10] == 11'b01010110100) begin
            //Count Ones in Bytes - cntb (RR)
            for (j = 0; j <= 15 ; j = j + 1 ) begin
                c := 0;
                b := RA_data_in[8*j:8*j+7];
                for (m = 0; m <= 7 ; m = m + 1 ) begin
                    if (b[m] == 1'b1) begin
                        c = c + 1;
                    end
                end
                RT_data_out[8*j:8*j+7] = c;
            end

        end else if (instruction[0:10] == 11'b00011010011) begin
            //Average Bytes - avgb (RR)
            for (j = 0; j <= 15 ; j = j + 1 ) begin
                RT_data_out[8*j:8*j+7] = ({2'h00,RA_data_in[8*j:8*j+7]} + {2'h00,RB_data_in[8*j:8*j+7]} + 1'b1)[7:14];
            end

        end else if (instruction[0:10] == 11'b00001010011) begin
            //Absolute Differences of Bytes - absdb (RR)
            for (j = 0; j <= 15 ; j = j + 1 ) begin
                if ($unsigned(RB_data_in[8*j:8*j+7] > RA_data_in[8*j:8*j+7])) begin
                    RT_data_out[8*j:8*j+7] = RB_data_in[8*j:8*j+7] - RA_data_in[8*j:8*j+7];
                end else begin
                    RT_data_out[8*j:8*j+7] = RA_data_in[8*j:8*j+7] - RB_data_in[8*j:8*j+7];
                end
            end

        end else if (instruction[0:10] == 11'b01001010011) begin
            //Sum Bytes into Halfwords -- sumb (RR)
            RT_data_out[0:15] = $unsigned(RB_data_in[0:7] + RB_data_in[8:15] + RB_data_in[16:23] + RB_data_in[24:31]);
            RT_data_out[16:31] = $unsigned(RA_data_in[0:7] + RA_data_in[8:15] + RA_data_in[16:23] + RA_data_in[24:31]);
            RT_data_out[32:47] = $unsigned(RB_data_in[32:39] + RB_data_in[40:47] + RB_data_in[48:55] + RB_data_in[56:63]);
            RT_data_out[48:63] = $unsigned(RA_data_in[32:39] + RA_data_in[40:47] + RA_data_in[48:55] + RA_data_in[56:63]);
            RT_data_out[64:79] = $unsigned(RB_data_in[64:71] + RB_data_in[72:79] + RB_data_in[80:87] + RB_data_in[88:95]);
            RT_data_out[80:95] = $unsigned(RA_data_in[64:71] + RA_data_in[72:79] + RA_data_in[80:87] + RA_data_in[88:95]);
            RT_data_out[96:111] = $unsigned(RB_data_in[96:103] + RB_data_in[104:111] + RB_data_in[112:119] + RB_data_in[120:127]);
            RT_data_out[112:127] = $unsigned(RA_data_in[96:103] + RA_data_in[104:111] + RA_data_in[112:119] + RA_data_in[120:127]);

        end else begin
            //do nothing
        end
    end
    
endmodule