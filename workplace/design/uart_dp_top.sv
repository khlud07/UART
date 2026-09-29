`timescale 1ns / 1ps
module uart_dp_top #(parameter DATA_BW=8)
            (input  logic i_clk,
            input   logic i_rstn,
            input   logic i_uart_rx[DATA_BW-1:0],
            input   logic cfg_mode[2:0],
            input   logic cfg_key[DATA_BW-1:0],
            output  logic uart_tx [DATA_BW-1:0]
);
    logic rx_fifo_empty, rx_fifo_full, rx_fifo_rd_en, rx_output, tx_input;
    logic tx_fifo_empty, tx_fifo_full, tx_fifo_rd_en;
    bit rx_wr_en, tx_wr_en;


    fifo #(.WIDTH(DATA_BW), .DEPTH(16)) rx_fifo (
        .clk     (i_clk),
        .rst_n   (i_rstn),
        .wr_en   (rx_wr_en),
        .wr_data (i_uart_rx),
        .rd_en   (rx_fifo_rd_en),
        .rd_data (rx_output),
        .full    (rx_fifo_full),
        .empty   (rx_fifo_empty)
    );

    fifo #(.WIDTH(DATA_BW), .DEPTH(16)) tx_fifo (
        .clk     (i_clk),
        .rst_n   (i_rstn),
        .wr_en   (tx_wr_en),
        .wr_data (tx_input),
        .rd_en   (tx_fifo_rd_en),
        .rd_data (uart_tx),
        .full    (tx_fifo_full),
        .empty   (tx_fifo_empty)
    );



endmodule