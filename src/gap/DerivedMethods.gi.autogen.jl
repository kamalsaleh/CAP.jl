# SPDX-License-Identifier: GPL-2.0-or-later
# CAP: Categories, Algorithms, Programming
#
# Implementations
#

###########################
##
## In a terminal category
##
###########################

AddDerivationToCAP( IsLiftable,
                    [ ],
                    
  function( cat, morphism1, morphism2 )
        
    ## equality of targets is part of the specification of the input && checked by the pre-function
    return true;
    
end; CategoryFilter = IsTerminalCategory,
      Description = "Two morphisms with equal targets are mutually liftable ⥉ a terminal category" );
    
AddDerivationToCAP( IsColiftable,
                    [ ],
                    
  function( cat, morphism1, morphism2 )
    
    ## equality of sources is part of the specification of the input && checked by the pre-function
    return true;
    
end; CategoryFilter = IsTerminalCategory,
                        Description = "Two morphisms with equal sources are mutually coliftable ⥉ a terminal category" );

###########################
##
## WithGiven pairs
##
###########################

AddDerivationToCAP( MorphismFromKernelObjectToSink,
                    [ [ KernelObject, 1 ],
                      [ ZeroMorphism, 1 ] ],
        
  function( cat, alpha )
    local K;
    
    K = KernelObject( cat, alpha );
    
    return ZeroMorphism( cat, K, Range( alpha ) );
    
  end; Description = "MorphismFromKernelObjectToSink as zero morphism from kernel object to range" );

##
AddWithGivenDerivationPairToCAP( KernelLift,
  function( cat, mor, test_object, test_morphism )
    
    return LiftAlongMonomorphism( cat, KernelEmbedding( cat, mor ), test_morphism );
    
  end,
  
  function( cat, mor, test_object, test_morphism, kernel )
    
    return LiftAlongMonomorphism( cat, KernelEmbeddingWithGivenKernelObject( cat, mor, kernel ), test_morphism );
    
end; Description = "KernelLift using LiftAlongMonomorphism && KernelEmbedding" );

##
AddDerivationToCAP( MorphismFromSourceToCokernelObject,
                    [ [ CokernelObject, 1 ],
                      [ ZeroMorphism, 1 ] ],
        
  function( cat, alpha )
    local C;
    
    C = CokernelObject( cat, alpha );
    
    return ZeroMorphism( cat, Source( alpha ), C );
    
  end; Description = "MorphismFromSourceToCokernelObject as zero morphism from source to cokernel object" );

##
AddWithGivenDerivationPairToCAP( CokernelColift,
  function( cat, mor, test_object, test_morphism )
    
    return ColiftAlongEpimorphism( cat, CokernelProjection( cat, mor ), test_morphism );
    
  end,

  function( cat, mor, test_object, test_morphism, cokernel )
      
      return ColiftAlongEpimorphism( cat, CokernelProjectionWithGivenCokernelObject( cat, mor, cokernel ), test_morphism );
      
end; Description = "CokernelColift using ColiftAlongEpimorphism && CokernelProjection" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismIntoDirectSum,
  function( cat, diagram, test_object, source )
    local nr_components;
    
    nr_components = Length( source );
    
    return Sum(
        List( (1):(nr_components), i -> PreCompose( cat, source[ i ], InjectionOfCofactorOfDirectSum( cat, diagram, i ) ) ),
        ZeroMorphism( cat, test_object, DirectSum( cat, diagram ) )
    );
    
  end,
  
  function( cat, diagram, test_object, source, direct_sum )
    local nr_components;
    
    nr_components = Length( source );
  
    return Sum(
        List( (1):(nr_components), i -> PreCompose( cat, source[ i ], InjectionOfCofactorOfDirectSumWithGivenDirectSum( cat, diagram, i, direct_sum ) ) ),
        ZeroMorphism( cat, test_object, direct_sum )
    );
  
end; CategoryFilter = IsAdditiveCategory,
      Description = "UniversalMorphismIntoDirectSum using the injections of the direct sum" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismFromDirectSum,
  
  function( cat, diagram, test_object, sink )
    local nr_components;
    
    nr_components = Length( sink );
    
    return Sum(
        List( (1):(nr_components), i -> PreCompose( cat, ProjectionInFactorOfDirectSum( cat, diagram, i ), sink[ i ] ) ),
        ZeroMorphism( cat, DirectSum( cat, diagram ), test_object )
    );
    
  end,
  
  function( cat, diagram, test_object, sink, direct_sum )
    local nr_components;
    
    nr_components = Length( sink );
    
    return Sum(
        List( (1):(nr_components), i -> PreCompose( cat, ProjectionInFactorOfDirectSumWithGivenDirectSum( cat, diagram, i, direct_sum ), sink[ i ] ) ),
        ZeroMorphism( cat, direct_sum, test_object )
    );
  
end; CategoryFilter = IsAdditiveCategory,
      Description = "UniversalMorphismFromDirectSum using projections of the direct sum" );

##
AddWithGivenDerivationPairToCAP( ProjectionInFactorOfDirectSum,
  
  function( cat, list, projection_number )
    local morphisms;
    
    morphisms = List( (1):(Length( list )), function( i )
        
        if i == projection_number
            
            return IdentityMorphism( cat, list[projection_number] );
            
        else
            
            return ZeroMorphism( cat, list[i], list[projection_number] );
            
        end;
        
    end );
    
    return UniversalMorphismFromDirectSum( cat, list, list[projection_number], morphisms );
    
  end,
  
  function( cat, list, projection_number, direct_sum_object )
    local morphisms;
    
    morphisms = List( (1):(Length( list )), function( i )
        
        if i == projection_number
            
            return IdentityMorphism( cat, list[projection_number] );
            
        else
            
            return ZeroMorphism( cat, list[i], list[projection_number] );
            
        end;
        
    end );
    
    return UniversalMorphismFromDirectSumWithGivenDirectSum( cat, list, list[projection_number], morphisms, direct_sum_object );
    
end; Description = "ProjectionInFactorOfDirectSum using UniversalMorphismFromDirectSum" );

##
AddWithGivenDerivationPairToCAP( InjectionOfCofactorOfDirectSum,
  
  function( cat, list, injection_number )
    local morphisms;
    
    morphisms = List( (1):(Length( list )), function( i )
        
        if i == injection_number
            
            return IdentityMorphism( cat, list[injection_number] );
            
        else
            
            return ZeroMorphism( cat, list[injection_number], list[i] );
            
        end;
        
    end );
    
    return UniversalMorphismIntoDirectSum( cat, list, list[injection_number], morphisms );
    
  end,
  
  function( cat, list, injection_number, direct_sum_object )
    local morphisms;
    
    morphisms = List( (1):(Length( list )), function( i )
        
        if i == injection_number
            
            return IdentityMorphism( cat, list[injection_number] );
            
        else
            
            return ZeroMorphism( cat, list[injection_number], list[i] );
            
        end;
        
    end );
    
    return UniversalMorphismIntoDirectSumWithGivenDirectSum( cat, list, list[injection_number], morphisms, direct_sum_object );
    
end; Description = "InjectionOfCofactorOfDirectSum using UniversalMorphismIntoDirectSum" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismIntoTerminalObject,
  
  function( cat, test_source )
    local terminal_object;
    
    terminal_object = TerminalObject( cat );
    
    return ZeroMorphism( cat, test_source, terminal_object );
    
  end,
  
  function( cat, test_source, terminal_object )
    
    return ZeroMorphism( cat, test_source, terminal_object );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "UniversalMorphismIntoTerminalObject computing the zero morphism" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismFromInitialObject,
  
  function( cat, test_sink )
    local initial_object;
    
    initial_object = InitialObject( cat );
    
    return ZeroMorphism( cat, initial_object, test_sink );
    
  end,
                 
  function( cat, test_sink, initial_object )
    
    return ZeroMorphism( cat, initial_object, test_sink );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "UniversalMorphismFromInitialObject computing the zero morphism" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismFromZeroObject,
  
  function( cat, test_sink )
    local zero_object;
    
    zero_object = ZeroObject( cat );
    
    return ZeroMorphism( cat, zero_object, test_sink );
    
  end,
  
  function( cat, test_sink, zero_object )
    
    return ZeroMorphism( cat, zero_object, test_sink );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "UniversalMorphismFromZeroObject computing the zero morphism" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismIntoZeroObject,
  
  function( cat, test_source )
    local zero_object;
    
    zero_object = ZeroObject( cat );
    
    return ZeroMorphism( cat, test_source, zero_object );
    
  end,
                 
  function( cat, test_source, zero_object )
    
    return ZeroMorphism( cat, test_source, zero_object );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "UniversalMorphismIntoZeroObject computing the zero morphism" );

## FiberProduct from DirectProduct && Equalizer

##
AddDerivationToCAP( FiberProduct,
      
  function( cat, diagram )
    
    return Source( IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram( cat, diagram ) );
    
end; Description = "FiberProduct as the source of IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram" );

##
AddDerivationToCAP( ProjectionInFactorOfFiberProduct,
                    [ [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
                      [ PreCompose, 3 ],
                      [ EmbeddingOfEqualizer, 1 ],
                      [ DirectProduct, 1 ],
                      [ ComponentOfMorphismIntoDirectProduct, 1 ],
                      [ IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram, 1 ] ],
        
  function( cat, diagram, projection_number )
    local D, direct_product, diagram_of_equalizer, iota;
    
    D = List( diagram, Source );
    
    direct_product = DirectProduct( cat, D );
    
    diagram_of_equalizer = List( (1):(Length( D )), i -> PreCompose( cat, ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat, D, i, direct_product ), diagram[i] ) );
    
    iota = EmbeddingOfEqualizer( cat, direct_product, diagram_of_equalizer );
    
    return PreCompose( cat, IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram( cat, diagram ), ComponentOfMorphismIntoDirectProduct( cat, iota, D, projection_number ) );
    
  end; Description = "ProjectionInFactorOfFiberProduct by composing the embedding of equalizer with the direct product projection" );

##
AddDerivationToCAP( UniversalMorphismIntoFiberProduct,
                    [ [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
                      [ PreCompose, 3 ],
                      [ UniversalMorphismIntoDirectProduct, 1 ],
                      [ UniversalMorphismIntoEqualizer, 1 ],
                      [ DirectProduct, 1 ],
                      [ IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct, 1 ] ],
        
  function( cat, diagram, test_object, tau )
    local D, direct_product, diagram_of_equalizer, chi, psi;
    
    D = List( diagram, Source );
    
    direct_product = DirectProduct( cat, D );
    
    diagram_of_equalizer = List( (1):(Length( D )), i -> PreCompose( cat, ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat, D, i, direct_product ), diagram[i] ) );
    
    chi = UniversalMorphismIntoDirectProduct( cat, D, test_object, tau );

    psi = UniversalMorphismIntoEqualizer( cat, direct_product, diagram_of_equalizer, test_object, chi );
    
    return PreCompose( cat, psi, IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct( cat, diagram ) );
    
  end; Description = "UniversalMorphismIntoFiberProduct as the universal morphism into equalizer of a univeral morphism into direct product" );

##
AddDerivationToCAP( MorphismFromFiberProductToSink,
                    [ [ ProjectionInFactorOfFiberProduct, 1 ],
                      [ PreCompose, 1 ] ],
        
  function( cat, diagram )
    local pi_1;
    
    pi_1 = ProjectionInFactorOfFiberProduct( cat, diagram, 1 );
    
    return PreCompose( cat, pi_1, diagram[1] );
    
  end; Description = "MorphismFromFiberProductToSink by composing the first projection with the first morphism ⥉ the diagram" );

## Pushout from Coproduct && Coequalizer

##
AddDerivationToCAP( Pushout,
      
  function( cat, diagram )
    
    return Range( IsomorphismFromCoequalizerOfCoproductDiagramToPushout( cat, diagram ) );
    
end; Description = "Pushout as the range of IsomorphismFromCoequalizerOfCoproductDiagramToPushout" );

