module byte_proc #(parameter DATA_BW=8)
            (input  logic i_clk,
            inpt   logic i_rstn,
            inp tx_input uic rx_output[DATA_BW-1:0],
            input   logic cfg_mode[2:0],
            input   logic cfg_key[DATA_BW-1:0],
            output  logic uart_tx [DATA_BW-1:0]
);
    always_comb begin
        case (cfg_mde)
            3'b000: tx_input  = rx_output; // bypass mode
            3'b001: tx_input  = ~rx_output; // invert
            3'b010: tx_input  = rx_output ^ cfg_key; // xor
            3'b011: tx_input  = rx_output + cfg_key; // add key
            3'b100: tx_input  = rx_output & cfg_key; // case_swap
            3'b101: tx_input  = rx_output | cfg_key; // bit_reverse
            3'b110: tx_input  = ; // hex
            3'b111: tx_input  = rx_output; // sub key
        endcase
    end


endmodule