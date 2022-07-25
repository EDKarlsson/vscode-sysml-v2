grammar SysML
// KerML Element Hierarchy
import "sysml.types";


entry RootNamespace: 
    package+=Package
    | Comment
    ;

// Package:
//     'package' Identification '{' element+=Element* '}'
//     ;

/************************************************
 * Elements Concrete Syntax
 ************************************************/

Element returns SysMLElement:
    'element' Identification (';' | ElementBodyWithElement )
    // 'element' Identification (';' | '{' OwnedElement* '}')
    ;

fragment ElementBodyWithElement infers Element:
    '{' OwnedElement* '}'
    ;

fragment ElementBody infers Element:
    '{' OwnedElement* '}'|   ';' 
    ;

fragment Identification infers Element:
    ( '<' shortName = ID '>' )? ( name=ID )?
    ;

fragment OwnedElement infers Element:
    ownedRelationship = OwnedRelationship
    | ownedRelationship += OwnedCommentAnnotation
    | ownedRelationship += OwnedTextualRepresentationAnnotation
    | ownedRelationship += OwnedMetadataFeatureAnnotation
    ;

// fragment OtherOwnedElement infers Element:
//     'language' language=STRING
//     | 'doc' comment=REGULAR_COMMENT
//     ;

/************************************************
 * Relationship Concrete Syntax
 ************************************************/

// Grammar Definition for
RelationshipElement returns Relationship:
    'relationship' Identification
    RelationshipRelatedElements
    RelationshipBody
    ;

interface Relationship extends Element {
    target?:@Element
    source?:@Element
    ownedRelationship?:Relationship[]
}

OwnedRelationship returns Relationship:
    'relationship' Identification
    ( 'to' RelationshipTargetList )?
    RelationshipBody
    ;

RelationshipRelatedElements returns Relationship:
    ( 'from' RelationshipSourceList )?
    ( 'to' RelationshipTargetList )?
    ;
fragment RelationshipSourceList:
    RelationshipSource (',' RelationshipSource )*
    ;

fragment RelationshipSource:
    source += [Element:ID]
    ;

fragment RelationshipTargetList:
    RelationshipTarget (',' RelationshipTarget )*
    ;

fragment RelationshipTarget:
    target += [Element:ID]
    ;

fragment RelationshipBody:
    ';' | '{' RelationshipOwnedElement '}'
    ;

fragment RelationshipOwnedElement:
    OwnedRelatedElementRelationship
    | OwnedCommentTextualMetadataAnnotation
    ;

OwnedRelatedElementRelationship:
    ownedRelatedElement += OwnedRelatedElement
    |ownedRelatedElement += OwnedRelatedRelationship
    ;

fragment OwnedCommentTextualMetadataAnnotation:
    ownedRelationship += OwnedCommentAnnotation
    | ownedRelationship += OwnedTextualRepresentationAnnotation
    //     | OwnedMetadataFeatureAnnotation
    ;

OwnedRelatedElement infers Element:
    'element' Identification ElementBody
    ;

OwnedRelatedRelationship returns Relationship:
    'relationship' Identification
    RelationshipRelatedElements
    RelationshipBody
    ;
/************************************************
 * Comments
 ************************************************/
Comment:
    'comment' Identification
    (
        'about' annotation += Annotation
        // { ownedRelationship += annotation }
        (
            ',' annotation += Annotation
            // { ownedRelationship += annotation }
        )*
    )?
    body = REGULAR_COMMENT
    ;
Annotation:
    annotatedElement = [Element:ID]
    ;
fragment PrefixComment infers Comment:
    ( 'comment' Identification )?
    body = PREFIX_COMMENT
    ;
fragment Documentation infers Comment:
    'doc' Identification
    body=REGULAR_COMMENT
    ;
OwnedCommentAnnotation infers Annotation:
    ownedRelatedElement+= OwnedCommentOrDocumentation
    ;
OwnedCommentOrDocumentation:
    OwnedComment
    |OwnedDocumentation
    ;
fragment OwnedComment infers Comment:
    ( 'coment' Identification )?
    body =REGULAR_COMMENT // { annotation += a}
    ;
fragment OwnedDocumentation infers Documentation:
    'doc' Identification
    body = REGULAR_COMMENT // { annotation += a}
    ;

/************************************************
 * Textual Representation 
 ************************************************/
OwnedTextualRepresentationAnnotation infers Annotation :
    // ownedRelatedElement += OwnedTextualRepresentation
    ownedRelatedElement += OwnedTextualRepresentation
    ;
OwnedTextualRepresentation infers TextualRepresentation :
    ( 'rep' Identification )?
    'language' language = STRING_VALUE 
    body = REGULAR_COMMENT
    // { annotation += a }
    ;
TextualRepresentation:
    ( 'rep' Identification )?
    'language' language = STRING_VALUE 
    body = REGULAR_COMMENT
    ;
/************************************************
 * Namespaces
 ************************************************/
 Namespace:
    NamespaceDeclaration NamespaceBody
    ;

fragment NamespaceDeclaration:
    'namespace' Identification
    ;

NamespaceBody infers Namespace:
    ';' 
    | '{' NamespaceBodyElement* '}'
    ;