##
AddDerivationToCAP( InjectionOfCofactorOfPushout,
                    [ [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
                      [ PreCompose, 3 ],
                      [ Coproduct, 1 ],
                      [ ProjectionOntoCoequalizer, 1 ],
                      [ ComponentOfMorphismFromCoproduct, 1 ],
                      [ IsomorphismFromCoequalizerOfCoproductDiagramToPushout, 1 ] ],
        
  function( cat, diagram, injection_number )
    local D, coproduct, diagram_of_coequalizer, pi;
    
    D = List( diagram, Range );
    
    coproduct = Coproduct( cat, D );
    
    diagram_of_coequalizer = List( (1):(Length( D )), i -> PreCompose( cat, diagram[i], InjectionOfCofactorOfCoproductWithGivenCoproduct( cat, D, i, coproduct ) ) );
    
    pi = ProjectionOntoCoequalizer( cat, coproduct, diagram_of_coequalizer );
    
    return PreCompose( cat, ComponentOfMorphismFromCoproduct( cat, pi, D, injection_number ), IsomorphismFromCoequalizerOfCoproductDiagramToPushout( cat, diagram ) );
    
  end; Description = "InjectionOfCofactorOfPushout by composing the coproduct injection with the projection onto coequalizer" );

##
AddDerivationToCAP( UniversalMorphismFromPushout,
                    [ [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
                      [ PreCompose, 3 ],
                      [ UniversalMorphismFromCoproduct, 1 ],
                      [ UniversalMorphismFromCoequalizer, 1 ],
                      [ Coproduct, 1 ],
                      [ IsomorphismFromPushoutToCoequalizerOfCoproductDiagram, 1 ] ],
        
  function( cat, diagram, test_object, tau )
    local D, coproduct, diagram_of_coequalizer, chi, psi;
    
    D = List( diagram, Range );
    
    coproduct = Coproduct( cat, D );
    
    diagram_of_coequalizer = List( (1):(Length( D )), i -> PreCompose( cat, diagram[i], InjectionOfCofactorOfCoproductWithGivenCoproduct( cat, D, i, coproduct ) ) );
    
    chi = UniversalMorphismFromCoproduct( cat, D, test_object, tau );
    
    psi = UniversalMorphismFromCoequalizer( cat, coproduct, diagram_of_coequalizer, test_object, chi );
    
    return PreCompose( cat, IsomorphismFromPushoutToCoequalizerOfCoproductDiagram( cat, diagram ), psi );
    
  end; Description = "UniversalMorphismFromPushout as the universal morphism from coequalizer of a univeral morphism from coproduct" );

##
AddDerivationToCAP( MorphismFromSourceToPushout,
                    [ [ InjectionOfCofactorOfPushout, 1 ],
                      [ PreCompose, 1 ] ],
  
  function( cat, diagram )
    local iota_1;
    
    iota_1 = InjectionOfCofactorOfPushout( cat, diagram, 1 );
    
    return PreCompose( cat, diagram[1], iota_1 );
    
  end; Description = "MorphismFromSourceToPushout by composing the first morphism ⥉ the diagram with the first injection" );

##
AddDerivationToCAP( UniversalMorphismFromZeroObject,
                    [ [ IsomorphismFromZeroObjectToInitialObject, 1 ],
                      [ UniversalMorphismFromInitialObject, 1 ],
                      [ PreCompose, 1 ] ],
                  
  function( cat, obj )
    
    return PreCompose( cat, IsomorphismFromZeroObjectToInitialObject( cat ),
                       UniversalMorphismFromInitialObject( cat, obj ) );
    
  end; Description = "UniversalMorphismFromZeroObject using UniversalMorphismFromInitialObject" );

##
AddDerivationToCAP( UniversalMorphismIntoZeroObject,
                    [ [ UniversalMorphismIntoTerminalObject, 1 ],
                      [ IsomorphismFromTerminalObjectToZeroObject, 1 ],
                      [ PreCompose, 1 ] ],
                  
  function( cat, obj )
    
    return PreCompose( cat, UniversalMorphismIntoTerminalObject( cat, obj ),
                       IsomorphismFromTerminalObjectToZeroObject( cat ) );
  end; Description = "UniversalMorphismIntoZeroObject using UniversalMorphismIntoTerminalObject" );

##
AddDerivationToCAP( ProjectionInFactorOfDirectSum,
                    [ [ IsomorphismFromDirectSumToDirectProduct, 1 ],
                      [ ProjectionInFactorOfDirectProduct, 1 ],
                      [ PreCompose, 1 ] ],
                
  function( cat, diagram, projection_number )
    
    return PreCompose( cat, IsomorphismFromDirectSumToDirectProduct( cat, diagram ),
                       ProjectionInFactorOfDirectProduct( cat, diagram, projection_number ) );
    
  end; Description = "ProjectionInFactorOfDirectSum using ProjectionInFactorOfDirectProduct" );

##
AddDerivationToCAP( UniversalMorphismIntoDirectSum,
                    [ [ UniversalMorphismIntoDirectProduct, 1 ],
                      [ IsomorphismFromDirectProductToDirectSum, 1 ],
                      [ PreCompose, 1 ] ],
                    
  function( cat, diagram, test_object, source )
    
    return PreCompose( cat, UniversalMorphismIntoDirectProduct( cat, diagram, test_object, source ),
                       IsomorphismFromDirectProductToDirectSum( cat, diagram ) );
  end; Description = "UniversalMorphismIntoDirectSum using UniversalMorphismIntoDirectProduct" );

##
AddDerivationToCAP( ComponentOfMorphismIntoDirectSum,
                    [ [ IsomorphismFromDirectSumToDirectProduct, 1 ],
                      [ ComponentOfMorphismIntoDirectProduct, 1 ],
                      [ PreCompose, 1 ] ],
                   
  function( cat, alpha, summands, nr )
    
    return ComponentOfMorphismIntoDirectProduct( cat,
        PreCompose( cat, alpha, IsomorphismFromDirectSumToDirectProduct( cat, summands ) ),
        summands,
        nr
    );
    
  end; Description = "ComponentOfMorphismIntoDirectSum using ComponentOfMorphismIntoDirectProduct" );

##
AddDerivationToCAP( InjectionOfCofactorOfDirectSum,
                    [ [ InjectionOfCofactorOfCoproduct, 1 ],
                      [ IsomorphismFromCoproductToDirectSum, 1 ],
                      [ PreCompose, 1 ] ],
                    
  function( cat, diagram, injection_number )
    
    return PreCompose( cat, InjectionOfCofactorOfCoproduct( cat, diagram, injection_number ),
                       IsomorphismFromCoproductToDirectSum( cat, diagram ) );
  end; Description = "InjectionOfCofactorOfDirectSum using InjectionOfCofactorOfCoproduct" );

##
AddDerivationToCAP( UniversalMorphismFromDirectSum,
                    [ [ IsomorphismFromDirectSumToCoproduct, 1 ],
                      [ UniversalMorphismFromCoproduct, 1 ],
                      [ PreCompose, 1 ] ],
                    
  function( cat, diagram, test_object, sink )
    
    return PreCompose( cat, IsomorphismFromDirectSumToCoproduct( cat, diagram ),
                       UniversalMorphismFromCoproduct( cat, diagram, test_object, sink ) );
  end; Description = "UniversalMorphismFromDirectSum using UniversalMorphismFromCoproduct" );

##
AddDerivationToCAP( ComponentOfMorphismFromDirectSum,
                    [ [ IsomorphismFromCoproductToDirectSum, 1 ],
                      [ ComponentOfMorphismFromCoproduct, 1 ],
                      [ PreCompose, 1 ] ],
                   
  function( cat, alpha, summands, nr )
    
    return ComponentOfMorphismFromCoproduct( cat,
        PreCompose( cat, IsomorphismFromCoproductToDirectSum( cat, summands ), alpha ),
        summands,
        nr
    );
    
  end; Description = "ComponentOfMorphismFromDirectSum using ComponentOfMorphismFromCoproduct" );

##
AddDerivationToCAP( UniversalMorphismIntoTerminalObject,
                    [ [ UniversalMorphismIntoZeroObject, 1 ],
                      [ IsomorphismFromZeroObjectToTerminalObject, 1 ],
                      [ PreCompose, 1 ] ],
  
  function( cat, obj )
    
    return PreCompose( cat, UniversalMorphismIntoZeroObject( cat, obj ),
                       IsomorphismFromZeroObjectToTerminalObject( cat ) );
    
  end; Description = "UniversalMorphismFromInitialObject using UniversalMorphismFromZeroObject" );

##
AddDerivationToCAP( UniversalMorphismFromInitialObject,
                    [ [ IsomorphismFromInitialObjectToZeroObject, 1 ],
                      [ UniversalMorphismFromZeroObject, 1 ],
                      [ PreCompose, 1 ] ],
  
  function( cat, obj )
    
    return PreCompose( cat, IsomorphismFromInitialObjectToZeroObject( cat ),
                       UniversalMorphismFromZeroObject( cat, obj ) );
    
  end; Description = "UniversalMorphismFromInitialObject using UniversalMorphismFromZeroObject" );

##
AddDerivationToCAP( ProjectionInFactorOfDirectProduct,
                    [ [ IsomorphismFromDirectProductToDirectSum, 1 ],
                      [ ProjectionInFactorOfDirectSum, 1 ],
                      [ PreCompose, 1 ] ],
  
  function( cat, diagram, projection_number )
    
    return PreCompose( cat, IsomorphismFromDirectProductToDirectSum( cat, diagram ),
                       ProjectionInFactorOfDirectSum( cat, diagram, projection_number ) );
  end; Description = "ProjectionInFactorOfDirectProduct using ProjectionInFactorOfDirectSum" );

##
AddDerivationToCAP( UniversalMorphismIntoDirectProduct,
                    [ [ UniversalMorphismIntoDirectSum, 1 ],
                      [ IsomorphismFromDirectSumToDirectProduct, 1 ],
                      [ PreCompose, 1 ] ],
                    
  function( cat, diagram, test_object, source )
    
    return PreCompose( cat, UniversalMorphismIntoDirectSum( cat, diagram, test_object, source ),
                       IsomorphismFromDirectSumToDirectProduct( cat, diagram ) );
    
  end; Description = "UniversalMorphismIntoDirectProduct using UniversalMorphismIntoDirectSum" );

##
AddDerivationToCAP( ComponentOfMorphismIntoDirectProduct,
                    [ [ IsomorphismFromDirectProductToDirectSum, 1 ],
                      [ ComponentOfMorphismIntoDirectSum, 1 ],
                      [ PreCompose, 1 ] ],
                   
  function( cat, alpha, factors, nr )
    
    return ComponentOfMorphismIntoDirectSum( cat,
        PreCompose( cat, alpha, IsomorphismFromDirectProductToDirectSum( cat, factors ) ),
        factors,
        nr
    );
    
  end; Description = "ComponentOfMorphismIntoDirectProduct using ComponentOfMorphismIntoDirectSum" );

##
AddDerivationToCAP( InjectionOfCofactorOfCoproduct,
                    [ [ InjectionOfCofactorOfDirectSum, 1 ],
                      [ IsomorphismFromDirectSumToCoproduct, 1 ],
                      [ PreCompose, 1 ] ],
                      
  function( cat, diagram, injection_number )
    
    return PreCompose( cat, InjectionOfCofactorOfDirectSum( cat, diagram, injection_number ),
                       IsomorphismFromDirectSumToCoproduct( cat, diagram ) );
  end; Description = "InjectionOfCofactorOfCoproduct using InjectionOfCofactorOfDirectSum" );

##
AddDerivationToCAP( UniversalMorphismFromCoproduct,
                    [ [ IsomorphismFromCoproductToDirectSum, 1 ],
                      [ UniversalMorphismFromDirectSum, 1 ],
                      [ PreCompose, 1 ] ],
                    
  function( cat, diagram, test_object, sink )
    
    return PreCompose( cat, IsomorphismFromCoproductToDirectSum( cat, diagram ),
                       UniversalMorphismFromDirectSum( cat, diagram, test_object, sink ) );
  end; Description = "UniversalMorphismFromCoproduct using UniversalMorphismFromDirectSum" );

##
AddDerivationToCAP( ComponentOfMorphismFromCoproduct,
                    [ [ IsomorphismFromDirectSumToCoproduct, 1 ],
                      [ ComponentOfMorphismFromDirectSum, 1 ],
                      [ PreCompose, 1 ] ],
                   
  function( cat, alpha, cofactors, nr )
    
    return ComponentOfMorphismFromDirectSum( cat,
        PreCompose( cat, IsomorphismFromDirectSumToCoproduct( cat, cofactors ), alpha ),
        cofactors,
        nr
    );
    
  end; Description = "ComponentOfMorphismFromCoproduct using ComponentOfMorphismFromDirectSum" );

##
AddDerivationToCAP( UniversalMorphismIntoEqualizer,
                    [ [ JointPairwiseDifferencesOfMorphismsIntoDirectProduct, 1 ],
                      [ KernelLift, 1 ],
                      [ IsomorphismFromKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProductToEqualizer, 1 ],
                      [ PreCompose, 1 ] ],
                                       
  function( cat, A, diagram, test_object, tau )
    local joint_pairwise_differences, kernel_lift;
    
    joint_pairwise_differences = JointPairwiseDifferencesOfMorphismsIntoDirectProduct( cat, A, diagram );
    
    kernel_lift = KernelLift( cat, joint_pairwise_differences, test_object, tau );
    
    return PreCompose( cat,
             kernel_lift,
             IsomorphismFromKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProductToEqualizer( cat, A, diagram )
           );
    
  end; Description = "UniversalMorphismIntoEqualizer using the universality of the kernel representation of the equalizer" );

##
AddDerivationToCAP( UniversalMorphismFromCoequalizer,
                    [ [ JointPairwiseDifferencesOfMorphismsFromCoproduct, 1 ],
                      [ CokernelColift, 1 ],
                      [ IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct, 1 ],
                      [ PreCompose, 1 ] ],
                            
  function( cat, A, diagram, test_object, tau )
    local joint_pairwise_differences, cokernel_colift;
    
    joint_pairwise_differences = JointPairwiseDifferencesOfMorphismsFromCoproduct( cat, A, diagram );
    
    cokernel_colift = CokernelColift( cat, joint_pairwise_differences, test_object, tau );
    
    return PreCompose( cat,
             IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct( cat, A, diagram ),
             cokernel_colift
           );
    
  end; Description = "UniversalMorphismFromCoequalizer using the universality of the cokernel representation of the coequalizer" );

##
AddDerivationToCAP( ImageEmbedding,
                    [ [ CokernelProjection, 1 ],
                      [ KernelEmbedding, 1 ],
                      [ IsomorphismFromImageObjectToKernelOfCokernel, 1 ],
                      [ PreCompose, 1 ] ],
                      
  function( cat, mor )
    local image_embedding;
    
    image_embedding = KernelEmbedding( cat, CokernelProjection( cat, mor ) );
    
    return PreCompose( cat, IsomorphismFromImageObjectToKernelOfCokernel( cat, mor ),
                       image_embedding );
  
  end; CategoryFilter = IsAbelianCategory, ##FIXME: PreAbelian?
      Description = "ImageEmbedding as the kernel embedding of the cokernel projection"
);

##
AddDerivationToCAP( CoimageProjection,
                    [ [ KernelEmbedding, 1 ],
                      [ CokernelProjection, 1 ],
                      [ IsomorphismFromCokernelOfKernelToCoimage, 1 ],
                      [ PreCompose, 1 ] ],
  
  function( cat, mor )
    local coimage_projection;
    
    coimage_projection = CokernelProjection( cat, KernelEmbedding( cat, mor ) );
    
    return PreCompose( cat, coimage_projection,
                       IsomorphismFromCokernelOfKernelToCoimage( cat, mor ) );
    
end; CategoryFilter = IsAbelianCategory, ##FIXME: PreAbelian?
      Description = "CoimageProjection as the cokernel projection of the kernel embedding" );

##
AddDerivationToCAP( CoimageProjection,
                    [ [ CanonicalIdentificationFromImageObjectToCoimage, 1 ],
                      [ CoastrictionToImage, 1 ],
                      [ PreCompose, 1 ] ],
  
  function( cat, mor )
    local iso;
    
    iso = CanonicalIdentificationFromImageObjectToCoimage( cat, mor );
    
    return PreCompose( cat, CoastrictionToImage( cat, mor ), iso );
    
end; Description = "CoimageProjection as the coastriction to image" );

##
AddWithGivenDerivationPairToCAP( CoastrictionToImage,
                      
  function( cat, morphism )
    local image_embedding;
    
    image_embedding = ImageEmbedding( cat, morphism );
    
    return LiftAlongMonomorphism( cat, image_embedding, morphism );
  
  end,
  
  function( cat, morphism, image )
    local image_embedding;
    
    image_embedding = ImageEmbeddingWithGivenImageObject( cat, morphism, image );
    
    return LiftAlongMonomorphism( cat, image_embedding, morphism );
  
end; Description = "CoastrictionToImage using that image embedding can be seen as a kernel" );

##
AddWithGivenDerivationPairToCAP( AstrictionToCoimage,
          
  function( cat, morphism )
    local coimage_projection;
    
    coimage_projection = CoimageProjection( cat, morphism );
    
    return ColiftAlongEpimorphism( cat, coimage_projection, morphism );
    
  end,
  
  function( cat, morphism, coimage )
    local coimage_projection;
    
    coimage_projection = CoimageProjectionWithGivenCoimageObject( cat, morphism, coimage );
    
    return ColiftAlongEpimorphism( cat, coimage_projection, morphism );
    
end; Description = "AstrictionToCoimage using that coimage projection can be seen as a cokernel" );

##
AddWithGivenDerivationPairToCAP( AstrictionToCoimage,
          
  function( cat, morphism )
    local image_emb;
    
    image_emb = ImageEmbedding( cat, morphism );
    
    return PreCompose( cat, CanonicalIdentificationFromCoimageToImageObject( cat, morphism ), image_emb );
    
  end,
  
  function( cat, morphism, coimage )
    local image_emb;
    
    image_emb = ImageEmbedding( cat, morphism );
    
    return PreCompose( cat, CanonicalIdentificationFromCoimageToImageObject( cat, morphism ), image_emb );
    
end; Description = "AstrictionToCoimage as the image embedding" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismFromImage,
                      
  function( cat, morphism, test_factorization )
    local image_embedding;
    
    image_embedding = ImageEmbedding( cat, morphism );
    
    return LiftAlongMonomorphism( cat, test_factorization[2], image_embedding );
    
  end,
  
  function( cat, morphism, test_factorization, image )
    local image_embedding;
    
    image_embedding = ImageEmbeddingWithGivenImageObject( cat, morphism, image );
    
    return LiftAlongMonomorphism( cat, test_factorization[2], image_embedding );
    
end; Description = "UniversalMorphismFromImage using ImageEmbedding && LiftAlongMonomorphism" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismIntoCoimage,
  
  function( cat, morphism, test_factorization )
    local coimage_projection;
    
    coimage_projection = CoimageProjection( cat, morphism );
    
    return ColiftAlongEpimorphism( cat, test_factorization[1], coimage_projection );
    
  end,
  
  function( cat, morphism, test_factorization, coimage )
    local coimage_projection;
    
    coimage_projection = CoimageProjectionWithGivenCoimageObject( cat, morphism, coimage );
    
    return ColiftAlongEpimorphism( cat, test_factorization[1], coimage_projection );
    
end; Description = "UniversalMorphismIntoCoimage using CoimageProjection && ColiftAlongEpimorphism" );

##
AddDerivationToCAP( UniversalMorphismIntoCoimage,
                    [ [ UniversalMorphismFromImage, 1 ],
                      [ CanonicalIdentificationFromImageObjectToCoimage, 1 ],
                      [ InverseForMorphisms, 1 ],
                      [ PreCompose, 1 ] ],
  
  function( cat, morphism, test_factorization )
    local induced_mor;
    
    induced_mor = UniversalMorphismFromImage( cat, morphism, test_factorization );
    
    return PreCompose( cat, InverseForMorphisms( cat, induced_mor ), CanonicalIdentificationFromImageObjectToCoimage( cat, morphism ) );
    
  end; Description = "UniversalMorphismIntoCoimage using UniversalMorphismFromImage && CanonicalIdentificationFromImageObjectToCoimage" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismIntoEqualizer,
  function( cat, A, diagram, test_object, test_morphism )
    
    return LiftAlongMonomorphism( cat, EmbeddingOfEqualizer( cat, A, diagram ), test_morphism );
    
  end,
  
  function( cat, A, diagram, test_object, test_morphism, equalizer )
    
    return LiftAlongMonomorphism( cat, EmbeddingOfEqualizerWithGivenEqualizer( cat, A, diagram, equalizer ), test_morphism );
    
end; Description = "UniversalMorphismIntoEqualizer using LiftAlongMonomorphism && EmbeddingOfEqualizer" );

##
AddDerivationToCAP( MorphismFromEqualizerToSink,
                    [ [ EmbeddingOfEqualizer, 1 ],
                      [ PreCompose, 1 ] ],
        
  function( cat, A, diagram )
    local iota;
    
    iota = EmbeddingOfEqualizer( cat, A, diagram );
    
    return PreCompose( cat, iota, diagram[1] );
    
  end; Description = "MorphismFromEqualizerToSink by composing the embedding with the first morphism ⥉ the diagram" );

##
AddWithGivenDerivationPairToCAP( UniversalMorphismFromCoequalizer,
  function( cat, A, diagram, test_object, test_morphism )
    
    return ColiftAlongEpimorphism( cat, ProjectionOntoCoequalizer( cat, A, diagram ), test_morphism );
    
  end,

  function( cat, A, diagram, test_object, test_morphism, coequalizer )
      
      return ColiftAlongEpimorphism( cat, ProjectionOntoCoequalizerWithGivenCoequalizer( cat, A, diagram, coequalizer ), test_morphism );
      
end; Description = "UniversalMorphismFromCoequalizer using ColiftAlongEpimorphism && ProjectionOntoCoequalizer" );

##
AddDerivationToCAP( MorphismFromSourceToCoequalizer,
                    [ [ ProjectionOntoCoequalizer, 1 ],
                      [ PreCompose, 1 ] ],
  
  function( cat, A, diagram )
    local pi;
    
    pi = ProjectionOntoCoequalizer( cat, A, diagram );
    
    return PreCompose( cat, diagram[1], pi );
    
  end; Description = "MorphismFromSourceToCoequalizer by composing the first morphism ⥉ the diagram with the projection" );

##
AddDerivationToCAP( ImageObjectFunctorialWithGivenImageObjects,
                    [ [ LiftAlongMonomorphism, 1 ],
                      [ ImageEmbeddingWithGivenImageObject, 2 ],
                      [ PreCompose, 1 ] ],
        
  function( cat, I, alpha, nu, alphap, Ip )
    
    return LiftAlongMonomorphism( cat,
                   ImageEmbeddingWithGivenImageObject( cat, alphap, Ip ),
                   PreCompose( cat, ImageEmbeddingWithGivenImageObject( cat, alpha, I ), nu ) );
    
end; Description = "ImageObjectFunctorialWithGivenImageObjects using the universality" );

##
AddDerivationToCAP( CoimageObjectFunctorialWithGivenCoimageObjects,
                    [ [ ColiftAlongEpimorphism, 1 ],
                      [ CoimageProjectionWithGivenCoimageObject, 2 ],
                      [ PreCompose, 1 ] ],
        
  function( cat, C, alpha, mu, alphap, Cp )
    
    return ColiftAlongEpimorphism( cat,
                   CoimageProjectionWithGivenCoimageObject( cat, alpha, C ),
                   PreCompose( cat, mu, CoimageProjectionWithGivenCoimageObject( cat, alphap, Cp ) ) );
    
end; Description = "CoimageObjectFunctorialWithGivenCoimageObjects using the universality" );

##
AddDerivationToCAP( ProjectiveCoverObject,
                    [ [ EpimorphismFromProjectiveCoverObject, 1 ] ],
                    
  function( cat, obj )
    
    return Source( EpimorphismFromProjectiveCoverObject( cat, obj ) );
    
end; Description = "ProjectiveCoverObject as the source of EpimorphismFromProjectiveCoverObject" );

##
AddDerivationToCAP( InjectiveEnvelopeObject,
                    [ [ MonomorphismIntoInjectiveEnvelopeObject, 1 ] ],
                    
  function( cat, obj )
    
    return Range( MonomorphismIntoInjectiveEnvelopeObject( cat, obj ) );
    
end; Description = "InjectiveEnvelopeObject as the range of MonomorphismIntoInjectiveEnvelopeObject" );

###########################
##
## Methods returning a boolean
##
###########################

##
AddDerivationToCAP( IsBijectiveObject,
                    [ [ IsProjective, 1 ],
                      [ IsInjective, 1 ] ],
                    
  function( cat, object )
    
    return IsProjective( cat, object ) && IsInjective( cat, object );
    
end; Description = "IsBijectiveObject by checking if the object is both projective && injective" );

##
AddDerivationToCAP( IsProjective,
                    [ [ IsLiftable, 1 ],
                      [ EpimorphismFromSomeProjectiveObject, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    
  function( cat, object )
    
    return IsLiftable( cat,
      IdentityMorphism( cat, object ),
      EpimorphismFromSomeProjectiveObject( cat, object )
    );
    
end; Description = "IsProjective by checking if the object is a summand of some projective object" );

##
AddDerivationToCAP( IsInjective,
                    [ [ IsColiftable, 1 ],
                      [ MonomorphismIntoSomeInjectiveObject, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    
  function( cat, object )
    
    return IsColiftable( cat,
      MonomorphismIntoSomeInjectiveObject( cat, object ),
      IdentityMorphism( cat, object )
    );
    
end; Description = "IsInjective by checking if the object is a summand of some injective object" );

##
AddDerivationToCAP( IsOne,
                    [ [ IdentityMorphism, 1 ],
                      [ IsCongruentForMorphisms, 1 ] ],
                    
  function( cat, morphism )
    local object;
    
    object = Source( morphism );
    
    return IsCongruentForMorphisms( cat, IdentityMorphism( cat, object ), morphism );
    
end; Description = "IsOne by comparing with the identity morphism" );

##
AddDerivationToCAP( IsEndomorphism,
                    [ [ IsEqualForObjects, 1 ] ],
                      
  function( cat, morphism )
    
    return IsEqualForObjects( cat, Source( morphism ), Range( morphism ) );
    
end; Description = "IsEndomorphism by deciding whether source && range are equal as objects" );

##
AddDerivationToCAP( IsAutomorphism,
                    [ [ IsEndomorphism, 1 ],
                      [ IsIsomorphism, 1 ] ],
                    
  function( cat, morphism )
    
    return IsEndomorphism( cat, morphism ) && IsIsomorphism( cat, morphism );
    
end; Description = "IsAutomorphism by checking IsEndomorphism && IsIsomorphism");

##
AddDerivationToCAP( IsZeroForMorphisms,
                    [ [ ZeroMorphism, 1 ],
                      [ IsCongruentForMorphisms, 1 ] ],
                      
  function( cat, morphism )
    local zero_morphism;
    
    zero_morphism = ZeroMorphism( cat, Source( morphism ), Range( morphism ) );
    
    return IsCongruentForMorphisms( cat, zero_morphism, morphism );
    
end; Description = "IsZeroForMorphisms by deciding whether the given morphism is congruent to the zero morphism" );

##
AddDerivationToCAP( IsEqualToIdentityMorphism,
                    [ [ IsEqualForMorphismsOnMor, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    
  function( cat, morphism )
    
    return IsEqualForMorphismsOnMor( cat, morphism, IdentityMorphism( cat, Source( morphism ) ) );
    
end; Description = "IsEqualToIdentityMorphism using IsEqualForMorphismsOnMor && IdentityMorphism" );

##
AddDerivationToCAP( IsEqualToZeroMorphism,
                    
  function( cat, morphism )
    
    return IsEqualForMorphisms( cat, morphism, ZeroMorphism( cat, Source( morphism ), Range( morphism ) ) );
    
end; Description = "IsEqualToZeroMorphism using IsEqualForMorphisms && ZeroMorphism" );

##
AddDerivationToCAP( IsZeroForObjects,
                    [ [ IsCongruentForMorphisms, 1 ],
                      [ IdentityMorphism, 1 ],
                      [ ZeroMorphism, 1 ] ],
                 
  function( cat, object )
  
    return IsCongruentForMorphisms( cat, IdentityMorphism( cat, object ), ZeroMorphism( cat, object, object ) );
    
end; Description = "IsZeroForObjects by comparing identity morphism with zero morphism" );

##
AddDerivationToCAP( IsTerminal,
                  
  function( cat, object )
    
    return IsZeroForObjects( cat, object );
    
end; Description = "IsTerminal using IsZeroForObjects",
      CategoryFilter = IsAdditiveCategory ); #Ab-Category?

##
AddDerivationToCAP( IsTerminal,
                  
  function( cat, object )
    
    return IsIsomorphism( cat, UniversalMorphismIntoTerminalObject( cat, object ) );
    
end; Description = "IsTerminal using IsIsomorphism( cat, UniversalMorphismIntoTerminalObject )" );

##
AddDerivationToCAP( IsInitial,
                  
  function( cat, object )
    
    return IsZeroForObjects( cat, object );
    
end; Description = "IsInitial using IsZeroForObjects",
      CategoryFilter = IsAdditiveCategory ); #Ab-Category?

##
AddDerivationToCAP( IsInitial,
                  
  function( cat, object )
    
    return IsIsomorphism( cat, UniversalMorphismFromInitialObject( cat, object ) );
    
end; Description = "IsInitial using IsIsomorphism( cat, UniversalMorphismFromInitialObject )" );

##
AddDerivationToCAP( IsEqualForMorphismsOnMor,
                    [ [ IsEqualForMorphisms, 1 ],
                      [ IsEqualForObjects, 2 ] ],
                    
  function( cat, morphism_1, morphism_2 )
    local value_1, value_2;
    
    value_1 = IsEqualForObjects( cat, Source( morphism_1 ), Source( morphism_2 ) );
    
    value_2 = IsEqualForObjects( cat, Range( morphism_1 ), Range( morphism_2 ) );
    
    # See https://github.com/homalg-project/CAP_project/issues/595 for a discussion
    # why we might (not) want to allow IsEqualForObjects to return fail.
    # In any case, this currently is !officially supported, so CompilerForCAP can ignore this case.
    #% CAP_JIT_DROP_NEXT_STATEMENT
    if value_1 == fail || value_2 == fail
        
        return fail;
        
    end;
    
    if value_1 && value_2
        
        return IsEqualForMorphisms( cat, morphism_1, morphism_2 );
        
    else
        
        return false;
        
    end;
    
end; Description = "IsEqualForMorphismsOnMor using IsEqualForMorphisms" );

##
AddDerivationToCAP( IsIdempotent,
  function( cat, morphism )
    
    return IsCongruentForMorphisms( cat, PreCompose( cat, morphism, morphism ), morphism );
    
end; Description = "IsIdempotent by comparing the square of the morphism with itself" );

##
AddDerivationToCAP( IsMonomorphism,
                    [ [ IsZeroForObjects, 1 ],
                      [ KernelObject, 1 ] ],
  function( cat, morphism )
    
    return IsZeroForObjects( cat, KernelObject( cat, morphism ) );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "IsMonomorphism by deciding if the kernel is a zero object" );

##
AddDerivationToCAP( IsMonomorphism,
                    [ [ IsIsomorphism, 1 ],
                      [ IdentityMorphism, 1 ],
                      [ UniversalMorphismIntoFiberProduct, 1 ] ],
                 
  function( cat, morphism )
    local pullback_diagram, pullback_projection_1, pullback_projection_2, identity, diagonal_morphism;
      
      pullback_diagram = [ morphism, morphism ];
      
      identity = IdentityMorphism( cat, Source( morphism ) );
      
      diagonal_morphism = UniversalMorphismIntoFiberProduct( cat, pullback_diagram, [ identity, identity ] );
      
      return IsIsomorphism( cat, diagonal_morphism );
    
end; Description = "IsMonomorphism by deciding if the diagonal morphism is an isomorphism" );

##
AddDerivationToCAP( IsEpimorphism,
                    [ [ IsZeroForObjects, 1 ],
                      [ CokernelObject, 1 ] ],
  function( cat, morphism )
    
    return IsZeroForObjects( cat, CokernelObject( cat, morphism ) );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "IsEpimorphism by deciding if the cokernel is a zero object" );

##
AddDerivationToCAP( IsEpimorphism,
                    [ [ IdentityMorphism, 1 ],
                      [ UniversalMorphismFromPushout, 1 ],
                      [ IsIsomorphism, 1 ] ],
                 
  function( cat, morphism )
    local pushout_diagram, identity, codiagonal_morphism;
      
      pushout_diagram = [ morphism, morphism ];
      
      identity = IdentityMorphism( cat, Range( morphism ) );
      
      codiagonal_morphism = UniversalMorphismFromPushout( cat, pushout_diagram, [ identity, identity ] );
      
      return IsIsomorphism( cat, codiagonal_morphism );
    
end; Description = "IsEpimorphism by deciding if the codiagonal morphism is an isomorphism" );

##
AddDerivationToCAP( IsIsomorphism,
                    [ [ IsMonomorphism, 1 ],
                      [ IsEpimorphism, 1 ] ],
                 
  function( cat, morphism )
    
    return IsMonomorphism( cat, morphism ) && IsEpimorphism( cat, morphism );
    
end; CategoryFilter = IsAbelianCategory,
      Description = "IsIsomorphism by deciding if it is a mono && an epi" );

##
AddDerivationToCAP( IsIsomorphism,
                    [ [ IsSplitMonomorphism, 1 ],
                      [ IsSplitEpimorphism, 1 ] ],
                 
  function( cat, morphism )
    
    return IsSplitMonomorphism( cat, morphism ) && IsSplitEpimorphism( cat, morphism );
    
end; Description = "IsIsomorphism by deciding if it is a split mono && a split epi" );

##
AddDerivationToCAP( IsIsomorphism,
                    [ [ IsSplitMonomorphism, 1 ],
                      [ IsEpimorphism, 1 ] ],
                 
  function( cat, morphism )
    
    return IsSplitMonomorphism( cat, morphism ) && IsEpimorphism( cat, morphism );
    
end; Description = "IsIsomorphism by deciding if it is a split mono && an epi" );

##
AddDerivationToCAP( IsIsomorphism,
                    [ [ IsMonomorphism, 1 ],
                      [ IsSplitEpimorphism, 1 ] ],
                 
  function( cat, morphism )
    
    return IsMonomorphism( cat, morphism ) && IsSplitEpimorphism( cat, morphism );
    
end; Description = "IsIsomorphism by deciding if it is a mono && a split epi" );

##
AddDerivationToCAP( IsSplitEpimorphism,
                    [ [ IsLiftable, 1 ],
                      [ IdentityMorphism, 1 ] ],
  
  function( cat, morphism )
    
    return IsLiftable( cat, IdentityMorphism( cat, Range( morphism ) ), morphism );
  
end; Description = "IsSplitEpimorphism by using IsLiftable" );

##
AddDerivationToCAP( IsSplitMonomorphism,
                    [ [ IsColiftable, 1 ],
                      [ IdentityMorphism, 1 ] ],
  
  function( cat, morphism )
    
    return IsColiftable( cat, morphism, IdentityMorphism( cat, Source( morphism ) ) );
  
end; Description = "IsSplitMonomorphism by using IsColiftable" );

##
AddDerivationToCAP( IsEqualAsSubobjects,
                    [ [ IsDominating, 2 ] ],
               
  function( cat, sub1, sub2 )
    
    return IsDominating( cat, sub1, sub2 ) && IsDominating( cat, sub2, sub1 );
    
end; Description = "IsEqualAsSubobjects(sub1, sub2) if sub1 dominates sub2 && vice versa" );

##
AddDerivationToCAP( IsEqualAsFactorobjects,
                    [ [ IsCodominating, 2 ] ],
                                  
  function( cat, factor1, factor2 )
    
    return IsCodominating( cat, factor1, factor2 ) && IsCodominating( cat, factor2, factor1 );
    
end; Description = "IsEqualAsFactorobjects(factor1, factor2) if factor1 dominates factor2 && vice versa" );

##
AddDerivationToCAP( IsDominating,
  function( cat, sub1, sub2 )
    
    return IsLiftableAlongMonomorphism( cat, sub2, sub1 );
    
end; Description = "IsDominating using IsLiftableAlongMonomorphism" );

##
AddDerivationToCAP( IsDominating,
                    [ [ CokernelProjection, 2 ],
                      [ IsCodominating, 1 ] ],
                                  
  function( cat, sub1, sub2 )
    local cokernel_projection_1, cokernel_projection_2;
    
    cokernel_projection_1 = CokernelProjection( cat, sub1 );
    
    cokernel_projection_2 = CokernelProjection( cat, sub2 );
    
    return IsCodominating( cat, cokernel_projection_1, cokernel_projection_2 );
    
end; Description = "IsDominating using IsCodominating && duality by cokernel" );

##
AddDerivationToCAP( IsDominating,
                    [ [ CokernelProjection, 1 ],
                      [ PreCompose, 1 ],
                      [ IsZeroForMorphisms, 1 ] ],
                                  
  function( cat, sub1, sub2 )
    local cokernel_projection, composition;
    
    cokernel_projection = CokernelProjection( cat, sub2 );
    
    composition = PreCompose( cat, sub1, cokernel_projection );
    
    return IsZeroForMorphisms( cat, composition );
    
end; Description = "IsDominating(sub1, sub2) by deciding if sub1 composed with CokernelProjection(cat, sub2) is zero" );

##
AddDerivationToCAP( IsCodominating,
  function( cat, factor1, factor2 )
    
    return IsColiftableAlongEpimorphism( cat, factor2, factor1 );
    
end; Description = "IsCodominating using IsColiftableAlongEpimorphism" );

##
AddDerivationToCAP( IsCodominating,
                    [ [ KernelEmbedding, 2 ],
                      [ IsDominating, 1 ] ],
                                  
  function( cat, factor1, factor2 )
    local kernel_embedding_1, kernel_embedding_2;
    
    kernel_embedding_1 = KernelEmbedding( cat, factor1 );
    
    kernel_embedding_2 = KernelEmbedding( cat, factor2 );
    
    return IsDominating( cat, kernel_embedding_2, kernel_embedding_1 );
    
end; Description = "IsCodominating using IsDominating && duality by kernel" );

##
AddDerivationToCAP( IsCodominating,
                    [ [ KernelEmbedding, 1 ],
                      [ PreCompose, 1 ],
                      [ IsZeroForMorphisms, 1 ] ],
                                  
  function( cat, factor1, factor2 )
    local kernel_embedding, composition;
    
    kernel_embedding = KernelEmbedding( cat, factor2 );
    
    composition = PreCompose( cat, kernel_embedding, factor1 );
    
    return IsZeroForMorphisms( cat, composition );
    
end; Description = "IsCodominating(factor1, factor2) by deciding if KernelEmbedding(cat, factor2) composed with factor1 is zero" );

##
AddDerivationToCAP( IsLiftableAlongMonomorphism,
                    [ [ IsLiftable, 1 ] ],
  function( cat, iota, tau )
    
    return IsLiftable( cat, tau, iota );
    
end; Description = "IsLiftableAlongMonomorphism using IsLiftable" );

##
AddDerivationToCAP( IsColiftableAlongEpimorphism,
                    [ [ IsColiftable, 1 ] ],
  function( cat, epsilon, tau )
    
    return IsColiftable( cat, epsilon, tau );
    
end; Description = "IsColiftableAlongEpimorphism using IsColiftable" );

##
AddDerivationToCAP( IsProjective,
        [ [ EpimorphismFromProjectiveCoverObject, 1 ],
          [ IsIsomorphism, 1 ],
          ],
        
  function( cat, alpha )
    
    return IsIsomorphism( cat, EpimorphismFromProjectiveCoverObject( cat, alpha ) );
    
end );

##
AddDerivationToCAP( IsInjective,
        [ [ MonomorphismIntoInjectiveEnvelopeObject, 1 ],
          [ IsIsomorphism, 1 ],
          ],
        
  function( cat, alpha )
    
    return IsIsomorphism( cat, MonomorphismIntoInjectiveEnvelopeObject( cat, alpha ) );
    
end );

###########################
##
## Methods returning a morphism where the source && range can directly be read of from the input
##
###########################

##
AddDerivationToCAP( ZeroMorphism,
                    [ [ PreCompose, 1 ],
                      [ UniversalMorphismIntoZeroObject, 1 ],
                      [ UniversalMorphismFromZeroObject, 1 ] ],
                 
  function( cat, obj_source, obj_range )
    
    return PreCompose( cat, UniversalMorphismIntoZeroObject( cat, obj_source ), UniversalMorphismFromZeroObject( cat, obj_range ) );
    
  end; CategoryFilter = IsAdditiveCategory,
        Description = "Zero morphism by composition of morphism into && from zero object" );

##
AddDerivationToCAP( ZeroMorphism,
                    [ [ SumOfMorphisms, 1 ] ],
                    
  function( cat, obj_source, obj_range )
    
    return SumOfMorphisms( cat, obj_source, [ ], obj_range );
    
  end; CategoryFilter = IsAbCategory,
        Description = "computing the empty sum of morphisms" );

##
AddDerivationToCAP( PostCompose,
                    [ [ PreCompose, 1 ] ],
                    
  function( cat, right_mor, left_mor )
    
    return PreCompose( cat, left_mor, right_mor );
    
end; Description = "PostCompose using PreCompose && swapping arguments" );

##
AddDerivationToCAP( PreCompose,
                    [ [ PostCompose, 1 ] ],
                    
  function( cat, left_mor, right_mor )
    
    return PostCompose( cat, right_mor, left_mor );
    
end; Description = "PreCompose using PostCompose && swapping arguments" );

##
AddDerivationToCAP( PreCompose,
                    
  function( cat, left_mor, right_mor )
    
    return PreComposeList( cat, [ left_mor, right_mor ] );
    
end; Description = "PreCompose by wrapping the arguments ⥉ a list" );

##
AddDerivationToCAP( PreComposeList,
                    
  function( cat, morphism_list )
    
    return Iterated( morphism_list, ( alpha, beta ) -> PreCompose( cat, alpha, beta ) );
    
end; Description = "PreComposeList by iterating PreCompose" );

##
AddDerivationToCAP( PostCompose,
                    
  function( cat, mor_right, mor_left )
    
    return PostComposeList( cat, [ mor_right, mor_left ] );
    
end; Description = "PostCompose by wrapping the arguments ⥉ a list" );

##
AddDerivationToCAP( PostComposeList,
                    
  function( cat, morphism_list )
    
    return Iterated( morphism_list, ( beta, alpha ) -> PostCompose( cat, beta, alpha ) );
    
end; Description = "PostComposeList by iterating PostCompose" );

##
AddDerivationToCAP( InverseForMorphisms,
                    [ [ IdentityMorphism, 1 ],
                      [ LiftAlongMonomorphism, 1 ] ],
                                       
  function( cat, mor )
    local identity_of_range;
        
        identity_of_range = IdentityMorphism( cat, Range( mor ) );
        
        return LiftAlongMonomorphism( cat, mor, identity_of_range );
        
end; Description = "InverseForMorphisms using LiftAlongMonomorphism of an identity morphism" );

##
AddDerivationToCAP( InverseForMorphisms,
                    [ [ IdentityMorphism, 1 ],
                      [ ColiftAlongEpimorphism, 1 ] ],
                                       
  function( cat, mor )
    local identity_of_source;
    
    identity_of_source = IdentityMorphism( cat, Source( mor ) );
    
    return ColiftAlongEpimorphism( cat, mor, identity_of_source );
      
end; Description = "InverseForMorphisms using ColiftAlongEpimorphism of an identity morphism" );

##
AddDerivationToCAP( PreInverseForMorphisms,
                    [ [ IdentityMorphism, 1 ],
                      [ Lift, 1 ] ],
  
  function( cat, mor )
    
    return Lift( cat, IdentityMorphism( cat, Range( mor ) ), mor );
    
end; Description = "PreInverseForMorphisms using IdentityMorphism && Lift" );

##
AddDerivationToCAP( PostInverseForMorphisms,
                    [ [ IdentityMorphism, 1 ],
                      [ Colift, 1 ] ],
  
  function( cat, mor )
    
    return Colift( cat, mor, IdentityMorphism( cat, Source( mor ) ) );
    
end; Description = "PostInverseForMorphisms using IdentityMorphism && Colift" );

##
AddDerivationToCAP( AdditionForMorphisms,
                    [ [ SumOfMorphisms, 1 ] ],
                    
  function( cat, mor1, mor2 )
    
    return SumOfMorphisms( cat, Source( mor1 ), [ mor1, mor2 ], Range( mor1 ) );
    
end; CategoryFilter = IsAbCategory,
      Description = "AdditionForMorphisms using SumOfMorphisms" );

##
AddDerivationToCAP( AdditionForMorphisms,
                    [ [ UniversalMorphismIntoDirectSum, 1 ],
                      [ IdentityMorphism, 1 ],
                      [ UniversalMorphismFromDirectSum, 1 ],
                      [ PreCompose, 1 ] ],
                      
  function( cat, mor1, mor2 )
    local return_value, B, identity_morphism_B, componentwise_morphism, addition_morphism;
    
    B = Range( mor1 );
    
    componentwise_morphism = UniversalMorphismIntoDirectSum( cat, [ mor1, mor2 ] );
    
    identity_morphism_B = IdentityMorphism( cat, B );
    
    addition_morphism = UniversalMorphismFromDirectSum( cat, [ identity_morphism_B, identity_morphism_B ] );
    
    return PreCompose( cat, componentwise_morphism, addition_morphism );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "AdditionForMorphisms(mor1, mor2) as the composition of (mor1,mor2) with the codiagonal morphism" );

##
AddDerivationToCAP( SubtractionForMorphisms,
                      
  function( cat, mor1, mor2 )
    
    return AdditionForMorphisms( cat, mor1, AdditiveInverseForMorphisms( cat, mor2 ) );
    
end; CategoryFilter = IsAbCategory,
      Description = "SubtractionForMorphisms(mor1, mor2) as the sum of mor1 && the additive inverse of mor2" );

##
AddDerivationToCAP( SumOfMorphisms,
                    [ [ AdditionForMorphisms, 1 ],
                      [ ZeroMorphism, 1 ] ],
                    
  function( cat, obj1, mors, obj2 )
    
    return Iterated( mors, ( alpha, beta ) -> AdditionForMorphisms( cat, alpha, beta ), ZeroMorphism( cat, obj1, obj2 ) );
    
end; CategoryFilter = IsAbCategory,
      Description = "SumOfMorphisms using AdditionForMorphisms && ZeroMorphism" );

##
AddDerivationToCAP( LiftAlongMonomorphism,
                    [ [ Lift, 1 ] ],
                    
  function( cat, alpha, beta )
    
    ## Caution with the order of the arguments!
    return Lift( cat, beta, alpha );
    
end; Description = "LiftAlongMonomorphism using Lift" );

##
AddDerivationToCAP( ProjectiveLift,
                    [ [ Lift, 1 ] ],
                    
  function( cat, alpha, beta )
    
    return Lift( cat, alpha, beta );
    
end; Description = "ProjectiveLift using Lift" );


##
AddDerivationToCAP( ColiftAlongEpimorphism,
                    [ [ Colift, 1 ] ],
                    
  function( cat, alpha, beta )
    
    return Colift( cat, alpha, beta );
    
end; Description = "ColiftAlongEpimorphism using Colift" );

##
AddDerivationToCAP( InjectiveColift,
                    [ [ Colift, 1 ] ],
                    
  function( cat, alpha, beta )
    
    return Colift( cat, alpha, beta );
    
end; Description = "InjectiveColift using Colift" );

##
AddDerivationToCAP( RandomMorphismByInteger,
                    [
                      [ RandomObjectByInteger, 1 ],
                      [ RandomMorphismWithFixedSourceByInteger, 1 ]
                    ],

  function( cat, n )
    
    return RandomMorphismWithFixedSourceByInteger( cat, RandomObjectByInteger( cat, n ), 1 + Log2Int( n ) );
    
end; Description = "RandomMorphismByInteger using RandomObjectByInteger && RandomMorphismWithFixedSourceByInteger" );

##
AddDerivationToCAP( RandomMorphismByInteger,
                    [
                      [ RandomObjectByInteger, 1 ],
                      [ RandomMorphismWithFixedRangeByInteger, 1 ]
                    ],

  function( cat, n )
    
    return RandomMorphismWithFixedRangeByInteger( cat, RandomObjectByInteger( cat, n ),  1 + Log2Int( n ) );
    
end; Description = "RandomMorphismByInteger using RandomObjectByInteger && RandomMorphismWithFixedRangeByInteger" );

##
AddDerivationToCAP( RandomMorphismWithFixedSourceByInteger,
                    [
                      [ RandomObjectByInteger, 1 ],
                      [ RandomMorphismWithFixedSourceAndRangeByInteger, 1 ]
                    ],

  function( cat, S, n )
    
    return RandomMorphismWithFixedSourceAndRangeByInteger( cat, S, RandomObjectByInteger( cat, n ), 1 + Log2Int( n ) );
    
end; CategoryFilter = IsAbCategory,
Description = "RandomMorphismWithFixedSourceByInteger using RandomObjectByInteger && RandomMorphismWithFixedSourceAndRangeByInteger" );

##
AddDerivationToCAP( RandomMorphismWithFixedRangeByInteger,
                    [
                      [ RandomObjectByInteger, 1 ],
                      [ RandomMorphismWithFixedSourceAndRangeByInteger, 1 ]
                    ],

  function( cat, R, n )
    
    return RandomMorphismWithFixedSourceAndRangeByInteger( cat, RandomObjectByInteger( cat, n ), R, 1 + Log2Int( n ) );
    
end; CategoryFilter = IsAbCategory,
Description = "RandomMorphismWithFixedRangeByInteger using RandomObjectByInteger && RandomMorphismWithFixedSourceAndRangeByInteger" );

##
AddDerivationToCAP( RandomMorphismByInteger,
                    [
                      [ RandomObjectByInteger, 2 ],
                      [ RandomMorphismWithFixedSourceAndRangeByInteger, 1 ]
                    ],

  function( cat, n )
    
    return RandomMorphismWithFixedSourceAndRangeByInteger( cat, RandomObjectByInteger( cat, n ), RandomObjectByInteger( cat, n ), 1 + Log2Int( n ) );
    
end; CategoryFilter = IsAbCategory,
Description = "RandomMorphismByInteger using RandomObjectByInteger && RandomMorphismWithFixedSourceAndRangeByInteger" );

##
AddDerivationToCAP( RandomMorphismByList,
                    [
                      [ RandomObjectByList, 1 ],
                      [ RandomMorphismWithFixedSourceByList, 1 ]
                    ],

  function( cat, L )
    
    if Length( L ) != 2 || !ForAll( L, IsList )
        Error( "the list passed to 'RandomMorphismByList' ⥉ ", Name( cat ), " must be a list consisting of two lists!\n" );
    end;
    
    return RandomMorphismWithFixedSourceByList( cat, RandomObjectByList( cat, L[1] ), L[2] );
    
end; Description = "RandomMorphismByList using RandomObjectByList && RandomMorphismWithFixedSourceByList" );

##
AddDerivationToCAP( RandomMorphismByList,
                    [
                      [ RandomObjectByList, 1 ],
                      [ RandomMorphismWithFixedRangeByList, 1 ]
                    ],

  function( cat, L )
    
    if Length( L ) != 2 || !ForAll( L, IsList )
        Error( "the list passed to 'RandomMorphismByList' ⥉ ", Name( cat ), " must be a list consisting of two lists!\n" );
    end;
    
    return RandomMorphismWithFixedRangeByList( cat, RandomObjectByList( cat, L[1] ), L[2] );
    
end; Description = "RandomMorphismByList using RandomObjectByList && RandomMorphismWithFixedRangeByList" );

##
AddDerivationToCAP( RandomMorphismWithFixedSourceByList,
                    [
                      [ RandomObjectByList, 1 ],
                      [ RandomMorphismWithFixedSourceAndRangeByList, 1 ]
                    ],
  
  function( cat, S, L )
    
    if Length( L ) != 2 || !ForAll( L, IsList )
        Error( "the list passed to 'RandomMorphismWithFixedSourceByList' ⥉ ", Name( cat ), " must be a list consisting of two lists!\n" );
    end;
    
    return RandomMorphismWithFixedSourceAndRangeByList( cat, S, RandomObjectByList( cat, L[1] ), L[2] );
    
end; CategoryFilter = IsAbCategory,
Description = "RandomMorphismWithFixedSourceByList using RandomObjectByList && RandomMorphismWithFixedSourceAndRangeByList" );

##
AddDerivationToCAP( RandomMorphismWithFixedRangeByList,
                    [
                      [ RandomObjectByList, 1 ],
                      [ RandomMorphismWithFixedSourceAndRangeByList, 1 ]
                    ],
  
  function( cat, R, L )
    
    if Length( L ) != 2 || !ForAll( L, IsList )
        Error( "the list passed to 'RandomMorphismWithFixedRangeByList' ⥉ ", Name( cat ), " must be a list consisting of two lists!\n" );
    end;
    
    return RandomMorphismWithFixedSourceAndRangeByList( cat, RandomObjectByList( cat, L[1] ), R, L[2] );

end; CategoryFilter = IsAbCategory,
Description = "RandomMorphismWithFixedRangeByList using RandomObjectByList && RandomMorphismWithFixedSourceAndRangeByList" );

##
AddDerivationToCAP( RandomMorphismByList,
                    [
                      [ RandomObjectByList, 2 ],
                      [ RandomMorphismWithFixedSourceAndRangeByList, 1 ]
                    ],
  
  function( cat, L )
    
    if Length( L ) != 3 || !ForAll( L, IsList )
        Error( "the list passed to 'RandomMorphismByList' ⥉ ", Name( cat ), " must be a list consisting of three lists!\n" );
    end;
    
    return RandomMorphismWithFixedSourceAndRangeByList( cat, RandomObjectByList( cat, L[1] ), RandomObjectByList( cat, L[2] ), L[3] );
    
end; CategoryFilter = IsAbCategory,
Description = "RandomMorphismByList using RandomObjectByList && RandomMorphismWithFixedSourceAndRangeByList"  );


##
AddDerivationToCAP( IsomorphismFromKernelOfCokernelToImageObject,
        
  function( cat, morphism )
    
    return InverseForMorphisms( cat, IsomorphismFromImageObjectToKernelOfCokernel( cat, morphism ) );
    
end; Description = "IsomorphismFromKernelOfCokernelToImageObject as the inverse of IsomorphismFromImageObjectToKernelOfCokernel" );

##
AddDerivationToCAP( IsomorphismFromImageObjectToKernelOfCokernel,
        
  function( cat, morphism )
    
    return InverseForMorphisms( cat, IsomorphismFromKernelOfCokernelToImageObject( cat, morphism ) );
    
end; Description = "IsomorphismFromImageObjectToKernelOfCokernel as the inverse of IsomorphismFromKernelOfCokernelToImageObject" );

##
AddDerivationToCAP( IsomorphismFromImageObjectToKernelOfCokernel,
        
  function( cat, morphism )
    local kernel_emb, morphism_to_kernel;
    
    kernel_emb = KernelEmbedding( cat, CokernelProjection( cat, morphism ) );
    
    morphism_to_kernel = LiftAlongMonomorphism( cat, kernel_emb, morphism );
    
    return UniversalMorphismFromImage( cat, morphism, [ morphism_to_kernel, kernel_emb ] );
    
end; CategoryFilter = IsAbelianCategory,
      Description = "IsomorphismFromImageObjectToKernelOfCokernel using the universal property of the image" );

##
AddDerivationToCAP( IsomorphismFromCokernelOfKernelToCoimage,
        
  function( cat, morphism )
    
    return InverseForMorphisms( cat, IsomorphismFromCoimageToCokernelOfKernel( cat, morphism ) );
    
end; Description = "IsomorphismFromCokernelOfKernelToCoimage as the inverse of IsomorphismFromCoimageToCokernelOfKernel" );

##
AddDerivationToCAP( IsomorphismFromCokernelOfKernelToCoimage,
        
  function( cat, morphism )
    local cokernel_proj, morphism_from_cokernel;
    
    cokernel_proj = CokernelProjection( cat, KernelEmbedding( cat, morphism ) );
    
    morphism_from_cokernel = ColiftAlongEpimorphism( cat, cokernel_proj, morphism );
    
    return UniversalMorphismIntoCoimage( cat, morphism, [ cokernel_proj, morphism_from_cokernel ] );
    
end; CategoryFilter = IsAbelianCategory,
      Description = "IsomorphismFromCokernelOfKernelToCoimage using the universal property of the coimage" );

##
AddDerivationToCAP( IsomorphismFromCoimageToCokernelOfKernel,
        
  function( cat, morphism )
    
    return InverseForMorphisms( cat, IsomorphismFromCokernelOfKernelToCoimage( cat, morphism ) );
    
end; Description = "IsomorphismFromCoimageToCokernelOfKernel as the inverse of IsomorphismFromCokernelOfKernelToCoimage" );

##
AddDerivationToCAP( IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct,
          
  function( cat, A, diagram )
    local joint_pairwise_differences, equalizer, equalizer_embedding;
    
    joint_pairwise_differences = JointPairwiseDifferencesOfMorphismsIntoDirectProduct( cat, A, diagram );
    
    equalizer = Equalizer( cat, A, diagram );
    
    equalizer_embedding = EmbeddingOfEqualizerWithGivenEqualizer( cat, A, diagram, equalizer );
    
    return KernelLift( cat, joint_pairwise_differences, equalizer, equalizer_embedding );
    
end; Description = "IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct using the universal property of the kernel" );

##
AddDerivationToCAP( IsomorphismFromKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProductToEqualizer,
          
  function( cat, A, diagram )
    local joint_pairwise_differences, kernel_object, kernel_embedding;
    
    joint_pairwise_differences = JointPairwiseDifferencesOfMorphismsIntoDirectProduct( cat, A, diagram );
    
    kernel_object = KernelObject( cat, joint_pairwise_differences );
    
    kernel_embedding = KernelEmbeddingWithGivenKernelObject( cat, joint_pairwise_differences, kernel_object );
    
    return UniversalMorphismIntoEqualizer( cat, A, diagram, kernel_object, kernel_embedding );
    
end; Description = "IsomorphismFromKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProductToEqualizer using the universal property of the equalizer" );

##
AddDerivationToCAP( IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct,
          
  function( cat, A, diagram )
    local joint_pairwise_differences, cokernel_object, cokernel_proj;
    
    joint_pairwise_differences = JointPairwiseDifferencesOfMorphismsFromCoproduct( cat, A, diagram );
    
    cokernel_object = CokernelObject( cat, joint_pairwise_differences );
    
    cokernel_proj = CokernelProjectionWithGivenCokernelObject( cat, joint_pairwise_differences, cokernel_object );
    
    return UniversalMorphismFromCoequalizer( cat, A, diagram, cokernel_object, cokernel_proj );
    
end; Description = "IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct using the universal property of the coequalizer" );

##
AddDerivationToCAP( IsomorphismFromCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproductToCoequalizer,
          
  function( cat, A, diagram )
    local joint_pairwise_differences, coequalizer, coequalizer_projection;
    
    joint_pairwise_differences = JointPairwiseDifferencesOfMorphismsFromCoproduct( cat, A, diagram );
    
    coequalizer = Coequalizer( cat, A, diagram );
    
    coequalizer_projection = ProjectionOntoCoequalizerWithGivenCoequalizer( cat, A, diagram, coequalizer );
    
    return CokernelColift( cat, joint_pairwise_differences, coequalizer, coequalizer_projection );
    
end; Description = "IsomorphismFromCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproductToCoequalizer using the universal property of the cokernel" );

##
AddDerivationToCAP( IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram,
                    [ [ DirectProduct, 1 ],
                      [ PreCompose, 2 ],
                      [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
                      [ ProjectionInFactorOfFiberProductWithGivenFiberProduct, 2 ],
                      [ UniversalMorphismIntoDirectProductWithGivenDirectProduct, 1 ],
                      [ FiberProduct, 1 ],
                      [ UniversalMorphismIntoEqualizer, 1 ] ],
                      
  function( cat, diagram )
    local sources_of_diagram, direct_product, direct_product_diagram, fiber_product, test_source, fiber_product_embedding;
    
    sources_of_diagram = List( diagram, Source );
    
    direct_product = DirectProduct( cat, sources_of_diagram );
    
    direct_product_diagram = List( [ 1.. Length( sources_of_diagram ) ],
                                    i -> PreCompose( cat, ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat, sources_of_diagram, i, direct_product ), diagram[ i ] ) );
    
    fiber_product = FiberProduct( cat, diagram );
    
    test_source = List( (1):(Length( diagram )), i -> ProjectionInFactorOfFiberProductWithGivenFiberProduct( cat, diagram, i, fiber_product ) );
    
    fiber_product_embedding = UniversalMorphismIntoDirectProductWithGivenDirectProduct( cat, sources_of_diagram, fiber_product, test_source, direct_product );
    
    return UniversalMorphismIntoEqualizer( cat, direct_product, direct_product_diagram, fiber_product, fiber_product_embedding );
    
end; Description = "IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram using the universal property of the equalizer" );

##
AddDerivationToCAP( IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram,
                    [ [ IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct, 1 ],
                      [ InverseForMorphisms, 1 ] ],
                      
  function( cat, diagram )
    
    return InverseForMorphisms( cat, IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct( cat, diagram ) );
    
end; Description = "IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram as the inverse of IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct" );

##
AddDerivationToCAP( IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct,
                    [ [ PreCompose, 4 ],
                      [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
                      [ DirectProduct, 1 ],
                      [ Equalizer, 1 ],
                      [ EmbeddingOfEqualizerWithGivenEqualizer, 1 ],
                      [ UniversalMorphismIntoFiberProduct, 1 ] ],
                      
  function( cat, diagram )
    local sources_of_diagram, direct_product, direct_product_diagram, equalizer, equalizer_embedding, equalizer_of_direct_product_diagram;
    
    sources_of_diagram = List( diagram, Source );
    
    direct_product = DirectProduct( cat, sources_of_diagram );
    
    direct_product_diagram = List( [ 1.. Length( sources_of_diagram ) ],
                                    i -> PreCompose( cat, ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat, sources_of_diagram, i, direct_product ), diagram[ i ] ) );
    
    equalizer = Equalizer( cat, direct_product, direct_product_diagram );
    
    equalizer_embedding = EmbeddingOfEqualizerWithGivenEqualizer( cat, direct_product, direct_product_diagram, equalizer );
    
    equalizer_of_direct_product_diagram = List( (1):(Length( direct_product_diagram )), i -> PreCompose( cat, equalizer_embedding, direct_product_diagram[ i ] ) );
    
    return UniversalMorphismIntoFiberProduct( cat, diagram, equalizer, equalizer_of_direct_product_diagram );
    
end; Description = "IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct using the universal property of the fiber product" );

##
AddDerivationToCAP( IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct,
                    [ [ IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram, 1 ],
                      [ InverseForMorphisms, 1 ] ],
                      
  function( cat, diagram )
    
    return InverseForMorphisms( cat, IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram( cat, diagram ) );
    
end; Description = "IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct as the inverse of IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram" );

##
AddDerivationToCAP( IsomorphismFromPushoutToCoequalizerOfCoproductDiagram,
                    [ [ Coproduct, 1 ],
                      [ PreCompose, 4 ],
                      [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
                      [ Coequalizer, 1 ],
                      [ ProjectionOntoCoequalizerWithGivenCoequalizer, 1 ],
                      [ UniversalMorphismFromPushout, 1 ] ],
                      
  function( cat, diagram )
    local ranges_of_diagram, coproduct, coproduct_diagram, coequalizer, coequalizer_projection, coequalizer_of_coproduct_diagram;
    
    ranges_of_diagram = List( diagram, Range );
    
    coproduct = Coproduct( cat, ranges_of_diagram );
    
    coproduct_diagram = List( (1):(Length( ranges_of_diagram )),
                               i -> PreCompose( cat, diagram[ i ], InjectionOfCofactorOfCoproductWithGivenCoproduct( cat, ranges_of_diagram, i, coproduct ) ) );
    
    coequalizer = Coequalizer( cat, coproduct, coproduct_diagram );
    
    coequalizer_projection = ProjectionOntoCoequalizerWithGivenCoequalizer( cat, coproduct, coproduct_diagram, coequalizer );
    
    coequalizer_of_coproduct_diagram = List( (1):(Length( coproduct_diagram )), i -> PreCompose( cat, coproduct_diagram[ i ], coequalizer_projection ) );
    
    return UniversalMorphismFromPushout( cat, diagram, coequalizer, coequalizer_of_coproduct_diagram );
    
end; Description = "IsomorphismFromPushoutToCoequalizerOfCoproductDiagram using the universal property of the pushout" );

##
AddDerivationToCAP( IsomorphismFromPushoutToCoequalizerOfCoproductDiagram,
                    [ [ IsomorphismFromCoequalizerOfCoproductDiagramToPushout , 1 ],
                      [ InverseForMorphisms, 1 ] ],
                      
  function( cat, diagram )
    
    return InverseForMorphisms( cat, IsomorphismFromCoequalizerOfCoproductDiagramToPushout( cat, diagram ) );
    
end; Description = "IsomorphismFromPushoutToCoequalizerOfCoproductDiagram as the inverse of IsomorphismFromCoequalizerOfCoproductDiagramToPushout" );

##
AddDerivationToCAP( IsomorphismFromCoequalizerOfCoproductDiagramToPushout,
                    [ [ Coproduct, 1 ],
                      [ PreCompose, 2 ],
                      [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
                      [ InjectionOfCofactorOfPushoutWithGivenPushout, 2 ],
                      [ UniversalMorphismFromCoproductWithGivenCoproduct, 1 ],
                      [ Pushout, 1 ],
                      [ UniversalMorphismFromCoequalizer, 1 ] ],
                      
  function( cat, diagram )
    local ranges_of_diagram, coproduct, coproduct_diagram, pushout, test_sink, pushout_injection;
    
    ranges_of_diagram = List( diagram, Range );
    
    coproduct = Coproduct( cat, ranges_of_diagram );
    
    coproduct_diagram = List( (1):(Length( ranges_of_diagram )),
                               i -> PreCompose( cat, diagram[ i ], InjectionOfCofactorOfCoproductWithGivenCoproduct( cat, ranges_of_diagram, i, coproduct ) ) );
    
    pushout = Pushout( cat, diagram );
    
    test_sink = List( (1):(Length( diagram )), i -> InjectionOfCofactorOfPushoutWithGivenPushout( cat, diagram, i, pushout ) );
    
    pushout_injection = UniversalMorphismFromCoproductWithGivenCoproduct( cat, ranges_of_diagram, pushout, test_sink, coproduct );
    
    return UniversalMorphismFromCoequalizer( cat, coproduct, coproduct_diagram, pushout, pushout_injection );
    
end; Description = "IsomorphismFromCoequalizerOfCoproductDiagramToPushout using the universal property of the coequalizer" );

##
AddDerivationToCAP( IsomorphismFromCoequalizerOfCoproductDiagramToPushout,
                    [ [ IsomorphismFromPushoutToCoequalizerOfCoproductDiagram, 1 ],
                      [ InverseForMorphisms, 1 ] ],
                      
  function( cat, diagram )
    
    return InverseForMorphisms( cat, IsomorphismFromPushoutToCoequalizerOfCoproductDiagram( cat, diagram ) );
    
end; Description = "IsomorphismFromCoequalizerOfCoproductDiagramToPushout as the inverse of IsomorphismFromPushoutToCoequalizerOfCoproductDiagram" );

##
AddDerivationToCAP( ColiftAlongEpimorphism,
                    [ [ KernelEmbedding, 1 ],
                      [ CokernelColift, 2 ],
                      [ PreCompose, 1 ],
                      [ InverseForMorphisms, 1 ] ],
                    
  function( cat, epimorphism, test_morphism )
    local kernel_emb, cokernel_colift_to_range_of_epimorphism, cokernel_colift_to_range_of_test_morphism;
    
    kernel_emb = KernelEmbedding( cat, epimorphism );
    
    cokernel_colift_to_range_of_epimorphism =
      CokernelColift( cat, kernel_emb, epimorphism );
      
    cokernel_colift_to_range_of_test_morphism =
      CokernelColift( cat, kernel_emb, test_morphism );
    
    return PreCompose( cat, InverseForMorphisms( cat, cokernel_colift_to_range_of_epimorphism ), cokernel_colift_to_range_of_test_morphism );
    
end; CategoryFilter = IsAbelianCategory, 
      Description = "ColiftAlongEpimorphism by inverting the cokernel colift from the cokernel of the kernel to the range of a given epimorphism");

##
AddDerivationToCAP( LiftAlongMonomorphism,
                    [ [ CokernelProjection, 1 ],
                      [ KernelLift, 2 ],
                      [ PreCompose, 1 ],
                      [ InverseForMorphisms, 1 ] ],
                    
  function( cat, monomorphism, test_morphism )
    local cokernel_proj, kernel_lift_from_source_of_monomorphism, kernel_lift_from_source_of_test_morphism;
    
    cokernel_proj = CokernelProjection( cat, monomorphism );
    
    kernel_lift_from_source_of_monomorphism =
      KernelLift( cat, cokernel_proj, monomorphism );
      
    kernel_lift_from_source_of_test_morphism =
      KernelLift( cat, cokernel_proj, test_morphism );
    
    return PreCompose( cat, kernel_lift_from_source_of_test_morphism, InverseForMorphisms( cat, kernel_lift_from_source_of_monomorphism ) );
    
end; CategoryFilter = IsAbelianCategory, 
      Description = "LiftAlongMonomorphism by inverting the kernel lift from the source to the kernel of the cokernel of a given monomorphism");

##
AddDerivationToCAP( ComponentOfMorphismIntoDirectProduct,
                   
  function( cat, alpha, factors, nr )
    
    return PreCompose( cat, alpha, ProjectionInFactorOfDirectProduct( cat, factors, nr ) );
    
end; Description = "ComponentOfMorphismIntoDirectProduct by composing with the direct product projection" );

##
AddDerivationToCAP( ComponentOfMorphismFromCoproduct,
                   
  function( cat, alpha, cofactors, nr )
    
    return PreCompose( cat, InjectionOfCofactorOfCoproduct( cat, cofactors, nr ), alpha );
    
end; Description = "ComponentOfMorphismFromCoproduct by composing with the coproduct injection" );

##
AddDerivationToCAP( ComponentOfMorphismIntoDirectSum,
                    
  function( cat, alpha, summands, nr )
    
    return PreCompose( cat, alpha, ProjectionInFactorOfDirectSum( cat, summands, nr ) );
    
end; Description = "ComponentOfMorphismIntoDirectSum by composing with the direct sum projection" );

##
AddDerivationToCAP( ComponentOfMorphismFromDirectSum,
                    
  function( cat, alpha, summands, nr )
    
    return PreCompose( cat, InjectionOfCofactorOfDirectSum( cat, summands, nr ), alpha );
    
end; Description = "ComponentOfMorphismFromDirectSum by composing with the direct sum injection" );

##
AddDerivationToCAP( MorphismBetweenDirectSumsWithGivenDirectSums,
                    
  function( cat, S, diagram_S, morphism_matrix, diagram_T, T )
    local test_diagram_product, test_diagram_coproduct;
    
    if morphism_matrix == [ ] || morphism_matrix[1] == [ ]
        return ZeroMorphism( cat, S, T );
    end;
    
    test_diagram_coproduct = ListN( diagram_S, morphism_matrix,
        ( source, row ) -> UniversalMorphismIntoDirectSumWithGivenDirectSum( cat, diagram_T, source, row, T )
    );
    
    return UniversalMorphismFromDirectSumWithGivenDirectSum( cat, diagram_S, T, test_diagram_coproduct, S );
    
end; CategoryFilter = cat -> !( IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true ),
      Description = "MorphismBetweenDirectSumsWithGivenDirectSums using universal morphisms of direct sums (without support for empty limits)" );

##
AddDerivationToCAP( MorphismBetweenDirectSumsWithGivenDirectSums,
                    
  function( cat, S, diagram_S, morphism_matrix, diagram_T, T )
    local test_diagram_product, test_diagram_coproduct;
    
    test_diagram_coproduct = ListN( diagram_S, morphism_matrix,
        ( source, row ) -> UniversalMorphismIntoDirectSumWithGivenDirectSum( cat, diagram_T, source, row, T )
    );
    
    return UniversalMorphismFromDirectSumWithGivenDirectSum( cat, diagram_S, T, test_diagram_coproduct, S );
    
end; CategoryFilter = cat -> IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true,
      Description = "MorphismBetweenDirectSumsWithGivenDirectSums using universal morphisms of direct sums (with support for empty limits)" );

##
AddDerivationToCAP( HomologyObjectFunctorialWithGivenHomologyObjects,
                    
  function( cat, homology_source, mor_list, homology_range )
    local alpha, beta, epsilon, gamma, delta, image_emb_source, image_emb_range, cok_functorial, functorial_mor;
    
    alpha = mor_list[1];
    
    beta = mor_list[2];
    
    epsilon = mor_list[3];
    
    gamma = mor_list[4];
    
    delta = mor_list[5];
    
    image_emb_source = ImageEmbedding( cat,
      PreCompose( cat, KernelEmbedding( cat, beta ), CokernelProjection( cat, alpha ) )
    );
    
    image_emb_range = ImageEmbedding( cat,
      PreCompose( cat, KernelEmbedding( cat, delta ), CokernelProjection( cat, gamma ) )
    );
    
    cok_functorial = CokernelObjectFunctorial( cat, alpha, epsilon, gamma );
    
    functorial_mor =
      LiftAlongMonomorphism( cat,
        image_emb_range, PreCompose( cat, image_emb_source, cok_functorial )
      );
    
    return PreCompose( cat,
        IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject( cat, alpha, beta ),
        PreCompose( cat,
            functorial_mor,
            IsomorphismFromItsConstructionAsAnImageObjectToHomologyObject( cat, gamma, delta )
        )
    );
    
end; CategoryFilter = IsAbelianCategory,
      Description = "HomologyObjectFunctorialWithGivenHomologyObjects using functoriality of (co)kernels && images ⥉ abelian categories" );


###########################
##
## Methods returning a morphism with source || range constructed within the method!
## If there is a method available which only constructs this source || range,
## one has to be sure that this source is equal to that construction (by IsEqualForObjects)
##
###########################

##
AddDerivationToCAP( ZeroObjectFunctorial,
                    [ [ ZeroObject, 1 ],
                      [ ZeroMorphism, 1 ],
                    ],
                    
  function( cat )
    local zero_object;
    
    zero_object = ZeroObject( cat );
    
    return ZeroMorphism( cat, zero_object, zero_object );
    
end; Description = "ZeroObjectFunctorial using ZeroMorphism" );

##
AddDerivationToCAP( JointPairwiseDifferencesOfMorphismsIntoDirectProduct,
                    [ [ UniversalMorphismIntoTerminalObject, 1 ],
                      [ UniversalMorphismIntoDirectProduct, 2 ], ## 2*(Length( diagram ) - 1) would be the correct number here
                      [ SubtractionForMorphisms, 1 ],
                    ],
                    
  function( cat, A, diagram )
    local number_of_morphisms, ranges, mor1, mor2;
    
    number_of_morphisms = Length( diagram );
    
    if number_of_morphisms == 1
        
        return UniversalMorphismIntoTerminalObject( cat, A );
        
    end;
    
    ranges = List( diagram, Range );
    
    mor1 = UniversalMorphismIntoDirectProduct( cat, ranges[(1):(number_of_morphisms - 1)], A, diagram[(1):(number_of_morphisms - 1)] );
    
    mor2 = UniversalMorphismIntoDirectProduct( cat, ranges[(2):(number_of_morphisms)], A, diagram[(2):(number_of_morphisms)] );
    
    return SubtractionForMorphisms( cat, mor1, mor2 );
    
end; CategoryFilter = cat -> !( IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true ),
      Description = "JointPairwiseDifferencesOfMorphismsIntoDirectProduct using the operations defining this morphism (without support for empty limits)" );

##
AddDerivationToCAP( JointPairwiseDifferencesOfMorphismsIntoDirectProduct,
                    [ [ UniversalMorphismIntoDirectProduct, 2 ], ## 2*(Length( diagram ) - 1) would be the correct number here
                      [ SubtractionForMorphisms, 1 ],
                    ],
                    
  function( cat, A, diagram )
    local number_of_morphisms, ranges, mor1, mor2;
    
    number_of_morphisms = Length( diagram );
    
    ranges = List( diagram, Range );
    
    mor1 = UniversalMorphismIntoDirectProduct( cat, ranges[(1):(number_of_morphisms - 1)], A, diagram[(1):(number_of_morphisms - 1)] );
    
    mor2 = UniversalMorphismIntoDirectProduct( cat, ranges[(2):(number_of_morphisms)], A, diagram[(2):(number_of_morphisms)] );
    
    return SubtractionForMorphisms( cat, mor1, mor2 );
    
end; CategoryFilter = cat -> IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true,
      Description = "JointPairwiseDifferencesOfMorphismsIntoDirectProduct using the operations defining this morphism (with support for empty limits)" );

##
AddDerivationToCAP( JointPairwiseDifferencesOfMorphismsFromCoproduct,
                    [ [ UniversalMorphismFromInitialObject, 1 ],
                      [ UniversalMorphismFromCoproduct, 2 ], ## 2*( Length( diagram ) - 1 ) would be the correct number 
                      [ SubtractionForMorphisms, 1 ],
                    ],
                    
  function( cat, A, diagram )
    local number_of_morphisms, sources, mor1, mor2;
    
    number_of_morphisms = Length( diagram );
 
    if number_of_morphisms == 1
        
        return UniversalMorphismFromInitialObject( cat, A );
        
    end;
    
    sources = List( diagram, Source );
    
    mor1 = UniversalMorphismFromCoproduct( cat, sources[(1):(number_of_morphisms - 1)], A, diagram[(1):(number_of_morphisms - 1)] );
    
    mor2 = UniversalMorphismFromCoproduct( cat, sources[(2):(number_of_morphisms)], A, diagram[(2):(number_of_morphisms)] );
    
    return SubtractionForMorphisms( cat, mor1, mor2 );
    
end; CategoryFilter = cat -> !( IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true ),
      Description = "JointPairwiseDifferencesOfMorphismsFromCoproduct using the operations defining this morphism (without support for empty limits)" );

##
AddDerivationToCAP( JointPairwiseDifferencesOfMorphismsFromCoproduct,
                    [ [ UniversalMorphismFromCoproduct, 2 ], ## 2*( Length( diagram ) - 1 ) would be the correct number 
                      [ SubtractionForMorphisms, 1 ],
                    ],
                    
  function( cat, A, diagram )
    local number_of_morphisms, sources, mor1, mor2;
    
    number_of_morphisms = Length( diagram );
    
    sources = List( diagram, Source );
    
    mor1 = UniversalMorphismFromCoproduct( cat, sources[(1):(number_of_morphisms - 1)], A, diagram[(1):(number_of_morphisms - 1)] );
    
    mor2 = UniversalMorphismFromCoproduct( cat, sources[(2):(number_of_morphisms)], A, diagram[(2):(number_of_morphisms)] );
    
    return SubtractionForMorphisms( cat, mor1, mor2 );
    
end; CategoryFilter = cat -> IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true,
      Description = "JointPairwiseDifferencesOfMorphismsFromCoproduct using the operations defining this morphism (with support for empty limits)" );

##
AddDerivationToCAP( EmbeddingOfEqualizer,
                    [ [ KernelEmbedding, 1 ],
                      [ JointPairwiseDifferencesOfMorphismsIntoDirectProduct, 1 ],
                      [ PreCompose, 1 ],
                      [ IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct, 1 ] ],
                    
  function( cat, A, diagram )
    local kernel_of_pairwise_differences;
    
    kernel_of_pairwise_differences = KernelEmbedding( cat, JointPairwiseDifferencesOfMorphismsIntoDirectProduct( cat, A, diagram ) );
    
    return PreCompose( cat, IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct( cat, A, diagram ),
                       kernel_of_pairwise_differences );
    
end; Description = "EmbeddingOfEqualizer using the kernel embedding of JointPairwiseDifferencesOfMorphismsIntoDirectProduct" );

##
AddDerivationToCAP( ProjectionOntoCoequalizer,
                    [ [ CokernelProjection, 1 ],
                      [ JointPairwiseDifferencesOfMorphismsFromCoproduct, 1 ],
                      [ PreCompose, 1 ],
                      [ IsomorphismFromCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproductToCoequalizer, 1 ] ],
                    
  function( cat, A, diagram )
    local cokernel_proj_of_pairwise_differences;
    
    cokernel_proj_of_pairwise_differences = CokernelProjection( cat, JointPairwiseDifferencesOfMorphismsFromCoproduct( cat, A, diagram ) );
    
    return PreCompose( cat, cokernel_proj_of_pairwise_differences,
                       IsomorphismFromCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproductToCoequalizer( cat, A, diagram ) );
    
end; Description = "ProjectionOntoCoequalizer using the cokernel projection of JointPairwiseDifferencesOfMorphismsFromCoproduct" );

##
AddDerivationToCAP( IsomorphismFromInitialObjectToZeroObject,
                    [ [ UniversalMorphismFromInitialObject, 1 ],
                      [ ZeroObject, 1 ] ],
                      
  function( cat )
    
    return UniversalMorphismFromInitialObject( cat, ZeroObject( cat ) );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "IsomorphismFromInitialObjectToZeroObject as the unique morphism from initial object to zero object" );

##
AddDerivationToCAP( IsomorphismFromInitialObjectToZeroObject,
        
  function( cat )
    
    return UniversalMorphismIntoZeroObject( cat, InitialObject( cat ) );
    
end; Description = "IsomorphismFromInitialObjectToZeroObject using the universal property of the zero object" );

##
AddDerivationToCAP( IsomorphismFromInitialObjectToZeroObject,
                    [ [ InverseForMorphisms, 1 ],
                      [ IsomorphismFromZeroObjectToInitialObject, 1 ] ],
  function( cat )
    
    return InverseForMorphisms( cat, IsomorphismFromZeroObjectToInitialObject( cat ) );
    
end; Description = "IsomorphismFromInitialObjectToZeroObject as the inverse of IsomorphismFromZeroObjectToInitialObject" );

##
AddDerivationToCAP( IsomorphismFromZeroObjectToInitialObject,
                    [ [ InverseForMorphisms, 1 ],
                      [ IsomorphismFromInitialObjectToZeroObject, 1 ] ],
  function( cat )
    
    return InverseForMorphisms( cat, IsomorphismFromInitialObjectToZeroObject( cat ) );
    
end; Description = "IsomorphismFromZeroObjectToInitialObject as the inverse of IsomorphismFromInitialObjectToZeroObject" );

##
AddDerivationToCAP( IsomorphismFromZeroObjectToInitialObject,
         
  function( cat )
    
    return UniversalMorphismFromZeroObject( cat, InitialObject( cat ) );
    
end; Description = "IsomorphismFromZeroObjectToInitialObject using the universal property of the zero object" );

##
AddDerivationToCAP( IsomorphismFromZeroObjectToTerminalObject,
                    [ [ UniversalMorphismIntoTerminalObject, 1 ],
                      [ ZeroObject, 1 ] ],
  function( cat )
    
    return UniversalMorphismIntoTerminalObject( cat, ZeroObject( cat ) );
    
end; CategoryFilter = IsAdditiveCategory,
      Description = "IsomorphismFromZeroObjectToTerminalObject as the unique morphism from zero object to terminal object" );

##
AddDerivationToCAP( IsomorphismFromZeroObjectToTerminalObject,
        
  function( cat )
    
    return UniversalMorphismFromZeroObject( cat, TerminalObject( cat ) );
    
end; Description = "IsomorphismFromZeroObjectToTerminalObject using the universal property of the zero object" );

##
AddDerivationToCAP( IsomorphismFromTerminalObjectToZeroObject,
                    [ [ InverseForMorphisms, 1 ],
                      [ IsomorphismFromZeroObjectToTerminalObject, 1 ] ],
  function( cat )
    
    return InverseForMorphisms( cat, IsomorphismFromZeroObjectToTerminalObject( cat ) );
    
end; Description = "IsomorphismFromTerminalObjectToZeroObject as the inverse of IsomorphismFromZeroObjectToTerminalObject" );

##
AddDerivationToCAP( IsomorphismFromTerminalObjectToZeroObject,
        
  function( cat )
    
    return UniversalMorphismIntoZeroObject( cat, TerminalObject( cat ) );
    
end; Description = "IsomorphismFromTerminalObjectToZeroObject using the universal property of the zero object" );

##
AddDerivationToCAP( IsomorphismFromZeroObjectToTerminalObject,
                    [ [ InverseForMorphisms, 1 ],
                      [ IsomorphismFromTerminalObjectToZeroObject, 1 ] ],
  function( cat )
    
    return InverseForMorphisms( cat, IsomorphismFromTerminalObjectToZeroObject( cat ) );
    
end; Description = "IsomorphismFromZeroObjectToTerminalObject as the inverse of IsomorphismFromTerminalObjectToZeroObject" );


##
AddDerivationToCAP( IsomorphismFromDirectProductToDirectSum,
                    [ [ ProjectionInFactorOfDirectProduct, 2 ], ## Length( diagram ) would be the correct number
                      [ DirectProduct, 1 ],
                      [ UniversalMorphismIntoDirectSum, 1 ] ],
                    
  function( cat, diagram )
    local source;
    
    source = List( (1):(Length( diagram )), i -> ProjectionInFactorOfDirectProduct( cat, diagram, i ) );
    
    return UniversalMorphismIntoDirectSum( cat, diagram, DirectProduct( cat, diagram ), source );
    
end; Description = "IsomorphismFromDirectProductToDirectSum using direct product projections && universal property of direct sum" );

##
AddDerivationToCAP( IsomorphismFromDirectProductToDirectSum,
                    [ [ IsomorphismFromDirectSumToDirectProduct, 1 ],
                      [ InverseForMorphisms, 1 ] ],
                      
  function( cat, diagram )
    
    return InverseForMorphisms( cat, IsomorphismFromDirectSumToDirectProduct( cat, diagram ) );
    
end; Description = "IsomorphismFromDirectProductToDirectSum as the inverse of IsomorphismFromDirectSumToDirectProduct" );

##
AddDerivationToCAP( IsomorphismFromDirectSumToDirectProduct,
                    [ [ ProjectionInFactorOfDirectSum, 2 ], ## Length( diagram ) would be the correct number
                      [ DirectSum, 1 ],
                      [ UniversalMorphismIntoDirectProduct, 1 ] ],
                    
  function( cat, diagram )
    local source;
    
    source = List( (1):(Length( diagram )), i -> ProjectionInFactorOfDirectSum( cat, diagram, i ) );
    
    return UniversalMorphismIntoDirectProduct( cat, diagram, DirectSum( cat, diagram ), source );
    
end; Description = "IsomorphismFromDirectSumToDirectProduct using direct sum projections && universal property of direct product" );

##
AddDerivationToCAP( IsomorphismFromDirectSumToDirectProduct,
                    [ [ InverseForMorphisms, 1 ],
                      [ IsomorphismFromDirectProductToDirectSum, 1 ] ],
                      
  function( cat, diagram )
    
    return InverseForMorphisms( cat, IsomorphismFromDirectProductToDirectSum( cat, diagram ) );
    
end; Description = "IsomorphismFromDirectSumToDirectProduct as the inverse of IsomorphismFromDirectProductToDirectSum" );

##
AddDerivationToCAP( IsomorphismFromCoproductToDirectSum,
                    [ [ InjectionOfCofactorOfDirectSum, 2 ], ## Length( diagram ) would be the correct number
                      [ DirectSum, 1 ],
                      [ UniversalMorphismFromCoproduct, 1 ] ],
                    
  function( cat, diagram )
    local sink;
    
    sink = List( (1):(Length( diagram )), i -> InjectionOfCofactorOfDirectSum( cat, diagram, i ) );
    
    return UniversalMorphismFromCoproduct( cat, diagram, DirectSum( cat, diagram ), sink );
    
end; Description = "IsomorphismFromCoproductToDirectSum using cofactor injections && the universal property of the coproduct" );

##
AddDerivationToCAP( IsomorphismFromCoproductToDirectSum,
                    [ [ InverseForMorphisms, 1 ],
                      [ IsomorphismFromDirectSumToCoproduct, 1 ] ],
                      
  function( cat, diagram )
    
    return InverseForMorphisms( cat, IsomorphismFromDirectSumToCoproduct( cat, diagram ) );
  
end; Description = "IsomorphismFromCoproductToDirectSum as the inverse of IsomorphismFromDirectSumToCoproduct" );

##
AddDerivationToCAP( IsomorphismFromDirectSumToCoproduct,
                    [ [ InjectionOfCofactorOfCoproduct, 2 ], ## Length( diagram ) would be the correct number
                      [ Coproduct, 1 ],
                      [ UniversalMorphismFromDirectSum, 1 ] ],
                    
  function( cat, diagram )
    local sink;
    
    sink = List( (1):(Length( diagram )), i -> InjectionOfCofactorOfCoproduct( cat, diagram, i ) );
    
    return UniversalMorphismFromDirectSum( cat, diagram, Coproduct( cat, diagram ), sink );
    
end; Description = "IsomorphismFromDirectSumToCoproduct using cofactor injections && the universal property of the direct sum" );

##
AddDerivationToCAP( IsomorphismFromDirectSumToCoproduct,
                    [ [ InverseForMorphisms, 1 ],
                      [ IsomorphismFromCoproductToDirectSum, 1 ] ],
                    
  function( cat, diagram )
    
    return InverseForMorphisms( cat, IsomorphismFromCoproductToDirectSum( cat, diagram ) );
    
end; Description = "IsomorphismFromDirectSumToCoproduct as the inverse of IsomorphismFromCoproductToDirectSum" );

## B -β→ C ←α- A, ℓ•β == α ⇔ ν(ℓ)•H(A,β) == ν(α)
##
AddDerivationToCAP( Lift,
            [ [ IdentityMorphism, 1 ],
              [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 1 ],
              [ HomomorphismStructureOnMorphisms, 1 ],
              [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 1 ],
              [ Lift, 1, RangeCategoryOfHomomorphismStructure ] ],
              
  function( cat, alpha, beta )
    local range_cat, a, b;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    a = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, alpha );
    
    b = HomomorphismStructureOnMorphisms( cat, IdentityMorphism( Source( alpha ) ), beta );
    
    return InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat, Source( alpha ), Source( beta ), Lift( range_cat, a, b ) );
    
end; CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
      CategoryFilter = cat -> HasRangeCategoryOfHomomorphismStructure( cat ),
      Description = "Derive Lift using the homomorphism structure && Lift ⥉ the range of the homomorphism structure" );

##
AddDerivationToCAP( LiftOrFail,
            [ [ IdentityMorphism, 1 ],
              [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 1 ],
              [ HomomorphismStructureOnMorphisms, 1 ],
              [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 1 ],
              [ LiftOrFail, 1, RangeCategoryOfHomomorphismStructure ] ],
              
  function( cat, alpha, beta )
    local range_cat, a, b, l;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    a = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, alpha );
    
    b = HomomorphismStructureOnMorphisms( cat, IdentityMorphism( Source( alpha ) ), beta );
    
    l = LiftOrFail( range_cat, a, b );
    
    if l == fail
      
      return fail;
      
    end;
    
    return InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat, Source( alpha ), Source( beta ), l );
    
end; CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
      CategoryFilter = cat -> HasRangeCategoryOfHomomorphismStructure( cat ),
      Description = "Derive LiftOrFail using the homomorphism structure && LiftOrFail ⥉ the range of the homomorphism structure" );

##
AddDerivationToCAP( IsLiftable,
            [ [ IdentityMorphism, 1 ],
              [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 1 ],
              [ HomomorphismStructureOnMorphisms, 1 ],
              [ IsLiftable, 1, RangeCategoryOfHomomorphismStructure ] ],
              
  function( cat, alpha, beta )
    local range_cat, a, b;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    a = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, alpha );
    
    b = HomomorphismStructureOnMorphisms( cat, IdentityMorphism( Source( alpha ) ), beta );
    
    return IsLiftable( range_cat, a, b );
    
end; CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
      CategoryFilter = cat -> HasRangeCategoryOfHomomorphismStructure( cat ),
      Description = "Derive IsLiftable using the homomorphism structure && Liftable ⥉ the range of the homomorphism structure" );

## B ←β- C -α→ A, α•ℓ == β ⇔ ν(ℓ)•H(α,B) == ν(β)
##
AddDerivationToCAP( Colift,
            [ [ IdentityMorphism, 1 ],
              [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 1 ],
              [ HomomorphismStructureOnMorphisms, 1 ],
              [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 1 ],
              [ Lift, 1, RangeCategoryOfHomomorphismStructure ] ],
              
  function( cat, alpha, beta )
    local range_cat, b, a;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    b = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, beta );
    
    a = HomomorphismStructureOnMorphisms( cat, alpha, IdentityMorphism( Range( beta ) ) );
    
    return InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat, Range( alpha ), Range( beta ), Lift( range_cat, b, a ) );
    
end; CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
      CategoryFilter = cat -> HasRangeCategoryOfHomomorphismStructure( cat ),
      Description = "Derive Colift using the homomorphism structure && Lift ⥉ the range of the homomorphism structure" );

##
AddDerivationToCAP( ColiftOrFail,
            [ [ IdentityMorphism, 1 ],
              [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 1 ],
              [ HomomorphismStructureOnMorphisms, 1 ],
              [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 1 ],
              [ LiftOrFail, 1, RangeCategoryOfHomomorphismStructure ] ],
              
  function( cat, alpha, beta )
    local range_cat, b, a, l;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    b = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, beta );
    
    a = HomomorphismStructureOnMorphisms( cat, alpha, IdentityMorphism( Range( beta ) ) );
    
    l = LiftOrFail( range_cat, b, a );
    
    if l == fail
      
      return fail;
      
    end;
    
    return InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat, Range( alpha ), Range( beta ), l );
    
end; CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
      CategoryFilter = cat -> HasRangeCategoryOfHomomorphismStructure( cat ),
      Description = "Derive ColiftOrFail using the homomorphism structure && LiftOrFail ⥉ the range of the homomorphism structure" );

##
AddDerivationToCAP( IsColiftable,
            [ [ IdentityMorphism, 1 ],
              [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 1 ],
              [ HomomorphismStructureOnMorphisms, 1 ],
              [ IsLiftable, 1, RangeCategoryOfHomomorphismStructure ] ],
              
  function( cat, alpha, beta )
    local range_cat, b, a;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    b = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, beta );
    
    a = HomomorphismStructureOnMorphisms( cat, alpha, IdentityMorphism( Range( beta ) ) );
    
    return IsLiftable( range_cat, b, a );
    
end; CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
      CategoryFilter = cat -> HasRangeCategoryOfHomomorphismStructure( cat ),
      Description = "Derive IsColiftable using the homomorphism structure && IsLiftable ⥉ the range of the homomorphism structure" );

