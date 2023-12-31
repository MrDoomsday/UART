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
        [12] - tx_enable
        [13] - rx_enable
        [31:14] - reserved
    0x1 - BAUD_GEN: baud_limit - WR
    0x2 - FILL TX - RO
    0x3 - FILL RX - RO
    0x4 - TX FIFO - WO
    0x5 - RX FIFO - RO
*/
`define use_axi

module uart_mm_top #(
    parameter fifo_depth = 10
)(
	input clk,
	input reset_n,

`ifdef use_axi
//AXI-Lite Interface
    input  bit [4:0]            s_axil_awaddr,
    input  bit [2:0]            s_axil_awprot,
    input  bit                  s_axil_awvalid,
    output bit                  s_axil_awready,
    input  bit [31:0]           s_axil_wdata,
    input  bit [3:0]            s_axil_wstrb,
    input  bit                  s_axil_wvalid,
    output bit                  s_axil_wready,
    output bit [1:0]            s_axil_bresp,
    output bit                  s_axil_bvalid,
    input  bit                  s_axil_bready,
    input  bit [4:0]            s_axil_araddr,
    input  bit [2:0]            s_axil_arprot,
    input  bit                  s_axil_arvalid,
    output bit                  s_axil_arready,
    output bit [31:0]           s_axil_rdata,
    output bit [1:0]            s_axil_rresp,
    output bit                  s_axil_rvalid,
    input  bit                  s_axil_rready,
`else
//Avalon-ST Interface
	input 	bit 				avmms_write_i,
	input 	bit 	[2:0] 		avmms_address_i,
	input 	bit 	[31:0]		avmms_writedata_i,
    input   bit     [3:0]       avmms_byteenable_i,
    input   bit                 avmms_read_i,
	output 	bit 				avmms_waitrequest_o,
    output  bit     [31:0]      avmms_readdata_o,
`endif

    input   logic uart_rx,
    output  logic uart_tx
);

/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************        DECLARATION         ************************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
    logic fifo_tx_wr, fifo_tx_rd;
    logic [fifo_depth:0] fifo_tx_fill;
    logic [7:0] fifo_tx_din, fifo_tx_dout;
    logic fifo_tx_full, fifo_tx_empty;

    logic fifo_rx_wr, fifo_rx_rd;
    logic [fifo_depth:0] fifo_rx_fill;
    logic [8:0] fifo_rx_din, fifo_rx_dout;
    logic fifo_rx_full, fifo_rx_empty;

//control register
    bit             cr_pbit; // enable parity bit
    bit     [1:0]   cr_sbit; // count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
	bit				cr_ptype;// type parity bit, 0 - even, 1 - odd
    bit     [31:0]	cr_baud_limit;
    bit             cr_baud_update;
    bit             cr_tx_en;
    bit             cr_rx_en;

//tx data
    bit     [7:0]   tx_data_i;
    bit             tx_valid_i;
    bit             tx_ready_o;

//rx data
    bit     [7:0]   rx_data_o;
    bit             rx_pbit_error;
    bit             rx_valid_o;

    bit             rx_read;
    bit     [8:0]   rx_readdata;
    bit             rx_readdatavalid;

