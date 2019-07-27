##############################################################################
##
##  gp4obj.gd                 GAP4 package `XMod'                Chris Wensley
##                                                                Alper Odabas
#Y  Copyright (C) 2001-2019, Chris Wensley et al,  
#Y  School of Computer Science, Bangor University, U.K. 
##  
##  This file declares generic methods for (pre-)crossed cubes and
##  (pre-)cat3-groups.

#############################################################################
##
#A  Up3DimensionalGroup( <PS> ) 
#A  Down3DimensionalGroup ( <PS> ) 
#A  Left3DimensionalGroup( <PS> ) 
#A  Right3DimensionalGroup( <PS> ) 
#A  Front3DimensionalGroup( <PS> ) 
#A  Back3DimensionalGroup( <PS> )
##
DeclareAttribute( "Up3DimensionalGroup", IsHigherDimensionalGroup );
DeclareAttribute( "Left3DimensionalGroup", IsHigherDimensionalGroup );
DeclareAttribute( "Down3DimensionalGroup", IsHigherDimensionalGroup );
DeclareAttribute( "Right3DimensionalGroup", IsHigherDimensionalGroup );
DeclareAttribute( "Front3DimensionalGroup", IsHigherDimensionalGroup );
DeclareAttribute( "back3DimensionalGroup", IsHigherDimensionalGroup );

#############################################################################
##
#R  IsPreCat3GroupObj ( <obj> ) 
#T  PreCat3GroupObjType 
#O  PreCat3GroupObj( <cat1gp>, <cat1gp> ) 
##  A pre-cat3-group is a cube of commuting pre-cat1-groups 
##
DeclareRepresentation( "IsPreCat3GroupObj", 
    IsHigherDimensionalGroup and IsAttributeStoringRep,
    [ "up3d", "left3d", "right3d", "down3d", "front3d", "back3d" ] );
BindGlobal( "PreCat3GroupObjType", 
            NewType( FamilyHigherDimensionalGroup, IsPreCat3GroupObj ) ); 
DeclareOperation( "PreCat3GroupObj", [ IsList] );

#############################################################################
##
#P  IsPreCat3Group( <PCG> ) 
#P  IsCat3Group( <C1G> ) 
##
DeclareProperty( "IsPreCat3Group", IsHigherDimensionalGroup );
DeclareProperty( "IsCat3Group", IsHigherDimensionalGroup );
InstallTrueMethod( IsPreCat3Group, IsCat3Group );

#############################################################################
##
#F  PreCat3Group( <arg> ) 
#F  Cat3Group( <arg> }
#O  DetermineRightDownBackCat2Groups( <front>, <up>, <left> )
#O  PreCat3GroupByPreCat2Groups( <front>,<up>,<left>,<right>,<down>,<back> )
##
DeclareGlobalFunction( "PreCat3Group" );
DeclareGlobalFunction( "Cat3Group" );
DeclareOperation( "DetermineRightDownBackCat2Groups", 
    [ IsPreCat2Group, IsPreCat2Group, IsPreCat2Group ] );
DeclareOperation( "PreCat3GroupByPreCat2Groups", 
    [ IsPreCat2Group, IsPreCat2Group, IsPreCat2Group, 
      IsPreCat2Group, IsPreCat2Group, IsPreCat1Group ] );

