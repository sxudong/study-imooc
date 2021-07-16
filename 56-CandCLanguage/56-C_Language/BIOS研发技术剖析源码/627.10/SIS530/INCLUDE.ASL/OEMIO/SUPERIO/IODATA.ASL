//////////////////////////////////////////////////////////////////
// Generic devices Current Resources Buffers /////////////////////
//////////////////////////////////////////////////////////////////

// FDC Current Resource Settings (to be returned by _CRS)
	Name(FCRS, ResourceTemplate() {
		IO(Decode16, 0x3f2, 0x3f2, 1, 2, FCP1)
		IO(Decode16, 0x3f4, 0x3f4, 1, 2, FCP2)
		IO(Decode16, 0x3f7, 0x3f7, 1, 1, FCP3)
		IRQNoFlags(FCI1) {6}
		DMA(Compatibility, NotBusMaster, Transfer8, FCD1) {2}
	})

// Ports (COMx and LPT) Current Resource Settings
// (to be initialized and returned by _CRSreturned by COMx._CRS/LPT._CRS)
	Name(PBUF, ResourceTemplate() {
		IO(Decode16, 0, 0, 1, 8, PBP1)
		IRQNoFlags(PBI1) {0}
	})

// ECP DEVICE Current Resource Settings
	Name(EBUF, ResourceTemplate() {
		IO(Decode16, 0x378, 0x378, 1, 8, EBP1)
		IO(Decode16, 0x778, 0x778, 1, 4, EBP2)
		IRQNoFlags(EBI1) {7}
		DMA(Compatibility, NotBusMaster, Transfer8, EBD1) {}
	})

//////////////////////////////////////////////////////////////////
// Generic devices Possible Resources Buffers ////////////////////
//////////////////////////////////////////////////////////////////

// FDC Possible Resources
	Name(FPRS, ResourceTemplate() {
		StartDependentFn(0, 0) {
			IO(Decode16, 0x3f2, 0x3f2, 1, 2)
			IO(Decode16, 0x3f4, 0x3f4, 1, 2)
			IO(Decode16, 0x3f7, 0x3f7, 1, 1)
			IRQNoFlags() {6}
			DMA(Compatibility, NotBusMaster, Transfer8) {2}
		}
		EndDependentFn()
	})

// UART1 Possible Resources
	Name(C1PR, ResourceTemplate() {
		StartDependentFn(0, 0) {
			IO(Decode16, 0x3f8, 0x3f8, 4, 8)
			IRQNoFlags() {4}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x3f8, 0x3f8, 4, 8)
			IRQNoFlags() {3,4,10,11}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x2f8, 0x2f8, 4, 8)
			IRQNoFlags() {3,4,10,11}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x3e8, 0x3e8, 4, 8)
			IRQNoFlags() {3,4,10,11}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x2e8, 0x2e8, 4, 8)
			IRQNoFlags() {3,4,10,11}
		}
		EndDependentFn()
	})

// UART2 Possible Resources
	Name(C2PR, ResourceTemplate() {
		StartDependentFn(0, 0) {
			IO(Decode16, 0x2f8, 0x2f8, 4, 8)
			IRQNoFlags() {3}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x2f8, 0x2f8, 4, 8)
			IRQNoFlags() {3,4,10,11}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x3f8, 0x3f8, 4, 8)
			IRQNoFlags() {3,4,10,11}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x3e8, 0x3e8, 4, 8)
			IRQNoFlags() {3,4,10,11}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x2e8, 0x2e8, 4, 8)
			IRQNoFlags() {3,4,10,11}
		}
		EndDependentFn()
	})

// LPT Possible Resources
	Name(LPPR, ResourceTemplate() {
		StartDependentFn(0, 0) {
			IO(Decode16, 0x378, 0x378, 1, 8)
			IRQNoFlags() {7}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x378, 0x378, 1, 8)
			IRQNoFlags() {5, 7}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x278, 0x278, 1, 8)
			IRQNoFlags() {5, 7}
		}
		StartDependentFnNoPri() {
			IO(Decode16, 0x3bc, 0x3bc, 1, 4)
			IRQNoFlags() {5, 7}
		}
		EndDependentFn()
	})

// ECP Possible Resources
	Name(EPRS, ResourceTemplate() {
		StartDependentFn(0, 0) {
			IO(Decode16, 0x378, 0x378, 1, 8)
			IO(Decode16, 0x778, 0x778, 1, 4)
			IRQNoFlags() {7}
			DMA(Compatibility, NotBusMaster, Transfer8) {1}
			}
		StartDependentFnNoPri() {
			IO(Decode16, 0x378, 0x378, 1, 8)
			IO(Decode16, 0x778, 0x778, 1, 4)
			IRQNoFlags() {5, 7}
			DMA(Compatibility, NotBusMaster, Transfer8) {0, 1, 3}
			}
		StartDependentFnNoPri() {
			IO(Decode16, 0x278, 0x278, 1, 8)
			IO(Decode16, 0x678, 0x678, 1, 4)
			IRQNoFlags() {5, 7}
			DMA(Compatibility, NotBusMaster, Transfer8) {0, 1, 3}
			}
		StartDependentFnNoPri() {
			IO(Decode16, 0x3bc, 0x3bc, 1, 4)
			IO(Decode16, 0x7bc, 0x7bc, 1, 4)
			IRQNoFlags() {5, 7}
			DMA(Compatibility, NotBusMaster, Transfer8) {0, 1, 3}
		}
// No DMA
		StartDependentFnNoPri() {
			IO(Decode16, 0x378, 0x378, 1, 8)
			IO(Decode16, 0x778, 0x778, 1, 4)
			IRQNoFlags() {5, 7}
			DMA(Compatibility, NotBusMaster, Transfer8) {}
			}
		StartDependentFnNoPri() {
			IO(Decode16, 0x278, 0x278, 1, 8)
			IO(Decode16, 0x678, 0x678, 1, 4)
			IRQNoFlags() {5, 7}
			DMA(Compatibility, NotBusMaster, Transfer8) {}
			}
		StartDependentFnNoPri() {
			IO(Decode16, 0x3bc, 0x3bc, 1, 4)
			IO(Decode16, 0x7bc, 0x7bc, 1, 4)
			IRQNoFlags() {5, 7}
			DMA(Compatibility, NotBusMaster, Transfer8) {}
		}
		EndDependentFn()
	})
