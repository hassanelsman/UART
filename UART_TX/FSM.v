module FSM (
input wire               CLK,
input wire               RST,
input wire               PAR_EN,
input wire               DATA_VALID,
input wire               Done,
input wire               S_data,
input wire               Par_bit,

output reg               Ser_en,
output reg               TX_OUT,
output reg               BUSY
);

//niternal connections
reg [2:0]		        current_state,
                        next_state     ;
reg                     tx_out;
reg                     busy;

////////////////////////////// FSM  (UART_TX Controller) ///////////////////////////////
//start bit and stop bit handeld are into FSM not in separate blocks
//local parameters for states
localparam [2:0] 	IDLE  		= 3'b000 ,
				    Start_bit 	= 3'b001 ,
	             	Ser_bits 	= 3'b010 ,
                    Par_bits 	= 3'b011 ,
                    Stop_bits 	= 3'b100 ; 

//moore output depend on only the current state 
//RTL CODE

//  state transitions seq.
always @(posedge CLK or negedge RST)
begin
 if(!RST)
  current_state <= IDLE ;
 else
  current_state <= next_state ;
end


//  next state comb & op
always @(*)
begin
case (current_state)
IDLE : begin
		tx_out = 1'b1;
		Ser_en = 1'b0;
        busy = 1'b0;
        //DATA_VALID_par = 1'b0;
	    if (!BUSY && DATA_VALID && !Done)
		 begin
		  next_state = Start_bit ;
		 end
		else begin
		 next_state = IDLE ;
	   end
 end
Start_bit : begin
	     tx_out = 1'b0 ;
         Ser_en = 1'b1 ;
         busy = 1'b1 ;
         //DATA_VALID_par = 1'b1; //calc the parity and store it to 
                                  //prevent changing it if P_data change
	    if (!DATA_VALID && !Done)
		 begin
		  next_state = Ser_bits ;
		 end
		else begin
		 next_state = Start_bit ;
		end
 end
Ser_bits : begin
	     tx_out = S_data ;
		 Ser_en = 1'b1 ;
		 busy = 1'b1 ;
	    if (Done &&  PAR_EN)
		 begin
		  next_state = Par_bits ;
		 end
		else if (Done && !PAR_EN) begin
		 next_state = Stop_bits ;
		end
		else begin
		 next_state = Ser_bits ;
		end
 end

Par_bits : begin // this case will be just a glich if PAR_EN is off !? NOOO should have to pre condition
		tx_out = Par_bit ;
		Ser_en = 1'b0 ;
		busy = 1'b1 ;
		next_state = Stop_bits;
 end

Stop_bits : begin
	     tx_out = 1'b1 ;
		 Ser_en = 1'b0 ;
		 busy   = 1'b1 ;
		 next_state = IDLE ;
 end
	 
default : begin
	     tx_out = 1'b1;
		 Ser_en = 1'b0;
         busy   = 1'b0;
		 next_state = IDLE ;
 end
endcase
end

///////////////////////////////// final output ////////////////////////////////////////
always @(posedge CLK or negedge RST )
begin
	if (!RST)begin
	TX_OUT <= 1 ;
    BUSY <= 0 ;
	end else begin
    TX_OUT <= tx_out ;
    BUSY <= busy ;
	end
end
endmodule