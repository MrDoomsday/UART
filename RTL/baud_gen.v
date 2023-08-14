module baud_gen (
	//---------------------------------------------------------------------------------------
	// modules inputs and outputs 
	input 			clock,		// global clock input 
	input 			reset,		// global reset input 
	output	reg		ce_8,		// baud rate multiplyed by 16 
	input	[31:0]	baud_limit, // limit counter
	input 			baud_update
);

	// internal registers 
	reg [31:0]	counter;
	//---------------------------------------------------------------------------------------
	// module implementation 
	// baud divider counter  
	always @ (posedge clock or posedge reset) begin
		if(reset) 
			counter <= 32'b0;
		else if((counter == baud_limit) || baud_update)
			counter <= 32'b0;
		else 
			counter <= counter + 32'h1;
	end

	// clock divider output 
	always @ (posedge clock or posedge reset) begin
		if(reset)
			ce_8 <= 1'b0;
		else if(counter == baud_limit) 
			ce_8 <= 1'b1;
		else 
			ce_8 <= 1'b0;
	end 

endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------