##
AddDerivationToCAP( Lift,
                    [ [ IdentityMorphism, 1 ],
                      [ SolveLinearSystemInAbCategory, 1 ] ],
  function( cat, alpha, beta )
    local left_coefficients, right_coefficients, right_side, right_divide;
    
    left_coefficients = [ [ IdentityMorphism( cat, Source( alpha ) ) ] ];
    
    right_coefficients = [ [ beta ] ];
    
    right_side = [ alpha ];
    
    right_divide = SolveLinearSystemInAbCategory( cat,
                      left_coefficients, right_coefficients, right_side );
    
    return right_divide[1];
    
end; Description = "Lift by SolveLinearSystemInAbCategory" );

##
AddDerivationToCAP( LiftOrFail,
                    [ [ IdentityMorphism, 1 ],
                      [ SolveLinearSystemInAbCategoryOrFail, 1 ] ],
  function( cat, alpha, beta )
    local left_coefficients, right_coefficients, right_side, right_divide;
    
    left_coefficients = [ [ IdentityMorphism( cat, Source( alpha ) ) ] ];
    
    right_coefficients = [ [ beta ] ];
    
    right_side = [ alpha ];
    
    right_divide = SolveLinearSystemInAbCategoryOrFail( cat,
                      left_coefficients, right_coefficients, right_side );
    
    if right_divide == fail
      
      return fail;
      
    end;
    
    return right_divide[1];
    
end; Description = "LiftOrFail by SolveLinearSystemInAbCategoryOrFail" );

