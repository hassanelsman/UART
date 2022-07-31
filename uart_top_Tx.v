module uart_top (
input wire         CLK,
input wire         RST,
input wire         PAR_EN,
input wire         PAR_TYP,
input wire         DATA_VALID,
input wire [7:0]   P_DATA,
output reg         TX_OUT,
output reg         BUSY
);
//internal signals
reg                Ser_en;
wire               Done;
wire               S_data;
wire               Par_bit;
reg [2:0]		   current_state, next_state ;
reg                tx_out;
reg                busy;
reg                DATA_VALID_par;



////////////////////////////// FSM  (UART_TX Controller) ///////////////////////////////
//local parameters for states
localparam [2:0] 	IDLE  = 3'b000 ,
				    Start_bit = 3'b001 ,
	             	Ser_bits = 3'b010 ,
                    Par_bits = 3'b011 ,
                    Stop_bits =3'b100 ; 

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
        DATA_VALID_par = 1'b0;
	    if (!BUSY && DATA_VALID && !Done)
		 begin
		  next_state = Start_bit ;
		 end
		else 
		 next_state = IDLE ;
	   end
	   
Start_bit : begin
	     tx_out = 1'b0 ;
         Ser_en = 1'b1 ;
         busy = 1'b1 ;
         DATA_VALID_par = 1'b1; //calc the parity and store it to 
                                //prevent changing it if P_data change
	    if (!DATA_VALID && !Done)
		 begin
		  next_state = Ser_bits ;
		 end
		else 
		 next_state = Start_bit ;
	    
		end
		
Ser_bits : begin
	     tx_out = S_data ;
		 Ser_en = 1'b1 ;
		 busy = 1'b1 ;
         DATA_VALID_par = 1'b0;
	    if (Done &&  PAR_EN)
		 begin
		  next_state = Par_bits ;
		 end
		else if (Done && !PAR_EN) begin
		 next_state = Stop_bits ;
		end
		else 
		 next_state = Ser_bits ;
		end

Par_bits : begin // this case will be just a glich if PAR_EN is off !? NOOO should have to pre condition
		tx_out = Par_bit ;
		Ser_en = 1'b0 ;
		busy = 1'b1 ;
        DATA_VALID_par = 1'b0;

	    if ( Done )
		 begin
		  next_state = Par_bits ;
		 end
		else 
		begin
		next_state = Stop_bits ;
		end

		end

Stop_bits : begin
	     tx_out = 1'b1 ;
		 Ser_en = 1'b0 ;
		 busy = 1'b1 ;
         DATA_VALID_par = 1'b0;
		 next_state = IDLE ;
     end
	 
default : begin
	     tx_out = 1'b1;
		 Ser_en = 1'b0;
         busy = 1'b0;
         DATA_VALID_par = 1'b0;
		 next_state = IDLE ;
	      end

endcase
end

///////////////////////////////// final output ////////////////////////////////////////
always @(posedge CLK )
begin
    TX_OUT <= tx_out ;
    BUSY <= busy ;
end

//////////////////////////////// instantiation ////////////////////////////////////////
serializer SER (
.clk(CLK),
.ser_en(Ser_en),
.p_data(P_DATA),
.s_data(S_data),
.ser_done(Done)
);

parity_clc PAR (
.clk(CLK),
.par_typ(PAR_TYP),
.p_data(P_DATA),
.parity_bit(Par_bit),
.data_valid(DATA_VALID_par)
);
  
endmodule