fragment NamespaceBodyElement:
    OwnedRelationshipNamespaceMember
    | OwnedRelationshipAliasMember
    | OwnedRelationshipImport
    ;

fragment OwnedRelationshipNamespaceMember:
    ownedRelationship += NamespaceMember
    ;
fragment OwnedRelationshipAliasMember:
    ownedRelationship += AliasMember
    ;
fragment OwnedRelationshipImport:
    ownedRelationship += Import
    ;
fragment MemberPrefix:
    (visibility = VisibilityIndicator)?
    ;
NamespaceMember:
    NonFeatureMember
    | NamespaceFeatureMember
    NamespaceFeatureMember
    ;
NonFeatureMember infers OwningMembership :
    MemberPrefix
    ownedMemberElement = NonFeatureElement
;
NamespaceFeatureMember infers Membership :
    MemberPrefix
    ownedMemberElement = FeatureElement
;
AliasMember infers Membership :
    MemberPrefix
    'alias' ( '<' memberShortName = ID'>' )?
    ( memberName = ID)?
    'for' memberElement = [QualifiedName] ';'
    ;
Import: 
    ( visibility = VisibilityIndicator )?
    'import' ( isImportAll ?= 'all' )?
    ( ImportedNamespace
    | ImportedFilterPackage ) ';'
    ;
ImportedNamespace infers Import :
    ( importedNamespace = [QualifiedName] '::' )?
    ( importedName = ID| '*' )
    ( '::' isRecursive ?= '**' )?
    ;
ImportedFilterPackage infers Import:
    importedNamespace = FilterPackage
    // { ownedRelatedElement += importedNamespace }
    ;
FilterPackage infers Package :
    ownedRelationship += FilterPackageImport
    ( ownedRelationship += FilterPackageMember )+
;
FilterPackageImport infers Import :
    ImportedNamespace
;
FilterPackageMember infers ElementFilterMembership :
    '[' condition = OwnedExpression ']'
    // { visibility = 'private' }
    ;

// VisibilityIndicator infers VisibilityKind :
terminal VisibilityIndicator:
    'public' | 'private' | 'protected'
    ;


/************************************************
 * Namespace Elements
 ************************************************/
 NonFeatureElement infers Element :
    Element
    | RelationshipElement
    | Comment
    | PrefixComment
    | Documentation
    | TextualRepresentation
    | MetadataFeature
    | Namespace
    | Type
    | Classifier
    | DataType
    | Class
    | Structure
    | Metaclass
    | Association
    | AssociationStructure
    | Interaction
    | Behavior
    | Function
    | Predicate
    | Multiplicity
    | Package
    | Specialization
    | Conjugation
    | Subclassification
    | Disjoining
    | FeatureInverting
    | FeatureTyping
    | Subsetting
    | Redefinition
    | TypeFeaturing
    ;
FeatureElement infers Feature :
    Feature
    | Step
    | Expression
    | BooleanExpression
    | Invariant
    | Connector
    | BindingConnector
    | Succession
    | ItemFlow
    | SuccessionItemFlow
    ;
/************************************************
 * Name Resolution
 ************************************************/
QualifiedName: 
    name=ID( '::' ID )*
    ;
/************************************************
 * Types
 ************************************************/
Type:
    ( isAbstract ?= 'abstract' )? 'type'
    TypeDeclaration TypeBody
    ;

fragment TypeDeclaration infers Type:
    (isSufficient ?= 'all' )? Identification
    ( ownedRelationship += OwnedMultiplicity )?
    ( SpecializationPart | ConjugationPart )+
    DisjoiningPart?
    ;
SpecializationPart infers Type :
    SPECIALIZES ownedRelationship += OwnedSpecialization
    ( ',' ownedRelationship += OwnedSpecialization )*
    ;
ConjugationPart infers Type :
    CONJUGATES ownedRelationship += OwnedConjugation
    ;
DisjoiningPart infers Type :
    'disjoint' 'from' ownedRelationship += OwnedDisjoining
    ( ',' ownedRelationship += OwnedDisjoining )*
    ;
TypeBody infers Type :
    ';' | '{' TypeBodyElement* '}'
    ;
TypeBodyElement infers Type :
    ownedRelationship += NonFeatureMember
    | ownedRelationship += FeatureMember
    | ownedRelationship += AliasMember
    | ownedRelationship += Import
    ;
/************************************************
 * Specialization
 ************************************************/
 Specialization :
    ( 'specialization' Identification )?
    'subtype' SpecificType
    SPECIALIZES GeneralType ';'
    ;
OwnedSpecialization infers Specialization :
    GeneralType
    ;
SpecificType infers Specialization :
    specific = [QualifiedName]
    | specific += OwnedFeatureChain
    // { ownedRelatedElement += specific }
    ;
GeneralType infers Specialization :
    general = [QualifiedName]
    | general += OwnedFeatureChain
    // { ownedRelatedElement += general }
    ;
/************************************************
 * Conjugation
 ************************************************/
 Conjugation:
    ( 'conjugation' Identification )?
    'conjugate'
    ( conjugatedType = [QualifiedName]
    | conjugatedType = FeatureChain
    // { ownedRelatedElement += conjugatedType } 
    )
    CONJUGATES
    ( originalType = [QualifiedName]
    | originalType = FeatureChain
    // { ownedRelatedElement += originalType } 
    ) ';'
    ;
