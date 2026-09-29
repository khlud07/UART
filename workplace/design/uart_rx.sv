module uart_rx #(parameter DATA_BW=8)
(
    input  logic i_clk,
    input  logic i_rstn,
    input  logic i_uart_rx[DATA_BW-1:0],
    output logic rx_fifo_wr_en,
    output logic rx_fifo_rd_en,
    output logic rx_fifo_empty,
    output logic rx_fifo_full,
    output logic [DATA_BW-1:0] rx_output
);

    // Instantiate the RX FIFO
    fifo #(.DEPTH(16), .DWIDTH(DATA_BW)) rx_fifo (
        .rstn(i_rstn),
        .clk(i_clk),
        .wr_en(rx_fifo_wr_en),
        .rd_en(rx_fifo_rd_en),
        .din(i_uart_rx),
        .dout(rx_output),
        .empty(rx_fifo_empty),
        .full(rx_fifo_full)
    );
    int tick_cnt = 0;

    always_ff @(posedge i_clk or negedge i_rstn) begin
        if (!i_rstn) begin
            rx_fifo_wr_en <= 0;
            rx_fifo_rd_en <= 0;
        end else begin
            if (tick_16x) begin
                tick_cnt <= tick_cnt + 1;
                if (/* condition to detect valid data on i_uart_rx */) begin
                    rx_fifo_wr_en <= 1;
                end else begin
                    rx_fifo_wr_en <= 0;
                end

                // Logic to determine when to read from the FIFO based on FIFO state
                if (!rx_fifo_empty) begin
                    rx_fifo_rd_en <= 1;
                end else begin
                    rx_fifo_rd_en <= 0;
                end
            end else begin
                rx_fifo_wr_en <= 0;
                rx_fifo_rd_en <= 0;
            end
            rx_fifo_wr_en <= /* some condition based on UART RX */;
            rx_fifo_rd_en <= /* some condition based on FIFO state */;
        end
    end