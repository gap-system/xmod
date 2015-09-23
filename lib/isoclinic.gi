#############################################################################
##
#W  isoclinic.gi               GAP4 package `XMod'                Alper Odabas
#W                                                               & Enver Uslu
##  version 2.43, 23/09/2015 
##
#Y  Copyright (C) 2001-2015, Chris Wensley et al 
#Y   
##  This file contains generic methods for finding isoclinism classes 
##  of crossed modules. 
##

#############################################################################
##
#M  PreXModFixedPointSubgroup  . . elements of the range unmoved by the source
##
InstallMethod( PreXModFixedPointSubgroup, "generic method for crossed modules", 
    true, [ IsPreXMod ], 0,
function( XM )

    local  alpha, T, G, t, g, list;

    T := Source(XM);
    G := Range(XM);
    if ( HasIsTrivialAction2dGroup(XM) and IsTrivialAction2dGroup(XM) ) then 
        return T; 
    fi;
    alpha := XModAction(XM);
    list := [];
    for t in T do
        if ForAll( G, g -> Image(Image(alpha,g),t) = t ) then
            Add( list, t );
        fi;        
    od; 
    ##  if the list consist only the identity element then there is a bug 
    ##  in the function AsMagma. 
    if ( Length( Set(list) ) = 1 ) then
        return TrivialSubgroup( T );
    fi;
    return AsGroup(list);
end );
       
#############################################################################
##
#M  PreXModStabilizer .. elements of the range which fix the source pointwise
##
InstallMethod( PreXModStabilizer, "generic method for crossed modules", true, 
    [ IsPreXMod ], 0,
function( XM )

    local alpha, sonuc, T, G, t, g, list;

    T := Source(XM);
    G := Range(XM);
    alpha := XModAction(XM);
    list := [];
    for g in G do
        if ForAll( T, t -> Image(Image(alpha,g),t)=t ) then
            Add( list, g );
        fi;        
    od;
    ##  if the lists consist only the identity element then there is a bug 
    ##  in the function AsMagma. 
    if ( Length( Set(list) ) = 1 ) then
        return TrivialSubgroup( G );
    fi;
    return AsGroup(list);
end );

#############################################################################
##
#M  CentreXMod  . . . . . . . . . the centre of a crossed module
##
InstallMethod( CentreXMod, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function( XM )

    local alpha, T, G, partial, fix, k_partial, k_alpha, PM, K;

    T := Source(XM);
    G := Range(XM);
    alpha := XModAction(XM);
    partial := Boundary(XM);
    K := Intersection( Centre(G), PreXModStabilizer(XM) );
    fix := PreXModFixedPointSubgroup( XM );
    k_partial := GroupHomomorphismByFunction( fix, K, x -> Image(partial,x) );
    k_alpha := GroupHomomorphismByFunction( K, AutomorphismGroup( fix ), 
                   x -> Image( alpha, x ) );
    return XModByBoundaryAndAction( k_partial, k_alpha );
end );

#############################################################################
##
#M  DisplacementSubgroup . . . subgroup of source generated by the (s^r)(s^-1)
##
InstallMethod( DisplacementSubgroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function( XM )

    local  alpha, sonuc, T, G, t, t0, g, list;

    T := Source(XM);
    G := Range(XM);
    alpha := XModAction(XM);
    list := [];
    for t in T do
        for g in G do
            t0 := Image( Image( alpha, g ), t ) * t^-1; 
            if ( Position( list, t0 ) = fail ) then  
                Add( list, t0 );
            fi;
        od;
    od;
    ##  if the list consist only the identity element then there is a bug 
    ##  in the function AsMagma. 
    if ( Length( Set(list) ) = 1 ) then
        return TrivialSubgroup( T );
    fi;
    return AsGroup(list);
end );

#############################################################################
##
#M  IntersectionSubXMod  . . . . intersection of subcrossed modules SH and RK
##
InstallMethod( IntersectionSubXMod, "generic method for crossed modules", 
    true, [ IsXMod, IsXMod, IsXMod ], 0,
function( XM, SH, RK)

    local alpha, T, G, S, H, R, K, partial, k_partial, k_alpha, SR, HK;

    T := Source(XM);
    G := Range(XM);
    alpha := XModAction(XM);
    partial := Boundary(XM);
    S := Source(SH);
    H := Range(SH);
    R := Source(RK);
    K := Range(RK);
    SR := Intersection(S,R);
    HK := Intersection(H,K);
    k_partial := GroupHomomorphismByFunction( SR, HK, x -> Image(partial,x) );
    k_alpha := GroupHomomorphismByFunction( HK, AutomorphismGroup(SR), 
                   x -> Image(alpha,x) );
    return XModByBoundaryAndAction( k_partial, k_alpha );
end );

