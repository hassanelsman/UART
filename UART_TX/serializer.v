//note this code will repeat serializing and out X !! so should have enable control
//acording the output done
// if p data changed it will continue serializing with new values ?? should register them first ????
//module name & declarations
module serializer (
input wire         clk,
input wire         ser_en,
input wire         data_valid,
input wire [7:0]   p_data,
output reg         s_data,
output reg         ser_done
);
//internal signals declarations
reg [3:0]           count;
reg                 ser_data;
reg	[7:0]			p_data_saved ;
 
//RTL Code

always@(posedge clk)
begin
if (data_valid)
p_data_saved <= p_data ;
end


//Counter
always @(posedge clk)
 begin
   if(!ser_en || ser_done)  // synchronous active low reset 
     begin
      count <= 0 ;
     end
   else
     begin
      count <= count + 4'b1 ;
     end
 end

always @(*)
 begin
      if (count == 4'b1000) begin
        ser_done =  1'b1 ;
        ser_data = 1'b0 ;
       end
      else begin
        ser_done = 1'b0;
		ser_data = p_data_saved[count];
      end
   end

always @(posedge clk)
begin
  s_data <= ser_data ;
end

endmodule