##
AddDerivationToCAP( IsLiftable,
                    [ [ IdentityMorphism, 1 ],
                      [ MereExistenceOfSolutionOfLinearSystemInAbCategory, 1 ] ],
  function( cat, alpha, beta )
    local left_coefficients, right_coefficients, right_side;
    
    left_coefficients = [ [ IdentityMorphism( cat, Source( alpha ) ) ] ];
    
    right_coefficients = [ [ beta ] ];
    
    right_side = [ alpha ];
    
    return MereExistenceOfSolutionOfLinearSystemInAbCategory( cat,
                      left_coefficients, right_coefficients, right_side );
    
end; Description = "IsLiftable by MereExistenceOfSolutionOfLinearSystemInAbCategory" );

##
AddDerivationToCAP( Colift,
                    [ [ IdentityMorphism, 1 ],
                      [ SolveLinearSystemInAbCategory, 1 ] ],
  function( cat, alpha, beta )
    local left_coefficients, right_coefficients, right_side, left_divide;
    
    left_coefficients = [ [ alpha ] ];
    
    right_coefficients = [ [ IdentityMorphism( cat, Range( beta ) ) ] ];
    
    right_side = [ beta ];
    
    left_divide = SolveLinearSystemInAbCategory( cat,
                      left_coefficients, right_coefficients, right_side );
    
    return left_divide[1];
    
end; Description = "Colift by SolveLinearSystemInAbCategory" );

