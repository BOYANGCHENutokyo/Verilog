`default_nettype none
`timescale 10ps / 1ps

/*
module div1
   #(parameter K = 32)
   ( input wire [K-1:0]  x0,
     input wire [K-1:0]  d0,
     output wire  q0,
     output wire [K-1:0] r0);

   assign q0 = (x0>d0) ? 1 : 0;

   assign r0 = q0 ? (x0-d0) : x0;
endmodule
*/

module div2
   #(parameter K = 32,
     localparam  M = 1)
   ( input wire [K+2*M-1:0] x,
     input wire [K-1:0]  d,
     output wire [2*M-1:0] q,
     output wire [K-1:0] r);
     
     wire [K-1:0] xh1;
     wire  xh2;
     wire  xl;
     wire [K-1:0] rh;
     wire [K-1:0] rl;
     wire  qh;
     wire  ql; 
     //wire [K+M-1:0] rh_xl;
     assign xh1 = x[K+2*M-1:2*M];
     assign xh2 = x[1];
     assign xl = x[0];
     
     assign qh = ({xh1,xh2} >  d) ? 1'b1 : 1'b0;
     assign rh = ({xh1,xh2} > d) ? ({xh1,xh2} - d) : {xh1,xh2};

     assign ql = ({rh,xl} > d) ? 1'b1 : 1'b0;
     assign rl = ({rh,xl} > d) ? ({rh,xl} - d) : {rh,xl};
     
     assign q = {qh, ql};
     assign r = rl;
endmodule

module div4
   #(parameter K = 32,
     localparam M = 2)
   ( input wire [K+2*M-1:0]  x,
     input wire [K-1:0]  d,
     output wire [2*M-1:0] q,
     output wire [K-1:0] r);
     
     wire [K-1:0] xh1;
     wire [M-1:0] xh2;
     wire [M-1:0] xl;
     wire [K-1:0] rh;
     wire [K-1:0] rl;
     wire [M-1:0] qh;
     wire [M-1:0] ql; 
     //wire [K+M-1:0] rh_xl;
     assign xh1 = x[K+2*M-1:2*M];
     assign xh2 = x[2*M-1:M];
     assign xl = x[M-1:0];
     
     div2 #(32) u1({xh1,xh2}, d, qh, rh);
     
     div2 #(32) u2({rh,xl}, d ,ql, rl);
     
     assign q = {qh, ql};
     assign r = rl;
endmodule

module div8
   #(parameter K = 32,
     localparam M = 4)
   ( input wire [K+2*M-1:0]  x,
     input wire [K-1:0]  d,
     output wire [2*M-1:0] q,
     output wire [K-1:0] r);
     
     wire [K-1:0] xh1;
     wire [M-1:0] xh2;
     wire [M-1:0] xl;
     wire [K-1:0] rh;
     wire [K-1:0] rl;
     wire [M-1:0] qh;
     wire [M-1:0] ql; 
     //wire [K+M-1:0] rh_xl;
     assign xh1 = x[K+2*M-1:2*M];
     assign xh2 = x[2*M-1:M];
     assign xl = x[M-1:0];
     
     div4 #(32) u1({xh1,xh2}, d, qh, rh);
     
     div4 #(32) u2({rh,xl}, d ,ql, rl);
     
     assign q = {qh, ql};
     assign r = rl;
endmodule

module div16
   #(parameter K = 32,
     localparam M = 8)
   ( input wire [K+2*M-1:0]  x,
     input wire [K-1:0]  d,
     output wire [2*M-1:0] q,
     output wire [K-1:0] r);
     
     wire [K-1:0] xh1;
     wire [M-1:0] xh2;
     wire [M-1:0] xl;
     wire [K-1:0] rh;
     wire [K-1:0] rl;
     wire [M-1:0] qh;
     wire [M-1:0] ql; 
     //wire [K+M-1:0] rh_xl;
     assign xh1 = x[K+2*M-1:2*M];
     assign xh2 = x[2*M-1:M];
     assign xl = x[M-1:0];
     
     div8 #(32) u1({xh1,xh2}, d, qh, rh);
     
     div8 #(32) u2({rh,xl}, d ,ql, rl);
     
     assign q = {qh, ql};
     assign r = rl;
endmodule

module div32
#( parameter K = 32 )

   ( input wire [K+31:0] x,

     input wire [K-1:0] d,

     output wire [K-1:0] q,

     output wire [K-1:0] r);
     wire clk;
     wire rstn;
     wire [32-1:0] xh1;
     wire [16-1:0] xh2;
     wire [16-1:0] xl;
     wire [K-1:0] rh;
     wire [K-1:0] rl;
     wire [16-1:0] qh;
     wire [16-1:0] ql; 
     //wire [K+16-1:0] rh_xl;
     reg [16-1:0] qh_reg;
     reg [16-1:0] ql_reg;
     reg [32-1:0] r_reg;
     //reg [16-1:0] d_reg;
     assign xh1 = x[K+2*16-1:2*16];
     assign xh2 = x[2*16-1:16];
     assign xl = x[15:0];
     
     div16 #(32) u1({xh1,xh2}, d, qh, rh);
     div16 #(32) u2({rh,xl}, d, ql, rl);
     
     always @(posedge clk) begin 
        if (~rstn) begin 
            qh_reg <= 16'b0000000000000000;
            ql_reg <= 16'b0000000000000000;
            r_reg <= 32'b00000000000000000000000000000000;
            //d_reg <= 0;
        end else begin
            qh_reg <= qh;
            ql_reg <= ql;
            r_reg <= rl;
            //d_reg <= d;
        end
      end

     
     assign q = {qh_reg, ql_reg};
     assign r = r_reg;


endmodule // div32

`default_nettype wire