#############################################################################
##
#M  FactorXMod  . . . . . . . . . . . . . . . . . the quotient crossed module
##
InstallMethod( FactorXMod, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod ], 0,
function( XM, PM )

    local  alpha1, alpha2, partial1, partial2, nhom1, nhom2, T, G, S, H, 
           B1, B2, bdy, act;

    alpha1 := XModAction(XM);
    partial1 := Boundary(XM);
    T := Source(XM);
    G := Range(XM);
    alpha2 := XModAction(PM);
    partial2 := Boundary(PM);
    S := Source(PM);
    H := Range(PM);
    nhom1 := NaturalHomomorphismByNormalSubgroup(T,S);
    nhom2 := NaturalHomomorphismByNormalSubgroup(G,H);
    B1 := Image(nhom1); # T/S bölüm grubu
    B2 := Image(nhom2); # G/H bölüm grubu
    bdy := GroupHomomorphismByFunction( B1, B2, 
             a -> Image( nhom2, 
               Image(partial1,PreImagesRepresentative( nhom1, a ) ) ) );
    act := GroupHomomorphismByFunction( B2, AutomorphismGroup(B1), 
             b -> GroupHomomorphismByFunction( B1, B1, 
               c -> Image( nhom1, 
                   (Image(Image(alpha1,PreImagesRepresentative(nhom2,b)), 
                       PreImagesRepresentative(nhom1,c) ) ) ) ) );
    return XModByBoundaryAndAction( bdy, act );
end );

#############################################################################
##
#M  DerivedSubXMod  . . . . . . . . . . the commutator of the crossed module
##
InstallMethod( DerivedSubXMod, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function(XM)

    local  D, genD, imD, bdy, alpha, PM, dgt, gendgt, imdgt, aut, 
           k_partial, k_alpha; 

    D := DerivedSubgroup( Range( XM ) );
    bdy := Boundary( XM );
    alpha := XModAction( XM );
    dgt := DisplacementSubgroup( XM );
    ## aut := AutomorphismGroup( dgt ); 
    ## gendgt := GeneratorsOfGroup( dgt );
    ## imdgt := List( gendgt, x -> Image( bdy, x ) );
    k_partial := RestrictionMappingGroups( bdy, dgt, D ); 
    genD := GeneratorsOfGroup( D ); 
    imD := List( genD, x -> 
               RestrictionMappingGroups( Image(alpha,x), dgt, dgt ) ); 
    k_alpha := GroupHomomorphismByImages( D, Group( Set(imD) ), genD, imD );
    return XModByBoundaryAndAction( k_partial, k_alpha );
end );

#############################################################################
##
#M  CommutatorSubXMod  . . . . . . . commutator subxmod of two normal subxmods
##
InstallMethod( CommutatorSubXMod, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod, IsXMod ], 0,
function( TG, SH, RK )

    local  alpha, T, G, S, H, R, K, partial, k_partial, k_alpha, s, k, r, h, 
           DKS_DHR, KomHK, list;
    T := Source(TG);
    G := Range(TG);
    alpha := XModAction(TG);
    partial := Boundary(TG);
    S := Source(SH);
    H := Range(SH);
    R := Source(RK);
    K := Range(RK);
    list := [];
    ## for elements of DKS and DHR 
    for s in S do
        for k in K do
            Add( list, Image( Image(alpha,k), s ) * s^-1 );
        od;
    od;
    for r in R do
        for h in H do
            Add( list, Image( Image(alpha,h), r ) * r^-1);
        od;
    od;
    list := Set(list);
    ### if the list consists only the identity element 
    ### then there is a bug in the function AsMagma. 
    if ( Length( Set(list) ) = 1 ) then
        DKS_DHR := TrivialSubgroup( T );
    else
        DKS_DHR := AsGroup(list);
    fi;
    KomHK := CommutatorSubgroup( H, K );
    k_partial := GroupHomomorphismByFunction( DKS_DHR, KomHK, 
                     x -> Image( partial, x ) );
    k_alpha := GroupHomomorphismByFunction( KomHK, AutomorphismGroup(DKS_DHR), 
                   x -> Image( alpha, x ) );
    return XModByBoundaryAndAction( k_partial, k_alpha );
end );

#############################################################################
##
#M  LowerCentralSeriesOfXMod  . . . . . . . the lower central series of an xmod
##
InstallMethod( LowerCentralSeriesOfXMod, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function(XM)

    local  list, C;

    list := [ XM ];
    C := DerivedSubXMod( XM );
    ##  while (IsEqualXMod(C,list[Length(list)]) = false)  do
    while ( C <> list[ Length(list) ] )  do
        Add( list, C );
        C := CommutatorSubXMod( XM, C, XM );
    od;
    return list;
end );
    
