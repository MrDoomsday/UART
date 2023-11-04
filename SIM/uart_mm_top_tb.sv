`timescale 1ns/1ns
import defs::*;
`define axi

module uart_mm_top_tb();


    localparam fifo_depth = 10;
    localparam bit [31:0] system_frequency = 32'd100_000_000; // in Hz
    reg     [31:0]	baudrate = 921600; // in Baud




    reg clk;
    reg reset_n;

`ifdef axi
    reg [4:0]            s_axil_awaddr;
    reg [2:0]            s_axil_awprot;
    reg                  s_axil_awvalid;
    wire                 s_axil_awready;
    reg [31:0]           s_axil_wdata;
    reg [3:0]            s_axil_wstrb;
    reg                  s_axil_wvalid;
    wire                 s_axil_wready;
    wire [1:0]           s_axil_bresp;
    wire                 s_axil_bvalid;
    reg                  s_axil_bready;
    reg [4:0]            s_axil_araddr;
    reg [2:0]            s_axil_arprot;
    reg                  s_axil_arvalid;
    wire                 s_axil_arready;
    wire [31:0]          s_axil_rdata;
    wire [1:0]           s_axil_rresp;
    wire                 s_axil_rvalid;
    reg                  s_axil_rready;
`else
    reg 				avmms_write_i;
    reg 	[2:0] 		avmms_address_i;
    reg 	[31:0]		avmms_writedata_i;
    reg     [3:0]       avmms_byteenable_i;
    reg                 avmms_read_i;
    wire 				avmms_waitrequest_o;
    wire    [31:0]      avmms_readdata_o;
`endif
    wire    uart_tx_rx;

    uart_mm_top #(
        .fifo_depth(fifo_depth)
    ) DUT (
        .clk            (clk),
        .reset_n        (reset_n),
        
    `ifdef axi
        //AXI-Lite Interface
        .s_axil_awaddr  (s_axil_awaddr),
        .s_axil_awprot  (s_axil_awprot),
        .s_axil_awvalid (s_axil_awvalid),
        .s_axil_awready (s_axil_awready),
        .s_axil_wdata   (s_axil_wdata),
        .s_axil_wstrb   (s_axil_wstrb),
        .s_axil_wvalid  (s_axil_wvalid),
        .s_axil_wready  (s_axil_wready),
        .s_axil_bresp   (s_axil_bresp),
        .s_axil_bvalid  (s_axil_bvalid),
        .s_axil_bready  (s_axil_bready),
        .s_axil_araddr  (s_axil_araddr),
        .s_axil_arprot  (s_axil_arprot),
        .s_axil_arvalid (s_axil_arvalid),
        .s_axil_arready (s_axil_arready),
        .s_axil_rdata   (s_axil_rdata),
        .s_axil_rresp   (s_axil_rresp),
        .s_axil_rvalid  (s_axil_rvalid),
        .s_axil_rready  (s_axil_rready),
    `else
        //Avalon-MM Interface
        .avmms_write_i      (avmms_write_i),
        .avmms_address_i    (avmms_address_i),
        .avmms_writedata_i  (avmms_writedata_i),
        .avmms_byteenable_i (avmms_byteenable_i),
        .avmms_read_i       (avmms_read_i),
        .avmms_waitrequest_o(avmms_waitrequest_o),
        .avmms_readdata_o   (avmms_readdata_o),
    `endif
    
        .uart_rx(uart_tx_rx),
        .uart_tx(uart_tx_rx)
    );


    always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end
    


