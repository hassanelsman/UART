//combinantiol block
module strt_check (
input wire          sampled_bit,
input wire          smpl_ready,
input wire          strt_chk_en,
output reg          strt_glitch
);
    

//RTL
always @(*) begin
    if (strt_chk_en && sampled_bit && smpl_ready) begin
        strt_glitch = 1'b1;
    end else begin
       strt_glitch = 1'b0 ; 
    end
end
endmodule