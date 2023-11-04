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
module axi_to_reg (
    input bit clk,
    input bit reset_n,

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

//register
    output   bit                cr_pbit, // enable parity bit
    output   bit     [1:0]      cr_sbit, // count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
	output 	 bit				cr_ptype,// type parity bit, 0 - even, 1 - odd
    output   bit     [31:0]	    cr_baud_limit,
    output   bit                cr_baud_update,
    output   bit                cr_tx_en,
    output   bit                cr_rx_en,
    


    input   bit                 fifo_tx_empty,
    input   bit                 fifo_tx_full,
    input   bit     [31:0]      fifo_tx_fill,

    input   bit                 fifo_rx_empty,
    input   bit                 fifo_rx_full,
    input   bit     [31:0]      fifo_rx_fill,
    
    output   bit     [7:0]      tx_byte,
    output   bit                tx_valid,

    output  bit                 rx_read,
    input   bit     [8:0]       rx_readdata,
    input   bit                 rx_readdatavalid

);



/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************        DECLARATION         ************************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
//write channel
bit [2:0] aligned_awaddress_reg;// = s_axil_awaddr[5:2];
bit [2:0] awprot_reg;

bit [3:0] wstrb_reg;
bit [31:0] wdata_reg;

bit aw_capture;//address write captured and wait write transaction 
bit w_capture;

//read channel
bit [2:0] aligned_araddress_reg;// = s_axil_araddr[5:2];
bit [2:0] arprot_reg;


bit ar_capture;


/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************            WRITE            ***********************************************/
/*******************************************            CHANNEL          ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/

always_ff @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        aw_capture <= 1'b0;
        w_capture <= 1'b0;
    end
    else begin
        if(aw_capture) aw_capture <= ~(s_axil_bvalid & s_axil_bready);
        else aw_capture <= s_axil_awvalid;

        if(w_capture) w_capture <= ~(s_axil_bvalid & s_axil_bready);
        else w_capture <= s_axil_wvalid;
    end
end

assign s_axil_awready = ~aw_capture;
assign s_axil_wready = ~w_capture;

always_ff @ (posedge clk) begin
    if(s_axil_awvalid && s_axil_awready) begin
        aligned_awaddress_reg <= s_axil_awaddr[4:2];
        awprot_reg <= s_axil_awprot;
    end

    if(s_axil_wready && s_axil_wvalid) begin
        wstrb_reg <= s_axil_wstrb;
        wdata_reg <= s_axil_wdata;
    end
end


//write only 1 tick
always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) s_axil_bvalid <= 1'b0;
    else if(aw_capture && w_capture && ~s_axil_bvalid) s_axil_bvalid <= 1'b1;
    else if(s_axil_bready) s_axil_bvalid <= 1'b0;

always_ff @ (posedge clk) begin
    if((aligned_awaddress_reg == 3'h2) || (aligned_awaddress_reg == 3'h3) || (aligned_awaddress_reg == 3'h5)) s_axil_bresp <= 2'b10;//SLAVE ERROR
    else s_axil_bresp <= 2'b00;//OK
end

wire transaction_ok = aw_capture & w_capture & s_axil_bready & s_axil_bvalid;

/*REGISTER WRITE*/
//aligned_awaddress_reg = 0;
    //uart control bits 