##
AddDerivationToCAP( ColiftOrFail,
                    [ [ IdentityMorphism, 1 ],
                      [ SolveLinearSystemInAbCategoryOrFail, 1 ] ],
  function( cat, alpha, beta )
    local left_coefficients, right_coefficients, right_side, left_divide;
    
    left_coefficients = [ [ alpha ] ];
    
    right_coefficients = [ [ IdentityMorphism( cat, Range( beta ) ) ] ];
    
    right_side = [ beta ];
    
    left_divide = SolveLinearSystemInAbCategoryOrFail( cat,
                      left_coefficients, right_coefficients, right_side );
    
    if left_divide == fail
      
      return fail;
      
    end;
    
    return left_divide[1];
    
end; Description = "ColiftOrFail by SolveLinearSystemInAbCategoryOrFail" );

##
AddDerivationToCAP( IsColiftable,
                    [ [ IdentityMorphism, 1 ],
                      [ MereExistenceOfSolutionOfLinearSystemInAbCategory, 1 ] ],
  function( cat, alpha, beta )
    local left_coefficients, right_coefficients, right_side;
    
    left_coefficients = [ [ alpha ] ];
    
    right_coefficients = [ [ IdentityMorphism( cat, Range( beta ) ) ] ];
    
    right_side = [ beta ];
    
    return MereExistenceOfSolutionOfLinearSystemInAbCategory( cat,
                      left_coefficients, right_coefficients, right_side );
    
end; Description = "IsColiftable by MereExistenceOfSolutionOfLinearSystemInAbCategory" );

