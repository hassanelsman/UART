//note this code will repeat serializing and out X !! so should have enable control
//acording the output done
//module name & declarations
module serializer (
input wire         clk,
input wire         ser_en,
input wire [7:0]   p_data,
output reg         s_data,
output reg         ser_done
);
//internal signals declarations
reg [3:0]          count;
reg                ser_data; 
//RTL Code

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
      ser_data = p_data[count];
      if (count == 4'b1000) begin
        ser_done <=  1'b1 ;
        ser_data <= 1'b0 ;
       end
      else begin
        ser_done <= 1'b0;
      end
   end

always @(posedge clk)
begin
  s_data <= ser_data ;
end

endmodule


