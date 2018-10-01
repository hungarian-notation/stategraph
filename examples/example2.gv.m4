m4_define(<|__sg_style_redhouse__|>, <|shape=house style=filled fillcolor=red|>)

sg_define_class(<|redhouse|>,,<|label="This is the \N house!" sg_optional($3,, height=",") sg_optional($4,, fillcolor=",")|>)

sg_begin()
  dpi = 72;  

  ordering=out;

  sg_redhouse(A)
  sg_redhouse(B,,,yellow)
  sg_redhouse(C)
  sg_redhouse(D,,1)
  sg_redhouse(E,,2)
  sg_redhouse(F)
  sg_redhouse(G,,,green)
  sg_redhouse(H)
  sg_redhouse(I,,1.5)  
  
  sg_anchor(ANCHOR)  
  
  sg_edge(A, C)
  
  sg_edge(A, B)
  sg_edge(A, E)
  sg_edge(B, C)
  
  sg_next_edge(constraint=false tailport=se headport=w)
  sg_edge(C, ANCHOR, "Down and In!")
  sg_next_edge(constraint=false tailport=e headport=sw)
  sg_edge(ANCHOR, I, "Down and In!")

  sg_edge(D, E)
  sg_edge(E, C)
  sg_edge(E, F)  
  
  sg_chain(F->ANCHOR)
  
  sg_next_edge(constraint=false)
  sg_edge(G, A, "Up and Over!")
  
  sg_edge(G, E)
  sg_edge(G, H)
  sg_edge(H, I)
  
  sg_next_edge(constraint=false)
  sg_edge(I,E, "Backwards!")
  sg_next_edge(constraint=false)
  sg_edge(I,G, "Still Backwards!")
  
  
  
sg_end()
