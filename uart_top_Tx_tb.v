`timescale 1us/1us
module uart_top_tb ();

// Clock Period
parameter  CLK_PERIOD  = 10 ;
		   
/*************************************************************************/
/******************************** TB Signals *****************************/
/*************************************************************************/

reg         CLK_tb ;
reg         RST_tb ;
reg         PAR_EN_tb ;
reg         PAR_TYP_tb ;
reg         DATA_VALID_tb ;
reg [7:0]   P_DATA_tb ;
wire         TX_OUT_tb ;
wire        BUSY_tb ;
 
  
initial
  begin
    $dumpfile("uart.vcd");
    $dumpvars ;

//initial values
CLK_tb = 1'b0;
    
    $display ("*** TEST CASE 1  check normal case***");
RST_tb = 0 ;
PAR_EN_tb = 0;
P_DATA_tb = 8'b011001101;
#CLK_PERIOD
   if (TX_OUT_tb == 1 && BUSY_tb == 0)
       $display ("case 1 pass") ;
   else
      begin
       $display ("case 1 fail") ;
      end
RST_tb = 1 ;
P_DATA_tb = 8'b011001101;
DATA_VALID_tb = 1;
#CLK_PERIOD
DATA_VALID_tb = 0 ;
#CLK_PERIOD
    $display ("*** TEST CASE 2 start bit***") ;

   if (TX_OUT_tb == 0 && BUSY_tb == 1)      
      $display ("case 2  IS pass") ; 
   else
      $display ("case 2  IS failed") ;
    $display ("*** TEST CASE 3 *** check output by yourself") ;
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
        
    $display ("*** TEST CASE 4 ***") ;
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD


P_DATA_tb = 8'b01100101;
DATA_VALID_tb = 1;
PAR_EN_tb = 1;
PAR_TYP_tb = 1;
#CLK_PERIOD
DATA_VALID_tb =0 ;
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD

    $display ("*** TEST CASE 5 ***") ;
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD


P_DATA_tb = 8'b01100101;
DATA_VALID_tb = 1;
PAR_EN_tb = 1;
PAR_TYP_tb = 0;
#CLK_PERIOD
DATA_VALID_tb =0 ;
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD
#CLK_PERIOD

   #100 $finish;  //finished with simulation 
  end
  
  
// Clock Generator with 100 KHz (10 us)
always #(CLK_PERIOD/2) CLK_tb = ~CLK_tb ;


   // instantiate Design Unit
uart_top uart_tb (
.CLK(CLK_tb),
.RST(RST_tb),
.P_DATA(P_DATA_tb),
.PAR_EN(PAR_EN_tb),
.DATA_VALID(DATA_VALID_tb),
.PAR_TYP(PAR_TYP_tb),
.TX_OUT(TX_OUT_tb),
.BUSY(BUSY_tb)
);
 
endmodule