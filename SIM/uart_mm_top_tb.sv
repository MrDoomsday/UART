`timescale 1ns/1ns
import defs::*;

module uart_mm_top_tb();


    localparam fifo_depth = 10;
    localparam bit [31:0] system_frequency = 32'd100_000_000; // in Hz
    reg     [31:0]	baudrate = 9600; // in Baud




    reg clk;
    reg reset_n;
    
    reg 				avmms_write_i;
    reg 	[2:0] 		avmms_address_i;
    reg 	[31:0]		avmms_writedata_i;
    reg     [3:0]       avmms_byteenable_i;
    reg                 avmms_read_i;
    wire 				avmms_waitrequest_o;
    wire    [31:0]      avmms_readdata_o;

    wire    uart_tx_rx;

    uart_mm_top #(
        .fifo_depth(fifo_depth)
    ) DUT (
        .clk            (clk),
        .reset_n        (reset_n),
        
        .avmms_write_i      (avmms_write_i),
        .avmms_address_i    (avmms_address_i),
        .avmms_writedata_i  (avmms_writedata_i),
        .avmms_byteenable_i (avmms_byteenable_i),
        .avmms_read_i       (avmms_read_i),
        .avmms_waitrequest_o(avmms_waitrequest_o),
        .avmms_readdata_o   (avmms_readdata_o),
    
    
        .uart_rx(uart_tx_rx),
        .uart_tx(uart_tx_rx)
    );


    always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end
    



    task mm_write(bit [2:0] address, bit [31:0] data);
        avmms_address_i = address;
        avmms_writedata_i = data;
        avmms_write_i = 1'b1;
        avmms_byteenable_i = 4'b1111;
        @(posedge clk);
        #2;
        while(avmms_waitrequest_o) begin
            @(posedge clk);
            #2;
        end
        @(posedge clk);
        avmms_writedata_i = 32'h0;
        avmms_write_i = 1'b0;
        avmms_byteenable_i = 4'b0000;
    endtask

    /*REGISTER MAP*/
    /*
        0x0 - CONTROL - RW
            [0] - fifo_rx_empty
            [1] - fifo_rx_full
            [2] - fifo_tx_empty
            [3] - fifo_tx_full
            [8] - enable parity bit
            [9] - parity bit type, 0 - even, 1 - odd
            [11:10] - count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
            [31:12] - reserved
        0x1 - BAUD_GEN: baud_limit - WR
        0x2 - FILL TX - RO
        0x3 - FILL RX - RO
        0x4 - TX FIFO - WO
        0x5 - RX FIFO - RO
    */

    reg [7:0] tx_byte;
    reg [7:0] rx_byte;
    reg [7:0] queue_tx_byte [$];
    reg [31:0] rx_fifo_fill;


    initial begin
        reset_n = 1'b0;
        avmms_write_i = 1'b0;
        avmms_address_i = 3'h0;
        avmms_writedata_i = 32'h0;
        avmms_byteenable_i = 4'h0;
        avmms_read_i = 1'b0;
        repeat(5) @ (posedge clk);
        reset_n = 1'b1;
        repeat(5) @ (posedge clk);
        
        mm_write(3'h1, calc_baud_limit(system_frequency, baudrate));

        for (int i = 0; i < 16; i++) begin
            mm_write(3'h0, {16'h0, i[7:0], 8'h0});            
            //write transaction
            for(int j = 0; j < 256; j++) begin
                //tx_byte = j[7:0];
                tx_byte = $urandom();
                mm_write(3'h4, {24'h0, tx_byte});
                queue_tx_byte.push_back(tx_byte);
            end

            rx_fifo_fill = 32'h0;
            //wait transmit all byte
            while(rx_fifo_fill < 256) begin
                avmms_read_i = 1'b1;
                avmms_address_i = 3'd3;
                @(posedge clk);
                #2;
                while(avmms_waitrequest_o) begin
                    @(posedge clk);
                    #2;
                end
                rx_fifo_fill = avmms_readdata_o;
                @(posedge clk);
                avmms_read_i = 1'b0;
                avmms_address_i = 3'h0;
            end

            $display("RX FIFO FILL = 256 byte");
            repeat(10) @ (posedge clk);

            //read and check transaction
            for(int j = 0; j < 256; j++) begin
                avmms_read_i = 1'b1;
                avmms_address_i = 3'd5;
                @(posedge clk);
                #2;
                while(avmms_waitrequest_o) begin
                    @(posedge clk);
                    #2;
                end
                @(posedge clk);
                avmms_read_i = 1'b0;
                avmms_address_i = 3'd0;
                rx_byte = queue_tx_byte.pop_front();
                //@(posedge clk);
                if((rx_byte == avmms_readdata_o[7:0]) && !avmms_readdata_o[8]) begin
                    $display("Byte = %0h OK", rx_byte);
                end
                else begin
                    $display("***TEST FAILED***");
                    if(avmms_readdata_o[8]) $display("Parity bit error");
                    $display("Byte if queue = %0h, byte receive = %0h", rx_byte, avmms_readdata_o[7:0]);
                    $display("CR_PTYPE = %0b, CR_PBIT = %0b, CR_SBIT = %0d", i[1], i[0], i[3:2]);
                    $stop();
                end
            end
            $display();
        end

        repeat(50000) @ (posedge clk);
        $display("***TEST PASSED***");
        $stop();
    end






endmodule