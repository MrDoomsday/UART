module uart_tb();

    reg clk;
    reg reset_n;

    //tx data
    reg     [7:0]   tx_data_i;
    reg             tx_valid_i;
    wire            tx_ready_o;

    //rx data
    wire     [7:0]   rx_data_o;
    wire             rx_pbit_error;
    wire             rx_valid_o;


    wire    uart_rx;
    wire    uart_tx;
    assign uart_rx = uart_tx;

    //control register
    reg             cr_pbit; // enable control bit
    reg     [1:0]   cr_sbit; // count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
    reg				cr_ptype;// type parity bit, 0 - even, 1 - odd
    reg     [11:0]  cr_baud_freq = 12'd576; // baud = 115200, freq = 50 MHz
    reg     [15:0]	cr_baud_limit = 16'd15049;



    uart_rx_tx DUT (

        .clk            (clk),
        .reset_n        (reset_n),

        //tx data
        .tx_data_i      (tx_data_i),
        .tx_valid_i     (tx_valid_i),
        .tx_ready_o     (tx_ready_o),

        //rx data
        .rx_data_o      (rx_data_o),
        .rx_pbit_error  (rx_pbit_error),
        .rx_valid_o     (rx_valid_o),


        .uart_rx        (uart_rx),
        .uart_tx        (uart_tx),

        //control register
        .cr_pbit        (cr_pbit), // enable control bit
        .cr_sbit        (cr_sbit), // count stop bit, 2'b00 - 1 stop bit, 2'b01 - 2 stop bit, 2'b10 - 3 stop bit, 2'b11 - 3 stop bit;
        .cr_ptype       (cr_ptype),// type parity bit, 0 - even, 1 - odd
        .cr_baud_freq   (cr_baud_freq),
        .cr_baud_limit  (cr_baud_limit)

    );

    


    always begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
    end

    bit [7:0] random_data;

    initial begin
        reset_n = 1'b0;
        tx_data_i = 8'h0;
        tx_valid_i = 1'b0;
        cr_pbit = 1'b0;
        cr_sbit = 2'b00;
        repeat(10) @ (posedge clk);
        reset_n = 1'b1;
        repeat(10) @ (posedge clk);
        
        for (int j = 0; j < 16; j++) begin
            {cr_ptype, cr_pbit, cr_sbit} = j[3:0];
            /*repeat(100000)*/ @(posedge clk);
            for(int i = 0; i < 256; i++) begin
                wait(tx_ready_o == 1'b1);
                random_data = i[7:0];//$urandom();
                tx_valid_i = 1'b1;
                tx_data_i = random_data;
                @(posedge clk);
                tx_data_i = 8'h0;
                tx_valid_i = 1'b0;
                @(posedge clk);

                wait(rx_valid_o == 1'b1);
                @(posedge clk);
                if((random_data == rx_data_o) && !rx_pbit_error) $display("Transaction OK, data = %0h", random_data);
                else begin
                    if(rx_pbit_error) $display("Parity bit error");
                    $display("Transaction failed");
                    $display("CR_PTYPE = %0b, CR_PBIT = %0b, CR_SBIT = %0d", cr_ptype, cr_pbit, cr_sbit);
                    $stop();
                end 
            end
        end

        repeat(1000) @ (posedge clk);
        $display("***Test PASSED***");
        $stop();
    end


endmodule