OwnedConjugation infers Conjugation :
    originalType = [QualifiedName]
    | originalType = FeatureChain
    // { ownedRelatedElement += originalType }
    ;
/************************************************
 * Disjoining
 ************************************************/
 Disjoining :
    ( 'disjoining' Identification )?
    'disjoint'
    ( typeDisjoined = [QualifiedName]
    | typeDisjoined = FeatureChain
    // { ownedRelatedElement += typeDisjoined } 
    )
    'from'
    ( disjoiningType = [QualifiedName] | disjoinginType = FeatureChain) ';'
    // { ownedRelatedElement += disjoiningType } 
    ;
OwnedDisjoining infers Disjoining :
    disjoiningType = [QualifiedName]
    | disjoinginType = FeatureChain
    // { ownedRelatedElement += disjoiningType }
    ;
/************************************************
 * Feature Membership
 ************************************************/
 FeatureMember infers OwningMembership :
    TypeFeatureMember
    | OwnedFeatureMember
    ;
TypeFeatureMember infers OwningMembership :
    MemberPrefix 'member' ownedMemberElement = FeatureElement
    ;
OwnedFeatureMember infers FeatureMembership :
    MemberPrefix ownedMemberFeature = FeatureElement
    ;
/************************************************
 * Classifiers
 ************************************************/
 Classifier :
    ( isAbstract ?= 'abstract' ) 'classifier'
    ClassifierDeclaration TypeBody
    ;
ClassifierDeclaration infers Type :
    ( isSufficient ?= 'all' )? Identification
    ( ownedRelationship += OwnedMultiplicity )?
    ( SuperclassingPart | ConjugationPart )?
    DisjoiningPart?
    ;
SuperclassingPart infers Type :
    SPECIALIZES ownedRelationship += OwnedSubclassification
    ( ',' ownedRelationship += OwnedSubclassification )*
    ;
/************************************************
 * Subclassification
 ************************************************/
 Subclassification :
    ( 'specialization' Identification )?
    'subclassifier' subclassifier = [QualifiedName]
    SPECIALIZES superclassifier = [QualifiedName] ';'
    ;
OwnedSubclassification infers Subclassification :
    superclassifier = [QualifiedName]
    ;
/************************************************
 * Features
 ************************************************/
 Feature :
    FeaturePrefix
    'feature'? FeatureDeclaration
    ValuePart? TypeBody
    ;
FeaturePrefix infers Feature:
    ( direction = FeatureDirection )?
    ( isAbstract ?= 'abstract' )?
    ( isComposite ?= 'composite' | isPortion ?= 'portion' )?
    ( isReadOnly ?= 'readonly' )?
    ( isDerived ?= 'derived' )?
    ( isEnd ?= 'end' )?
    ;
// FeatureDirection infers FeatureDirectionKind :
terminal FeatureDirection:
    'in' | 'out' | 'inout'
    ;
FeatureDeclaration infers Feature :
    ( isSufficient ?= 'all' )? Identification
    ( FeatureSpecializationPart | ConjugationPart )?
    FeatureRelationshipPart*
    ;
FeatureRelationshipPart infers Feature :
    ChainingPart
    | DisjoiningPart
    | InvertingPart
    | TypeFeaturingPart
    ;
ChainingPart infers Feature :
    'chains' FeatureChain
    ;
InvertingPart infers Feature :
    'inverse' 'of' ownedRelationship += OwnedFeatureInverting
    ;
TypeFeaturingPart infers Feature :
    'featured' 'by' ownedRelatioship += OwnedTypeFeaturing
    ( ',' ownedTypeFeaturing += OwnedTypeFeaturing )*
    ;
FeatureSpecializationPart infers Feature :
    FeatureSpecialization+ MultiplicityPart? FeatureSpecialization*
    | MultiplicityPart FeatureSpecialization*
    ;
MultiplicityPart infers Feature:
    ownedRelationship += OwnedMultiplicity
    | ( ownedRelationship += OwnedMultiplicity )?
    ( isOrdered ?= 'ordered' ( /*{isUnique = false}*/ 'nonunique' )?
    | 'nonunique' ( isOrdered ?= 'ordered' )? )
    // | {isUnique = false} 'nonunique' ( isOrdered ?= 'ordered' )? )
    ;
FeatureSpecialization infers Feature:
    Typings | Subsettings | Redefinitions
    ;
Typings infers Feature:
    TypedBy ( ',' ownedRelationship += OwnedFeatureTyping )*
    ;
TypedBy infers Feature:
    TYPED_BY ownedRelationship += OwnedFeatureTyping
    ;
Subsettings infers Feature:
    Subsets ( ',' ownedRelationship += OwnedSubsetting )*
    ;
Subsets infers Feature:
    SUBSETS ownedRelationship += OwnedSubsetting
    ;
Redefinitions infers Feature:
    Redefines ( ',' ownedRelationship += OwnedRedefinition )*
    ;
Redefines infers Feature :
    REDEFINES ownedRelationship += OwnedRedefinition
    ;