#############################################################################
##
#M  IsAbelian2dGroup . . . . . . . . . check that a crossed module is abelian
##
InstallMethod( IsAbelian2dGroup, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function( XM )
    return ( XM = CentreXMod( XM ) );
end );

#############################################################################
##
#M  IsAspherical2dGroup . . . . . . check that a crossed module is aspherical
##
InstallMethod( IsAspherical2dGroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function( XM )
    return ( Size( Kernel( Boundary(XM) ) ) = 1 ); 
end );

#############################################################################
##
#M  IsSimplyConnected2dGroup . check that a crossed module is simply connected
##
InstallMethod( IsSimplyConnected2dGroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function( XM )
    return ( Size( CoKernel( Boundary(XM) ) ) = 1 );
end );

#############################################################################
##
#M  IsFaithful2dGroup . . . . . . . . check that a crossed module is faithful
##
InstallMethod( IsFaithful2dGroup, "generic method for crossed modules", true, 
    [ IsXMod ], 0,
function( XM )
    return ( Size( PreXModStabilizer(XM) ) = 1 ); 
end );

#############################################################################
##
#M  IsNilpotent2dGroup  . . . . . . . . . . . check that an xmod is nilpotent
##
InstallMethod( IsNilpotent2dGroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function(XM)

    local  S, n, sonuc;

    S := LowerCentralSeriesOfXMod( XM );
    n := Length(S);
    if ( Size(S[n]) = [1,1] ) then
        sonuc := true;
    else
        sonuc := false;
    fi;
return sonuc;
end );

#############################################################################
##
#M  NilpotencyClass2dGroup . . . . . . .nilpotency degree of a crossed module
##
InstallMethod( NilpotencyClass2dGroup, "generic method for crossed modules", 
    true, [ IsXMod ], 0,
function(XM)

    if not IsNilpotent2dGroup(XM) then
        return 0;
    else
        return Length( LowerCentralSeriesOfXMod(XM) ) - 1;        
    fi;
end );



############################################################################# 
#####                FUNCTIONS FOR ISOCLINISM OF GROUPS                 ##### 
############################################################################# 

#############################################################################
##
#M IsStemGroup . . . check that the centre is a subgroup of the derived group
## 
InstallMethod( IsStemGroup, "generic method for groups", true, [ IsGroup ], 0,
function(G)
    return IsSubgroup( DerivedSubgroup(G), Centre(G) );
end );

#############################################################################
##
#M AllStemGroupIds . . . list of all IdGroup's of stem groups of chosen order 
## 
InstallMethod( AllStemGroupIds, "generic method for posint", true, 
    [ IsPosInt ], 0,
function(a) 

    local  g, i, j, sonuc, sayi;

    sonuc := [ ]; 
    for g in AllSmallGroups(a) do 
        if IsStemGroup( g ) then 
            Add( sonuc, IdGroup(g) ); 
        fi;
    od; 
    return sonuc; 
end );

#############################################################################
##
#M CentralQuotient . . . . . . . . . . . . . . . . . . . . . . . . . . G/Z(G)
#M CentralQuotientHomomorphism . . . . . . . . . . . . . . . . .  G -> G/Z(G)
## 
InstallMethod( CentralQuotient, "generic method for groups", true, 
    [ IsGroup ], 0,
function( G ) 

    local  ZG, Q, nat; 

    ZG := Centre( G ); 
    Q := FactorGroup( G, ZG ); 
    nat := NaturalHomomorphismByNormalSubgroup( G, ZG ); 
    SetCentralQuotientHomomorphism( G, nat ); 
    return Q;
end );

InstallMethod( CentralQuotientHomomorphism, "generic method for groups", true, 
    [ IsGroup ], 0,
function( G ) 

    local  Q; 

    Q := CentralQuotientHomomorphism( G );
    return NaturalHomomorphismByNormalSubgroup( G, Q ); 
end );

#############################################################################
##
#M MiddleLength . . .
## 
InstallMethod( MiddleLength, "generic method for groups", true, 
    [ IsGroup ], 0,
function( G ) 

    local sonuc, ZG, DG, BG, KG, m1, l1, l2;

    ZG := Center(G);
    DG := DerivedSubgroup(G);
    KG := Intersection(DG,ZG);
    BG := FactorGroup(DG,KG);
    return Log2( Float( Size(BG) ) );     
end );

