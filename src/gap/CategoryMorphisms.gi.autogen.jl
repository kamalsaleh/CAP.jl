# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#

######################################
##
## Reps, types, stuff.
##
######################################

# backwards compatibility
@BindGlobal( "IsCapCategoryMorphismRep", IsCapCategoryMorphism );

#######################################
##
## Technical implications
##
#######################################

@InstallValueConst( PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, [ ] );

##
@InstallGlobalFunction( INSTALL_TODO_LIST_FOR_EQUAL_MORPHISMS,
                       
  function( morphism_1, morphism_2 )
    local category, i, entry;
    
    category = CapCategory( morphism_1 );
    
    for i in PROPAGATION_LIST_FOR_EQUAL_MORPHISMS
        
        AddToToDoList( ToDoListEntryForEqualAttributes( morphism_1, i, morphism_2, i ) );
        
    end;
    
    if (@IsBound( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS ))
        
        for i in category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS
            
            AddToToDoList( ToDoListEntryForEqualAttributes( morphism_1, i, morphism_2, i ) );
            
        end;
        
    end;
    
end );

##
@InstallMethod( AddPropertyToMatchAtIsCongruentForMorphisms,
               [ IsCapCategory, IsString ],
               
  function( category, name )
    
    if (@not @IsBound( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS ))
        
        category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS = [ ];
        
    end;
    
    if (Position( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, name ) == fail)
        
        Add( category.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, name );
        
    end;
    
end );

######################################
##
## Operations
##
######################################

@InstallMethod( Target,
               [ IsCapCategoryMorphism ],
               
  Range );

@InstallMethod( Add,
               [ IsCapCategory, IsCapCategoryMorphism ],
               
  function( category, morphism )
    local filter;
    
    filter = MorphismFilter( category );
    
    if (@not filter( morphism ))
        
        SetFilterObj( morphism, filter );
        
    end;
    
    if (HasCapCategory( morphism ))
        
        if (@not IsIdenticalObj( CapCategory( morphism ), category ))
            
            Error(
                @Concatenation(
                    "a morphism that lies in the CAP-category with the name\n",
                    Name( CapCategory( morphism ) ),
                    "\n",
                    "was tried to be added to a different CAP-category with the name\n",
                    Name( category ), ".\n",
                    "(Please note that it is possible for different CAP-categories to have the same name)"
                )
            );
            
        end;
        
    else
        
        SetCapCategory( morphism, category );
        
    end;
    
    AddObject( category, Source( morphism ) );
    
    AddObject( category, Range( morphism ) );
    
    if (category.predicate_logic)
        
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ morphism ], Source( morphism ), category );
        
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ morphism ], Range( morphism ), category );
      
    end;
    
end );

@InstallMethod( AddMorphism,
               [ IsCapCategory, IsCapCategoryMorphism ],
               
  function( category, morphism )
    
    Add( category, morphism );
    
end );

@InstallMethod( AddMorphism,
               [ IsCapCategory, IsAttributeStoringRep ],
               
  function( category, morphism )
    
    SetFilterObj( morphism, IsCapCategoryMorphism );
    
    Add( category, morphism );
    
end );

##
@InstallGlobalFunction( CreateCapCategoryMorphismWithAttributes,
                       
  function( category, source, range, additional_arguments_list... )
    local arg_list, objectified_morphism;
    
    arg_list = @Concatenation(
        [ @rec( ), category.morphism_type, CapCategory, category, Source, source, Range, range ], additional_arguments_list
    );
    
    objectified_morphism = CallFuncList( ObjectifyWithAttributes, arg_list );
    
    if (category.predicate_logic)
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ objectified_morphism ], source, category );
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ objectified_morphism ], range, category );
    end;
    
    return objectified_morphism;
    
end );

