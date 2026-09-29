module baud_gen #(parameter cfg_div)
(
    input logic i_clk,
    input logic i_rstn,
    output logic tick_16x
);

//produces a one tick every cfg_div cycles of i_clk. 
//rx and tx modules will use this tick to sample the data at 16x the baud rate.    
    

    logic [$clog2(cfg_div)-1:0] counter;

    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            counter <= 0;
            tick_16x <= 0;
        end else begin
            if (counter == cfg_div - 1) begin
                counter <= 0;
                tick_16x <= 1;
            end else begin
                counter <= counter + 1;
                tick_16x <= 0;
            end
        end
    end
endmodule