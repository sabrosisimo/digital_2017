`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:28:56 07/04/2017 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALU(
    input  [3:0] a,
    input  [3:0] b,
    output  [7:0] c,
    input  [2:0] oc,
	 input  cry_in,
    output  cry,
    output  brr,
    output  zro,
    output  neg,
    output  arith,
    output  eq,
    output  gtr,
    output  min);
	 
	
reg [7:0] wire_c;
reg [3:0] reg_b;
wire [3:0] w_adder_suma;
wire wire_cry;
reg reg_cry;
reg [7:0] logic_out=0;
reg reg_zro=0;
reg reg_brr=0;
reg reg_neg=0;
reg reg_arith=0;
reg reg_eq=0;
reg reg_gtr=0;
reg reg_min=0;
reg [7:0] reg_neg_a;
reg [8:0] reg_mul;

always @ *
begin 
   //reg_mul<=0;
	wire_c <= c;
	logic_out[3:0]<=0;
	reg_neg_a<=a;
	reg_b<=b;

	case (oc) 
	///////////////////////////////////////////////
	//    negar A si el opcode es 0              //
	///////////////////////////////////////////////
			0: logic_out[3:0] <= ~a;
	///////////////////////////////////////////////
	//    A&B     si el opcode es 1              //
	///////////////////////////////////////////////		
			1: logic_out[3:0] <= a&b;
	///////////////////////////////////////////////
	//    A|B     si el opcode es 2              //
	///////////////////////////////////////////////		
			2: logic_out[3:0] <= a|b;
	///////////////////////////////////////////////
	//    A^B     si el opcode es 3              //
	///////////////////////////////////////////////			
			3: logic_out[3:0] <= a^b;
	///////////////////////////////////////////////
	//    A+B desde modulo si el opcode es 4     //
	///////////////////////////////////////////////
			4: logic_out[3:0] <= 0;
	///////////////////////////////////////////////
	// comp a 2 de b para resta si el opcode es 5//
	///////////////////////////////////////////////		
			5: case (b)
					0: reg_b <= 0;
					1: reg_b <= 15; 
					2: reg_b <= 14;
					3: reg_b <= 13;
					4: reg_b <= 12;
					5: reg_b <= 11;
					6: reg_b <= 10;
					7: reg_b <= 9;
					8: reg_b <= 0;
					9: reg_b <= 7;
					10: reg_b <= 6;
					11: reg_b <= 5;
					12: reg_b <= 4;
					13: reg_b <= 3;
					14: reg_b <= 2;
					15: reg_b <= 1;
				endcase
	///////////////////////////////////////////////
	//     cambio de signo A si el opcode es 6   //
	///////////////////////////////////////////////	
			6: case (a)
					0: reg_neg_a <= 0;
					1: reg_neg_a <= 15; 
					2: reg_neg_a <= 14;
					3: reg_neg_a <= 13;
					4: reg_neg_a <= 12;
					5: reg_neg_a <= 11;
					6: reg_neg_a <= 10;
					7: reg_neg_a <= 9;
					8: reg_neg_a <= 0;
					9: reg_neg_a <= 7;
					10: reg_neg_a <= 6;
					11: reg_neg_a <= 5;
					12: reg_neg_a <= 4;
					13: reg_neg_a <= 3;
					14: reg_neg_a <= 2;
					15: reg_neg_a <= 1;
				endcase
	///////////////////////////////////////////////
	//     A*B               si el opcode es 7   //
	///////////////////////////////////////////////
			7: reg_mul <= a*b;
			default: begin
				reg_mul<=0;
				logic_out<=0;
						end
	endcase
	
	

///////////////////////////////////////////////
// logica de banderas                        //
///////////////////////////////////////////////	

///////////////////////////////////////////////
// Bandera resultado igual a cero            //
///////////////////////////////////////////////	
if (wire_c==0 && (oc == 1 || oc==2 || oc==3 || oc==6 || oc==7 || oc==0))
	reg_zro<=1;
else if (wire_c[2:0]==0 && (oc == 4 || oc==5))
   reg_zro<=1;
else
	reg_zro<=0;

///////////////////////////////////////////////
// Bandera resultado negativo                //
///////////////////////////////////////////////	
if (wire_c[3]==1 && reg_arith==1)
	reg_neg<=1;
else
	reg_neg<=0;

///////////////////////////////////////////////
// Bandera aritmetica                        //
///////////////////////////////////////////////	
if (oc==4 || oc==5 || oc==6 || oc==7)
	reg_arith<=1;
else
	reg_arith<=0;

///////////////////////////////////////////////
// Bandera de a=b                            //
///////////////////////////////////////////////	
if (a==b)
	reg_eq<=1;
else
	reg_eq<=0;
	
///////////////////////////////////////////////
// Bandera a mayor que b                     //
///////////////////////////////////////////////	
if (a > b)
	reg_gtr<=1;
else
	reg_gtr<=0;
	
///////////////////////////////////////////////
// Bandera a menor que b                     //
///////////////////////////////////////////////	
if (a < b)
	reg_min<=1;
else
	reg_min<=0;

///////////////////////////////////////////////
// Bandera borrow                            //
///////////////////////////////////////////////	
if (oc==5 && wire_cry==1)
	reg_brr<=1;
else
	reg_brr<=0;

///////////////////////////////////////////////
// Bandera carry                             //
///////////////////////////////////////////////	
if ((oc==4 && wire_cry==1) || reg_mul[8] == 1)
	reg_cry<=1;
else
	reg_cry<=0;

end
	
	assign cry = reg_cry;
	assign brr = reg_brr;
	assign zro = reg_zro;
	assign neg = reg_neg;
	assign arith = reg_arith;
	assign eq = reg_eq;
	assign gtr = reg_gtr;
	assign min = reg_min;
  
	sumador4bit sum_i0 (.a(a), .b(reg_b), .suma(w_adder_suma), .carry_in(cry_in), .carry_out(wire_cry));
	mul8a1 mul_i0 (.in0(logic_out), .in1(logic_out), .in2(logic_out), .in3(logic_out), .in4({0,0,0,wire_cry,w_adder_suma}), .in5({0,0,0,wire_cry,w_adder_suma}), .in6(reg_neg_a), .in7(reg_mul[7:0]), .out(c), .sel(oc));


endmodule