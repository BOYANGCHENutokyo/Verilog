`timescale 1ns / 1ps
`default_nettype none

module test_divider #(parameter integer K = 32) ();
   logic [K+31:0] xi;
   logic [K-1:0]  di;
   wire [K+31:0]  x;
   wire [K-1:0]   d;
   wire [K-1:0]   r;
   wire [K-1:0]   q;

   integer        i;
   integer        j;
   logic [K-1:0]  th;
   logic [31:0]   tl;

   assign x = xi;
   assign d = di;
  
   div32 udiv32(x,d,q,r);

   initial begin
      $dumpfile("test_divider.vcd");
      $dumpvars(0);

      $display("start of checking module div32");

      for (i=0;i<100;i++) begin
         #1;
         di = 0;
         th = 0;
         tl = $urandom();
         xi = {th,tl};
         #1;
         if (di != 0) begin
            if (q !== xi/di) $display("q %d %d %d %d", xi,di,q, xi/di);
            if (r !== xi%di) $display("r %d %d %d %d", xi,di,r, xi%di);
         end else begin
            if (q !== '1) $display("q %d %d %d %d", xi,di,q, xi/di);
            if (r !== xi) $display("r %d %d %d %d", xi,di,r, xi%di);
         end
      end

      for (i=0;i<1000;i++) begin
         for (j=0;j<K-7;j++) begin
            #1;
            di = $urandom()>>j;
            th = (di==0)?('0):($urandom()%di);
            tl = $urandom();
            xi = {th,tl};
            #1;
            if (di != 0) begin
               if (q !== xi/di) $display("q %d %d %d %d", xi,di,q, xi/di);
               if (r !== xi%di) $display("r %d %d %d %d", xi,di,r, xi%di);
            end else begin
               if (q !== '1) $display("q %d %d %d %d", xi,di,q, xi/di);
               if (r !== xi) $display("r %d %d %d %d", xi,di,r, xi%di);
            end
         end
      end

      $display("end of checking module div32");
      $finish;
   end
endmodule

`default_nettype wire