#############################################################################
##
#M AreIsoclinicGroups . . . 
## 
InstallMethod( AreIsoclinicGroups, "generic method for two groups", true, 
    [ IsGroup, IsGroup ], 0,
function( G1, G2 ) 
    local  iso; 
    iso := Isoclinism( G1, G2 ); 
    if ( iso = false ) then 
        return false; 
    elif ( iso = fail ) then 
        return fail; 
    else 
        return true; 
    fi; 
end );

#############################################################################
##
#M Isoclinism . . . 
## 
InstallMethod( Isoclinism, "generic method for two groups", true, 
    [ IsGroup, IsGroup ], 0,
function( G1, G2 )

    local  B1, B2, ComG1, ComG2, nhom1, nhom2, iterb1, iterb2, iterB, iterC, 
           isoB, isoC, b1, b2, gb1, gb2, f, g, sonuc, x, y, 
           gx, gy, gor1, gor2, yeni_iso;

    if (IsomorphismGroups(G1,G2) <> fail) then
        return true;
    fi;
    B1 := CentralQuotient(G1);
    B2 := CentralQuotient(G2);
    ComG1 := DerivedSubgroup(G1);
    ComG2 := DerivedSubgroup(G2);
    isoB := IsomorphismGroups(B1,B2);
    isoC := IsomorphismGroups(ComG1,ComG2);
    if ( ( isoB = fail ) or ( isoC = fail ) ) then 
        return false;
    fi;
    nhom1 := CentralQuotientHomomorphism(G1);
    nhom2 := CentralQuotientHomomorphism(G2);
    iterB := Iterator( AllAutomorphisms(B2) ); 
    iterC := Iterator( AllAutomorphisms(ComG2) );
    ### ilk iki ˛art˝ geÁerse 3. y¸ kontrol edelim
    ### anlams˝z hata al˝yorum 
    iterb1 := Iterator( B1 );
    while not IsDoneIterator( iterB ) do 
        f := isoB * NextIterator(iterB); 
        while not IsDoneIterator( iterC ) do 
            g := isoC * NextIterator(iterC); 
            sonuc := true;
            yeni_iso := false;
            while ( ( not yeni_iso ) and ( not IsDoneIterator(iterb1) ) ) do 
                b1 := NextIterator( iterb1 ); 
                ## yeni_iso degeri dogru geliyorsa yeni f,g 
                ## ikili iÁin dˆng¸y¸ k˝r.
                ## if ( yeni_iso = true ) then        
                ##     break;
                ## fi;
                x := PreImagesRepresentative(nhom1,b1);
                gb1 := Image(f,b1);
                gx := PreImagesRepresentative(nhom2,gb1);
                iterb2 := Iterator( B1 );
                while ( ( not yeni_iso ) and ( not IsDoneIterator(iterb2) ) ) do 
                    b2 := NextIterator( iterb2 ); 
                    y := PreImagesRepresentative(nhom1,b2);
                    gb2 := Image(f,b2);
                    gy := PreImagesRepresentative(nhom2,gb2);            
                    gor1 := Image(g,Comm(x,y));    
                    gor2 := Comm(gx,gy);
                    if (gor1 <> gor2) then 
                        yeni_iso := true;
                        ## sonuc := false;
                        ## 3. sart bu f,g ikilisi iÁin salanm˝yor 
                        ## break; 
                    fi;
                od;
            od;
            ## 3. sart˝ salayan 1 tane f,g ikilisi bulunmas˝ yeterlidir.  
            if sonuc then        
                return [f,g];
            fi;
        od;
    od;
    return fail;
end );

#############################################################################
##
#M IsoclinicStemGroups . . . 
## 
InstallMethod( IsoclinicStemGroups, "generic method for a group", 
    true, [ IsGroup ], 0,
function(G)

    local  s, i, len, divs, n, id, j, sonuc, sayi;

    if ( HasIsAbelian(G) and IsAbelian(G) ) then 
        return [ [ 1, 1 ] ]; 
    fi;
    if IsStemGroup(G) then 
        id := AllStemGroupIds( Size(G) ); 
        return Filtered( id, i -> AreIsoclinicGroups( G, SmallGroup(i) ) ); 
    fi;
    sonuc := [];
    sayi := 0;
    divs := DivisorsInt( Size(G) );
    len := Length( divs ); 
    for i in divs{[1..len-1]} do 
        for id in AllStemGroupIds( i ) do
            j := id[2]; 
            if AreIsoclinicGroups( G, SmallGroup(i,j) ) then
                ## Print("SmallGroup(",i,",",j,")\n");        
                sayi := sayi + 1;
                Add( sonuc, [i,j] );
            fi;        
        od;
        if ( Length( sonuc ) > 0 ) then 
            return sonuc; 
        fi;
    od;
    Print( "Total Numbers : ", sayi, "\n");
    return sonuc;
end );



