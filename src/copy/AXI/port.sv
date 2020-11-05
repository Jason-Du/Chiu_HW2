input        [  `AXI_ID_BITS-1:0] AWID_M1;
	input        [`AXI_ADDR_BITS-1:0] AWADDR_M1;
	input        [ `AXI_LEN_BITS-1:0] AWLEN_M1;
	input        [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
	input        [               1:0] AWBURST_M1;
	input                             AWVALID_M1;
	//WRITE DATA
	input        [`AXI_DATA_BITS-1:0] WDATA_M1;
	input        [`AXI_STRB_BITS-1:0] WSTRB_M1;
	input                             WLAST_M1;
	input                             WVALID_M1;
	//WRITE RESPONSE
	input                             BREADY_M1;
	
	
	
	
	//WRITE DATA

	
	//MASTER INTERFACE FOR SLAVES
	
	input                             WREADY_S1;
	//WRITE ADDRESS1
	input                             AWREADY_S1;
	//WRITE RESPONSE1
	input        [ `AXI_IDS_BITS-1:0] BID_S1;
	input        [               1:0] BRESP_S1;
	input                             BVALID_S1;
	
	
	input                             WREADY_S0;
	//WRITE ADDRESS0
	input                             AWREADY_S0;
	//WRITE RESPONSE0
	input        [ `AXI_IDS_BITS-1:0] BID_S0;
	input        [               1:0] BRESP_S0;
	input                             BVALID_S0;
	
	
	
	
	
	output logic                      WREADY_M1;
	//WRITE ADDRESS
	output logic                      AWREADY_M1;
	//WRITE RESPONSE
	output logic [  `AXI_ID_BITS-1:0] BID_M1;
	output logic [               1:0] BRESP_M1;
	output logic                      BVALID_M1;
	
		//WRITE ADDRESS0
		
	output logic [ `AXI_IDS_BITS-1:0] AWID_S0;
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0;
	output logic [ `AXI_LEN_BITS-1:0] AWLEN_S0;
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0;
	output logic [               1:0] AWBURST_S0;
	output logic                      AWVALID_S0;
	
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S0;
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0;
	output logic                      WLAST_S0;
	output logic                      WVALID_S0;
	//WRITE RESPONSE0
	output logic                      BREADY_S0;
	//WRITE DATA0
	//WRITE ADDRESS1
	output logic [ `AXI_IDS_BITS-1:0] AWID_S1;
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1;
	output logic [ `AXI_LEN_BITS-1:0] AWLEN_S1;
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1;
	output logic [               1:0] AWBURST_S1;
	output logic                      AWVALID_S1;
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1;
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1;
	output logic                      WLAST_S1;
	output logic                      WVALID_S1;
	//WRITE RESPONSE1
	output logic                      BREADY_S1;
	//WRITE DATA1
	