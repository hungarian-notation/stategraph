  
  # This file defines:
  #
  # sg_join(delim, ...)
  #
  #   Joins any number of arguments with the specified delimiter. The arguments
  #   are not themselves expanded until the very end of the algorithm when they
  #   are expanded once in sequence.  
  #
  # sg_unquote(...)
  #
  #   Removes one level of quoting from one or more arguments.
  
  m4_define(<|sg_unquote|>, $*)  
  
  m4_define(<|sg_shift3|>, <|m4_shift(m4_shift(m4_shift($@)))|>)
  
  # Selects from the three alternatives based on the number of arguments.
  m4_define(<|sg_join_impl_for|>, 
    <|sg_join_impl_<||>|><|m4_eval(<| ((($1) > 2) * 1) + ((($1) == 2) * 2) |>)|>)
  
  # The null case: when the number of arguments is less than 2
  m4_define(<|sg_join_impl_0|>,) 
  
  # The general case, for when argc is > 2
  m4_define(<|sg_join_impl_1|>,     
    <|sg_unquote(<|<|$3|>|><|<|$2|>|>sg_join_impl_for(<|$1-1|>)(m4_eval(<|$1-1|>), <|<|$2|>|>, <|sg_shift3($@)|>))|>)
 
  # The terminal case, for when argc == 2 (delimiter + last value)
  m4_define(<|sg_join_impl_2|>,
    <|<|$3|>|>)    
  
  m4_define(<|sg_join|>, <|sg_unquote(sg_unquote(sg_join_impl_for($#)($#, <|$@|>)))|>)  
