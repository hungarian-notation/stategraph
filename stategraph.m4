m4_divert(-1)

m4_changequote(`<|', `|>')

# Configurable Style Macros

m4_define(<|__sg_style_reference__|>, <|shape=circle     style=filled fillcolor=slategray2|>)
m4_define(<|__sg_style_state__|>,     <|shape=box3d      style=filled fillcolor=snow2|>)
m4_define(<|__sg_style_branch__|>,    <|shape=diamond    style=solid fillcolor=slategray2|>)
m4_define(<|__sg_style_process__|>,   <|shape=rectangle  style=solid |>)

# Graph Setup

m4_define(<|__sg_edgeop__|>,      <|->|>)
m4_define(<|__sg_graph__|>,           <|digraph|>)
m4_define(<|sg_merge_edge|>,      <|n|>)

# This macro creates __sg_next_edge__, __sg_apply_next_edge__, sg_next_edge(...)
# It can be used to define new property accumulators as needed.

m4_define(<|sg_temporary|>, 
  <|m4_define(<|__sg_default_|>|>$1<|<|__|>, |>$2<|)|>
  <|m4_define(<|__sg_next_|>|>$1<|<|__|>, <||>)|>
  <|m4_define(<|__sg_apply_next_|>|>$1<|<|__|>, <|__sg_next_|>|>$1<|<|__|> <|m4_define(<|__sg_next_|>|>$1<|<|__|>, <|__sg_default_|>|>$1<|<|__|>)|>)|>
  <|m4_define(<|sg_next_|>|>$1<|<||>, <|m4_define(<|__sg_next_|>|>$1<|<|__|>, |>|> <|<|__sg_next_$1__|>|> <|<|$|>|><|<|1|>|><|<|)|> )|>)

# More can be added here as needed.

sg_temporary(<|edge|>, <||>)

# These macros form the preamble of a source graph.

m4_define(<|sg_graph|>, <|__sg_graph__|>)

m4_define(<|sg_init|>, <|
  node [fontsize=10];
  edge [fontsize=8 fontname="monospace"];
  forcelabels=true;|>)
  
# Call this macro at the beginning of the file.
  
m4_define(<|sg_begin|>, <|sg_graph { sg_init()|>)

# Call this macro at the end of the file.

m4_define(<|sg_end|>,   <|}|>)
  
# This macro is a reusable macro-factory for node generating macros.
#
# Each node macro will take at least two arguments: a node ID and a label.
#
# Further arguments can be supported by declaring them in the third argument
# passed to *THIS* macro, the result of which will be injected into the nodes
# attributes.
#
# For each node type NODE, the following macros is defined:
# 
#   sg_NODE(id, label, ...) 
#       Writes a node to the output.
#
# For each invocation of sg_NODE(ID, ...), the following macros are defined.
#
#   __sg_classof_ID
#       Returns NODE
#
#   __sg_typeof_ID
#       Returns the second value passed to sg_define_node
#
# For example, if you declare: 
#   sg_process(SAMPLE, "A Sample Process")
#
# The following macros will be defined:
#
#   __sg_classof_SAMPLE = process
#   __sg_typeof_SAMPLE  = __sg_type_state__

m4_define(<|sg_define_node|>, 
  <|m4_define(<|sg_|>|>$1<|<||>, 
    <|m4_define(<|__sg_classof_|>|><|$|><|1|><|<||>, |>|>$1<|<|)m4_define(<|__sg_typeof_|>|><|$|><|1|><|<||>, |>|>$2<|<|)"|><|$|><|1|><|" [$3]|>)|>)
     
# The following macros are utilites to make accessing the reflective macros
# defined by a node factory more expressive.
    
m4_define(<|sg_typeof|>, 
    __sg_typeof_$1)
    
m4_define(<|sg_classof|>, 
    __sg_classof_$1)
    
# NODES ######################################################################## 

sg_define_node(
  <|process|>,   
  <|__sg_type_state__|>,    
  <|__sg_style_process__ label=$2|>)
    
sg_define_node(
  <|reference|>, 
  <|__sg_type_state__|>,    
  <|__sg_style_reference__ fixedsize=true width=0.5 margin="0.1,0.05" label=<<font face="serif"><b>$2</b></font>>|>)
  
sg_define_node(
  <|branch|>,    
  <|__sg_type_branch__|>,   
  <|__sg_style_branch__ margin="0.0,0.0" label="$2" height=1 tooltip="$2"|>)

sg_define_node(
  <|state|>,       
  <|__sg_type_state__|>,      
  <|__sg_style_state__ margin="0.1,0.05" label=
  <<table border="0" cellborder="0" cellpadding="1" cellspacing="1">
    <tr>
      <td cellpadding="3" border="0" colspan="2"><font face="serif"><b>$2</b></font></td>
    </tr>
    $3
  </table>>|>)
  
sg_define_node(
  <|merge|>,       
  
  <|__sg_type_merge__|>,      
  <|label="" shape=point fixedsize=true width=0.005];|>
  <|"$1" __sg_edgeop__ "$2" [__sg_apply_next_edge__ arrowhead=$3 weight=10 len=0|>)
  
# This macro is used inside the third argument of sg_state(...) macros to
# declare key-value attributes for that state.

m4_define(<|sg_attr|>,
  <|<tr>
      <td align="right"><font face="monospace">$1</font>&nbsp;</td>
      <td align="left"><i>$2</i></td>
    </tr>|>)
    
# Use this to define edges between states. The third argument defines the 
# label if present.
    
m4_define(<|sg_edge|>,     
    <|$1 __sg_edgeop__ $2 [__sg_apply_next_edge__ m4_ifelse(sg_typeof($2), __sg_type_merge__, <|arrowhead=none headport=n|> , <||>) m4_ifelse(
      m4_len(<|$3|>), <|0|>,,<|label=$3|>) ];|>)
   
# This macro uses the "next_edge" facility to add a "empty dot" to the tail of
# the next edge, signifying a negated output.

m4_define(<|sg_negate|>, <|sg_next_edge(dir=both arrowtail=odot)|>)
  
m4_define(<|sg_rank|>, <| subgraph { rank=same; $1 } |>)
m4_define(<|sg_chain|>, <| $1 [style=invis]; |>)
  
m4_divert(0)