/************************************************
 * Feature Typing
 ************************************************/
 FeatureTyping:
    ( 'specialization' Identification )?
    'typing' typedFeature = [QualifiedName]
    TYPED_BY GeneralType ';'
    ;
OwnedFeatureTyping infers FeatureTyping :
    GeneralType
    ;
/************************************************
 * Subsetting
 ************************************************/
 Subsetting:
    ( 'specialization' Identification )?
    'subset' SpecificType
    SUBSETS GeneralType ';'
    ;
OwnedSubsetting infers Subsetting:
    GeneralType
    ;
/************************************************
 * Redefinition
 ************************************************/
 Redefinition:
    ( 'specialization' Identification )?
    'redefinition' SpecificType
    REDEFINES GeneralType ';'
    ;
OwnedRedefinition infers Redefinition:
    GeneralType
    ;
/************************************************
 * Feature Chaining
 ************************************************/
 OwnedFeatureChain infers Feature:
    FeatureChain
    ;
FeatureChain infers Feature:
    ownedRelationship += OwnedFeatureChaining
    ( '.' ownedRelationship += OwnedFeatureChaining )+
    ;
OwnedFeatureChaining infers FeatureChaining:
    chainingFeature = [QualifiedName]
    ;
/************************************************
 * Feature Inverting
 ************************************************/
 FeatureInverting:
    ( 'inverting' Identification? )?
    'inverse'
    ( featureInverted = [QualifiedName]
    | featureInverted = OwnedFeatureChain
    // { ownedRelatedElement += featureInverted } 
    )
    'of'
    ( invertingFeature = [QualifiedName]
    | ownedRelatedElement += OwnedFeatureChain
    // { ownedRelatedElement += invertingFeature } 
    ) ';'
    ;
OwnedFeatureInverting infers FeatureInverting:
    invertingFeature = [QualifiedName]
    | invertingFeature = OwnedFeatureChain
    // { ownedRelatedElement += invertingFeature }
    ;
/************************************************
 * Type Featuring
 ************************************************/
TypeFeaturing:
    'featuring' ( Identification 'of')?
    featureOfType = [QualifiedName]
    'by' featuringType = [QualifiedName] ';'
    ;
OwnedTypeFeaturing infers TypeFeaturing:
    featuringType = [QualifiedName]
    ;
/************************************************
 * Data Types
 ************************************************/
DataType:
    ( isAbstract ?= 'abstract' )? 'datatype'
    ClassifierDeclaration TypeBody
    ;
/************************************************
 * Classes
 ************************************************/
 Class:
    ( isAbstract ?= 'abstract' )? 'class'
    ClassifierDeclaration TypeBody
    ;
/************************************************
 * Structure
 ************************************************/
Structure:
    ( isAbstract ?= 'abstract' )? 'struct'
    ClassifierDeclaration TypeBody
    ;
/************************************************
 * Associations
 ************************************************/
 Association:
    ( isAbstract ?= 'abstract' )? 'assoc'
    ClassifierDeclaration TypeBody
    ;
AssociationStructure:
    ( isAbstract ?= 'abstract' )? 'assoc' 'struct'
    ClassifierDeclaration TypeBody
    ;
/************************************************
 * Connectors
 ************************************************/
 Connector:
    FeaturePrefix 'connector'
    ConnectorDeclaration TypeBody
    ;
ConnectorDeclaration infers Connector:
    BinaryConnectorDeclaration | NaryConnectorDeclaration
    ;
BinaryConnectorDeclaration infers Connector:
    ( FeatureDeclaration? 'from' | isSufficient ?= 'all' 'from'? )?
    ownedRelationship += ConnectorEndMember 'to'
    ownedRelationship += ConnectorEndMember
    ;
NaryConnectorDeclaration infers Connector :
    FeatureDeclaration
    ( '(' ownedRelationship += ConnectorEndMember ','
    ownedRelationship += ConnectorEndMember
    ( ',' ownedRelationship += ConnectorEndMember )* ')' )?
    ;
ConnectorEndMember infers EndFeatureMembership :
    ownedMemberFeature = ConnectorEnd
    ;
ConnectorEnd infers Feature :
    ( name = ID ':>' )?
    ownedRelationship += OwnedSubsetting
    ( ownedRelationship += OwnedMultiplicity )?
    ;
/************************************************
 * Binding Connectors
 ************************************************/
 BindingConnector:
    FeaturePrefix 'binding'
    BindingConnectorDeclaration
    // BindingConnectorDeclarationTypeBody
    ;
BindingConnectorDeclaration infers BindingConnector:
    ( FeatureDeclaration 'of' | isSufficient ?= 'all' 'of'? )?
    ownedRelationship += ConnectorEndMember '='
    ownedRelationship += ConnectorEndMember
    ;
/************************************************
 * Successions
 ************************************************/
 Succession:
    FeaturePrefix 'succession'
    SuccessionDeclaration TypeBody
    ;
SuccessionDeclaration infers Succession:
    ( FeatureDeclaration? 'first' | isSufficient ?= 'all' 'first'? )?
    ownedRelationship += ConnectorEndMember 'then'
    ownedRelationship += ConnectorEndMember
    ;
/************************************************
 * Behaviors
 ************************************************/
 Behavior:
    ( isAbstract ?= 'abstract')? 'behavior'
    BehaviorDeclaration TypeBody
    ;