#############################################################################
##
#M  AreIsoclinicXMods  . . . . . check that two crossed modules are isoclinic
##
InstallMethod( AreIsoclinicXMods, "generic method for crossed modules", true, 
    [ IsXMod, IsXMod ], 0,
function(XM1,XM2)

    local  cakma3, cakma4, kG12, kG11, T, G, S, H, sonuc, kT11, kT12, 
           cakma, cakma2, yeni_iso, x, y, z1, z2, gz1, gz2, gx, gy, 
           gor1, gor2, pisi0, pisi1, nisi1, nisi0, nhom1, nhom2, nhom3, nhom4, 
           ComXM1, ComXM2, MXM1, MXM2, BXM1, BXM2, b1, a1, T1, G1, 
           b2, a2, T2, G2, alpha1, phi1, m1_ler, m2_ler, m1, m2, b11, a11, 
           T11, G11, b12, a12, T12, G12, alpha11, phi11, m11, alp, ph, 
           isoT, isoG, isoT1, isoG1, iterT2, iterG2, iterT12, iterG12, mor, 
           QXM1, QXM2;

    sonuc := true;
    T := Source(XM1);
    G := Range(XM1);
    S := Source(XM2);
    H := Range(XM2);
    ComXM1 := DerivedSubXMod(XM1);
    ComXM2 := DerivedSubXMod(XM2);
    b1 := Boundary(ComXM1);
    a1 := XModAction(ComXM1);
    T1 := Source(ComXM1);
    G1 := Range(ComXM1);
    b2 := Boundary(ComXM2);
    a2 := XModAction(ComXM2);
    T2 := Source(ComXM2);
    G2 := Range(ComXM2);
    
    isoT := IsomorphismGroups(T1,T2); 
    isoG := IsomorphismGroups(G1,G2);
    if ( ( isoT = fail ) or (isoG = fail ) ) then 
        return false; 
    fi;

    MXM1 := CentreXMod(XM1);
    MXM2 := CentreXMod(XM2);
    BXM1 := FactorXMod(XM1,MXM1); 
    BXM2 := FactorXMod(XM2,MXM2); 
    b11 := Boundary(BXM1);
    a11 := XModAction(BXM1);
    T11 := Source(BXM1);
    G11 := Range(BXM1);
    b12 := Boundary(BXM2);
    a12 := XModAction(BXM2);
    T12 := Source(BXM2);
    G12 := Range(BXM2);
        
    isoT1 := IsomorphismGroups(T11,T12); 
    isoG1 := IsomorphismGroups(G11,G12);
    if ( ( isoT1 = fail ) or ( isoG1 = fail ) ) then 
        return false;
    fi;
    
    ## alpha1 := AllIsomorphisms( T1, T2 ); 
    iterT2 := Iterator( AllAutomorphisms(T2) ); 
    ## phi1 := AllIsomorphisms( G1, G2 ); 
    iterG2 := Iterator( AllAutomorphisms(G2) ); 
    m1_ler := [];        
    ## for alp in alpha1 do
    while not IsDoneIterator( iterT2 ) do 
        alp := isoT * NextIterator( iterT2 ); 
        ## for ph in phi1 do 
        while not IsDoneIterator( iterG2 ) do 
            ph := isoG * NextIterator( iterG2 ); 
            mor := Make2dGroupMorphism(ComXM1,ComXM2,alp,ph); 
            if IsPreXModMorphism( mor ) then 
                if IsXModMorphism( mor ) then 
                    Add( m1_ler, mor );
                fi; 
            fi;
        od;
    od;    
    ## m1_ler := Filtered(m1_ler,IsXModMorphism); 
    if ( Length(m1_ler) = 0 ) then
        Info( InfoXMod, 1, "There is no morphism" );
        return false;
    fi;
    
    ## alpha11 := AllIsomorphisms(T11,T12);
    iterT12 := Iterator( AllAutomorphisms( T12 ) ); 
    ## phi11 := AllIsomorphisms(G11,G12); 
    iterG12 := Iterator( AllAutomorphisms( G12 ) ); 
    m2_ler := [];        
    ## for alp in alpha11 do 
    while not IsDoneIterator( iterT12 ) do 
        alp := isoT1 * NextIterator( iterT12 ); 
        ## for ph in phi11 do 
        while not IsDoneIterator( iterG12 ) do 
            ph := isoG1 * NextIterator( iterG12 ); 
            mor := Make2dGroupMorphism( BXM1, BXM2, alp, ph ); 
            if IsPreXModMorphism( mor ) then 
                if IsXModMorphism( mor ) then 
                    Add( m2_ler, mor );
                fi; 
            fi;
        od;
    od;
    if ( Length(m2_ler) = 0 ) then
        Info( InfoXMod, 1, "There is no morphism" );
        return false;
    fi;
    
    QXM1 := Intersection( Centre(G), PreXModStabilizer(XM1) ); 
    nhom1 := NaturalHomomorphismByNormalSubgroup( G, QXM1 ); 
    kG11 := Image( nhom1 );
    cakma3 := GroupHomomorphismByImages( kG11, G11, GeneratorsOfGroup(kG11), 
                                                    GeneratorsOfGroup(G11) );
    QXM2 := Intersection( Centre(H), PreXModStabilizer(XM2) ); 
    nhom2 := NaturalHomomorphismByNormalSubgroup( H, QXM2 ); 
    kG12 := Image( nhom2 );
    cakma4 := GroupHomomorphismByImages( G12, kG12, GeneratorsOfGroup(G12),
                                                    GeneratorsOfGroup(kG12) );

    nhom3 := NaturalHomomorphismByNormalSubgroup( T,
                 PreXModFixedPointSubgroup( XM1 ) ); 
    kT11 := Image(nhom3); 
    cakma := GroupHomomorphismByImages( kT11, T11, GeneratorsOfGroup(kT11),
                                                   GeneratorsOfGroup(T11) );
    nhom4 := NaturalHomomorphismByNormalSubgroup( S,
                 PreXModFixedPointSubgroup( XM2 ) ); 
    kT12 := Image(nhom4);
    cakma2 := GroupHomomorphismByImages( T12, kT12, GeneratorsOfGroup(T12),
                                                    GeneratorsOfGroup(kT12) );
    for m2 in m2_ler do
        nisi1 := SourceHom( m2 );
        nisi0 := RangeHom( m2 );
        for m1 in m1_ler do
            pisi1 := SourceHom(m1);
            pisi0 := RangeHom(m1);
            sonuc := true;
            yeni_iso := false;    
            ### start check diagram 1    
            for z1 in kT11 do
                x := PreImagesRepresentative(nhom3,z1);
                gz1 := Image(nisi1,Image(cakma,z1));
                gx := PreImagesRepresentative(nhom4,Image(cakma2,gz1));
                for z2 in kG11 do
                    y := PreImagesRepresentative(nhom1,z2);
                    gz2 := Image(nisi0,Image(cakma3,z2));
                    gy := PreImagesRepresentative(nhom2,Image(cakma4,gz2));    
                    gor1 := Image(pisi1,Image(Image(XModAction(XM1),y),x)*x^-1);    
                    gor2 := Image(Image(XModAction(XM2),gy),gx)*gx^-1;
                    if (gor1 <> gor2) then
                        sonuc := false;
                        yeni_iso := true;
                        break;            
                    fi;
                od;
                if ( yeni_iso = true ) then        
                    break;
                fi;
            od;
            ### end check diagram 1
            if ( yeni_iso = true ) then        
                break;
            fi;

            ### start check diagram 2    
            for z1 in kG11 do
                x := PreImagesRepresentative(nhom1,z1);
                gz1 := Image(nisi0,Image(cakma3,z1));
                gx := PreImagesRepresentative(nhom2,Image(cakma4,gz1));
                for z2 in kG11 do
                    y := PreImagesRepresentative(nhom1,z2);
                    gz2 := Image(nisi0,Image(cakma3,z2));
                    gy := PreImagesRepresentative(nhom2,Images(cakma4,gz2));            
                    gor1 := Image(pisi0,Comm(x,y));    
                    gor2 := Comm(gx,gy);
                    if (gor1 <> gor2) then
                        sonuc := false;
                        yeni_iso := true;
                        break; 
                    fi;
                od;
                if ( yeni_iso = true ) then        
                    break;
                fi;
            od;
            ### end check diagram 2
            if ( yeni_iso = true ) then        
                break;
            fi;
            if ( sonuc = true ) then    
                return sonuc;
            fi;    
        od;
    od;
    Print("There is no morphism that provides conditions \n");    
    return sonuc;
end );

