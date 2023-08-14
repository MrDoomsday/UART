
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

module avalon_to_reg (
    input bit clk,
    input bit reset_n,

//Avalon Interface
	input 	bit 				avmms_write_i,
	input 	bit 	[2:0] 		avmms_address_i,
	input 	bit 	[31:0]		avmms_writedata_i,
    input   bit     [3:0]       avmms_byteenable_i,
    input   bit                 avmms_read_i,
	output 	bit 				avmms_waitrequest_o,
    output  bit     [31:0]      avmms_readdata_o,

//register
    output   bit                cr_pbit, // enable parity bit
    output   bit     [1:0]      cr_sbit, // count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
	output 	 bit				cr_ptype,// type parity bit, 0 - even, 1 - odd
    output   bit     [31:0]	    cr_baud_limit,
    output   bit                cr_baud_update,


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
bit next_waitrequest;
bit write_transaction, read_transaction;//выставляется в момент активной транзакции (чтения или записи)


/***********************************************************************************************************************/
/***********************************************************************************************************************/
/*******************************************            LOGIC            ***********************************************/
/***********************************************************************************************************************/
/***********************************************************************************************************************/
//write in register
    //uart control bits 
    always_ff @ (posedge clk or negedge reset_n)
        if(!reset_n) begin
            cr_pbit <= 1'b0;
            cr_ptype <= 1'b0;
            cr_sbit <= 2'b00;
        end
        else if((avmms_address_i == 3'h0) && avmms_write_i && !avmms_waitrequest_o) begin
            if(avmms_byteenable_i[1]) {cr_sbit, cr_ptype, cr_pbit} <= avmms_writedata_i[11:8];
        end
    
    //baud freq and baud limit
    always_ff @ (posedge clk) begin
        if((avmms_address_i == 3'h1) && avmms_write_i && !avmms_waitrequest_o) begin
            if(avmms_byteenable_i[3])   cr_baud_limit[31:24] <= avmms_writedata_i[31:24];
            if(avmms_byteenable_i[2])   cr_baud_limit[23:16] <= avmms_writedata_i[23:16];
            if(avmms_byteenable_i[1])   cr_baud_limit[15:8]  <= avmms_writedata_i[15:8];
            if(avmms_byteenable_i[0])   cr_baud_limit[7:0]   <= avmms_writedata_i[7:0];
        end
    end

    always_ff @ (posedge clk or negedge reset_n)
        if(!reset_n) cr_baud_update <= 1'b0;
        else if((avmms_address_i == 3'h1) && avmms_write_i && !avmms_waitrequest_o) cr_baud_update <= 1'b1;
        else cr_baud_update <= 1'b0;

    //new data for TX
    always_ff @ (posedge clk or negedge reset_n)
        if(!reset_n) begin
            tx_byte     <= 8'h0;
            tx_valid    <= 1'b0;
        end
        else if((avmms_address_i == 3'h4) && avmms_write_i && !avmms_waitrequest_o && avmms_byteenable_i[0]) begin
            tx_byte     <= avmms_writedata_i[7:0];
            tx_valid    <= 1'b1;
        end
        else begin
            tx_byte     <= 8'h0;
            tx_valid    <= 1'b0;
        end

//control transaction
    always_ff @ (posedge clk or negedge reset_n)
        if(!reset_n) begin
            write_transaction   <= 1'b0;
            read_transaction    <= 1'b0;
        end
        else begin
            if(!write_transaction) write_transaction <= avmms_write_i;
            else if(avmms_write_i & !avmms_waitrequest_o) write_transaction <= 1'b0;

            if(!read_transaction) read_transaction <= avmms_read_i;
            else if(avmms_read_i & !avmms_waitrequest_o) read_transaction <= 1'b0;
        end


    always_ff @ (posedge clk or negedge reset_n)
        if(!reset_n) begin
            avmms_waitrequest_o <= 1'b1;
            next_waitrequest <= 1'b1;
        end
        else begin
            if(avmms_read_i && (avmms_address_i == 3'h5) && !read_transaction) begin
                next_waitrequest <= 1'b0;
                avmms_waitrequest_o <= next_waitrequest;
            end
            else if(avmms_write_i && !write_transaction || avmms_read_i && !read_transaction) begin
                avmms_waitrequest_o <= 1'b0;
                next_waitrequest <= 1'b1;
            end
            else begin 
                next_waitrequest <= 1'b1;
                avmms_waitrequest_o <= next_waitrequest;
            end
        end

//read from register
    assign rx_read = avmms_read_i & (avmms_address_i == 3'h5) & !read_transaction;

    always_ff @ (posedge clk) begin
        avmms_readdata_o <= 32'h0;
        case(avmms_address_i)
            3'h0:   avmms_readdata_o <= {16'h0, {4'h0, cr_sbit, cr_ptype, cr_pbit}, {4'h0, fifo_tx_full, fifo_tx_empty, fifo_rx_full, fifo_rx_empty}};
            3'h1:   avmms_readdata_o <= cr_baud_limit;
            3'h2:   avmms_readdata_o <= fifo_tx_fill;
            3'h3:   avmms_readdata_o <= fifo_rx_fill;
            3'h5:   avmms_readdata_o <= {23'h0, rx_readdata};
            default:    avmms_readdata_o <= 32'h0;
        endcase
    end

endmodule