BehaviorDeclaration infers Behavior:
    ClassifierDeclaration ParameterList?
    ;
ParameterList infers Type:
    '(' ( ownedRelationship += ParameterMember
    ( ',' ownedRelationship += ParameterMember )* )? ')'
    ;
ParameterMember infers ParameterMembership:
    ownedMemberParameter = ParameterDeclaration
    ;
ParameterDeclaration infers Feature:
    FeatureParameterDeclaration
    | StepParameterDeclaration
    | ExpressionParameterDeclaration
    | BooleanExpressionParameterDeclaration
    ;
FeatureParameterDeclaration infers Feature:
    ( direction = FeatureDirection )?
    'feature'? ( isSufficient ?= 'all' )? Identification
    ParameterSpecializationPart
    ;
StepParameterDeclaration infers Step:
    ( direction = FeatureDirection )?
    'step' ( isSufficient ?= 'all' )? Identification
    ParameterSpecializationPart
    ;
ExpressionParameterDeclaration infers Expression:
    ( direction = FeatureDirection )?
    'expr' ( isSufficient ?= 'all' )? Identification
    ParameterSpecializationPart
    ;
BooleanExpressionParameterDeclaration infers BooleanExpression :
    ( direction = FeatureDirection )?
    'bool' ( isSufficient ?= 'all' )? Identification
    ParameterSpecializationPart
    ;
ParameterSpecializationPart infers Feature:
    ParameterSpecialization* MultiplicityPart? ParameterSpecialization*
    // ParameterSpecialization* MultiplicityPart? ParameterSpecialization(f)*
    ;
ParameterSpecialization infers Feature:
    TypedBy | Subsets | Redefines
    ;
/************************************************
 * Steps
 ************************************************/
 Step:
    FeaturePrefix 'step'
    StepDeclaration TypeBody
    ;
StepDeclaration infers Step:
    FeatureDeclaration ( ValuePart | StepParameterList )?
    ;
StepParameterList infers Type:
    '(' ( ownedRelationship += StepParameterMember
    ( ',' ownedRelationship += StepParameterMember )* )? ')'
    ;
StepParameterMember infers ParameterMembership :
    ownedMemberParameter = StepParameter
    ;
StepParameter infers Feature:
    ParameterDeclaration ValuePart?
    ;
/************************************************
 * Functions
 ************************************************/
 Function:
    ( isAbstract ?= 'abstract' )? 'function'
    FunctionDeclaration FunctionBody
    ;
FunctionDeclaration infers Function:
    ClassifierDeclaration ParameterList ReturnParameterPart?
    ;
ReturnParameterPart infers Type :
    ownedRelationship += ReturnParameterMember
    ;
ReturnParameterMember infers ReturnParameterMembership:
    'return'? ownedMemberParameter = ParameterDeclaration
    ;
FunctionBody infers Type :
    ';'
    | '{' ( TypeBodyElement
    | ownedRelationship += ReturnFeatureMember
    )*
    ( ownedRelationship += ResultExpressionMember )?
    '}'
    ;
ReturnFeatureMember infers ReturnParameterMembership:
    MemberPrefix 'return'
    ownedMemberParameter = FeatureElement
    ;
ResultExpressionMember infers ResultExpressionMembership :
    MemberPrefix
    ownedResultExpression = OwnedExpression
    ;
/************************************************
 * Expressions
 ************************************************/
 Expression:
    FeaturePrefix 'expr'
    ExpressionDeclaration
    // ExpressionDeclarationFunctionBody
    ;
ExpressionDeclaration infers Expression:
// ExpressionDeclarationFunctionBody infers Expression:
    FeatureDeclaration
    ( ValuePart | StepParameterList ReturnParameterPart? )?
    ;
/************************************************
 * Predicates
 ************************************************/
 Predicate:
    ( isAbstract ?= 'abstract' )? 'predicate'
    PredicateDeclaration FunctionBody
    ;
PredicateDeclaration infers Predicate:
    ClassifierDeclaration
    ( ParameterList ReturnParameterPart? )?
    ;
/************************************************
 * Boolean Expresions and Invariants
 ************************************************/
 BooleanExpression:
    FeaturePrefix 'bool'
    ExpressionDeclaration
    ;
Invariant :
    FeaturePrefix 'inv' ( 'true' | isNegated ?= 'false' )?
    ExpressionDeclaration FunctionBody
    ;
/************************************************
 * Operator Expressions
 ************************************************/
OwnedExpressionReferenceMember infers FeatureMembership :
    ownedRelationship += OwnedExpressionReference
    ;
OwnedExpressionReference infers FeatureReferenceExpression :
    ownedRelationship += OwnedExpressionMember
    ;
OwnedExpressionMember infers FeatureMembership :
    ownedFeatureMember = OwnedExpression
    ;
OwnedExpression infers Expression :
    ConditionalExpression
    | BinaryOperatorExpression
    | UnaryOperatorExpression
    | ClassificationExpression
    | ExtentExpression
    | PrimaryExpression
    ;