#############################################################################
##
#M  IsIsomorphicXMod  . . check that the given crossed modules are isomorphic
##
InstallMethod( IsIsomorphicXMod, "generic method for crossed modules", true, 
    [ Is2dGroup, Is2dGroup ], 0,
function(XM1,XM2)

    local  sonuc, T1, G1, b2, a2, b1, a1, T2, G2, alpha1, phi1, m1_ler, m1, 
           isoT, isoG, iterT, iterG, alp, ph, mor;

    sonuc := true;
    T1 := Source(XM1);
    G1 := Range(XM1);
    b1 := Boundary(XM1);
    a1 := XModAction(XM1);
    T2 := Source(XM2);
    G2 := Range(XM2);
    b2 := Boundary(XM2);
    a2 := XModAction(XM2);
    isoT := IsomorphismGroups(T1,T2); 
    isoG := IsomorphismGroups(G1,G2);
    if ( ( isoT = fail ) or (isoG = fail ) ) then 
        return false; 
    fi;
    ## alpha1 := AllIsomorphisms(T1,T2); 
    iterT := Iterator( AllAutomorphisms( T2 ) ); 
    ## phi1 := AllIsomorphisms(G1,G2); 
    iterG := Iterator( AllAutomorphisms( G2 ) ); 
    m1_ler := []; 
    ## for alp in alpha1 do
    while not IsDoneIterator( iterT ) do 
        alp := isoT * NextIterator( iterT );
        ## for ph in phi1 do
        while not IsDoneIterator( iterG ) do 
            ph := isoG * NextIterator( iterG ); 
            mor := Make2dGroupMorphism( XM1, XM2, alp, ph ); 
            if IsPreXModMorphism( mor ) then 
                if IsXModMorphism( mor ) then 
                    Add( m1_ler, mor ); 
                fi; 
            fi;
        od;
    od;    
    ## m1_ler := Filtered(m1_ler,IsXModMorphism);
    if ( Length( m1_ler ) = 0 ) then 
        return false;
    fi;    
    return sonuc;
end );

