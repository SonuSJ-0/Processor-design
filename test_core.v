module test_core();

reg clk, reset,interrupt;
reg[2:0] count,rand;

integer i;

core_top #(.PMA_SIZE(16), .PMD_SIZE(32), .DMA_SIZE(16), .DMD_SIZE(16), .RF_DATASIZE(16), .ADDRESS_WIDTH(4), .SIGNAL_WIDTH(3), .PM_LOCATE("C:/Users/Dell/Desktop/Arundhathy-files/Processor-design/memory_files/pm_file.txt"), .DM_LOCATE("C:/Users/Dell/Desktop/Arundhathy-files/Processor-design/memory_files/dm_file.txt"))
	core_obj	(
				clk,
				reset,
				interrupt
			);

initial 
begin
	clk=1;
	forever begin #5 clk=~clk; end
end
	
initial
begin
	reset=1;
	#1 reset=0;
	#2 reset=1;
end

always@(posedge clk or negedge reset) begin
	if(!reset) begin
		interrupt<=1'b0;
		count<=3'b0;
	end else begin
		rand<=$urandom_range(0,7);
		if(count==3'b0) begin
			count<=rand;
			if(core_obj.ps_obj.ps_idle)
				interrupt<=1'b1;
		end else begin
			interrupt<=1'b0;
		end
		if(core_obj.ps_obj.ps_idle) begin
			count<=count-3'b1;
		end
	end
end

always@(*) begin
	if(core_obj.mem_obj.pm_ps_op[31:22]==10'b1) begin
		#50;
		//////$system("python C:/Users/Dell/Desktop/Arundhathy-files/Processor-design/Processor-design/a_test_script.py");                          
		//Command to run a_test_script.py - Update its location if neccessary
		#50;
		$stop;
	end

	if(core_obj.ps_obj.ps_stcky[2]) begin
		for(i=0;i<100;i=i+1) begin
			$write("/");
		end
		$write("\n");
		$display("ERROR: PCSTCK OVERFLOW. RESET REQUIRED");
		for(i=0;i<100;i=i+1) begin
			$write("/");
		end
		$write("\n");
		$stop;
	end
end

endmodule
