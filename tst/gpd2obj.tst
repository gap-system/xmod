#############################################################################
##
#W  gpd2obj.tst                   XMOD test file                Chris Wensley
##
#Y  Copyright (C) 2001-2017, Chris Wensley et al, 
#Y  School of Computer Science, Bangor University, U.K. 
##
gap> START_TEST( "XMod package: gpd2obj.tst" );
gap> saved_infolevel_xmod := InfoLevel( InfoXMod );; 
gap> SetInfoLevel( InfoXMod, 0 );;
gap> saved_infolevel_groupoids := InfoLevel( InfoGroupoids );; 
gap> SetInfoLevel( InfoGroupoids, 0 );;

## Chapter 9

## Subsection 9.1.1 
gap> s4 := Group( (1,2,3,4), (3,4) );; 
gap> SetName( s4, "s4" );
gap> a4 := Subgroup( s4, [ (1,2,3), (2,3,4) ] );;
gap> SetName( a4, "a4" );
gap> X4 := XModByNormalSubgroup( s4, a4 );; 
gap> DX4 := SinglePiecePreXModWithObjects( X4, [-9,-8,-7], false );
precrossed module with source groupoid:
single piece groupoid: < a4, [ -9, -8, -7 ] >
and range groupoid:
single piece groupoid: < s4, [ -9, -8, -7 ] >
gap> Ga4 := Source( DX4 );; 
gap> Gs4 := Range( DX4 );;

## Subsection 9.1.2 
gap> IsXModWithObjects( DX4 ); 
true
gap> KnownPropertiesOfObject( DX4 ); 
[ "CanEasilyCompareElements", "CanEasilySortElements", "IsDuplicateFree", 
  "IsGeneratorsOfSemigroup", "IsSinglePieceDomain", 
  "IsDirectProductWithCompleteDigraphDomain", "IsPreXModWithObjects", 
  "IsXModWithObjects" ]

## Subsection 9.1.3 
gap> IsPermPreXModWithObjects( DX4 );
true
gap> IsPcPreXModWithObjects( DX4 );  
false
gap> IsFpPreXModWithObjects( DX4 );
false

## Subsection 9.1.4 
gap> KnownAttributesOfObject(DX4);
[ "Range", "Source", "Boundary", "ObjectList", "XModAction", "Root2dGroup" ]
gap> Root2dGroup( DX4 ); 
[a4->s4]
gap> act := XModAction( DX4 );; 
gap> r := Arrow( Gs4, (1,2,3,4), -7, -8 );; 
gap> ImageElm( act, r );            
[groupoid homomorphism : 
[ [ [(1,2,3) : -9 -> -9], [(2,3,4) : -9 -> -9], [() : -9 -> -8], 
      [() : -9 -> -7] ], 
  [ [(2,3,4) : -9 -> -9], [(1,3,4) : -9 -> -9], [() : -9 -> -7], 
      [() : -9 -> -8] ] ] : 0 -> 0]
gap> s := Arrow( Ga4, (1,2,4), -8, -8 );;
gap> ##  calculate s^r 
gap> ims := ImageElmXModAction( DX4, s, r );
[(1,2,3) : -7 -> -7]

gap> SetInfoLevel( InfoXMod, saved_infolevel_xmod );; 
gap> SetInfoLevel( InfoGroupoids, saved_infolevel_groupoids );; 
gap> STOP_TEST( "gpd2obj.tst", 10000 );

#############################################################################
##
#E  gpd2obj.tst . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
