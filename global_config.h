//定义有可能变化的参数
`ifndef __GLOBAL_CONFIG_HEADER__
    `define __GLOBAL_CONFIG_HEADER__
    
    `define  RESET_EDGE   negedge   //以实际为准，这里设为下降沿复位
    `define  RESET_ENABLE   1'b0    //复位有效  
    `define  RESET_DISABLE  1'b1    //复位无效 
    `define  MEM_ENABLE     1'b0    //内存有效 
    `define  MEM_DISABLE    1'b1    //内存无效 


`endif