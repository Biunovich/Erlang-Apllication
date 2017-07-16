-module(sum).

-export([add5/2, add5/1]).

add5( 0 ) ->
  5;
add5( A ) ->
  A1 = A + 1,
  A2 = A1 + 2,
  A3 = A2 + 2.
%  A + 5;


add5( A, B) ->
  A + B.