ConditionalExpression infers OperatorExpression :
    ownedRelationship += OwnedExpressionMember
    operator = '?'
    ownedRelationship += OwnedExpressionReferenceMember ':'
    ownedRelationship += OwnedExpressionReferenceMember
    | 'if' ownedRelationship += OwnedExpressionMember
    operator = '?'
    ownedRelationship += OwnedExpressionReferenceMember 'else'
    ownedRelationship += OwnedExpressionReferenceMember
    ;
ConditionalBinaryOperatorExpression infers OperatorExpression:
    ownedRelationship += OwnedExpressionMember
    operator = ConditionalBinaryOperator
    ownedRelationship += OwnedExpressionReferenceMember
    ;
terminal ConditionalBinaryOperator:
    '??' | '||' | '&&' | 'or' | 'and' | 'implies'
    ;
BinaryOperatorExpression infers OperatorExpression:
    ownedRelationship += OwnedExpressionMember
    operator = BinaryOperator
    ownedRelationship += OwnedExpressionMember
    ;
terminal BinaryOperator:
    '|' | '&' | '^^' | 'xor' | '==' | '!='
    | '..' | '<' | '>' | '<=' | '>=' | '+'
    | '-' | '*' | '/' | '%'
    | '^' | '**'
    ;
UnaryOperatorExpression infers OperatorExpression:
    operator = UnaryOperator
    ownedRelationship += OwnedExpressionMember
    ;
terminal UnaryOperator:
    '+' | '-' | '!' | '~' | 'not'
    ;
ClassificationExpression infers OperatorExpression:
    ( ownedRelationship += OwnedExpressionMember )?
    operator = ClassificationOperator
    ownedRelationship += TypeReferenceMember
    ;
terminal ClassificationOperator :
    'istype' | 'hastype' | '@' | 'as'
    ;
ExtentExpression infers OperatorExpression:
    operator = 'all'
    ownedRelationship += TypeReferenceMember
    ;
TypeReferenceMember infers FeatureMembership:
    ownedMemberFeature = TypeReference
    ;
TypeReference infers Feature:
    ownedRelationship += ReferenceTyping
    ;
ReferenceTyping infers FeatureTyping:
    type = [QualifiedName]
    ;
/************************************************
 * Primary Expressions
 ************************************************/
 PrimaryExpression infers Expression:
    FeatureChainExpression
    | NonFeatureChainPrimaryExpression
    ;
PrimaryExpressionMember infers FeatureMembership:
    ownedMemberFeature = PrimaryExpression
    ;
NonFeatureChainPrimaryExpression infers Expression:
    IndexExpression
    | SequenceExpression
    | SelectExpression
    | CollectExpression
    | FunctionOperationExpression
    | BaseExpression
    ;
NonFeatureChainPrimaryExpressionMember infers FeatureMembership:
    ownedMemberFeature = NonFeatureChainPrimaryExpression
    ;
IndexExpression infers OperatorExpression:
    ownedRelationship += PrimaryExpressionMember
    operator = '['
    ownedRelationship += OwnedExpressionMember ']'
    ;
SequenceExpression infers Expression:
    '(' ( OwnedExpression | SequenceExpressionList ) ','? ')'
    ;
SequenceExpressionList infers OperatorExpression:
    ownedRelationship += OwnedExpressionMember
    operator = ','
    ( ownedRelationship += SequenceExpressionListMember
    | ownedRelationship += OwnedExpressionMember )
    ;
SequenceExpressionListMember infers FeatureMembership:
    ownedMemberFeature = SequenceExpressionList
    ;
FeatureChainExpression infers FeatureChainExpression:
    ownedRelationship += NonFeatureChainPrimaryExpressionMember '.'
    ownedRelationship += FeatureChainMember
    ;
CollectExpression infers CollectExpression:
    ownedRelationship += PrimaryExpressionMember '.'
    ownedRelationship += BodyExpressionMember
    ;
SelectExpression infers SelectExpression:
    ownedRelationship += PrimaryExpressionMember '.?'
    ownedRelationship += BodyExpressionMember
    ;
FunctionOperationExpression infers InvocationExpression:
    ownedRelationship += PrimaryExpressionMember '->'
    ownedRelationship += ReferenceTyping
    ( ownedRelationship += BodyExpressionMember
    | ownedRelationship += FunctionExpressionMember
    // | ownedRelationship += FunctionReferenceExpressionMember
    | ArgumentList )
    ;
BodyExpressionMember infers FeatureMembership :
    ownedMemberFeature = BodyExpression
    ;
FunctionExpressionMember infers FeatureMembership:
    ownedMemberFeature = FunctionReferenceExpression
    ;
FunctionReferenceExpression infers FeatureReferenceExpression:
    ownedRelationship += FunctionReferenceMember
    ;
FunctionReferenceMember infers FeatureMembership :
    ownedMemberFeature = FunctionReference
    ;
FunctionReference infers Expression:
    ownedRelationship += ReferenceTyping
    ;
FeatureChainMember infers Membership :
    FeatureReferenceMember
    | OwnedFeatureChainMember
    ;
OwnedFeatureChainMember infers OwningMembership:
    ownedMemberElement = FeatureChain
    ;
/************************************************
 * Base Expressions
 ************************************************/
 BaseExpression infers Expression:
    NullExpression
    | LiteralExpression
    | FeatureReferenceExpression
    | InvocationExpression
    | BodyExpression
    ;
