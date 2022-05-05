`timescale 1ns/1ns   //单位时间为1ns,时间精度1ns

`include "stddef.h"
`include "global_config.h" 

`include "bus.h"   //包含总线头文件

module bus_arbiter(
     
	  input  wire     clk,     //时钟
      input  wire     reset,   //异步复位 
   
	  input  wire     m0_req_,   //0号总线主控_请求总线
      output reg      m0_grnt_,  //0号总线主控_赋予总线
     
	  input  wire     m1_req_,   //1号总线主控_请求总线
      output reg      m1_grnt_,  //1号总线主控_赋予总线
     
	  input  wire     m2_req_,   //2号总线主控_请求总线
      output reg      m2_grnt_,  //2号总线主控_赋予总线
	  
	  input  wire     m3_req_,   //3号总线主控_请求总线
      output reg      m3_grnt_   //3号总线主控_赋予总线

);

/****内部信号****/
  reg[1:0]     owner;

/****赋予总线使用权****/ 
always @(*) begin
   /****赋予总线使用权的初始化****/ 
	m0_grnt_ = `DISABLE_;
    m1_grnt_ = `DISABLE_;
	m2_grnt_ = `DISABLE_;
	m3_grnt_ = `DISABLE_;
	
   /****赋予总线使用权****/ 
   case(owner)
	    `BUS_OWNER_MASTER_0 : begin
		    m0_grnt_ = `ENABLE_;    
	    end
		 
		 `BUS_OWNER_MASTER_1 : begin
		    m1_grnt_ = `ENABLE_;    
	    end
		 
		 `BUS_OWNER_MASTER_2 : begin
		    m2_grnt_ = `ENABLE_;
		 end 
			 
		 `BUS_OWNER_MASTER_3 : begin
		    m3_grnt_ = `ENABLE_; 
		 end	 
	endcase

 end

 
   /****总线使用权的仲裁****/ 
 
 always @(posedge clk or `RESET_EDGE reset) begin
 
        if(reset==`RESET_ENABLE) begin//异步复位
		    owner <= #1 `BUS_OWNER_MASTER_0;
		end 
        else begin
		   //仲裁
			case(owner)
			`BUS_OWNER_MASTER_0:begin
			    if(m0_req_ == `ENABLE_)begin
                    owner <= #1 `BUS_OWNER_MASTER_0;
			    end 

                else if(m1_req_ == `ENABLE_)begin
			        owner <= #1 `BUS_OWNER_MASTER_1;
			    end 

                else if(m2_req_ == `ENABLE_)begin
			        owner <= #1 `BUS_OWNER_MASTER_2;
			    end 

                else if(m3_req_ == `ENABLE_)begin
			        owner <= #1 `BUS_OWNER_MASTER_3;
		        end
				
            end 
		 
		    `BUS_OWNER_MASTER_1:begin
			    if(m1_req_ == `ENABLE_)begin
				    owner <= #1 `BUS_OWNER_MASTER_1;
				end 

                else if(m2_req_ == `ENABLE_)begin
				    owner <= #1 `BUS_OWNER_MASTER_2;
		   	    end 
                   
                else if(m3_req_ == `ENABLE_)begin
		            owner <= #1 `BUS_OWNER_MASTER_3;
			    end 
                
                else if(m0_req_ == `ENABLE_)begin
			        owner <= #1 `BUS_OWNER_MASTER_0;
				end 
			
			end
			
		    `BUS_OWNER_MASTER_2:begin
			    if(m2_req_ == `ENABLE_)begin
				    owner <= #1 `BUS_OWNER_MASTER_2;
				end 
                
                else if(m3_req_ == `ENABLE_)begin
				    owner <= #1 `BUS_OWNER_MASTER_3;
		   	    end 

                else if(m0_req_ == `ENABLE_)begin
		            owner <= #1 `BUS_OWNER_MASTER_0;
			    end 
                
                else if(m1_req_ == `ENABLE_)begin
			        owner <= #1 `BUS_OWNER_MASTER_1;
				end 
			
			end
			
		    `BUS_OWNER_MASTER_3:begin
			    if(m3_req_ == `ENABLE_)begin
				    owner <= #1 `BUS_OWNER_MASTER_3;
				end 
                
                else if(m0_req_ == `ENABLE_)begin
				    owner <= #1 `BUS_OWNER_MASTER_0;
		   	    end 
                   
                else if(m1_req_ == `ENABLE_)begin
		            owner <= #1 `BUS_OWNER_MASTER_1;
			    end 

                else if(m2_req_ == `ENABLE_)begin
			        owner <= #1 `BUS_OWNER_MASTER_2;
				end 
			
			end
	  endcase
	end	
end 

endmodule