#############################################################################
##
#M  PreAllXMods  . . . . . all precrossed modules in the given order interval
##
InstallMethod( PreAllXMods, "generic method for crossed modules", true, 
    [ IsInt, IsInt ], 0,
function(min,max)

    local  s1, i1, j1, s2, i2, j2, s3, i3, j3, s4, i4, j4, sonuc, sayi,
           T, G, S, H, b1, a1, b2, a2, XM1_ler, XM2_ler, XM1, XM2,
           b11, a11, PreXM1_ler;

    sonuc := [];
    a1 := [];
    b1 := [];
    a2 := [];
    b2 := [];
    sayi := 0;
    XM1_ler := [];
    PreXM1_ler := [];

    for i1 in [min..max] do
        s1 := Length(IdsOfAllSmallGroups(i1));        
        for j1 in [1..s1] do
            T := SmallGroup(i1,j1);
            for i2 in [min..max] do
                s2 := Length(IdsOfAllSmallGroups(i2));        
                for j2 in [1..s2] do
                    G := SmallGroup(i2,j2);
                    b1 := AllHomomorphisms(T,G);
                    a1 := AllHomomorphisms(G,AutomorphismGroup(T));    
                    for b11 in b1 do
                        for a11 in a1 do
                            if IsPreXMod(PreXModObj(b11,a11)) then
                                Add(PreXM1_ler,PreXModObj(b11,a11));
                            fi;
                        od;
                    od; 
                od;
            od;
        od; 
    od;
    return PreXM1_ler;
end );

#############################################################################
##
#M  AllXMods  . . . . . . . . all crossed modules in the given order interval
##
InstallMethod( AllXMods, "generic method for crossed modules", true, 
    [ IsInt, IsInt ], 0,
function(min,max)

    local  s1, i1, j1, s2, i2, j2, s3, i3, j3, s4, i4, j4, sonuc, sayi,
           T, G, S, H, b1, a1, b2, a2, XM1_ler, XM2_ler, XM1, XM2, 
           b11, a11, PreXM1_ler;

    sonuc := [];
    a1 := [];
    b1 := [];
    a2 := [];
    b2 := [];
    sayi := 0;
    XM1_ler := [];
    PreXM1_ler := [];
    for i1 in [min..max] do
        s1 := Length(IdsOfAllSmallGroups(i1));        
        for j1 in [1..s1] do
            T := SmallGroup(i1,j1);
            for i2 in [min..max] do
                s2 := Length(IdsOfAllSmallGroups(i2));        
                for j2 in [1..s2] do
                    G := SmallGroup(i2,j2);
                    b1 := AllHomomorphisms(T,G);
                    a1 := AllHomomorphisms(G,AutomorphismGroup(T));    
                    for b11 in b1 do
                        for a11 in a1 do
                            if (  IsPreXMod(PreXModObj(b11,a11)) ) then
                                Add(PreXM1_ler,PreXModObj(b11,a11));
                            fi;
                        od;
                    od;
                    XM1_ler := Filtered( PreXM1_ler, IsXMod );        
                od;
            od;
        od; 
    od;
    return XM1_ler;
end );

