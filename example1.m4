m4_include(`stategraph.m4')

sg_begin()


  { 
    rank=min; 
    sg_reference(START, Start)
  }
  
  sg_reference(END, End)  
  
  sg_reference(ANY_RESET, Any) 
  
  sg_reference(ANY_INVALIDATE, Any)   
  
  sg_reference(ANY_END, Any) 
  
  sg_process(FREE_PROCESS, "FreeHandle() releases any resources and\nfrees the memory used by\nthe handle on the heap.")
  
  sg_reference(ERR_IO, Error)
  
  sg_reference(ERR_IO, Error)
      
  sg_state(RESET, Reset, 
    sg_attr(GetPath, "")
    sg_attr(GetName, "")
    sg_attr(CheckError, 0))  
    
  sg_process(RESET_1, "Allocate a new handle\non the heap.")
  
  sg_process(RESET_2, "Reset the handle's state.")
  
  sg_process(PREPARE_PROCESS, 
    "Define the handle's path either from\nan integer index or an explicit path.")
  
  sg_state(PREPARED_INDEX, Prepared (From Index), 
    sg_attr(GetPath, "/dev/hidraw{N}")  
    sg_attr(GetName, "")
    sg_attr(CheckError, 0))
    
  sg_state(PREPARED_PATH, Prepared (From Path), 
    sg_attr(GetPath, "{PATH}")  
    sg_attr(GetName, "")
    sg_attr(CheckError, 0))
  
  sg_process(OPEN_PROCESS, "Attempt to open the device\nat the specified path.")
  
  sg_process(REOPEN_PROCESS, "Using the same path…")
  
  sg_process(REUSE_PREPARE, "Reuse the handle and\nspecify a new path.")
  
  sg_branch(TRY_OPEN, CheckAccess(H, W_OK) = ?)   
  
  sg_state(OPEN, Open, 
    sg_attr(IsOpen,      true)
    sg_attr(GetPath,     unchanged)
    sg_attr(GetName,     HID … NAME)
    sg_attr(GetVendor,   HID … INFO-&gt;vendor)
    sg_attr(GetProduct,  HID … INFO-&gt;product)
    sg_attr(CheckError,  = 0))  
        
  sg_state(CLOSED, Closed,
    sg_attr(IsOpen,      false)
    sg_attr(GetPath,     unchanged)
    sg_attr(GetName,     unchanged)
    sg_attr(GetVendor,   unchanged)
    sg_attr(GetProduct,  unchanged)
    sg_attr(CheckError,  = 0 (always)))  
    
  sg_state(INVALIDATED, Invalidated, 
    sg_attr(GetPath, "")
    sg_attr(GetName, "")
    sg_attr(CheckError, unchanged))   
  
  sg_branch(WRITE_BRANCH, Write succeded?)
  
  # RANKINGS
  
  sg_rank(START; ANY_RESET; ANY_INVALIDATE; ANY_END;)
  
  sg_rank(sg_chain(RESET_1->RESET->RESET_2->INVALIDATED))
  
  sg_rank(sg_chain(PREPARE_PROCESS->REUSE_PREPARE))
  
  sg_rank(sg_chain(PREPARED_PATH->PREPARED_INDEX))
  
  sg_rank(sg_chain(OPEN_PROCESS->REOPEN_PROCESS) FREE_PROCESS)
  
  sg_rank(sg_chain(TRY_OPEN->OPEN->CLOSED))
  
  sg_rank(nodesep=10; sg_chain(ERR_IO->WRITE_BRANCH) END; rank=sink;)
  
  # BRANCH CHOICES 
  
  sg_next_edge(tailport=se)
    sg_edge(TRY_OPEN, OPEN, "ok")  
  sg_negate() sg_next_edge(tailport=sw weight=10)
    sg_edge(TRY_OPEN, ERR_IO, "not ok")
  
  sg_next_edge(constrain=false tailport=e headport=se)
    sg_edge(WRITE_BRANCH, OPEN, "yes")      
  sg_negate()
    sg_edge(WRITE_BRANCH, ERR_IO, "no")
  
  sg_edge(START, RESET_1, "AllocateHandle()")   
  sg_edge(RESET_1, RESET)
  
  sg_edge(RESET_2, RESET)
  sg_edge(RESET, PREPARE_PROCESS, "PrepareFromIndex(int)\nPrepareFromPath(const char*)")
  sg_edge(PREPARE_PROCESS, PREPARED_PATH)  
  sg_edge(PREPARE_PROCESS, PREPARED_INDEX)
    
  # Opening
  
  sg_next_edge(headport=n)
  sg_edge(PREPARED_PATH, OPEN_PROCESS, "Open()") 
  sg_next_edge(headport=ne)
  sg_edge(PREPARED_INDEX, OPEN_PROCESS, "Open()")  
  
  sg_next_edge(tailport=w headport=n)
  sg_edge(OPEN_PROCESS, TRY_OPEN)
  
  sg_next_edge(tailport=w headport=e)
  sg_edge(REOPEN_PROCESS, OPEN_PROCESS)
  
  sg_edge(OPEN, WRITE_BRANCH, "WriteFeature(...)\nWriteOutput(...)")  
    
  # Closing and Reuse
  
  
  sg_edge(OPEN, CLOSED, "Close()")
  
  
  sg_next_edge(constrain=false)
  sg_edge(CLOSED, REOPEN_PROCESS, "Open()")
  
  sg_next_edge(constrain=false)
  sg_edge(CLOSED, REUSE_PREPARE, "PrepareFromIndex(int)\nPrepareFromPath(const char*)")
  
  sg_next_edge(constrain=false)
  sg_edge(REUSE_PREPARE, PREPARE_PROCESS)
  
  # Invalidate VS Reset
  
  sg_edge(ANY_INVALIDATE, INVALIDATED, "Invalidate()")    
  sg_edge(ANY_RESET, RESET_2, "Reset()")    
  sg_edge(INVALIDATED, RESET_2, "Reset()")  
  
  # Freeing the Handle
  
  sg_edge(ANY_END, FREE_PROCESS, "FreeHandle()")  
  sg_edge(FREE_PROCESS, END)  
  
sg_end()
