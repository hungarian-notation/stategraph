sg_begin()
  dpi = 72;    
  
  sg_reference(A1,A1)
  sg_reference(A2,A2)
  sg_reference(A3,A3)
  sg_reference(A4,A4)
  sg_reference(A5,A5)
  sg_reference(A6,A6)
  sg_reference(A7,A7)
  sg_reference(A8,A8)
  sg_reference(A9,A9)
  
  sg_reference(B1,B1)
  sg_reference(B2,B2)
  sg_reference(B3,B3)
  sg_reference(B4,B4)
  sg_reference(B5,B5)
  sg_reference(B6,B6)
  sg_reference(B7,B7)
  sg_reference(B8,B8)
  sg_reference(B9,B9)
  
  //# Use sg_chain and sg_rank to constrain layout.
  
  sg_chain(A1,A2,A3)
  sg_chain(A4,A5,A6)
  sg_chain(A7,A8,A9)
  
  sg_rank(sg_chain(A1,A4,A7))
  
  sg_chain(B1,B2,B3)
  sg_chain(B4,B5,B6)
  sg_chain(B7,B8,B9)
  
  sg_rank(sg_chain(B1,B5,B9))  
  sg_rank(sg_chain(A7,B3))  
sg_end()