##
AddDerivationToCAP( LiftOrFail,
                    [ [ IsLiftable, 1 ],
                      [ Lift, 1 ] ],
  function( cat, alpha, beta )
    
    if IsLiftable( cat, alpha, beta )
        
        return Lift( cat, alpha, beta );
        
    else
        
        return fail;
        
    end;
    
end; Description = "LiftOrFail using IsLiftable && Lift" );

##
AddDerivationToCAP( ColiftOrFail,
                    [ [ IsColiftable, 1 ],
                      [ Colift, 1 ] ],
  function( cat, alpha, beta )
    
    if IsColiftable( cat, alpha, beta )
        
        return Colift( cat, alpha, beta );
        
    else
        
        return fail;
        
    end;
    
end; Description = "ColiftOrFail using IsColiftable && Colift" );

##
AddDerivationToCAP( SolveLinearSystemInAbCategoryOrFail,
                    [ [ MereExistenceOfSolutionOfLinearSystemInAbCategory, 1 ],
                      [ SolveLinearSystemInAbCategory, 1 ] ],
  function( cat, left_coefficients, right_coefficients, right_side )
    
    if MereExistenceOfSolutionOfLinearSystemInAbCategory( cat, left_coefficients, right_coefficients, right_side )
        
        return SolveLinearSystemInAbCategory( cat, left_coefficients, right_coefficients, right_side );
        
    else
        
        return fail;
        
    end;
    
end; Description = "SolveLinearSystemInAbCategoryOrFail using MereExistenceOfSolutionOfLinearSystemInAbCategory && SolveLinearSystemInAbCategory" );

##
AddDerivationToCAP( IsomorphismFromItsConstructionAsAnImageObjectToHomologyObject,
  function( cat, alpha, beta )
    
    return InverseForMorphisms( cat, IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject( cat, alpha, beta ) );
    
end; Description = "IsomorphismFromItsConstructionAsAnImageObjectToHomologyObject as the inverse of IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject" );

###########################
##
## Methods returning a nonnegative integer || Inf
##
###########################

##
AddDerivationToCAP( ProjectiveDimension,
                    
  function( cat, obj )
    local dim, syzygy_obj;

    dim = 0;
    
    syzygy_obj = obj;

    while !IsProjective( cat, syzygy_obj )
      syzygy_obj = KernelObject( cat, EpimorphismFromSomeProjectiveObject( cat, syzygy_obj ) );
      dim = dim + 1;
    end;
    
    return dim;

end; CategoryFilter = cat -> HasIsLocallyOfFiniteProjectiveDimension( cat ) && IsLocallyOfFiniteProjectiveDimension( cat ) && HasIsAbelianCategory( cat ) && IsAbelianCategory( cat ),
Description = "ProjectiveDimension by iteratively testing whether the syzygy object is projective" );

##
AddDerivationToCAP( InjectiveDimension,
                    
  function( cat, obj )
    local dim, cosyzygy_obj;

    dim = 0;
    
    cosyzygy_obj = obj;

    while !IsInjective( cat, cosyzygy_obj )
      cosyzygy_obj = CokernelObject( cat, MonomorphismIntoSomeInjectiveObject( cat, cosyzygy_obj ) );
      dim = dim + 1;
    end;
    
    return dim;

end; CategoryFilter = cat -> HasIsLocallyOfFiniteInjectiveDimension( cat ) && IsLocallyOfFiniteInjectiveDimension( cat ) && HasIsAbelianCategory( cat ) && IsAbelianCategory( cat ),
Description = "InjectiveDimension by iteratively testing whether the cosyzygy object is injective" );


###########################
##
## Methods returning an object
##
###########################

##
AddDerivationToCAP( KernelObject,
                    [ [ KernelEmbedding, 1 ] ],
                    
  function( cat, mor )
    
    return Source( KernelEmbedding( cat, mor ) );
    
end; Description = "KernelObject as the source of KernelEmbedding" );

##
AddDerivationToCAP( CokernelObject,
                    [ [ CokernelProjection, 1 ] ],
                                  
  function( cat, mor )
    
    return Range( CokernelProjection( cat, mor ) );
    
end; Description = "CokernelObject as the range of CokernelProjection" );

##
AddDerivationToCAP( Coproduct,
                    [ [ InjectionOfCofactorOfCoproduct, 1 ] ],
                                        
  function( cat, object_product_list )
    
    return Range( InjectionOfCofactorOfCoproduct( cat, object_product_list, 1 ) );
    
end; CategoryFilter = cat -> !( IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true ),
      Description = "Coproduct as the range of the first injection" );

##
AddDerivationToCAP( DirectProduct,
                    [ [ ProjectionInFactorOfDirectProduct, 1 ] ],
                                        
  function( cat, object_product_list )
    
    return Source( ProjectionInFactorOfDirectProduct( cat, object_product_list, 1 ) );
    
end; CategoryFilter = cat -> !( IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true ),
      Description = "DirectProduct as Source of ProjectionInFactorOfDirectProduct" );

##
AddDerivationToCAP( DirectProduct,
                    [ [ IsomorphismFromDirectProductToDirectSum, 1 ] ],
  function( cat, object_product_list )
    
    return Source( IsomorphismFromDirectProductToDirectSum( cat, object_product_list ) );
    
end; Description = "DirectProduct as the source of IsomorphismFromDirectProductToDirectSum" );

##
AddDerivationToCAP( Coproduct,
                    [ [ IsomorphismFromDirectSumToCoproduct, 1 ] ],
  function( cat, object_product_list )
    
    return Range( IsomorphismFromDirectSumToCoproduct( cat, object_product_list ) );
    
end; Description = "Coproduct as the range of IsomorphismFromDirectSumToCoproduct" );

##
AddDerivationToCAP( TerminalObject,
                    [ [ IsomorphismFromTerminalObjectToZeroObject, 1 ] ],
               
  function( cat )
    
    return Source( IsomorphismFromTerminalObjectToZeroObject( cat ) );
    
end; Description = "TerminalObject as the source of IsomorphismFromTerminalObjectToZeroObject" );

##
AddDerivationToCAP( TerminalObject,
                    [ [ IsomorphismFromZeroObjectToTerminalObject, 1 ] ],
               
  function( cat )
    
    return Range( IsomorphismFromZeroObjectToTerminalObject( cat ) );
    
end; Description = "TerminalObject as the range of IsomorphismFromZeroObjectToTerminalObject" );

##
AddDerivationToCAP( InitialObject,
                    [ [ IsomorphismFromInitialObjectToZeroObject, 1 ] ],
               
  function( cat )
    
    return Source( IsomorphismFromInitialObjectToZeroObject( cat ) );
    
end; Description = "InitialObject as the source of IsomorphismFromInitialObjectToZeroObject" );

##
AddDerivationToCAP( InitialObject,
                    [ [ IsomorphismFromZeroObjectToInitialObject, 1 ] ],
               
  function( cat )
    
    return Range( IsomorphismFromZeroObjectToInitialObject( cat ) );
    
end; Description = "InitialObject as the range of IsomorphismFromZeroObjectToInitialObject" );


