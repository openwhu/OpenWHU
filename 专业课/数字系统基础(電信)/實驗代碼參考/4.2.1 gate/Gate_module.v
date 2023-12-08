module Gate_module
(
	Gate_In, Gate_Out
);

	 input [1:0]Gate_In;
	 output reg [5:0]Gate_Out;	 
 
	always @ ( Gate_In[0] or Gate_In[1] ) 
		begin 
			Gate_Out[0] = Gate_In[0] & Gate_In[1];
			Gate_Out[1] = ~ (Gate_In[0] & Gate_In[1]);
			Gate_Out[2] = Gate_In[0] | Gate_In[1];
			Gate_Out[3] = ~ (Gate_In[0] | Gate_In[1]);
			Gate_Out[4] = Gate_In[0] ^ Gate_In[1];
			Gate_Out[5] = Gate_In[0] ~^ Gate_In[1];
		 end
		 
endmodule