#############################################################################
##
#M  IsoclinicXModFamily  . . . . all xmods in the list isoclinic to the xmod
##
InstallMethod( IsoclinicXModFamily, "generic method for crossed modules", 
    true, [ Is2dGroup, IsList ], 0,
function( XM, XM1_ler )

    local  sonuc, sayi, XM1;

    sonuc := [];
    sayi := 0;
    for XM1 in XM1_ler do
        if AreIsoclinicXMods(XM,XM1) then
            Print(XM," ~ ",XM1,"\n" );    
            Add(sonuc,Position(XM1_ler,XM1));
            sayi := sayi + 1;            
        else
            Print(XM," |~ ",XM1,"\n" );            
        fi;        
    od; 
    ## Print(sayi,"\n");
    return sonuc;
end );

#############################################################################
##
#M  IsomorphicXModFamily  . . . all xmods in the list isomorphic to the xmod
##
InstallMethod( IsomorphicXModFamily, "generic method for crossed modules", 
    true, [ Is2dGroup, IsList ], 0,
function( XM, XM1_ler )

    local  sonuc, sayi, XM1;

    sonuc := [];
    sayi := 0;
    for XM1 in XM1_ler do
        if IsIsomorphicXMod(XM,XM1) then
            # Print(XM," ~ ",XM1,"\n" );    
            Add(sonuc,Position(XM1_ler,XM1));
            sayi := sayi + 1;
        fi;
    od;        
    ## Print(sayi,"\n");
    return sonuc;
end );


#############################################################################
##
#M  IsoAllXMods  . . . . . . . . . . . all crossed modules up to isomorphism
##
InstallMethod( IsoAllXMods, "generic method for crossed modules", true, 
    [ IsList ], 0,
function(allxmods)

    local  n, l, i, j, k, isolar, list1, list2;

    n := Length( allxmods );
    list1 := [];
    list2 := [];
    for i in [1..n] do
        if i in list1 then
            continue;
        else
            isolar := IsomorphicXModFamily(allxmods[i],allxmods);
            Append(list1,isolar);        
            Add(list2,allxmods[i]);
        fi; 
    od; 
    return list2;
end );

#############################################################################
##
#M  RankXMod  . . . . . . . . . . . . . . . . the rank of the crossed module
##
InstallMethod( RankXMod, "generic method for crossed modules", true, 
    [ Is2dGroup ], 0,
function(XM)

    local  ZXMod, DXMod, BXMod, KXMod, m1, m2, l1, l2;

    ZXMod := CentreXMod(XM);
    DXMod := DerivedSubXMod(XM);
    BXMod := FactorXMod(XM,ZXMod);
    KXMod := IntersectionSubXMod(XM,ZXMod,DXMod);
    m1 := Size(BXMod);
    m2 := Size(KXMod);
    l1 := Log2(Float(m1[1])) + Log2(Float(m2[1]));
    l2 := Log2(Float(m1[2])) + Log2(Float(m2[2]));
    return [l1,l2];
end );

#############################################################################
##
#M  MiddleLength  . . . . . . . the middle length of the crossed module
##
InstallOtherMethod( MiddleLength, "generic method for crossed modules", true, 
    [ Is2dGroup ], 0,
function(XM)

    local  sonuc, ZXMod, DXMod, BXMod, KXMod, m1, l1, l2;

    ZXMod := CentreXMod(XM);
    DXMod := DerivedSubXMod(XM);
    KXMod := IntersectionSubXMod(XM,DXMod,ZXMod);
    BXMod := FactorXMod(DXMod,KXMod);
    m1 := Size(BXMod);     
    l1 := Log2(Float(m1[1]));
    l2 := Log2(Float(m1[2]));
    return [l1,l2];
end );

#############################################################################
##
#M  TableRowXMod  . .. . table row for isoclinism families of crossed modules
##
InstallMethod( TableRowXMod, "generic method for crossed modules", true, 
    [ Is2dGroup, IsList ], 0,
function(XM,XM_ler)

    local  Eler, Iler, i, j, sinif, B;

    sinif := IsoclinicXModFamily( XM, XM_ler );
    B := LowerCentralSeriesOfXMod( XM );
    
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print("Number","\t","Rank","\t\t","M. L.","\t\t","Class","\t","|G/Z|","\t\t","|g2|","\t\t","|g3|","\t\t","|g4|","\t\t","|g5| \n");
Print("---------------------------------------------------------------------------------------------------------------------------------- \n");
Print(Length(sinif),"\t",RankXMod(XM),"\t",MiddleLength(XM),"\t",NilpotencyClass2dGroup(XM),"\t",Size(FactorXMod(XM,CentreXMod(XM))));    

if Length(B) > 1 then
for i in [2..Length(B)] do
        Print("\t");
        Print(Size(B[i]));
        
od;
fi;

Print("\n---------------------------------------------------------------------------------------------------------------------------------- \n");
return sinif;
end );