##
AddDerivationToCAP( ImageObject,
                    [ [ ImageEmbedding, 1 ] ],
                    
  function( cat, mor )
    
    return Source( ImageEmbedding( cat, mor ) );
    
end; Description = "ImageObject as the source of ImageEmbedding" );

##
AddDerivationToCAP( ImageObject,
                    
  function( cat, morphism )
    
    return Source( IsomorphismFromImageObjectToKernelOfCokernel( cat, morphism ) );
    
end; Description = "ImageObject as the source of IsomorphismFromImageObjectToKernelOfCokernel" );

##
AddDerivationToCAP( ImageObject,
                  
  function( cat, morphism )
    
    return Range( IsomorphismFromKernelOfCokernelToImageObject( cat, morphism ) );
    
end; Description = "ImageObject as the range of IsomorphismFromKernelOfCokernelToImageObject" );

##
AddDerivationToCAP( CoimageObject,
        
  function( cat, morphism )
    
    return Range( CoimageProjection( cat, morphism ) );
    
end; Description = "CoimageObject as the range of CoimageProjection" );

##
AddDerivationToCAP( CoimageObject,
        
  function( cat, morphism )
    
    return Range( IsomorphismFromCokernelOfKernelToCoimage( cat, morphism ) );
    
end; Description = "CoimageObject as the range of IsomorphismFromCokernelOfKernelToCoimage" );

##
AddDerivationToCAP( CoimageObject,
        
  function( cat, morphism )
    
    return Source( IsomorphismFromCoimageToCokernelOfKernel( cat, morphism ) );
    
end; Description = "CoimageObject as the source of IsomorphismFromCoimageToCokernelOfKernel" );

##
AddDerivationToCAP( CoimageObject,
        
  function( cat, morphism )
    
    return Range( CanonicalIdentificationFromImageObjectToCoimage( cat, morphism ) );
    
end; Description = "CoimageObject as the range of CanonicalIdentificationFromImageObjectToCoimage" );

##
AddDerivationToCAP( CoimageObject,
        
  function( cat, morphism )
    
    return Source( CanonicalIdentificationFromCoimageToImageObject( cat, morphism ) );
    
end; Description = "CoimageObject as the source of CanonicalIdentificationFromCoimageToImageObject" );

##
AddDerivationToCAP( SomeProjectiveObject,
                    [ [ EpimorphismFromSomeProjectiveObject, 1 ] ],
                    
  function( cat, obj )
    
    return Source( EpimorphismFromSomeProjectiveObject( cat, obj ) );
    
end; Description = "SomeProjectiveObject as the source of EpimorphismFromSomeProjectiveObject" );

##
AddDerivationToCAP( SomeInjectiveObject,
                    [ [ MonomorphismIntoSomeInjectiveObject, 1 ] ],
                    
  function( cat, obj )
    
    return Range( MonomorphismIntoSomeInjectiveObject( cat, obj ) );
    
end; Description = "SomeInjectiveObject as the range of MonomorphismIntoSomeInjectiveObject" );

##
AddDerivationToCAP( Equalizer,
                    [ [ EmbeddingOfEqualizer, 1 ] ],
                    
function( cat, A, diagram )
    
    return Source( EmbeddingOfEqualizer( cat, A, diagram ) );
    
end; Description = "Equalizer as the source of EmbeddingOfEqualizer" );

##
AddDerivationToCAP( Coequalizer,
                    [ [ ProjectionOntoCoequalizer, 1 ] ],
                    
  function( cat, A, diagram )
    
    return Range( ProjectionOntoCoequalizer( cat, A, diagram ) );
    
end; Description = "Coequalizer as the range of ProjectionOntoCoequalizer" );

##
AddDerivationToCAP( HomologyObject,
                    
  function( cat, alpha, beta )
    
    return Source( IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject( cat, alpha, beta ) );
    
end; Description = "HomologyObject as the source of IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject" );

###########################
##
## Methods returning a twocell
##
###########################

##
AddDerivationToCAP( HorizontalPostCompose,
                    [ [ HorizontalPreCompose, 1 ] ],
                    
  function( cat, twocell_right, twocell_left )
    
    return HorizontalPreCompose( cat, twocell_left, twocell_right );
    
end; Description = "HorizontalPostCompose using HorizontalPreCompose" );

##
AddDerivationToCAP( HorizontalPreCompose,
                    [ [ HorizontalPostCompose, 1 ] ],
                    
  function( cat, twocell_left, twocell_right )
    
    return HorizontalPostCompose( cat, twocell_right, twocell_left );
    
end; Description = "HorizontalPreCompose using HorizontalPostCompose" );

##
AddDerivationToCAP( VerticalPostCompose,
                    [ [ VerticalPreCompose, 1 ] ],
                    
  function( cat, twocell_below, twocell_above )
    
    return VerticalPreCompose( cat, twocell_above, twocell_below );
    
end; Description = "VerticalPostCompose using VerticalPreCompose" );

##
AddDerivationToCAP( VerticalPreCompose,
                    [ [ VerticalPostCompose, 1 ] ],
                    
  function( cat, twocell_above, twocell_below )
    
    return VerticalPostCompose( cat, twocell_below, twocell_above );
    
end; Description = "VerticalPreCompose using VerticalPostCompose" );

###########################
##
## Methods involving homomorphism structures
##
###########################

##
AddDerivationToCAP( SolveLinearSystemInAbCategory,
                    [ [ DistinguishedObjectOfHomomorphismStructure, 1 ],
                      [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 2 ],
                      [ HomomorphismStructureOnMorphismsWithGivenObjects, 4 ],
                      [ HomomorphismStructureOnObjects, 6 ],
                      [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 2 ],
                      [ UniversalMorphismIntoDirectSum, 1, RangeCategoryOfHomomorphismStructure ],
                      [ MorphismBetweenDirectSums, 1, RangeCategoryOfHomomorphismStructure ],
                      [ Lift, 1, RangeCategoryOfHomomorphismStructure ],
                      [ ComponentOfMorphismIntoDirectSum, 2, RangeCategoryOfHomomorphismStructure ],
                    ],
  function( cat, left_coefficients, right_coefficients, right_side )
    local range_cat, m, n, distinguished_object, interpretations, nu, H_B_C, H_A_D, list, H, lift, summands;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    m = Length( left_coefficients );
    
    n = Length( left_coefficients[1] );
    
    ## create lift diagram
    
    distinguished_object = DistinguishedObjectOfHomomorphismStructure( cat );
    interpretations = List( (1):(m), i -> InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, right_side[i] ) );
    
    nu = UniversalMorphismIntoDirectSum( range_cat,
        List( interpretations, mor -> Range( mor ) ),
        distinguished_object,
        interpretations
    );
    
    # left_coefficients[i][j]; A_i -> B_j
    # right_coefficients[i][j]; C_j -> D_i
    
    H_B_C = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Range( left_coefficients[1][j] ), Source( right_coefficients[1][j] ) ) );
    
    H_A_D = List( (1):(m), i -> HomomorphismStructureOnObjects( cat, Source( left_coefficients[i][1] ), Range( right_coefficients[i][1] ) ) );
    
    list =
      List( (1):(n),
      j -> List( (1):(m), i -> HomomorphismStructureOnMorphismsWithGivenObjects( cat, H_B_C[j], left_coefficients[i][j], right_coefficients[i][j], H_A_D[i] ) ) 
    );
    
    H = MorphismBetweenDirectSums( range_cat, H_B_C, list, H_A_D );
    
    ## the actual computation of the solution
    lift = Lift( range_cat, nu, H );
    
    ## reinterpretation of the solution
    summands = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Range( left_coefficients[1][j] ), Source( right_coefficients[1][j] ) ) );
    
    return
      List( (1):(n), j -> 
        InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat,
          Range( left_coefficients[1][j] ),
          Source( right_coefficients[1][j] ),
          ComponentOfMorphismIntoDirectSum( range_cat, lift, summands, j )
        )
      );
  end,
  CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
  CategoryFilter = cat -> HasIsAbCategory( cat ) && IsAbCategory( cat ) && HasRangeCategoryOfHomomorphismStructure( cat ),
  Description = "SolveLinearSystemInAbCategory using the homomorphism structure" 
);

##
AddDerivationToCAP( SolveLinearSystemInAbCategoryOrFail,
                    [ [ DistinguishedObjectOfHomomorphismStructure, 1 ],
                      [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 2 ],
                      [ HomomorphismStructureOnMorphismsWithGivenObjects, 4 ],
                      [ HomomorphismStructureOnObjects, 6 ],
                      [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 2 ],
                      [ UniversalMorphismIntoDirectSum, 1, RangeCategoryOfHomomorphismStructure ],
                      [ MorphismBetweenDirectSums, 1, RangeCategoryOfHomomorphismStructure ],
                      [ LiftOrFail, 1, RangeCategoryOfHomomorphismStructure ],
                      [ ComponentOfMorphismIntoDirectSum, 2, RangeCategoryOfHomomorphismStructure ],
                    ],
  function( cat, left_coefficients, right_coefficients, right_side )
    local range_cat, m, n, distinguished_object, interpretations, nu, H_B_C, H_A_D, list, H, lift, summands;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    m = Length( left_coefficients );
    
    n = Length( left_coefficients[1] );
    
    ## create lift diagram
    
    distinguished_object = DistinguishedObjectOfHomomorphismStructure( cat );
    interpretations = List( (1):(m), i -> InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, right_side[i] ) );
    
    nu = UniversalMorphismIntoDirectSum( range_cat,
        List( interpretations, mor -> Range( mor ) ),
        distinguished_object,
        interpretations
    );
    
    # left_coefficients[i][j]; A_i -> B_j
    # right_coefficients[i][j]; C_j -> D_i
    
    H_B_C = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Range( left_coefficients[1][j] ), Source( right_coefficients[1][j] ) ) );
    
    H_A_D = List( (1):(m), i -> HomomorphismStructureOnObjects( cat, Source( left_coefficients[i][1] ), Range( right_coefficients[i][1] ) ) );
    
    list =
      List( (1):(n),
      j -> List( (1):(m), i -> HomomorphismStructureOnMorphismsWithGivenObjects( cat, H_B_C[j], left_coefficients[i][j], right_coefficients[i][j], H_A_D[i] ) ) 
    );
    
    H = MorphismBetweenDirectSums( range_cat, H_B_C, list, H_A_D );
    
    ## the actual computation of the solution
    lift = LiftOrFail( range_cat, nu, H );
    
    if lift == fail
        
        return fail;
        
    end;
    
    ## reinterpretation of the solution
    summands = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Range( left_coefficients[1][j] ), Source( right_coefficients[1][j] ) ) );
    
    return
      List( (1):(n), j -> 
        InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat,
          Range( left_coefficients[1][j] ),
          Source( right_coefficients[1][j] ),
          ComponentOfMorphismIntoDirectSum( range_cat, lift, summands, j )
        )
      );
  end,
  CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
  CategoryFilter = cat -> HasIsAbCategory( cat ) && IsAbCategory( cat ) && HasRangeCategoryOfHomomorphismStructure( cat ),
  Description = "SolveLinearSystemInAbCategoryOrFail using the homomorphism structure" 
);

##
AddDerivationToCAP( MereExistenceOfSolutionOfLinearSystemInAbCategory,
                    [ [ DistinguishedObjectOfHomomorphismStructure, 1 ],
                      [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 2 ],
                      [ HomomorphismStructureOnObjects, 4 ],
                      [ HomomorphismStructureOnMorphismsWithGivenObjects, 4 ],
                      [ UniversalMorphismIntoDirectSum, 1, RangeCategoryOfHomomorphismStructure ],
                      [ MorphismBetweenDirectSums, 1, RangeCategoryOfHomomorphismStructure ],
                      [ IsLiftable, 1, RangeCategoryOfHomomorphismStructure ],
                    ],
  function( cat, left_coefficients, right_coefficients, right_side )
    local range_cat, m, n, distinguished_object, interpretations, nu, H_B_C, H_A_D, list, H;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    m = Length( left_coefficients );
    
    n = Length( left_coefficients[1] );
    
    ## create lift diagram
    
    distinguished_object = DistinguishedObjectOfHomomorphismStructure( cat );
    interpretations = List( (1):(m), i -> InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, right_side[i] ) );
    
    nu = UniversalMorphismIntoDirectSum( range_cat,
        List( interpretations, mor -> Range( mor ) ),
        distinguished_object,
        interpretations
    );
    
    # left_coefficients[i][j]; A_i -> B_j
    # right_coefficients[i][j]; C_j -> D_i
    
    H_B_C = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Range( left_coefficients[1][j] ), Source( right_coefficients[1][j] ) ) );
    
    H_A_D = List( (1):(m), i -> HomomorphismStructureOnObjects( cat, Source( left_coefficients[i][1] ), Range( right_coefficients[i][1] ) ) );
    
    list =
      List( (1):(n),
      j -> List( (1):(m), i -> HomomorphismStructureOnMorphismsWithGivenObjects( cat, H_B_C[j], left_coefficients[i][j], right_coefficients[i][j], H_A_D[i] ) ) 
    );
    
    H = MorphismBetweenDirectSums( range_cat, H_B_C, list, H_A_D );
    
    ## the actual computation of the solution
    return IsLiftable( range_cat, nu, H );
    
  end,
  CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
  CategoryFilter = cat -> HasIsAbCategory( cat ) && IsAbCategory( cat ) && HasRangeCategoryOfHomomorphismStructure( cat ),
  Description = "MereExistenceOfSolutionOfLinearSystemInAbCategory using the homomorphism structure"
);

## Final methods for Equalizer

