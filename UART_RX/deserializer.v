module deserializer (
input wire              clk,rst, 
input wire              sampled_bit,
input wire              smpl_ready,
input wire              deser_en,
input wire  [3:0]       bit_cnt,
output reg  [7:0]       p_data
);


//RTL
always @(posedge clk or negedge rst) begin
    if (!rst) begin
      p_data <= 8'b0 ;
    end
    else if (smpl_ready && deser_en) begin // deser_en should come when sampled_bit ready
        p_data [bit_cnt - 1] <= sampled_bit ; 
    end /* else begin
        p_data [bit_cnt] <= sampled_bit ;
    end */
end

endmodule

/*
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

*/