always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) begin
        cr_pbit <= 1'b0;
        cr_ptype <= 1'b0;
        cr_sbit <= 2'b00;
        cr_tx_en <= 1'b1;
        cr_rx_en <= 1'b1;
    end
    else if((aligned_awaddress_reg == 3'h0) && transaction_ok) begin
        if(wstrb_reg[1]) begin
            cr_rx_en    <= wdata_reg[13];
            cr_tx_en    <= wdata_reg[12];
            cr_sbit     <= wdata_reg[11:10];
            cr_ptype    <= wdata_reg[9];
            cr_pbit     <= wdata_reg[8];
        end
    end

//baud freq and baud limit
always_ff @ (posedge clk) begin
    if((aligned_awaddress_reg == 3'h1) && transaction_ok) begin
        if(wstrb_reg[3])   cr_baud_limit[31:24] <= wdata_reg[31:24];
        if(wstrb_reg[2])   cr_baud_limit[23:16] <= wdata_reg[23:16];
        if(wstrb_reg[1])   cr_baud_limit[15:8]  <= wdata_reg[15:8];
        if(wstrb_reg[0])   cr_baud_limit[7:0]   <= wdata_reg[7:0];
    end
end

always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) cr_baud_update <= 1'b0;
    else if((aligned_awaddress_reg == 3'h1) && transaction_ok) cr_baud_update <= 1'b1;
    else cr_baud_update <= 1'b0;

//new data for TX
always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) begin
        tx_byte     <= 8'h0;
        tx_valid    <= 1'b0;
    end
    else if((aligned_awaddress_reg == 3'h4) && transaction_ok && wstrb_reg[0]) begin
        tx_byte     <= wdata_reg[7:0];
        tx_valid    <= 1'b1;
    end
    else begin
        tx_byte     <= 8'h0;
        tx_valid    <= 1'b0;
    end


/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************             READ            ***********************************************/
/*******************************************            CHANNEL          ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) ar_capture <= 1'b0;
    else begin
        if(ar_capture) ar_capture <= ~(s_axil_rready & s_axil_rvalid);
        else ar_capture <= s_axil_arvalid;
    end

assign s_axil_arready = ~ar_capture;



always_ff @ (posedge clk) begin
    if(s_axil_arready && s_axil_arvalid) begin
        aligned_araddress_reg <= s_axil_araddr[4:2];
        arprot_reg <= s_axil_arprot;
    end
end


//generate one tick signal 'read' from fifo
bit read_from_fifo_capture;

always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) begin
        rx_read <= 1'b0;
        read_from_fifo_capture <= 1'b0;
    end
    else begin
        if(~read_from_fifo_capture && (aligned_araddress_reg == 3'h5) && ar_capture) read_from_fifo_capture <= 1'b1;
        else if(s_axil_rready && s_axil_rvalid) read_from_fifo_capture <= 1'b0;

        if(~read_from_fifo_capture && (aligned_araddress_reg == 3'h5) && ar_capture) rx_read <= 1'b1;
        else rx_read <= 1'b0;
    end


//response 
    always_ff @ (posedge clk or negedge reset_n)
    if(!reset_n) s_axil_rvalid <= 1'b0;
    else begin
        if(s_axil_rready && s_axil_rvalid) s_axil_rvalid <= 1'b0;//transaction OK
        else if(ar_capture && ( (aligned_araddress_reg == 3'h0) || 
                                (aligned_araddress_reg == 3'h1) || 
                                (aligned_araddress_reg == 3'h2) || 
                                (aligned_araddress_reg == 3'h3) || 
                                (aligned_araddress_reg == 3'h4) || (aligned_araddress_reg == 3'h5) && rx_readdatavalid)) s_axil_rvalid <= 1'b1;//read from internal register
    end

always_ff @ (posedge clk or negedge reset_n) begin
        case(aligned_araddress_reg)
            3'h0:   s_axil_rdata <= {16'h0, {2'h0, cr_rx_en, cr_tx_en, cr_sbit, cr_ptype, cr_pbit}, {4'h0, fifo_tx_full, fifo_tx_empty, fifo_rx_full, fifo_rx_empty}};
            3'h1:   s_axil_rdata <= cr_baud_limit;
            3'h2:   s_axil_rdata <= fifo_tx_fill;
            3'h3:   s_axil_rdata <= fifo_rx_fill;
            3'h4:   s_axil_rdata <= 32'h0;//read fail
            3'h5:   s_axil_rdata <= rx_readdatavalid ? {23'h0, rx_readdata} : s_axil_rdata;
            default: s_axil_rdata <= 32'h0;
        endcase
end

always_ff @ (posedge clk) begin
    if( (aligned_araddress_reg == 3'h0) || 
        (aligned_araddress_reg == 3'h1) || 
        (aligned_araddress_reg == 3'h2) || 
        (aligned_araddress_reg == 3'h3) || 
        (aligned_araddress_reg == 3'h5)) s_axil_rresp <= 2'b00;
    else if(aligned_araddress_reg == 3'h4) s_axil_rresp <= 2'b10;//SLAVE ERR
end


endmodule