##
AddFinalDerivationBundle( # IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct
                    [ [ JointPairwiseDifferencesOfMorphismsIntoDirectProduct, 1 ], 
                      [ KernelObject, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ Equalizer,
                      EmbeddingOfEqualizer,
                      EmbeddingOfEqualizerWithGivenEqualizer,
                      UniversalMorphismIntoEqualizer,
                      UniversalMorphismIntoEqualizerWithGivenEqualizer,
                      IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct,
                      IsomorphismFromKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProductToEqualizer ],
[
  IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct,
  function( cat, A, diagram )
    local kernel_of_pairwise_differences;
    
    kernel_of_pairwise_differences = KernelObject( cat, JointPairwiseDifferencesOfMorphismsIntoDirectProduct( cat, A, diagram ) );
    
    return IdentityMorphism( cat, kernel_of_pairwise_differences );
    
  end
],
[
  IsomorphismFromKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProductToEqualizer,
  function( cat, A, diagram )
    local kernel_of_pairwise_differences;
    
    kernel_of_pairwise_differences = KernelObject( cat, JointPairwiseDifferencesOfMorphismsIntoDirectProduct( cat, A, diagram ) );
    
    return IdentityMorphism( cat, kernel_of_pairwise_differences );
    
  end
]; Description = "IsomorphismFromEqualizerToKernelOfJointPairwiseDifferencesOfMorphismsIntoDirectProduct as the identity of the kernel of the pairwise differences" );

## Final methods for Coequalizer

##
AddFinalDerivationBundle( # IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct
                    [ [ JointPairwiseDifferencesOfMorphismsFromCoproduct, 1 ], 
                      [ CokernelObject, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ Coequalizer,
                      ProjectionOntoCoequalizer,
                      ProjectionOntoCoequalizerWithGivenCoequalizer,
                      UniversalMorphismFromCoequalizer,
                      UniversalMorphismFromCoequalizerWithGivenCoequalizer,
                      IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct,
                      IsomorphismFromCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproductToCoequalizer ],
[
  IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct,
  function( cat, A, diagram )
    local cokernel_of_pairwise_differences;
    
    cokernel_of_pairwise_differences = CokernelObject( cat, JointPairwiseDifferencesOfMorphismsFromCoproduct( cat, A, diagram ) );
    
    return IdentityMorphism( cat, cokernel_of_pairwise_differences );
    
  end
],
[
  IsomorphismFromCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproductToCoequalizer,
  function( cat, A, diagram )
    local cokernel_of_pairwise_differences;
    
    cokernel_of_pairwise_differences = CokernelObject( cat, JointPairwiseDifferencesOfMorphismsFromCoproduct( cat, A, diagram ) );
    
    return IdentityMorphism( cat, cokernel_of_pairwise_differences );
    
  end
]; Description = "IsomorphismFromCoequalizerToCokernelOfJointPairwiseDifferencesOfMorphismsFromCoproduct as the identity of the kernel of the pairwise differences" );

## Final methods for FiberProduct

##
AddFinalDerivationBundle( # IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram,
                    [ [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ], ## Length( diagram ) would be the correct number
                      [ PreCompose, 2 ], ## Length( diagram ) would be the correct number
                      [ DirectProduct, 1 ],
                      [ Equalizer, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ FiberProduct,
                      ProjectionInFactorOfFiberProduct,
                      ProjectionInFactorOfFiberProductWithGivenFiberProduct,
                      UniversalMorphismIntoFiberProduct,
                      UniversalMorphismIntoFiberProductWithGivenFiberProduct,
                      IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram,
                      IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct ],
[
  IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram,
  [ [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ], ## Length( diagram ) would be the correct number
    [ PreCompose, 2 ], ## Length( diagram ) would be the correct number
    [ DirectProduct, 1 ],
    [ Equalizer, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, diagram )
    local D, direct_product, diagram_of_equalizer, equalizer_of_direct_product_diagram;
    
    D = List( diagram, Source );
    
    direct_product = DirectProduct( cat, D );
    
    diagram_of_equalizer = List( (1):(Length( D )), i -> PreCompose( cat, ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat, D, i, direct_product ), diagram[i] ) );
    
    equalizer_of_direct_product_diagram = Equalizer( cat, direct_product, diagram_of_equalizer );
    
    return IdentityMorphism( cat, equalizer_of_direct_product_diagram );
    
  end,
],
[
  IsomorphismFromEqualizerOfDirectProductDiagramToFiberProduct,
  [ [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ], ## Length( diagram ) would be the correct number
    [ PreCompose, 2 ], ## Length( diagram ) would be the correct number
    [ DirectProduct, 1 ],
    [ Equalizer, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, diagram )
    local D, direct_product, diagram_of_equalizer, equalizer_of_direct_product_diagram;
    
    D = List( diagram, Source );
    
    direct_product = DirectProduct( cat, D );
    
    diagram_of_equalizer = List( (1):(Length( D )), i -> PreCompose( cat, ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat, D, i, direct_product ), diagram[i] ) );
    
    equalizer_of_direct_product_diagram = Equalizer( cat, direct_product, diagram_of_equalizer );
    
    return IdentityMorphism( cat, equalizer_of_direct_product_diagram );
    
  end,
]; Description = "IsomorphismFromFiberProductToEqualizerOfDirectProductDiagram as the identity of the equalizer of direct product diagram" );

## Final methods for Pushout

##
AddFinalDerivationBundle( # IsomorphismFromPushoutToCoequalizerOfCoproductDiagram,
                    [ [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ], ## Length( diagram ) would be the correct number
                      [ PreCompose, 2 ], ## Length( diagram ) would be the correct number
                      [ Coproduct, 1 ],
                      [ Coequalizer, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ Pushout,
                      InjectionOfCofactorOfPushout,
                      InjectionOfCofactorOfPushoutWithGivenPushout,
                      UniversalMorphismFromPushout,
                      UniversalMorphismFromPushoutWithGivenPushout,
                      IsomorphismFromPushoutToCoequalizerOfCoproductDiagram,
                      IsomorphismFromCoequalizerOfCoproductDiagramToPushout ],
[
  IsomorphismFromPushoutToCoequalizerOfCoproductDiagram,
  [ [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ], ## Length( diagram ) would be the correct number
    [ PreCompose, 2 ], ## Length( diagram ) would be the correct number
    [ Coproduct, 1 ],
    [ Coequalizer, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, diagram )
    local D, coproduct, diagram_of_coequalizer, coequalizer_of_coproduct_diagram;
    
    D = List( diagram, Range );
    
    coproduct = Coproduct( cat, D );
    
    diagram_of_coequalizer = List( (1):(Length( D )), i -> PreCompose( cat, diagram[i], InjectionOfCofactorOfCoproductWithGivenCoproduct( cat, D, i, coproduct ) ) );
    
    coequalizer_of_coproduct_diagram = Coequalizer( cat, coproduct, diagram_of_coequalizer );
    
    return IdentityMorphism( cat, coequalizer_of_coproduct_diagram );
    
  end,
],
[
  IsomorphismFromCoequalizerOfCoproductDiagramToPushout,
  [ [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ], ## Length( diagram ) would be the correct number
    [ PreCompose, 2 ], ## Length( diagram ) would be the correct number
    [ Coproduct, 1 ],
    [ Coequalizer, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, diagram )
    local D, coproduct, diagram_of_coequalizer, coequalizer_of_coproduct_diagram;
    
    D = List( diagram, Range );
    
    coproduct = Coproduct( cat, D );
    
    diagram_of_coequalizer = List( (1):(Length( D )), i -> PreCompose( cat, diagram[i], InjectionOfCofactorOfCoproductWithGivenCoproduct( cat, D, i, coproduct ) ) );
    
    coequalizer_of_coproduct_diagram = Coequalizer( cat, coproduct, diagram_of_coequalizer );
    
    return IdentityMorphism( cat, coequalizer_of_coproduct_diagram );
    
  end,
]; Description = "IsomorphismFromPushoutToCoequalizerOfCoproductDiagram as the identity of the coequalizer of coproduct diagram" );

## Final methods for Image

##
AddFinalDerivationBundle( # IsomorphismFromImageObjectToKernelOfCokernel,
                    [ [ KernelObject, 1 ],
                      [ CokernelProjection, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ ImageObject,
                      ImageEmbedding,
                      ImageEmbeddingWithGivenImageObject,
                      CoastrictionToImage,
                      CoastrictionToImageWithGivenImageObject,
                      UniversalMorphismFromImage,
                      UniversalMorphismFromImageWithGivenImageObject,
                      IsomorphismFromImageObjectToKernelOfCokernel,
                      IsomorphismFromKernelOfCokernelToImageObject ],
[
  IsomorphismFromImageObjectToKernelOfCokernel,
  [ [ KernelObject, 1 ],
    [ CokernelProjection, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, mor )
    local kernel_of_cokernel;
    
    kernel_of_cokernel = KernelObject( cat, CokernelProjection( cat, mor ) );
    
    return IdentityMorphism( cat, kernel_of_cokernel );
    
  end,
],
[
  IsomorphismFromKernelOfCokernelToImageObject,
  [ [ KernelObject, 1 ],
    [ CokernelProjection, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, mor )
    local kernel_of_cokernel;
    
    kernel_of_cokernel = KernelObject( cat, CokernelProjection( cat, mor ) );
    
    return IdentityMorphism( cat, kernel_of_cokernel );
    
  end,
]; CategoryFilter = IsAbelianCategory,
    Description = "IsomorphismFromImageObjectToKernelOfCokernel as the identity of the kernel of the cokernel" );

##
AddDerivationToCAP( MorphismFromCoimageToImageWithGivenObjects,
                    
  ##CoimageObject, ImageObject as Assumptions
  function( cat, coimage, morphism, image )
    local coimage_projection, cokernel_projection, kernel_lift;
    
    cokernel_projection = CokernelProjection( cat, morphism );
    
    coimage_projection = CoimageProjection( cat, morphism );
    
    kernel_lift = KernelLift( cat, cokernel_projection, coimage, AstrictionToCoimageWithGivenCoimageObject( cat, morphism, coimage ) );
    
    return PreCompose( cat, kernel_lift, IsomorphismFromKernelOfCokernelToImageObject( cat, morphism ) );
    
end; CategoryFilter = IsPreAbelianCategory,
      Description = "MorphismFromCoimageToImageWithGivenObjects using that images are given by kernels of cokernels" );

##
AddDerivationToCAP( InverseMorphismFromCoimageToImageWithGivenObjects,
                    
  function( cat, coimage, morphism, image )
    
    return InverseForMorphisms( cat, MorphismFromCoimageToImageWithGivenObjects( cat, coimage, morphism, image ) );
    
end; CategoryFilter = IsAbelianCategory,
      Description = "InverseMorphismFromCoimageToImageWithGivenObjects as the inverse of MorphismFromCoimageToImage" );

##
AddDerivationToCAP( CanonicalIdentificationFromCoimageToImageObject,
                    
  function( cat, morphism )
    
    return InverseForMorphisms( cat, CanonicalIdentificationFromImageObjectToCoimage( cat, morphism ) );
    
end; Description = "CanonicalIdentificationFromCoimageToImageObject as the inverse of CanonicalIdentificationFromImageObjectToCoimage" );

## Final methods for Coimage

##
AddFinalDerivationBundle( # IsomorphismFromCoimageToCokernelOfKernel,
                    [ [ CokernelObject, 1 ],
                      [ KernelEmbedding, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ CoimageObject,
                      CoimageProjection,
                      CoimageProjectionWithGivenCoimageObject,
                      AstrictionToCoimage,
                      AstrictionToCoimageWithGivenCoimageObject,
                      UniversalMorphismIntoCoimage,
                      UniversalMorphismIntoCoimageWithGivenCoimageObject,
                      IsomorphismFromCoimageToCokernelOfKernel,
                      IsomorphismFromCokernelOfKernelToCoimage ],
[
  IsomorphismFromCoimageToCokernelOfKernel,
  [ [ CokernelObject, 1 ],
    [ KernelEmbedding, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, mor )
    local cokernel_of_kernel;
    
    cokernel_of_kernel = CokernelObject( cat, KernelEmbedding( cat, mor ) );
    
    return IdentityMorphism( cat, cokernel_of_kernel );
    
  end,
],
[
  IsomorphismFromCokernelOfKernelToCoimage,
  [ [ CokernelObject, 1 ],
    [ KernelEmbedding, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, mor )
    local cokernel_of_kernel;
    
    cokernel_of_kernel = CokernelObject( cat, KernelEmbedding( cat, mor ) );
    
    return IdentityMorphism( cat, cokernel_of_kernel );
    
  end,
]; CategoryFilter = IsAbelianCategory,
    Description = "IsomorphismFromCoimageToCokernelOfKernel as the identity of the cokernel of the kernel" );

## Final methods for initial object

##
AddFinalDerivationBundle( # IsomorphismFromInitialObjectToZeroObject,
                    [ [ ZeroObject, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ IsomorphismFromInitialObjectToZeroObject,
                      IsomorphismFromZeroObjectToInitialObject,
                      InitialObject,
                      UniversalMorphismFromInitialObject
                      ## NOTE: the combination of AddZeroObject && AddUniversalMorphismFromInitialObjectWithGivenInitialObject
                      ## is okay because only having UniversalMorphismFromInitialObjectWithGivenInitialObject, you cannot
                      ## deduce an InitialObject
#                       UniversalMorphismFromInitialObjectWithGivenInitialObject
                    ],
[
  IsomorphismFromInitialObjectToZeroObject,
  [ [ ZeroObject, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat )
    
    return IdentityMorphism( cat, ZeroObject( cat ) );
    
  end,
],
[
  IsomorphismFromZeroObjectToInitialObject,
  [ [ ZeroObject, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat )
    
    return IdentityMorphism( cat, ZeroObject( cat ) );
    
  end,
]; Description = "IsomorphismFromInitialObjectToZeroObject as the identity of the zero object" );

## Final methods for terminal object

##
AddFinalDerivationBundle( # IsomorphismFromTerminalObjectToZeroObject,
                    [ [ ZeroObject, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ IsomorphismFromTerminalObjectToZeroObject,
                      IsomorphismFromZeroObjectToTerminalObject,
                      TerminalObject,
                      UniversalMorphismIntoTerminalObject
                      ## NOTE: the combination of AddZeroObject && AddUniversalMorphismIntoTerminalObjectWithGivenTerminalObject
                      ## is okay because only having UniversalMorphismIntoTerminalObjectWithGivenTerminalObject, you cannot
                      ## deduce a TerminalObject
#                       UniversalMorphismIntoTerminalObjectWithGivenTerminalObject
                    ],
[
  IsomorphismFromTerminalObjectToZeroObject,
  [ [ ZeroObject, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat )
    
    return IdentityMorphism( cat, ZeroObject( cat ) );
    
  end,
],
[
  IsomorphismFromZeroObjectToTerminalObject,
  [ [ ZeroObject, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat )
    
    return IdentityMorphism( cat, ZeroObject( cat ) );
    
  end,
]; Description = "IsomorphismFromTerminalObjectToZeroObject as the identity of the zero object" );

## Final methods for product

##
AddFinalDerivationBundle( # IsomorphismFromDirectSumToDirectProduct,
                    [ [ DirectSum, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ IsomorphismFromDirectSumToDirectProduct,
                      IsomorphismFromDirectProductToDirectSum,
                      DirectProduct,
                      DirectProductFunctorialWithGivenDirectProducts,
                      ProjectionInFactorOfDirectProduct,
#                       ProjectionInFactorOfDirectProductWithGivenDirectProduct,
                      UniversalMorphismIntoDirectProduct ],
#                       UniversalMorphismIntoDirectProductWithGivenDirectProduct ],
[
  IsomorphismFromDirectSumToDirectProduct,
  [ [ DirectSum, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, diagram )
    
    return IdentityMorphism( cat, DirectSum( cat, diagram ) );
    
  end,
],
[
  IsomorphismFromDirectProductToDirectSum,
  [ [ DirectSum, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, diagram )
    
    return IdentityMorphism( cat, DirectSum( cat, diagram ) );
    
  end,
]; Description = "IsomorphismFromDirectSumToDirectProduct as the identity of the direct sum" );

## Final methods for coproduct

##
AddFinalDerivationBundle( # IsomorphismFromCoproductToDirectSum,
                    [ [ DirectSum, 1 ],
                      [ IdentityMorphism, 1 ] ],
                    [ IsomorphismFromCoproductToDirectSum,
                      IsomorphismFromDirectSumToCoproduct,
                      Coproduct,
                      CoproductFunctorialWithGivenCoproducts,
                      InjectionOfCofactorOfCoproduct,
#                       InjectionOfCofactorOfCoproductWithGivenCoproduct,
                      UniversalMorphismFromCoproduct ],
#                       UniversalMorphismFromCoproductWithGivenCoproduct ],
[
  IsomorphismFromCoproductToDirectSum,
  [ [ DirectSum, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, diagram )
    
    return IdentityMorphism( cat, DirectSum( cat, diagram ) );
    
  end,
],
[
  IsomorphismFromDirectSumToCoproduct,
  [ [ DirectSum, 1 ],
    [ IdentityMorphism, 1 ] ],
  function( cat, diagram )
    
    return IdentityMorphism( cat, DirectSum( cat, diagram ) );
    
  end,
]; Description = "IsomorphismFromCoproductToDirectSum as the identity of the direct sum" );

################

## Final methods for random methods by lists

##
AddFinalDerivationBundle( # RandomObjectByList,
                    [ [ RandomObjectByInteger, 1 ],
                      [ RandomMorphismWithFixedSourceAndRangeByInteger, 1 ],
                      [ RandomMorphismWithFixedSourceByInteger, 1 ],
                      [ RandomMorphismWithFixedRangeByInteger, 1 ],
                      [ RandomMorphismByInteger, 1 ],
                    ],
                    [ RandomObjectByList,
                      RandomMorphismWithFixedSourceAndRangeByList,
                      RandomMorphismWithFixedSourceByList,
                      RandomMorphismWithFixedRangeByList,
                      RandomMorphismByList ],
[
  RandomObjectByList,
  [ [ RandomObjectByInteger, 1 ] ],
  function( cat, L )
    
    if Length( L ) != 1 || !IsInt( L[1] )
        Error( "the list passed to 'RandomObjectByList' ⥉ ", Name( cat ), " must consist of only one integer!\n" );
    end;
    
    return RandomObjectByInteger( cat, L[1] );
    
  end
],
[
  RandomMorphismWithFixedSourceAndRangeByList,
  [ [ RandomMorphismWithFixedSourceAndRangeByInteger, 1 ] ],
  function( cat, S, R, L )
    
    if Length( L ) != 1 || !IsInt( L[1] )
        Error( "the list passed to 'RandomMorphismWithFixedSourceAndRangeByList' ⥉ ", Name( cat ), " must consist of only one integer!\n" );
    end;
    
    return RandomMorphismWithFixedSourceAndRangeByInteger( cat, S, R, L[1] );
    
  end
],
[
  RandomMorphismWithFixedSourceByList,
  [ [ RandomMorphismWithFixedSourceByInteger, 1 ] ],
  function( cat, S, L )
    
    if Length( L ) != 1 || !IsInt( L[1] )
        Error( "the list passed to 'RandomMorphismWithFixedSourceByList' ⥉ ", Name( cat ), " must consist of only one integer!\n" );
    end;
    
    return RandomMorphismWithFixedSourceByInteger( cat, S, L[1] );
    
  end
],
[
  RandomMorphismWithFixedRangeByList,
  [ [ RandomMorphismWithFixedRangeByInteger, 1 ] ],
  function( cat, R, L )
    
    if Length( L ) != 1 || !IsInt( L[1] )
        Error( "the list passed to 'RandomMorphismWithFixedRangeByList' ⥉ ", Name( cat ), " must consist of only one integer!\n" );
    end;
    
    return RandomMorphismWithFixedRangeByInteger( cat, R, L[1] );
    
  end
],
[
  RandomMorphismByList,
  [ [ RandomMorphismByInteger, 1 ] ],
  function( cat, L )
    
    if Length( L ) != 1 || !IsInt( L[1] )
        Error( "the list passed to 'RandomMorphismByList' ⥉ ", Name( cat ), " must consist of only one integer!\n" );
    end;
    
    return RandomMorphismByInteger( cat, L[1] );
    
  end
]; Description = "Derive all <ByList> random methods from <ByInteger> random methods" );

## Final methods for homology object

##
AddFinalDerivationBundle( # IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject,
                    [ [ ImageObject, 1 ],
                      [ PreCompose, 1 ],
                      [ KernelEmbedding, 1 ],
                      [ CokernelProjection, 1 ],
                      [ IdentityMorphism, 1 ],
                    ],
                    [ IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject,
                      IsomorphismFromItsConstructionAsAnImageObjectToHomologyObject,
                      HomologyObject,
                      HomologyObjectFunctorialWithGivenHomologyObjects ],
[
  IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject,
  [ [ ImageObject, 1 ],
    [ PreCompose, 1 ],
    [ KernelEmbedding, 1 ],
    [ CokernelProjection, 1 ],
    [ IdentityMorphism, 1 ],
  ],
  function( cat, alpha, beta )
    local homology_object;
    
    homology_object = ImageObject( cat, PreCompose( cat, KernelEmbedding( cat, beta ), CokernelProjection( cat, alpha ) ) );
    
    return IdentityMorphism( cat, homology_object );
    
  end,
],
[
  IsomorphismFromItsConstructionAsAnImageObjectToHomologyObject,
  [ [ ImageObject, 1 ],
    [ PreCompose, 1 ],
    [ KernelEmbedding, 1 ],
    [ CokernelProjection, 1 ],
    [ IdentityMorphism, 1 ],
  ],
  function( cat, alpha, beta )
    local homology_object;
    
    homology_object = ImageObject( cat, PreCompose( cat, KernelEmbedding( cat, beta ), CokernelProjection( cat, alpha ) ) );
    
    return IdentityMorphism( cat, homology_object );
    
  end,
]; CategoryFilter = IsAbelianCategory,
      Description = "IsomorphismFromHomologyObjectToItsConstructionAsAnImageObject as the identity of the homology object constructed as an image object" );


## Final method for IsEqualForObjects
##
AddFinalDerivation( IsEqualForObjects,
                    [ ],
                    [ IsEqualForObjects ],
                    
  ReturnFail );

## Final methods for IsEqual/IsEqualForMorphisms
##
AddFinalDerivation( IsCongruentForMorphisms,
                    [ ],
                    [ IsCongruentForMorphisms,
                      IsEqualForMorphisms ],
                      
  ReturnFail; Description = "Only IsIdenticalObj for comparing" );

##
AddFinalDerivation( IsEqualForMorphisms,
                    [ ],
                    [ IsCongruentForMorphisms,
                      IsEqualForMorphisms ],
                      
  ReturnFail; Description = "Only IsIdenticalObj for comparing" );

##
AddFinalDerivation( IsCongruentForMorphisms,
                    [ [ IsEqualForMorphisms, 1 ] ],
                    [ IsCongruentForMorphisms ],
                    
  ( cat, mor1, mor2 ) -> IsEqualForMorphisms( cat, mor1, mor2 ); Description = "Use IsEqualForMorphisms for IsCongruentForMorphisms" );

##
AddFinalDerivation( IsEqualForMorphisms,
                    [ [ IsCongruentForMorphisms, 1 ] ],
                    [ IsEqualForMorphisms ],
                    
  ( cat, mor1, mor2 ) -> IsCongruentForMorphisms( cat, mor1, mor2 ); Description = "Use IsCongruentForMorphisms for IsEqualForMorphisms" );

## Final methods for BasisOfExternalHom & CoefficientsOfMorphism

##
AddFinalDerivationBundle( # BasisOfExternalHom,
                    [
                      [ HomomorphismStructureOnObjects, 1 ],
                      [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 2 ],
                      [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 1 ],
                      [ DistinguishedObjectOfHomomorphismStructure, 1 ],
                      [ BasisOfExternalHom, 1, RangeCategoryOfHomomorphismStructure ],
                      [ CoefficientsOfMorphism, 1, RangeCategoryOfHomomorphismStructure ],
                    ],
                    [
                      BasisOfExternalHom,
                      CoefficientsOfMorphism
                    ],
[
  BasisOfExternalHom,
  [
    [ HomomorphismStructureOnObjects, 1 ],
    [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 2 ],
    [ DistinguishedObjectOfHomomorphismStructure, 1 ],
    [ BasisOfExternalHom, 1, RangeCategoryOfHomomorphismStructure ],
  ],
  function( cat, a, b )
    local range_cat, hom_a_b, D, B;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    hom_a_b = HomomorphismStructureOnObjects( cat, a, b );
    
    D = DistinguishedObjectOfHomomorphismStructure( cat );
    
    B = BasisOfExternalHom( range_cat, D, hom_a_b );
    
    return List( B, m -> InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat, a, b, m ) );
  
  end,
],
[
  CoefficientsOfMorphism,
  [
    [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 1 ],
    [ CoefficientsOfMorphism, 1, RangeCategoryOfHomomorphismStructure ],
  ],
  function( cat, alpha )
    local range_cat, beta;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    beta = InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, alpha );
    
    return CoefficientsOfMorphism( range_cat, beta );
    
  end,
],
  CategoryGetters = rec( range_cat = RangeCategoryOfHomomorphismStructure ),
  CategoryFilter =
    function( cat )
      local range_cat, required_methods;
      
      if !( HasIsLinearCategoryOverCommutativeRing( cat ) && IsLinearCategoryOverCommutativeRing( cat ) )
        
        return false;
        
      end;
      
      if !HasRangeCategoryOfHomomorphismStructure( cat )
        
        return false;
        
      end;
      
      range_cat = RangeCategoryOfHomomorphismStructure( cat );
      
      if IsIdenticalObj( cat, range_cat )
        
        return false;
        
      end;
      
      if !( HasIsLinearCategoryOverCommutativeRing( range_cat ) && IsLinearCategoryOverCommutativeRing( range_cat ) )
        
        return false;
        
      end;
      
      if !IsIdenticalObj( CommutativeRingOfLinearCategory( cat ), CommutativeRingOfLinearCategory( range_cat ) )
        
        return false;
        
      end;
      
      return true;
      
  end,
  Description = "Adding BasisOfExternalHom && CoefficientsOfMorphism using homomorphism structure"
);