// terminal NullExpression infers NullExpression:
terminal NullExpression:
    'null' | '(' ')'
    ;
FeatureReferenceExpression infers FeatureReferenceExpression:
    ownedRelationship += FeatureReferenceMember
    ;
FeatureReferenceMember infers Membership:
    memberElement = [QualifiedName]
    // memberElement = FeatureReference
    ;
// FeatureReference returns Feature:
// FeatureReference infers Feature:
//     [QualifiedName]
//     ;
InvocationExpression infers InvocationExpression :
    ownedRelationship += OwnedSpecialization
    ArgumentList
    // ArgumentList(this)
    ;
ArgumentList infers InvocationExpression:
    '(' ( PositionalArgumentList | NamedArgumentList )? ')'
    ;
PositionalArgumentList infers InvocationExpression:
    ownedRelationship += ArgumentMember
    ( ',' ownedRelationship += ArgumentMember )*
    ;
ArgumentMember infers ParameterMembership:
    ownedMemberParameter = Argument
    ;
Argument infers Feature:
    ownedRelationship += ArgumentValue
    ;
NamedArgumentList infers InvocationExpression:
    ownedRelationship += NamedArgumentMember
    ( ',' ownedRelationship += NamedArgumentMember )*
    ;
NamedArgumentMember infers FeatureMembership:
    ownedMemberFeature = NamedArgument
    ;
NamedArgument infers Feature:
    ownedRelationship += ParameterRedefinition '='
    ownedRelationship += ArgumentValue
    ;
ParameterRedefinition infers Redefinition :
    redefinedFeature = [QualifiedName]
    ;
ArgumentValue infers FeatureValue:
    value = OwnedExpression
    ;
BodyExpression infers FeatureReferenceExpression:
    ownedRelationship += ExpressionBodyMember
    ;
ExpressionBodyMember infers FeatureMembership:
    ownedMemberFeature = ExpressionBody
    ;
ExpressionBody infers Expression :
    FunctionBody
    ;
/************************************************
 * Literal Expressions
 ************************************************/
 LiteralExpression infers LiteralExpression:
    LiteralBoolean
    | LiteralString
    | LiteralInteger
    | LiteralReal
    | LiteralInfinity
    ;
LiteralBoolean infers LiteralBoolean:
    value = BooleanValue
    ;
// BooleanValue infers Boolean:
terminal BooleanValue:
    'true' | 'false'
    ;
fragment LiteralString infers LiteralString:
    value = STRING_VALUE
    ;
fragment LiteralInteger infers LiteralInteger :
    value = DECIMAL_VALUE
    ;
fragment LiteralReal infers LiteralReal:
    value = RealValue
    ;
// RealValue infers Real:
RealValue returns number:
    DECIMAL_VALUE? '.' ( DECIMAL_VALUE | EXPONENTIAL_VALUE )
    | EXPONENTIAL_VALUE
    ;
// LiteralInfinity : LiteralInfinity =
terminal LiteralInfinity:
    '*'
    ;
/************************************************
 * Interactions
 ************************************************/
Interaction:
    ( isAbstract ?= 'abstract' )? 'interaction'
    BehaviorDeclaration TypeBody
    ;
/************************************************
 * Item Flows
 ************************************************/
ItemFlow:
    FeaturePrefix 'flow'
    ItemFlowDeclaration TypeBody
    ;
SuccessionItemFlow:
    FeaturePrefix 'succession' 'flow'
    ItemFlowDeclaration TypeBody
    ;
ItemFlowDeclaration infers ItemFlow:
    ( FeatureDeclaration
    ( 'of' ownedRelationship += ItemFeatureMember
    | ownedRelationship += EmptyItemFeatureMember )
    'from'
    | ( isSufficient ?= 'all' )?
    ownedRelationship += EmptyItemFeatureMember
    )
    ownedRelationship += ItemFlowEndMember 'to'
    ownedRelationship += ItemFlowEndMember
    ;
ItemFeatureMember infers FeatureMembership:
    ownedMemberFeature = ItemFeature
    ;
ItemFeature infers Feature:
    ( name = ID ':' )?
    ( ownedTyping += OwnedFeatureTyping
    ( ownedRelationship += OwnedMultiplicity )?
    | ownedRelationship += OwnedMultiplicity
    ( ownedTyping += OwnedFeatureTyping )?
    )
    ;
EmptyItemFeatureMember infers FeatureMembership:
    ownedMemberFeature = EmptyItemFeature
    ;
EmptyItemFeature infers Feature:
    {SysMLFeature}
    ;
ItemFlowEndMember infers FeatureMembership:
    ownedMemberFeature = ItemFlowEnd
    ;
ItemFlowEnd infers Feature:
    ( ownedRelationship += Subsetting '.' )?
    ownedRelationship += ItemFlowFeatureMember
    ;
ItemFlowFeatureMember infers FeatureMembership:
    ownedMemberFeature = ItemFlowFeature
    ;
ItemFlowFeature infers Feature:
    ownedRelationship += ItemFlowRedefinition
    ;
ItemFlowRedefinition infers Redefinition:
    redefinedFeature = [QualifiedName]
    ;