/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************           INSTANCE          ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
`ifdef use_axi
    axi_to_reg axi_to_reg_inst (
        .clk        (clk),
        .reset_n    (reset_n),

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

    //register
        .cr_pbit        (cr_pbit), // enable parity bit
        .cr_sbit        (cr_sbit), // count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
        .cr_ptype       (cr_ptype),// type parity bit, 0 - even, 1 - odd
        .cr_baud_limit  (cr_baud_limit),
        .cr_baud_update (cr_baud_update),
        .cr_tx_en       (cr_tx_en),
        .cr_rx_en       (cr_rx_en),

        .fifo_tx_empty  (fifo_tx_empty),
        .fifo_tx_full   (fifo_tx_full),
        .fifo_tx_fill   ({{(32-fifo_depth-1){1'b0}}, fifo_tx_fill}),

        .fifo_rx_empty  (fifo_rx_empty),
        .fifo_rx_full   (fifo_rx_full),
        .fifo_rx_fill   ({{(32-fifo_depth-1){1'b0}}, fifo_rx_fill}),
        
        .tx_byte        (fifo_tx_din),
        .tx_valid       (fifo_tx_wr),

        .rx_read        (rx_read),
        .rx_readdata    (rx_readdata),
        .rx_readdatavalid(rx_readdatavalid)
    );
`else
    avalon_to_reg avalon_to_reg_inst (
        .clk        (clk),
        .reset_n    (reset_n),

    //Avalon Interface
        .avmms_write_i      (avmms_write_i),
        .avmms_address_i    (avmms_address_i),
        .avmms_writedata_i  (avmms_writedata_i),
        .avmms_byteenable_i (avmms_byteenable_i),
        .avmms_read_i       (avmms_read_i),
        .avmms_waitrequest_o(avmms_waitrequest_o),
        .avmms_readdata_o   (avmms_readdata_o),

    //register
        .cr_pbit        (cr_pbit), // enable parity bit
        .cr_sbit        (cr_sbit), // count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
        .cr_ptype       (cr_ptype),// type parity bit, 0 - even, 1 - odd
        .cr_baud_limit  (cr_baud_limit),
        .cr_baud_update (cr_baud_update),
        .cr_tx_en       (cr_tx_en),
        .cr_rx_en       (cr_rx_en),

        .fifo_tx_empty  (fifo_tx_empty),
        .fifo_tx_full   (fifo_tx_full),
        .fifo_tx_fill   ({{(32-fifo_depth-1){1'b0}}, fifo_tx_fill}),

        .fifo_rx_empty  (fifo_rx_empty),
        .fifo_rx_full   (fifo_rx_full),
        .fifo_rx_fill   ({{(32-fifo_depth-1){1'b0}}, fifo_rx_fill}),
        
        .tx_byte        (fifo_tx_din),
        .tx_valid       (fifo_tx_wr),

        .rx_read        (rx_read),
        .rx_readdata    (rx_readdata),
        .rx_readdatavalid(rx_readdatavalid)
    );
`endif

sc_fifo #(
	.data_width(8),
	.fifo_depth(fifo_depth)
) fifo_tx (
	.clk	(clk),
	.reset_n(reset_n),
		
	.wr		(fifo_tx_wr),
	.data_in(fifo_tx_din),
	
	.rd			(fifo_tx_rd),
	.data_out	(fifo_tx_dout),
	
	.full		(fifo_tx_full),
	.empty		(fifo_tx_empty),
	.use_words	(fifo_tx_fill),
	.clear		(1'b0)//active is HIGH
);


sc_fifo #(
	.data_width(9),// 8 bit for data + 1 bit for parity error
	.fifo_depth(fifo_depth)
) fifo_rx (
	.clk	(clk),
	.reset_n(reset_n),
		
	.wr		(fifo_rx_wr),
	.data_in(fifo_rx_din),
	
	.rd			(fifo_rx_rd),
	.data_out	(fifo_rx_dout),
	
	.full		(fifo_rx_full),
	.empty		(fifo_rx_empty),
	.use_words	(fifo_rx_fill),
	.clear		(1'b0)//active is HIGH

);



uart_rx_tx uart_rx_tx_inst(
    .clk    (clk),
    .reset_n(reset_n),

    //tx data
    .tx_data_i  (tx_data_i),
    .tx_valid_i (tx_valid_i),
    .tx_ready_o (tx_ready_o),

    //rx data
    .rx_data_o      (rx_data_o),
    .rx_pbit_error  (rx_pbit_error),
    .rx_valid_o     (rx_valid_o),


    .uart_rx(uart_rx),
    .uart_tx(uart_tx),

    //control register
    .cr_pbit        (cr_pbit), // enable parity bit
    .cr_sbit        (cr_sbit), // count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
	.cr_ptype       (cr_ptype),// type parity bit, 0 - even, 1 - odd
    .cr_baud_limit  (cr_baud_limit),
    .cr_baud_update (cr_baud_update)
);


/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************            LOGIC            ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
//connect fifo_tx
assign fifo_tx_rd = ~fifo_tx_empty & tx_ready_o & cr_tx_en;

always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) tx_valid_i <= 1'b0;
    else if(tx_ready_o) tx_valid_i <= fifo_tx_rd;

assign tx_data_i = fifo_tx_dout;

//connect fifo_rx
assign fifo_rx_wr = rx_valid_o & cr_rx_en;
assign fifo_rx_din = {rx_pbit_error, rx_data_o};

assign fifo_rx_rd = rx_read;
assign rx_readdata = fifo_rx_dout;

always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) rx_readdatavalid <= 1'b0;
    else rx_readdatavalid <= rx_read;



endmodule