##
@InstallGlobalFunction( AsCapCategoryMorphism,
                       
  function( category, source, morphism_datum, range )
    local morphism_datum_type, mor;
    
    morphism_datum_type = CAP_INTERNAL_GET_DATA_TYPE_FROM_STRING( "morphism_datum", category );
    
    if (morphism_datum_type != fail)
        
        CAP_INTERNAL_ASSERT_VALUE_IS_OF_TYPE_GETTER( morphism_datum_type, () -> "the third argument of `AsCapCategoryMorphism`" )( morphism_datum );
        
    end;
    
    mor = ObjectifyWithAttributes( @rec( ), category.morphism_type, CapCategory, category, Source, source, Range, range, category.morphism_attribute, morphism_datum );
    
    if (@not IsIdenticalObj( category.morphism_attribute( mor ), morphism_datum ))
        
        Print( "WARNING: <morphism_datum> is not identical to `", category.morphism_attribute_name, "( <mor> )`. You might want to make <morphism_datum> immutable.\n" );
        
    end;
    
    if (category.predicate_logic)
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ mor ], source, category );
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ mor ], range, category );
    end;
    
    return mor;
    
end );

###########################
##
## Print
##
###########################

@InstallMethod( StringGAP,
               [ IsCapCategoryMorphism ],
               
  function( morphism )
    
    return @Concatenation( "A morphism in ", Name( CapCategory( morphism ) ) );
    
end );

# fallback methods for Julia
@InstallMethod( ViewString,
               [ IsCapCategoryMorphism ],
               
  function ( morphism )
    
    # do not reuse `StringGAP` because morphisms might use `StringGAP` as the attribute storing the morphism datum
    return @Concatenation( "<A morphism in ", Name( CapCategory( morphism ) ), ">" );
    
end );

@InstallMethod( DisplayString,
               [ IsCapCategoryMorphism ],
               
  function ( morphism )
    
    # do not reuse `StringGAP` because morphisms might use `StringGAP` as the attribute storing the morphism datum
    return @Concatenation( "A morphism in ", Name( CapCategory( morphism ) ), ".\n" );
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_CREATE_MORPHISM_PRINT,
                       
  function( )
    local print_graph, morphism_function;
    
    morphism_function = function( object )
      local string;
        
        string = "morphism in ";
        
        Append( string, Name( CapCategory( object ) ) );
        
        return string;
        
    end;
    
    print_graph = CreatePrintingGraph( IsCapCategoryMorphism && HasCapCategory, morphism_function );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ @rec( Conditions = "IsIsomorphism",
                                              PrintString = "iso",
                                              Adjective = true,
                                              NoSepString = true ) ],
                             Range = [ @rec( Conditions = "IsSplitMonomorphism",
                                             PrintString = "split mono",
                                             TypeOfView = "ViewObj",
                                             ComputeLevel = "AllWithCompute",
                                             Adjective = true,
                                              NoSepString = true ),
                                        @rec( Conditions = "IsSplitEpimorphism",
                                             PrintString = "split epi",
                                             Adjective = true,
                                              NoSepString = true ) ] ) );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ @rec( Conditions = "IsOne",
                                              PrintString = "identity",
                                              Adjective = true ) ],
                             Range = [ @rec( Conditions = "IsAutomorphism",
                                             PrintString = "auto",
                                             Adjective = true,
                                             NoSepString = true ),
                                        "IsIsomorphism" ] ) );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ "IsAutomorphism" ],
                             Range = [ "IsIsomorphism",
                                        @rec( Conditions = "IsEndomorphism",
                                             PrintString = "endo",
                                             Adjective = true,
                                             NoSepString = true) ] ) );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ "IsSplitMonomorphism" ],
                             Range = [ @rec( Conditions = "IsMonomorphism",
                                             PrintString = "mono",
                                             Adjective = true,
                                             NoSepString = true ) ] ) );
    
    AddRelationToGraph( print_graph,
                        @rec( Source = [ "IsSplitEpimorphism" ],
                             Range = [ @rec( Conditions = "IsEpimorphism",
                                             PrintString = "epi",
                                             Adjective = true,
                                             NoSepString = true ) ] ) );
    
    AddNodeToGraph( print_graph,
                    @rec( Conditions = "IsZeroForMorphisms",
                         PrintString = "zero",
                         Adjective = true ) );
    
    InstallPrintFunctionsOutOfPrintingGraph( print_graph, -1 );
    
end );

#= comment for Julia
CAP_INTERNAL_CREATE_MORPHISM_PRINT( );
# =#