/************************************************
 * Feature Values
 ************************************************/
 ValuePart infers Feature:
    ownedRelationship += FeatureValue
    ;
FeatureValue :
    ( '='
    | isInitial ?= ':='
    | isDefault ?= 'default' ( '=' | isInitial ?= ':=' )?
    )
    value = OwnedExpression
    ;
/************************************************
 * Multiplicities
 ************************************************/
 Multiplicity:
    MultiplicitySubset | MultiplicityRange
    ;
MultiplicitySubset infers Multiplicity:
    'multiplicity' Identification Subsets ';'
    ;
MultiplicityRange:
    'multiplicity' Identification MultiplicityBounds ';'
    ;
OwnedMultiplicity infers OwningMembership:
    ownedMemberElement = OwnedMultiplicityRange
    ;
OwnedMultiplicityRange infers MultiplicityRange:
    MultiplicityBounds
    ;
MultiplicityBounds infers MultiplicityRange:
    '[' ( ownedRelationship += MultiplicityExpressionMember '..' )?
    ownedRelationship += MultiplicityExpressionMember ']'
    ;
MultiplicityExpressionMember infers OwningMembership:
    ownedMemberElement = ( LiteralExpression | FeatureReferenceExpression )
    ;
/************************************************
 * Metadata
 ************************************************/
 Metaclass:
    ( isAbstract ?= 'abstract' )? 'metaclass'
    ClassifierDeclaration TypeBody
    ;
OwnedMetadataFeatureAnnotation infers Annotation:
    ownedRelatedElement += OwnedMetadataFeature
    ;
OwnedMetadataFeature infers MetadataFeature:
    ( '@' | 'metadata' )
    ( Identification ( ':' | 'typed' 'by' ) )?
    ownedRelationship += [Metaclass:ID]
    // ownedRelationship += MetadataTyping
    TypeBody
    ;
MetadataFeature:
    ( '@' | 'metadata' )
    MetadataFeatureDeclaration
    ( 'about' annotation += Annotation
    // { ownedRelationship += annotation }
    ( ',' annotation += Annotation
    // { ownedRelationship += annotation } 
    )*
    )?
    MetadataBody
    ;
MetadataFeatureDeclaration infers MetadataFeature:
    ( Identification ( ':' | 'typed' 'by' ) )?
    ownedRelationship += OwnedFeatureTyping
    ;
MetadataBody infers Feature :
    ';' | '{' ( ownedRelationship += MetadataBodyElement )* '}'
    ;
MetadataBodyElement infers Membership:
    NonFeatureMember
    | MetadataBodyFeatureMember
    | AliasMember
    | Import
    ;
MetadataBodyFeatureMember infers FeatureMembership:
    ownedMemberFeature = MetadataBodyFeature
    ;
MetadataBodyFeature infers Feature:
    'feature'? ( ':>>' | 'redefines')? ownedRelationship += OwnedRedefinition
    FeatureSpecializationPart? ValuePart?
    MetadataBody
    ;
/************************************************
 * Packages
 ************************************************/
Package:
    PackageDeclaration PackageBody
    ;
PackageDeclaration:
    'package' Identification
    ;
PackageBody:
    ';'
    | '{' ( NamespaceBodyElement
    | ownedRelationship += ElementFilterMember
    )*
    '}'
    ;
ElementFilterMember infers ElementFilterMembership:
    MemberPrefix
    'filter' condition = OwnedExpression ';'
    ;

/************************************************
 * Terminals
 ************************************************/

// Numeric Literals
terminal DECIMAL_VALUE: /[0-9]+/;
terminal EXPONENTIAL_VALUE: DECIMAL_VALUE ('e' | 'E') ('+' | '-')? DECIMAL_VALUE;

// terminal LINE_TERMINATOR: /[\n\r]/;
// terminal LINE_TEXT: /[\s\S]/;
terminal ID: /[_a-zA-Z][\w_\d]*/;
terminal ESCAPE_SEQ:
    /[\'\"\b\f\t\n\\]/
    ;
// terminal INT returns number: /[0-9]+/;
terminal STRING: /"[^"]*"|'[^']*'/;
terminal STRING_VALUE: /\"[^\\\"]\"/;
terminal TYPED_BY: /\b(\:|typed\s+by)\b/;
terminal SPECIALIZES: /\b(\:\>|specializes)\b/;
terminal SUBSETS: /\b(\:\>|(subsets))\b/;
terminal REDEFINES: /\b(\:\>\>|redefines)\b/;
terminal CONJUGATES: /\b(\~|conjugates)\b/;
// terminal SUBSETS: /\bsubsets\b/;

// Notes and Comments
// Hidden Terminals: Not parsed
hidden terminal WS: /[\s\n\t]+/;

// hidden terminal SINGLE_LINE_NOTE: /\/\/[^\n\r]*/;
hidden terminal SINGLE_LINE_NOTE: /\/\/[^\n\r]*/;
hidden terminal MULTILINE_NOTE: /\/\/\*[\s\S]*?\*\//;
terminal REGULAR_COMMENT returns string: 
    /\/\*[\s\S]*\*\//
    ;
terminal PREFIX_COMMENT returns string: 
    /\/\*\*[\s\S]*\*\//
    ;