`ifdef axi
    task mm_write(bit [2:0] address, bit [31:0] data);
        fork
        //Address write channel
            begin
                s_axil_awaddr = {address, 2'h0};
                s_axil_awprot = 3'h0;
                s_axil_awvalid = 1'b1;
                #1;
                
                while(~s_axil_awready) begin
                    @(posedge clk);
                    #1;
                end
                @(posedge clk);
                s_axil_awaddr = 5'h0;
                s_axil_awprot = 3'h0;
                s_axil_awvalid = 1'b0;
            end

        //data write channel
            begin
                s_axil_wdata = data;
                s_axil_wstrb = 4'hF;
                s_axil_wvalid = 1'b1;
                #1;

                while(~s_axil_wready) begin
                    @(posedge clk);
                    #1;
                end
                @(posedge clk);

                s_axil_wdata = 32'h0;
                s_axil_wstrb = 4'h0;
                s_axil_wvalid = 1'b0;
            end

        //wait response
            begin
                while(~(s_axil_bready && s_axil_bvalid)) begin
                    @(posedge clk)
                    #1;
                end
                if(s_axil_bresp == 2'b00) begin
                    $display("Write OK, address = %h, data = %h", address, data);
                end
                else if(s_axil_bresp == 2'b10) begin
                    $display("***SLAVE ERROR***, address = %h, data = %h", address, data);
                end
                else begin
                    $display("***OTHER ERROR***, address = %h, data = %h", address, data);
                end
                @(posedge clk);
            end
        join
    endtask


    task mm_read (input bit [2:0] address, output bit [31:0] readdata);
        fork
            //write address
            begin
                s_axil_araddr = {address, 2'b0};
                s_axil_arprot = 3'h0;
                s_axil_arvalid = 1'b1;
                #1;
                while(~s_axil_arready) begin
                    @(posedge clk);
                    #1;
                end
                @(posedge clk);
                s_axil_araddr = 5'h0;
                s_axil_arprot = 3'h0;
                s_axil_arvalid = 1'b0;
            end

            //wait response
            begin
                while(~(s_axil_rready && s_axil_rvalid)) begin
                    @(posedge clk);
                    #1;
                end
                readdata = s_axil_rdata;
                if(s_axil_rresp == 2'b00) begin
                    $display("Read OK, address = %h, readdata = %h", address, readdata);
                end
                else if(s_axil_rresp == 2'b10) begin
                    $display("***SLAVE ERROR***, address = %h, readdata = %h", address, readdata);
                end
                else begin
                    $display("***OTHER ERROR***, address = %h, readdata = %h", address, readdata);
                end
                @(posedge clk);
            end
        join
    endtask
`else
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


    task mm_read (input bit [2:0] address, output bit [31:0] readdata);
        avmms_read_i = 1'b1;
        avmms_address_i = address;
        @(posedge clk);
        #2;
        while(avmms_waitrequest_o) begin
            @(posedge clk);
            #2;
        end
        readdata = avmms_readdata_o;//capture readdata from Avalon bus
        @(posedge clk);
        avmms_read_i = 1'b0;
        avmms_address_i = 3'd0;
    endtask
`endif
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
    `ifdef axi
        s_axil_awaddr = 5'h0;
        s_axil_awprot = 3'h0;
        s_axil_awvalid = 1'b0;

        s_axil_wdata = 32'h0;
        s_axil_wstrb = 4'h0;
        s_axil_wvalid = 1'b0;

        s_axil_araddr = 5'h0;
        s_axil_arprot = 3'h0;
        s_axil_arvalid = 1'b0;
    `else
        avmms_write_i = 1'b0;
        avmms_address_i = 3'h0;
        avmms_writedata_i = 32'h0;
        avmms_byteenable_i = 4'h0;
        avmms_read_i = 1'b0;
    `endif

        repeat(5) @ (posedge clk);
        reset_n = 1'b1;
        repeat(5) @ (posedge clk);
        
        mm_write(3'h1, calc_baud_limit(system_frequency, baudrate));//set baudrate

        for (int i = 0; i < 16; i++) begin
            mm_write(3'h0, {16'h0, {4'b0010, i[3:0]}, 8'h0});//tx_disable   
            //write transaction
            for(int j = 0; j < 256; j++) begin
                //tx_byte = j[7:0];
                tx_byte = $urandom();
                mm_write(3'h4, {24'h0, tx_byte});
                queue_tx_byte.push_back(tx_byte);
            end

            repeat(1000) @ (posedge clk);

            mm_write(3'h0, {16'h0, {4'b0011, i[3:0]}, 8'h0});//tx_enable
            rx_fifo_fill = 32'h0;
            //wait transmit all byte
            while(rx_fifo_fill < 256) begin
                mm_read(3'h3, rx_fifo_fill);
            end

            $display("RX FIFO FILL = 256 byte");
            repeat(10) @ (posedge clk);

            //read and check transaction
            for(int j = 0; j < 256; j++) begin
                bit [31:0] readdata_rx_fifo;
                mm_read(3'h5,readdata_rx_fifo);
                @(posedge clk);
                rx_byte = queue_tx_byte.pop_front();
                //@(posedge clk);
                if((rx_byte == readdata_rx_fifo[7:0]) && !readdata_rx_fifo[8]) begin
                    $display("Byte = %0h OK", rx_byte);
                end
                else begin
                    $display("***TEST FAILED***");
                    if(readdata_rx_fifo[8]) $display("Parity bit error");
                    $display("Byte if queue = %0h, byte receive = %0h", rx_byte, readdata_rx_fifo[7:0]);
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


`ifdef axi
    initial begin
        s_axil_bready = 1'b0;
        forever begin
            s_axil_bready = 1'b0;
            repeat($urandom_range(1,8)) @ (posedge clk);
            s_axil_bready = 1'b1;
            repeat($urandom_range(1,8)) @ (posedge clk);
        end
    end


    initial begin
        s_axil_rready = 1'b0;
        forever begin
            s_axil_rready = 1'b0;
            repeat($urandom_range(1,8)) @ (posedge clk);
            s_axil_rready = 1'b1;
            repeat($urandom_range(1,8)) @ (posedge clk);
        end
    end
`endif



endmodule