grammar SysML
// KerML Element Hierarchy

interface SysMLElement {
    aliasIds?:string[];
    documentation?:SysMLDocumentation[];
    elementId?:string;
    name?:string;
    ownedAnnotation?:@SysMLAnnotation[];
    ownedElement?:@SysMLElement[];
    ownedRelationship?:SysMLRelationship[];
    owner?:@SysMLElement;
    owningMembership?:@SysMLOwningMembership;
    owningNamespace?:@SysMLNamespace;
    owningRelationship?:@SysMLRelationship;
    qualifiedName?:string;
    shortName?:string[];
    textualRepresentation?:SysMLTextualRepresentation[];
}
interface SysMLAnnotatingElement extends SysMLElement { 
    annotatedElement?:SysMLElement[];
    annotation?:SysMLAnnotation[];
}
interface SysMLAnnotation extends SysMLRelationship { 
    annotatedElement?:@SysMLElement | @SysMLMetadataFeature | SysMLTextualRepresentation; // {redefines target}
    annotatingElement?:SysMLAnnotatingElement | SysMLComment | SysMLDocumentation;   // {redefines source}
    owningAnnotatedElement?:SysMLElement;       // {subsets annotatedElement, ownedRelatedElement}
}
interface SysMLComment extends SysMLAnnotatingElement { 
    commentBody:string;
    locale?:string;
}
interface SysMLDocumentation extends SysMLComment { 
    documentedElement?:@SysMLElement; // {subsets owner, redefines annotatedElement}
}
interface SysMLTextualRepresentation extends SysMLAnnotatingElement { 
    textualRepresentationBody?:string;
    language?:string;
    representedElement?:@SysMLElement; // {subsets owner, redefines annotatedElement}
}
interface SysMLNamespace extends SysMLElement {
    importedMembership?:SysMLMembership[];  // {subsets membership, ordered}
    member?:SysMLElement[];                 // {ordered}
    membership?:@SysMLMembership[];          // {ordered, union}
    ownedImport?:@SysMLImport[];             // {subsets sourceRelationship, ownedRelationship, ordered}
    ownedMember?:@SysMLElement[];            // {subsets member, ordered}
    ownedMembership?:@SysMLMembership[];     // {subsets membership, sourceRelationship, ownedRelationship, ordered}
 }
interface SysMLType extends SysMLNamespace { 
    directedFeature?:SysMLFeature[];    // {subsets feature, ordered}
    endFeature?:SysMLFeature[];         // {subsets feature, ordered}
    feature?:SysMLFeature[];            // {subsets feature, ordered}
    featureMembership?:SysMLFeatureMembership[]; // {subsets feature, ordered}
    inheritedFeature?:SysMLFeature[];   // {subsets feature, ordered}
    inheritedMembership?:SysMLMembership[]; // {subsets membership, ordered}
    input?:SysMLFeature[];  // {subsets directedFeature, ordered}
    // isAbstract?:boolean;
    isConjugated?:boolean;
    // isSufficient?:boolean;
    multiplicity?:SysMLMultiplicity;    // {subsets member}
    output?:SysMLFeature[];             // {subsets directedFeature, ordered}
    ownedConjugator?:SysMLConjugation;  // {subsets ownedRelationship, conjugator}
    ownedDisjoining?:SysMLDisjoining[]; // {subsets ownedRelationship, disjoiningTypeDisjoining}
    ownedEndFeature?:SysMLFeature[];    // {subsets endFeature, ownedFeature, ordered}
    ownedFeature?:SysMLFeature[];       // {subsets ownedMember, ordered}
    ownedFeatureMembership?:SysMLFeatureMembership; // {subsets ownedMembership, featureMembership, typedFeaturing, ordered}
    ownedSpecialization?:SysMLSpecialization[];     // {subsets specialization, ownedRelationship, ordered}
}
interface SysMLPackage extends SysMLNamespace { 
    filterCondition?:SysMLExpression[]; // {subsets ownedMember, ordered}
}

interface SysMLFeature extends SysMLType { 
    chainingFeature?:SysMLFeature[];    // {ordered, unique}
    direction?:string;  // direction: FeatureDirectionKind
    endOwnedType?:SysMLType;    // {subsets typeWithEndFeature, owningType}
    featuringType?:SysMLType[]; // {ordered}
    isComposite?: boolean;
    isDerived?:boolean;
    isEnd?:boolean;
    isOrdered?:boolean;
    isPortion?:boolean;
    isReadOnly?:boolean;
    isUnique?:boolean;
    ownedFeatureChaining?:SysMLFeatureChaining[];   // {subsets sourceRelationship, ownedRelationship, ordered}
    ownedFeatureInverting?:SysMLFeatureInverting[]; // {subsets ownedRelationship, invertingFeatureInverting}
    ownedRedefinition?:SysMLRedefinition[];         // {subsets ownedSubsetting}
    ownedSubsetting?:SysMLSubsetting[];             // {subsets ownedSpecialization, subsetting}
    ownedTypeFeaturing?:SysMLTypeFeaturing[];       // {subsets ownedRelationship, typeFeaturing, ordered}
    ownedTyping?:SysMLTypeFeaturing[];              // {subsets ownedSpecialization, typing, ordered}
    owningFeatureMembership?:SysMLFeatureMembership;// {subsets owningMembership, typeFeaturing}
    owningType?:SysMLType;                          // {subsets typeWithFeature, owningNamespace, featuringType}
    sysmlType?:SysMLType[];                         // {ordered}
}
interface SysMLFeatureInverting extends SysMLRelationship {
    featureInverted?:@SysMLFeature | SysMLFeature;   // {redefines source}
    invertingFeature?:@SysMLFeature | SysMLFeature;  // {redefines target}
    owningFeature?:@SysMLFeature | SysMLFeature;    // {subsets owningRelatedElement, featureInverted}
}
interface SysMLClassifier extends SysMLType { 
    ownedSubclassification?:SysMLSubclassification[];   // {subsets ownedSpecialization}
}
interface SysMLMultiplicity extends SysMLFeature { 
    // none
}
interface SysMLStep extends SysMLFeature { 
    behavior?:SysMLBehavior[];   // {redefines type, ordered}
    parameter?:SysMLFeature[];  // {redefines directedFeature, ordered}
}
interface SysMLConnector extends SysMLFeature, SysMLRelationship { 
    association?:SysMLAssociation[]; // {redefines type}
    connectorEnd?:SysMLFeature[];    // {redefines endFeature}
    isDirected?:boolean;
    relatedFeature?:SysMLFeature[];  // {redefines relatedElement, ordered, nonunique, union}
    sourceFeature?:SysMLFeature;    // {subsets relatedFeature, redefines source}
    targetFeature?:SysMLFeature[];   // {subsets relatedFeature, redefines target}
}
interface SysMLAssociation extends SysMLClassifier, SysMLRelationship { 
    associationEnd?:SysMLFeature[];  // {redefines endFeature}
    relatedType?:SysMLType;          // {redefines relatedElement ordered, nonunique, union}
    sourceType?:SysMLType;          // {subsets relatedType, redefines source}
    targetType?:SysMLType[];         // {subsets relatedType, redefines target}
}
interface SysMLClass extends SysMLClassifier {
    // none
 }
interface SysMLDataType extends SysMLClassifier { 
    // none
}
interface SysMLInteraction extends SysMLAssociation, SysMLBehavior { 
    // none
}
interface SysMLStructure extends SysMLClass { 
    // none
}
interface SysMLBehavior extends SysMLClass { 
    parameter?:SysMLFeature[];  // {redefines directedFeature, ordered}
    step?:SysMLStep[];          // {subsets feature}
}
interface SysMLAssociationStructure extends SysMLStructure, SysMLAssociation {
    // none
}

interface SysMLMetaclass extends SysMLStructure { 
    // none
}

interface SysMLMetadataFeature extends SysMLFeature, SysMLAnnotatingElement{ 
    metaclass?:SysMLMetaclass; // {redefines type}
}

interface SysMLFunction extends SysMLBehavior { 
    expression?:SysMLExpression[];  // {redefines step}
    isModelLevelEvaluable?:boolean;
    result?:SysMLFeature;            // {subsets parameter, output}
}

interface SysMLMultiplicityRange extends SysMLMultiplicity { 
    bound?:SysMLExpression[];        // {redefines ownedMember, ordered, union}
    lowerBound?:SysMLExpression;    // {subsets bound}
    upperBound?:SysMLExpression;     // {subsets bound}
}

interface SysMLExpression extends SysMLStep { 
    function?:SysMLFunction; // {redefines behavior}
    isModelLevelEvaluable?:boolean;
    result?:SysMLFeature;    // {subsets parameter, output}
}

interface SysMLItemFeature extends SysMLFeature { }
interface SysMLItemFlowFeature extends SysMLItemFlow, SysMLFeature { }
interface SysMLItemFlowEnd extends SysMLItemFlow { }

interface SysMLItemFlow extends SysMLConnector, SysMLStep { 
    itemFeature?:SysMLItemFeature[]; // {subsets ownedFeature}
    itemFlowEnd?:SysMLItemFlowEnd[]; // {redefines connectorEnd}
    itemFlowFeature?:SysMLItemFlowFeature[];
    itemType?:SysMLClassifier[];    // {ordered, nonunique}
    sourceOutputFeature?:SysMLFeature[];    // {ordered, nonunique}
    targetInputFeature?:SysMLFeature[];    // {ordered, nonunique}
}
interface SysMLSuccession extends SysMLConnector { 
    effectStep?:SysMLStep[];
    guardExpression?:SysMLExpression[];
    transitionStep?:SysMLStep;  // {subsets ownedFeature}
    triggerStep?:SysMLStep[];
}
interface SysMLBindingConnector extends SysMLConnector {
    // none
 }
interface SysMLSuccessionItemFlow extends SysMLItemFlow, SysMLSuccession { 
    // none
}
interface SysMLPredicate extends SysMLFunction { 
    // none
}
interface SysMLNullExpression extends SysMLExpression { 
    // none
}
interface SysMLLiteralExpression extends SysMLExpression { 
    // none
}
interface SysMLInvocationExpression extends SysMLExpression { 
    argument?:SysMLExpression[];    // {subsets ownedFeature, ordered}
} 
interface SysMLBooleanExpression extends SysMLExpression { }
interface SysMLFeatureReferenceExpression extends SysMLExpression { 
    referent?:@SysMLFeature; // {subsets member}
}
interface SysMLLiteralBoolean extends SysMLLiteralExpression { 
    // booleanValue:boolean;
}
interface SysMLLiteralString extends SysMLLiteralExpression { 
    // stringValue:string;
}
interface SysMLLiteralInteger extends SysMLLiteralExpression { 
    // integerValue:number;
}
interface SysMLLiteralReal extends SysMLLiteralExpression { 
    // realValue:number;
}
interface SysMLLiteralRational extends SysMLLiteralExpression { }
interface SysMLLiteralInfinity extends SysMLLiteralExpression { 
    // none
}
interface SysMLOperatorExpression extends SysMLInvocationExpression { 
    operand?:SysMLExpression[]; // {ordered}
    operator?:string;
}
interface SysMLInvariant extends SysMLBooleanExpression { 
    isNegated?:boolean;
}
interface SysMLFeatureChainExpression extends SysMLOperatorExpression { 
    // operator:string;            // {redefines operator}
    targetFeature:SysMLFeature; // {subsets member}
}
interface SysMLCollectExpression extends SysMLOperatorExpression { 
    // operator:string; // {redefines operator}
}
interface SysMLSelectExpression extends SysMLOperatorExpression { 
    // operator:string;     // {redefines operator}
}

// KerML Relationship Hierarchy
interface SysMLRelationship extends SysMLElement { 
    ownedRelatedElement?:SysMLElement[] | SysMLMetadataFeature[] | SysMLTextualRepresentation[] | SysMLFeature[];    // {subsets relatedElement, ordered}
    owningRelatedElement?:SysMLElement;     // {subsets relatedElement}
    relatedElement?:@SysMLElement[];          // {ordered, nonunique, union}
    source?:@SysMLElement;                   // {subsets relatedElement, ordered}
    target?:@SysMLElement;                   // {subsets relatedElement, ordered}
}
interface SysMLImport extends SysMLRelationship { 
    importedMemberName?:string;
    importedNamespace?:SysMLNamespace;       // {redefines target}
    importOwningNamespace?:SysMLNamespace;   // {subsets owningRelatedElement, redefines source}
    isImportAll?:boolean;
    isRecursive?:boolean;
    importVisibility?:string;
    // visibility:SysMLVisibilityKind;
}
interface SysMLMembership extends SysMLRelationship { 
    memberElement?:@SysMLElement;     // {redefines target}
    memberElementId?:string;
    memberName?:string;
    membershipOwningNamespace?:@SysMLNamespace; // {subsets membershipNamespace, owningRelatedElement, redefines source}
    memberShortName?:string;
    // visibility:SysMLVisibilityKind;
    membershipVisibility?:string;
}
interface SysMLOwningMembership extends SysMLMembership {
    ownedMemberElement?:SysMLElement;    // {subsets ownedRelatedElement, redefines memberElement}
    ownedMemberElementId?:string;        // {redefines memberElementId}
    ownedMemberName?:string;            // {redefines memberName}
    ownedMemberShortName?:string;       // {redefines memberShortName}
}
interface SysMLConjugation extends SysMLRelationship { 
    conjugatedType?:@SysMLType | @SysMLFeature | SysMLFeature;   // { redefines source }
    originalType?:@SysMLType | @SysMLFeature | SysMLFeature;     // { redefines target }
    owningType?:@SysMLType | @SysMLFeature | SysMLFeature;      // { subsets conjugatedType, owningRelatedElement }
}
interface SysMLDisjoining extends SysMLRelationship { 
    disjoiningType?:@SysMLType | @SysMLFeature | SysMLFeature;   // { redefines target }
    owningType?:@SysMLType | @SysMLFeature | SysMLFeature;       // { subsets typeDisjoined, owningRelatedElement }
    typeDisjoined?:@SysMLType | @SysMLFeature | SysMLFeature;    // { redefines source }
}
interface SysMLTypeFeaturing extends SysMLRelationship { 
    featureOfType?:@SysMLFeature; // {redefines source}
    featuringType?:@SysMLType;    // {redefines target}
    owningFeatureOfType?:@SysMLFeature;  // {subsets featureOfType, owningRelatedElement}
}

interface SysMLFeatureChaining extends SysMLRelationship { 
    chainingFeature?:@SysMLFeature;
    featureChained?:@SysMLFeature;
}

interface SysMLSpecialization extends SysMLRelationship { 
    general?:@SysMLType;      // {redefines target}
    owningType?:@SysMLType;  // {subsets specific, owningRelatedElement}
    specific?:@SysMLType;     // {redefines source}
}

interface SysMLFeatureValue extends SysMLOwningMembership { 
    featureWithValue?:SysMLFeature;  // {subsets membershipOwningNamespace}
    isDefault?:boolean;
    isInitial?:boolean;
    value?:SysMLExpression;  // {redefines ownedMemberElement}
}
interface SysMLElementFilterMembership extends SysMLOwningMembership { 
    condition?:SysMLExpression;  // {redefines ownedMemberElement}
}

interface SysMLFeatureMembership extends SysMLOwningMembership, SysMLTypeFeaturing { 
    ownedMemberFeature?:SysMLFeature | SysMLExpression | SysMLOperatorExpression | SysMLFeatureReferenceExpression;   // { subsets featureOfType, redefines ownedMemberElement }
    ownedFeatureMember?:SysMLFeature | SysMLExpression | SysMLOperatorExpression | SysMLFeatureReferenceExpression;   // { subsets featureOfType, redefines ownedMemberElement }
    owningType?:SysMLType;               // subsets featuringType, type, redefines membershipOwningNamespace }
}
interface SysMLEndFeatureMembership extends SysMLFeatureMembership {
    // ownedMemberFeature:SysMLFeature; // {redefines ownedMemberFeature}
}
interface SysMLFeatureTyping extends SysMLSpecialization { 
    owningFeature?:@SysMLFeature;    // {subsets typedFeature, redefines owningType}
    sysmlType?:@SysMLType;            // {redefines general}
    typedFeature?:@SysMLFeature;      // {redefines specific}
}
interface SysMLSubsetting extends SysMLSpecialization { 
    owningFeature?:SysMLFeature; // {subsets subsettingFeature, redefines owningType}
    subsettedFeature?:SysMLFeature;  // {redefines general}
    subsettingFeature?:SysMLFeature; // {redefines specific}
}
interface SysMLSubclassification extends SysMLSpecialization { 
    owningClassifier?:@SysMLClassifier;  // {redefines owningType}
    subclassifier?:@SysMLClassifier;      // {redefines specific}
    superclassifier?:@SysMLClassifier;    // {redefines general}
}
interface SysMLParameterMembership extends SysMLFeatureMembership {
    ownedMemberParameter?:SysMLFeature;  // {redefines ownedMemberFeature}
}
interface SysMLResultExpressionMembership extends SysMLFeatureMembership { 
    ownedResultExpression?: SysMLExpression; // {redefines ownedMemberFeature}
}
interface SysMLRedefinition extends SysMLSubsetting {
    redefinedFeature?:@SysMLFeature;  // {redefines subsettedFeature}
    redefiningFeature?:@SysMLFeature; // {redefines subsettingFeature}
}
interface SysMLReturnParameterMembership extends SysMLParameterMembership { 
    // None
}


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

fragment ElementBodyWithElement returns SysMLElement:
    '{' OwnedElement* '}'
    ;

fragment ElementBody returns SysMLElement:
    '{' OwnedElement* '}'|   ';' 
    ;

fragment Identification returns SysMLElement:
    ( '<' shortName = ID '>' )? ( name=ID )?
    ;

fragment OwnedElement returns SysMLElement:
    ownedRelationship = OwnedRelationship
    | ownedRelationship += OwnedCommentAnnotation
    | ownedRelationship += OwnedTextualRepresentationAnnotation
    | ownedRelationship += OwnedMetadataFeatureAnnotation
    ;

/************************************************
 * Relationship Concrete Syntax
 ************************************************/

// Grammar Definition for
Relationship returns SysMLRelationship:
    'relationship' Identification
    RelationshipRelatedElements
    RelationshipBody
    ;

OwnedRelationship returns SysMLRelationship:
    'relationship' Identification
    ( 'to' RelationshipTargetList )?
    RelationshipBody
    ;

RelationshipRelatedElements returns SysMLRelationship:
    ( 'from' RelationshipSourceList )?
    ( 'to' RelationshipTargetList )?
    ;
fragment RelationshipSourceList returns SysMLRelationship:
    RelationshipSource (',' RelationshipSource )*
    ;

fragment RelationshipSource returns SysMLRelationship:
    source += [SysMLElement:ID]
    ;

fragment RelationshipTargetList returns SysMLRelationship:
    RelationshipTarget (',' RelationshipTarget )*
    ;

fragment RelationshipTarget returns SysMLRelationship:
    target += [SysMLElement:ID]
    ;

fragment RelationshipBody returns SysMLRelationship:
    ';' | '{' RelationshipOwnedElement '}'
    ;

fragment RelationshipOwnedElement returns SysMLRelationship:
    OwnedRelatedElementRelationship
    | OwnedCommentTextualMetadataAnnotation
    ;

fragment OwnedRelatedElementRelationship returns SysMLRelationship:
    ownedRelatedElement += OwnedRelatedElement
    |ownedRelatedElement += OwnedRelatedRelationship
    ;

fragment OwnedCommentTextualMetadataAnnotation:
    ownedRelationship += OwnedCommentAnnotation
    | ownedRelationship += OwnedTextualRepresentationAnnotation
    //     | OwnedMetadataFeatureAnnotation
    ;

OwnedRelatedElement returns SysMLElement:
    'element' Identification ElementBody
    ;

OwnedRelatedRelationship returns SysMLRelationship:
    'relationship' Identification
    RelationshipRelatedElements
    RelationshipBody
    ;
/************************************************
 * Comments
 ************************************************/
Comment returns SysMLComment:
    'comment' Identification
    ( 'about' annotation += Annotation
      // { ownedRelationship += annotation }
        ( ',' annotation += Annotation
           // { ownedRelationship += annotation }
        )*
    )?
    commentBody = REGULAR_COMMENT
    ;
Annotation returns SysMLAnnotation:
    annotatedElement = [SysMLElement:ID]
    ;
fragment PrefixComment returns SysMLComment:
    ( 'comment' Identification )?
    body = PREFIX_COMMENT
    ;
fragment Documentation returns SysMLDocumentation:
    'doc' Identification
    body = REGULAR_COMMENT
    ;
OwnedCommentAnnotation returns SysMLAnnotation:
// OwnedCommentAnnotation infers Annotation:
    annotatingElement = (OwnedComment|OwnedDocumentation)
    // annotatingElement = OwnedCommentOrDocumentation
    // { ownedRelatedElement+= OwnedCommentOrDocumentation }
    ;

fragment OwnedComment returns SysMLComment:
    ( 'coment' Identification )?
    body = REGULAR_COMMENT // { annotation += a}
    ;
fragment OwnedDocumentation returns SysMLDocumentation:
    'doc' Identification
    body = REGULAR_COMMENT // { annotation += a}
    ;

/************************************************
 * Textual Representation 
 ************************************************/
// OwnedTextualRepresentationAnnotation infers Annotation :
OwnedTextualRepresentationAnnotation returns SysMLAnnotation :
    // ownedRelatedElement += OwnedTextualRepresentation
    ownedRelatedElement += OwnedTextualRepresentation
    ;
OwnedTextualRepresentation returns SysMLTextualRepresentation :
    ( 'rep' Identification )?
    'language' language = STRING_VALUE 
    textualRepresentationBody = REGULAR_COMMENT
    // { annotation += a }
    ;

TextualRepresentation returns SysMLTextualRepresentation:
    ( 'rep' Identification )?
    'language' language = STRING_VALUE 
    textualRepresentationBody = REGULAR_COMMENT
    ;
/************************************************
 * Namespaces
 ************************************************/
 Namespace returns SysMLNamespace:
    NamespaceDeclaration NamespaceBody
    ;

fragment NamespaceDeclaration returns SysMLNamespace:
    'namespace' Identification
    ;

fragment NamespaceBody returns SysMLNamespace:
    ';' 
    | '{' NamespaceBodyElement* '}'
    ;

fragment NamespaceBodyElement returns SysMLNamespace:
    OwnedRelationshipNamespaceMember
    | OwnedRelationshipAliasMember
    | OwnedRelationshipImport
    ;

fragment OwnedRelationshipNamespaceMember returns SysMLNamespace:
    ownedRelationship += NamespaceMember
    ;
fragment OwnedRelationshipAliasMember returns SysMLNamespace:
    ownedRelationship += AliasMember
    ;
fragment OwnedRelationshipImport returns SysMLNamespace:
    ownedRelationship += Import
    ;
fragment MemberPrefix returns SysMLMembership:
    (visibility = VisibilityIndicator)?
    ;
NamespaceMember returns SysMLOwningMembership:
    NonFeatureMember
    | NamespaceFeatureMember
    ;
fragment NonFeatureMember returns SysMLOwningMembership :
    MemberPrefix
    ownedMemberElement = NonFeatureElement
    ;
fragment NamespaceFeatureMember returns SysMLMembership :
    MemberPrefix
    ownedMemberElement = FeatureElement
    ;
AliasMember returns SysMLMembership :
    MemberPrefix
    'alias' ( '<' memberShortName = ID'>' )?
    ( memberName = ID)?
    'for' memberElement = [SysMLElement:QualifiedName] ';'
    ;
Import returns SysMLImport: 
    ( importVisibility = VisibilityIndicator )?
    'import' ( isImportAll ?= 'all' )?
    ( ImportedNamespace
    | ImportedFilterPackage ) ';'
    ;
fragment ImportedNamespace returns SysMLImport :
    ( importedNamespace = [SysMLElement:QualifiedName] '::' )?
    ( importedName = ID| '*' )
    ( '::' isRecursive ?= '**' )?
    ;
fragment ImportedFilterPackage returns SysMLImport:
    importedNamespace = FilterPackage
    // { ownedRelatedElement += importedNamespace }
    ;

FilterPackage returns SysMLPackage :
    FilterPackageFrag
    ;
fragment FilterPackageFrag returns SysMLPackage :
    ownedRelationship += FilterPackageImport
    ( ownedRelationship += FilterPackageMember )+
    ;
FilterPackageImport returns SysMLImport :
    ImportedNamespace
    ;
FilterPackageMember returns SysMLElementFilterMembership :
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
 NonFeatureElement returns SysMLElement :
    Element
    | Relationship
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
FeatureElement returns SysMLFeature :
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
QualifiedName returns string: 
    ID ( '::' ID )*
    ;
/************************************************
 * Types
 ************************************************/
fragment Type returns SysMLType:
    ( isAbstract ?= 'abstract' )? 'type'
    TypeDeclaration TypeBody
    ;

fragment TypeDeclaration returns SysMLType:
    (isSufficient ?= 'all' )? Identification
    ( ownedRelationship += OwnedMultiplicity )?
    ( SpecializationPart | ConjugationPart )+
    DisjoiningPart?
    ;
fragment SpecializationPart returns SysMLType:
    SPECIALIZES ownedRelationship += OwnedSpecialization
    ( ',' ownedRelationship += OwnedSpecialization )*
    ;
fragment ConjugationPart returns SysMLType :
    CONJUGATES ownedRelationship += OwnedConjugation
    ;
fragment DisjoiningPart returns SysMLType:
    'disjoint' 'from' ownedRelationship += OwnedDisjoining
    ( ',' ownedRelationship += OwnedDisjoining )*
    ;
fragment TypeBody returns SysMLType :
    ';' | '{' TypeBodyElement* '}'
    ;
fragment TypeBodyElement returns SysMLType:
    ownedRelationship += TypeBodyElementNonFeatureMember
    | ownedRelationship += FeatureMember
    | ownedRelationship += AliasMember
    | ownedRelationship += Import
    ;
TypeBodyElementNonFeatureMember:
    NonFeatureMember
    ;
/************************************************
 * Specialization
 ************************************************/
 Specialization returns SysMLSpecialization:
    ( 'specialization' Identification )?
    'subtype' SpecificType
    SPECIALIZES GeneralType ';'
    ;
OwnedSpecialization returns SysMLSpecialization:
    GeneralType
    ;
fragment SpecificType returns SysMLSpecialization:
    specific = [SysMLType:QualifiedName]
    | specific += OwnedFeatureChain
    // { ownedRelatedElement += specific }
    ;
fragment GeneralType returns SysMLSpecialization:
    general = [SysMLType:QualifiedName]
    | general += OwnedFeatureChain
    // { ownedRelatedElement += general }
    ;
/************************************************
 * Conjugation
 ************************************************/
 Conjugation returns SysMLConjugation:
    ( 'conjugation' Identification )?
    'conjugate'
    ( conjugatedType = [SysMLType:QualifiedName]
    | conjugatedType = FeatureChain
    // { ownedRelatedElement += conjugatedType } 
    )
    CONJUGATES
    ( originalType = [SysMLType:QualifiedName]
    | originalType = FeatureChain
    // { ownedRelatedElement += originalType } 
    ) ';'
    ;
OwnedConjugation returns SysMLConjugation :
    originalType = [SysMLType:QualifiedName]
    | originalType = FeatureChain
    // { ownedRelatedElement += originalType }
    ;
/************************************************
 * Disjoining
 ************************************************/
 Disjoining returns SysMLDisjoining:
    ( 'disjoining' Identification )?
    'disjoint'
    ( typeDisjoined = [SysMLType:QualifiedName]
    | typeDisjoined = FeatureChain
    // { ownedRelatedElement += typeDisjoined } 
    )
    'from'
    ( disjoiningType = [SysMLType:QualifiedName] | disjoiningType = FeatureChain) ';'
    // { ownedRelatedElement += disjoiningType } 
    ;
OwnedDisjoining returns SysMLDisjoining :
    disjoiningType = [SysMLType:QualifiedName]
    | disjoiningType = FeatureChain
    // { ownedRelatedElement += disjoiningType }
    ;
/************************************************
 * Feature Membership
 ************************************************/
FeatureMember returns SysMLOwningMembership :
    TypeFeatureMember
    | OwnedFeatureMember
    ;
fragment TypeFeatureMember returns SysMLOwningMembership :
    MemberPrefix 'member' ownedMemberElement = FeatureElement
    ;
fragment OwnedFeatureMember returns SysMLFeatureMembership :
    MemberPrefix ownedMemberFeature = FeatureElement
    ;
/************************************************
 * Classifiers
 ************************************************/
fragment Classifier returns SysMLClassifier:
    ( isAbstract ?= 'abstract' ) 'classifier'
    ClassifierDeclaration TypeBody
    ;
fragment ClassifierDeclaration returns SysMLType :
    ( isSufficient ?= 'all' )? Identification
    ( ownedRelationship += OwnedMultiplicity )?
    ( SuperclassingPart | ConjugationPart )?
    DisjoiningPart?
    ;
fragment SuperclassingPart returns SysMLType :
    SPECIALIZES ownedRelationship += OwnedSubclassification
    ( ',' ownedRelationship += OwnedSubclassification )*
    ;
/************************************************
 * Subclassification
 ************************************************/
Subclassification returns SysMLSubclassification:
    ( 'specialization' Identification )?
    'subclassifier' subclassifier = [SysMLClassifier:QualifiedName]
    SPECIALIZES superclassifier = [SysMLClassifier:QualifiedName] ';'
    ;
OwnedSubclassification returns SysMLSubclassification :
    superclassifier = [SysMLClassifier:QualifiedName]
    ;
/************************************************
 * Features
 ************************************************/
 Feature returns SysMLFeature:
    FeaturePrefix
    'feature'? FeatureDeclaration
    ValuePart? TypeBody
    ;
fragment FeaturePrefix returns SysMLFeature:
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
fragment FeatureDeclaration returns SysMLFeature:
    ( isSufficient ?= 'all' )? Identification
    ( FeatureSpecializationPart | ConjugationPart )?
    FeatureRelationshipPart*
    ;
fragment FeatureRelationshipPart returns SysMLFeature :
    ChainingPart
    | DisjoiningPart
    | InvertingPart
    | TypeFeaturingPart
    ;
fragment ChainingPart returns SysMLFeature:
    'chains' FeatureChain
    ;
fragment InvertingPart returns SysMLFeature:
    'inverse' 'of' ownedRelationship += OwnedFeatureInverting
    ;
fragment TypeFeaturingPart returns SysMLFeature :
    'featured' 'by' ownedRelatioship += OwnedTypeFeaturing
    ( ',' ownedTypeFeaturing += OwnedTypeFeaturing )*
    ;
fragment FeatureSpecializationPart returns SysMLFeature:
    FeatureSpecialization+ MultiplicityPart? FeatureSpecialization*
    | MultiplicityPart FeatureSpecialization*
    ;
fragment MultiplicityPart returns SysMLFeature:
    ownedRelationship += OwnedMultiplicity
    | ( ownedRelationship += OwnedMultiplicity )?
    ( isOrdered ?= 'ordered' ( /*{isUnique = false}*/ isUnique?='nonunique' )?
    | 'nonunique' ( isOrdered ?= 'ordered' )? )
    // | {isUnique = false} 'nonunique' ( isOrdered ?= 'ordered' )? )
    ;
fragment FeatureSpecialization returns SysMLFeature:
    Typings | Subsettings | Redefinitions
    ;
fragment Typings returns SysMLFeature:
    TypedBy ( ',' ownedRelationship += OwnedFeatureTyping )*
    ;
fragment TypedBy returns SysMLFeature:
    TYPED_BY ownedRelationship += OwnedFeatureTyping
    ;
fragment Subsettings returns SysMLFeature:
    Subsets ( ',' ownedRelationship += OwnedSubsetting )*
    ;
fragment Subsets returns SysMLFeature:
    SUBSETS ownedRelationship += OwnedSubsetting
    ;
fragment Redefinitions returns SysMLFeature:
    Redefines ( ',' ownedRelationship += OwnedRedefinition )*
    ;
fragment Redefines returns SysMLFeature:
    REDEFINES ownedRelationship += OwnedRedefinition
    ;
/************************************************
 * Feature Typing
 ************************************************/
FeatureTyping returns SysMLFeatureTyping:
    ( 'specialization' Identification )?
    'typing' typedFeature = [SysMLFeature:ID]
    TYPED_BY GeneralType ';'
    ;
OwnedFeatureTyping returns SysMLFeatureTyping :
    GeneralType
    ;
/************************************************
 * Subsetting
 ************************************************/
Subsetting returns SysMLSubsetting:
    ( 'specialization' Identification )?
    'subset' SpecificType
    SUBSETS GeneralType ';'
    ;
OwnedSubsetting returns SysMLSubsetting:
    GeneralType
    ;
/************************************************
 * Redefinition
 ************************************************/
Redefinition returns SysMLRedefinition:
    ( 'specialization' Identification )?
    'redefinition' SpecificType
    REDEFINES GeneralType ';'
    ;
OwnedRedefinition returns SysMLRedefinition:
    GeneralType
    ;
/************************************************
 * Feature Chaining
 ************************************************/
OwnedFeatureChain returns SysMLFeature:
    FeatureChain
    ;
FeatureChain returns SysMLFeature:
    FeatureChainFrag
    ;
fragment FeatureChainFrag returns SysMLFeature:
    ownedRelationship += OwnedFeatureChaining
    ( '.' ownedRelationship += OwnedFeatureChaining )+
    ;
OwnedFeatureChaining returns SysMLFeatureChaining:
    chainingFeature = [SysMLFeature:QualifiedName]
    ;
/************************************************
 * Feature Inverting
 ************************************************/
 FeatureInverting returns SysMLFeatureInverting:
    ( 'inverting' Identification? )?
    'inverse'
    ( featureInverted = [SysMLFeature:QualifiedName]
    | featureInverted = OwnedFeatureChain
    // { ownedRelatedElement += featureInverted } 
    )
    'of'
    ( invertingFeature = [SysMLFeature:QualifiedName]
    | ownedRelatedElement += OwnedFeatureChain
    // { ownedRelatedElement += invertingFeature } 
    ) ';'
    ;
OwnedFeatureInverting returns SysMLFeatureInverting:
    invertingFeature = [SysMLFeature:QualifiedName]
    | invertingFeature = OwnedFeatureChain
    // { ownedRelatedElement += invertingFeature }
    ;
/************************************************
 * Type Featuring
 ************************************************/
fragment TypeFeaturing returns SysMLTypeFeaturing:
    'featuring' ( Identification 'of')?
    featureOfType = [SysMLFeature:QualifiedName]
    'by' featuringType = [SysMLType:QualifiedName] ';'
    ;
OwnedTypeFeaturing returns SysMLTypeFeaturing:
    featuringType = [SysMLType:QualifiedName]
    ;
/************************************************
 * Data Types
 ************************************************/
fragment DataType returns SysMLDataType:
    ( isAbstract ?= 'abstract' )? 'datatype'
    ClassifierDeclaration TypeBody
    ;
/************************************************
 * Classes
 ************************************************/
fragment Class returns SysMLClass:
    ( isAbstract ?= 'abstract' )? 'class'
    ClassifierDeclaration TypeBody
    ;
/************************************************
 * Structure
 ************************************************/
fragment Structure returns SysMLStructure:
    ( isAbstract ?= 'abstract' )? 'struct'
    ClassifierDeclaration TypeBody
    ;
/************************************************
 * Associations
 ************************************************/
fragment Association returns SysMLAssociation:
    ( isAbstract ?= 'abstract' )? 'assoc'
    ClassifierDeclaration TypeBody
    ;
fragment AssociationStructure returns SysMLAssociation:
    ( isAbstract ?= 'abstract' )? 'assoc' 'struct'
    ClassifierDeclaration TypeBody
    ;
/************************************************
 * Connectors
 ************************************************/
fragment Connector returns SysMLConnector:
    FeaturePrefix 'connector'
    ConnectorDeclaration TypeBody
    ;
fragment ConnectorDeclaration returns SysMLConnector:
    BinaryConnectorDeclaration | NaryConnectorDeclaration
    ;
fragment BinaryConnectorDeclaration returns SysMLConnector:
    ( FeatureDeclaration? 'from' | isSufficient ?= 'all' 'from'? )?
    ownedRelationship += ConnectorEndMember 'to'
    ownedRelationship += ConnectorEndMember
    ;
fragment NaryConnectorDeclaration returns SysMLConnector:
    FeatureDeclaration
    ( '(' ownedRelationship += ConnectorEndMember ','
    ownedRelationship += ConnectorEndMember
    ( ',' ownedRelationship += ConnectorEndMember )* ')' )?
    ;

ConnectorEndMember returns SysMLEndFeatureMembership: ConnectorEndMemberFrag;

fragment ConnectorEndMemberFrag returns SysMLEndFeatureMembership:
    ownedMemberFeature = ConnectorEndFragment
    ;
ConnectorEndFragment returns SysMLFeature:
    ConnectorEnd
    ;
fragment ConnectorEnd returns SysMLFeature:
    ( name = ID ':>' )?
    ownedRelationship += OwnedSubsetting
    ( ownedRelationship += OwnedMultiplicity )?
    ;
/************************************************
 * Binding Connectors
 ************************************************/
 fragment BindingConnector returns SysMLBindingConnector:
    FeaturePrefix 'binding'
    BindingConnectorDeclaration
    // BindingConnectorDeclarationTypeBody
    ;
fragment BindingConnectorDeclaration returns SysMLBindingConnector:
    ( FeatureDeclaration 'of' | isSufficient ?= 'all' 'of'? )?
    ownedRelationship += ConnectorEndMember '='
    ownedRelationship += ConnectorEndMember
    ;
/************************************************
 * Successions
 ************************************************/
fragment Succession returns SysMLSuccession:
    FeaturePrefix 'succession'
    SuccessionDeclaration TypeBody
    ;
fragment SuccessionDeclaration returns SysMLSuccession:
    ( FeatureDeclaration? 'first' | isSufficient ?= 'all' 'first'? )?
    ownedRelationship += ConnectorEndMember 'then'
    ownedRelationship += ConnectorEndMember
    ;
/************************************************
 * Behaviors
 ************************************************/
fragment Behavior returns SysMLBehavior:
    ( isAbstract ?= 'abstract')? 'behavior'
    BehaviorDeclaration TypeBody
    ;
fragment BehaviorDeclaration returns SysMLBehavior:
    ClassifierDeclaration ParameterList?
    ;
fragment ParameterList returns SysMLType:
    '(' ( ownedRelationship += ParameterMember
    ( ',' ownedRelationship += ParameterMember )* )? ')'
    ;
ParameterMember returns SysMLParameterMembership:
    ownedMemberParameter = ParameterDeclaration
    ;
ParameterDeclaration returns SysMLFeature:
    FeatureParameterDeclaration
    | StepParameterDeclaration
    | ExpressionParameterDeclaration
    | BooleanExpressionParameterDeclaration
    ;
fragment FeatureParameterDeclaration returns SysMLFeature:
    ( direction = FeatureDirection )?
    'feature'? ( isSufficient ?= 'all' )? Identification
    ParameterSpecializationPart
    ;
fragment StepParameterDeclaration returns SysMLStep:
    ( direction = FeatureDirection )?
    'step' ( isSufficient ?= 'all' )? Identification
    ParameterSpecializationPart
    ;
fragment ExpressionParameterDeclaration returns SysMLExpression:
    ( direction = FeatureDirection )?
    'expr' ( isSufficient ?= 'all' )? Identification
    ParameterSpecializationPart
    ;
fragment BooleanExpressionParameterDeclaration returns SysMLBooleanExpression :
    ( direction = FeatureDirection )?
    'bool' ( isSufficient ?= 'all' )? Identification
    ParameterSpecializationPart
    ;
fragment ParameterSpecializationPart returns SysMLFeature:
    ParameterSpecialization* MultiplicityPart? ParameterSpecialization*
    // ParameterSpecialization* MultiplicityPart? ParameterSpecialization(f)*
    ;
fragment ParameterSpecialization returns SysMLFeature:
    TypedBy | Subsets | Redefines
    ;
/************************************************
 * Steps
 ************************************************/
 Step returns SysMLStep:
    FeaturePrefix 'step'
    StepDeclaration TypeBody
    ;
fragment StepDeclaration returns SysMLStep:
    FeatureDeclaration ( ValuePart | StepParameterList )?
    ;
fragment StepParameterList returns SysMLType:
    '(' ( ownedRelationship += StepParameterMember
    ( ',' ownedRelationship += StepParameterMember )* )? ')'
    ;
StepParameterMember returns SysMLParameterMembership :
    ownedMemberParameter = StepParameter
    ;
StepParameter returns SysMLFeature:
    ParameterDeclaration ValuePart?
    ;
/************************************************
 * Functions
 ************************************************/
fragment Function returns SysMLFunction:
    ( isAbstract ?= 'abstract' )? 'function'
    FunctionDeclaration FunctionBody
    ;
fragment FunctionDeclaration returns SysMLFunction:
    ClassifierDeclaration ParameterList ReturnParameterPart?
    ;
fragment ReturnParameterPart returns SysMLType :
    ownedRelationship += ReturnParameterMember
    ;
ReturnParameterMember returns SysMLReturnParameterMembership:ReturnParameterMemberFrag;

fragment ReturnParameterMemberFrag returns SysMLReturnParameterMembership:
    'return'? ownedMemberParameter = ParameterDeclaration
    ;
fragment FunctionBody returns SysMLType :
    ';'
    | '{' ( TypeBodyElement
    | ownedRelationship += ReturnFeatureMember
    )*
    ( ownedRelationship += ResultExpressionMember )?
    '}'
    ;
ReturnFeatureMember returns SysMLReturnParameterMembership:
    MemberPrefix 'return'
    ownedMemberParameter = FeatureElement
    ;
ResultExpressionMember returns SysMLResultExpressionMembership:
    MemberPrefix
    ownedResultExpression = OwnedExpression
    ;
/************************************************
 * Expressions
 ************************************************/
 Expression returns SysMLExpression:
    FeaturePrefix 'expr'
    ExpressionDeclaration
    // ExpressionDeclarationFunctionBody
    ;
ExpressionDeclaration returns SysMLExpression:
// ExpressionDeclarationFunctionBody infers Expression:
    FeatureDeclaration
    ( ValuePart | StepParameterList ReturnParameterPart? )?
    ;
/************************************************
 * Predicates
 ************************************************/
fragment Predicate returns SysMLPredicate:
    ( isAbstract ?= 'abstract' )? 'predicate'
    PredicateDeclaration FunctionBody
    ;
fragment PredicateDeclaration returns SysMLPredicate:
    ClassifierDeclaration
    ( ParameterList ReturnParameterPart? )?
    ;
/************************************************
 * Boolean Expresions and Invariants
 ************************************************/
BooleanExpression returns SysMLBooleanExpression:
    FeaturePrefix 'bool'
    ExpressionDeclaration
    ;
Invariant returns SysMLInvariant:
    FeaturePrefix 'inv' ( 'true' | isNegated ?= 'false' )?
    ExpressionDeclaration FunctionBody
    ;
/************************************************
 * Operator Expressions
 ************************************************/
OwnedExpressionReferenceMember returns SysMLFeatureMembership: OwnedExpressionReferenceMemberFrag;
fragment OwnedExpressionReferenceMemberFrag returns SysMLFeatureMembership:
    ownedRelationship += OwnedExpressionReference
    ;
OwnedExpressionReference returns SysMLFeatureReferenceExpression :
    OwnedExpressionReferenceFrag
    ;
fragment OwnedExpressionReferenceFrag returns SysMLFeatureReferenceExpression :
    ownedRelationship += OwnedExpressionMember
    ;
OwnedExpressionMember returns SysMLFeatureMembership :
    ownedFeatureMember = OwnedExpression
    ;
OwnedExpression returns SysMLExpression :
    ConditionalExpression
    | BinaryOperatorExpression
    | UnaryOperatorExpression
    | ClassificationExpression
    | ExtentExpression
    | PrimaryExpression
    ;
fragment ConditionalExpression returns SysMLOperatorExpression :
     'if' ownedRelationship += OwnedExpressionMember
    //  'if' ownedRelationship += ConditionalBinaryOperatorExpression
    operator = '?'
    ownedRelationship += OwnedExpressionReferenceMember 'else'
    ownedRelationship += OwnedExpressionReferenceMember
    | ownedRelationship += OwnedExpressionMember
    operator = '?'
    ownedRelationship += OwnedExpressionReferenceMember ':'
    ownedRelationship += OwnedExpressionReferenceMember
    ;
fragment ConditionalBinaryOperatorExpression returns SysMLOperatorExpression:
    ownedRelationship += OwnedExpressionMember
    operator = ConditionalBinaryOperator
    ownedRelationship += OwnedExpressionReferenceMember
    ;
terminal ConditionalBinaryOperator:
    '??' | '||' | '&&' | 'or' | 'and' | 'implies'
    ;
fragment BinaryOperatorExpression returns SysMLOperatorExpression:
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
fragment UnaryOperatorExpression returns SysMLOperatorExpression:
    operator = UnaryOperator
    ownedRelationship += OwnedExpressionMember
    ;
terminal UnaryOperator:
    '+' | '-' | '!' | '~' | 'not'
    ;
fragment ClassificationExpression returns SysMLOperatorExpression:
    ( ownedRelationship += OwnedExpressionMember )?
    operator = ClassificationOperator
    ownedRelationship += TypeReferenceMember
    ;
terminal ClassificationOperator:
    'istype' | 'hastype' | '@' | 'as'
    ;
fragment ExtentExpression returns SysMLOperatorExpression:
    operator = 'all'
    ownedRelationship += TypeReferenceMember
    ;
TypeReferenceMember returns SysMLFeatureMembership:
    ownedMemberFeature = TypeReference
    ;
TypeReference returns SysMLFeature:
    TypeReferenceFrag
    ;
fragment TypeReferenceFrag returns SysMLFeature:
    ownedRelationship += ReferenceTyping
    ;
ReferenceTyping returns SysMLFeatureTyping:
    sysmlType = [SysMLType:ID]
    // type = [QualifiedName]
    ;
/************************************************
 * Primary Expressions
 ************************************************/
 PrimaryExpression returns SysMLExpression:
    FeatureChainExpression
    | NonFeatureChainPrimaryExpression
    ;
PrimaryExpressionMember returns SysMLFeatureMembership:
    ownedMemberFeature = PrimaryExpression
    ;
NonFeatureChainPrimaryExpression returns SysMLExpression:
    IndexExpression
    | SequenceExpression
    | SelectExpression
    | CollectExpression
    | FunctionOperationExpression
    | BaseExpression
    ;
NonFeatureChainPrimaryExpressionMember returns SysMLFeatureMembership:
    ownedMemberFeature = NonFeatureChainPrimaryExpression
    ;
fragment IndexExpression returns SysMLOperatorExpression:
    ownedRelationship += PrimaryExpressionMember
    operator = '['
    ownedRelationship += OwnedExpressionMember ']'
    ;
fragment SequenceExpression returns SysMLExpression:
    '(' ( OwnedExpression | SequenceExpressionList ) ','? ')'
    ;

SequenceExpressionList returns SysMLOperatorExpression:SequenceExpressionListFrag;

fragment SequenceExpressionListFrag returns SysMLOperatorExpression:
    ownedRelationship += OwnedExpressionMember
    operator = ','
    ( ownedRelationship += SequenceExpressionListMember
    | ownedRelationship += OwnedExpressionMember )
    ;
SequenceExpressionListMember returns SysMLFeatureMembership:
    ownedMemberFeature = SequenceExpressionList
    ;
fragment FeatureChainExpression returns SysMLFeatureChainExpression:
    ownedRelationship += NonFeatureChainPrimaryExpressionMember '.'
    ownedRelationship += FeatureChainMember
    ;
fragment CollectExpression returns SysMLCollectExpression:
    ownedRelationship += PrimaryExpressionMember '.'
    ownedRelationship += BodyExpressionMember
    ;
fragment SelectExpression returns SysMLSelectExpression:
    ownedRelationship += PrimaryExpressionMember '.?'
    ownedRelationship += BodyExpressionMember
    ;
fragment FunctionOperationExpression returns SysMLInvocationExpression:
    ownedRelationship += PrimaryExpressionMember '->'
    ownedRelationship += ReferenceTyping
    ( ownedRelationship += BodyExpressionMember
    | ownedRelationship += FunctionExpressionMember
    // | ownedRelationship += FunctionReferenceExpressionMember
    | ArgumentList )
    ;
BodyExpressionMember returns SysMLFeatureMembership :
    ownedMemberFeature = BodyExpression
    ;
FunctionExpressionMember returns SysMLFeatureMembership:
    ownedMemberFeature = FunctionReferenceExpression
    ;
FunctionReferenceExpression returns SysMLFeatureReferenceExpression: FunctionReferenceExpressionFrag;

fragment FunctionReferenceExpressionFrag returns SysMLFeatureReferenceExpression:
    ownedRelationship += FunctionReferenceMember
    ;
FunctionReferenceMember returns SysMLFeatureMembership :
    ownedMemberFeature = FunctionReference
    ;
FunctionReference returns SysMLExpression: FunctionReferenceFrag;

fragment FunctionReferenceFrag returns SysMLExpression:
    ownedRelationship += ReferenceTyping
    ;
FeatureChainMember returns SysMLMembership :
    FeatureReferenceMember
    | OwnedFeatureChainMember
    ;
fragment OwnedFeatureChainMember returns SysMLOwningMembership:
    ownedMemberElement = FeatureChain
    ;
/************************************************
 * Base Expressions
 ************************************************/
 BaseExpression returns SysMLExpression:
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
fragment FeatureReferenceExpression returns SysMLFeatureReferenceExpression:
    ownedRelationship += FeatureReferenceMember
    ;

FeatureReferenceMember returns SysMLMembership:
    FeatureReferenceMemberFrag
    ;
fragment FeatureReferenceMemberFrag returns SysMLMembership:
    memberElement = [SysMLElement:QualifiedName]
    ;
fragment InvocationExpression returns SysMLInvocationExpression :
    ownedRelationship += OwnedSpecialization
    ArgumentList
    // ArgumentList(this)
    ;
fragment ArgumentList returns SysMLInvocationExpression:
    '(' ( PositionalArgumentList | NamedArgumentList )? ')'
    ;
fragment PositionalArgumentList returns SysMLInvocationExpression:
    ownedRelationship += ArgumentMember
    ( ',' ownedRelationship += ArgumentMember )*
    ;
ArgumentMember returns SysMLParameterMembership:
    ownedMemberParameter = Argument
    ;
Argument returns SysMLFeature:ArgumentFrag;

fragment ArgumentFrag returns SysMLFeature:
    ownedRelationship += ArgumentValue
    ;
fragment NamedArgumentList returns SysMLInvocationExpression:
    ownedRelationship += NamedArgumentMember
    ( ',' ownedRelationship += NamedArgumentMember )*
    ;
NamedArgumentMember returns SysMLFeatureMembership:
    ownedMemberFeature = NamedArgument
    ;

NamedArgument returns SysMLFeature: NamedArgumentFrag;

fragment NamedArgumentFrag returns SysMLFeature:
    ownedRelationship += ParameterRedefinition '='
    ownedRelationship += ArgumentValue
    ;
ParameterRedefinition returns SysMLRedefinition :
    redefinedFeature = [SysMLFeature:ID]
    // redefinedFeature = [QualifiedName]
    ;
ArgumentValue returns SysMLFeatureValue:
    value = OwnedExpression
    ;

BodyExpression returns SysMLFeatureReferenceExpression:BodyExpressionFrag;

fragment BodyExpressionFrag returns SysMLFeatureReferenceExpression:
    ownedRelationship += ExpressionBodyMember
    ;
ExpressionBodyMember returns SysMLFeatureMembership:
    ownedMemberFeature = ExpressionBody
    ;
ExpressionBody returns SysMLExpression:
    FunctionBody
    ;
/************************************************
 * Literal Expressions
 ************************************************/
 LiteralExpression returns SysMLLiteralExpression:
    LiteralBoolean
    | LiteralString
    | LiteralInteger
    | LiteralReal
    | LiteralInfinity
    ;
fragment LiteralBoolean returns SysMLLiteralBoolean:
    // value = BooleanValue
    value?='true' | 'false'
    ;
fragment LiteralString returns SysMLLiteralString:
    value = STRING_VALUE
    ;
fragment LiteralInteger returns SysMLLiteralInteger :
    value = DECIMAL_VALUE
    ;
fragment LiteralReal returns SysMLLiteralReal:
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
fragment Interaction returns SysMLInteraction:
    ( isAbstract ?= 'abstract' )? 'interaction'
    BehaviorDeclaration TypeBody
    ;
/************************************************
 * Item Flows
 ************************************************/
ItemFlow returns SysMLItemFlow:
    FeaturePrefix 'flow'
    ItemFlowDeclaration TypeBody
    ;
SuccessionItemFlow returns SysMLSuccessionItemFlow:
    FeaturePrefix 'succession' 'flow'
    ItemFlowDeclaration TypeBody
    ;
fragment ItemFlowDeclaration returns SysMLItemFlow:
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
ItemFeatureMember returns SysMLFeatureMembership:
    ownedMemberFeature = ItemFeature
    ;
ItemFeature  returns SysMLFeature:
    ItemFeatureFrag;

fragment ItemFeatureFrag returns SysMLFeature:
    ( name = ID ':' )?
    ( ownedTyping += OwnedFeatureTyping
    ( ownedRelationship += OwnedMultiplicity )?
    | ownedRelationship += OwnedMultiplicity
    ( ownedTyping += OwnedFeatureTyping )?
    )
    ;
EmptyItemFeatureMember returns SysMLFeatureMembership:
    ownedMemberFeature = EmptyItemFeature
    ;
EmptyItemFeature returns SysMLFeature:
    {SysMLFeature}
    ;
ItemFlowEndMember returns SysMLFeatureMembership:
    ownedMemberFeature = ItemFlowEnd
    ;
ItemFlowEnd returns SysMLFeature:
    ItemFlowEndFrag;

fragment ItemFlowEndFrag returns SysMLFeature:
    ( ownedRelationship += Subsetting* '.' )?
    ownedRelationship += ItemFlowFeatureMember
    ;
ItemFlowFeatureMember returns SysMLFeatureMembership:
    ownedMemberFeature = ItemFlowFeature
    ;

ItemFlowFeature returns SysMLFeature:
    ItemFlowFeatureFrag;

fragment ItemFlowFeatureFrag returns SysMLFeature:
    ownedRelationship += ItemFlowRedefinition
    ;
ItemFlowRedefinition returns SysMLRedefinition:
    ItemFlowRedefinitionFrag
    ;
fragment ItemFlowRedefinitionFrag returns SysMLRedefinition:
    redefinedFeature = [SysMLFeature:ID]
    ;
/************************************************
 * Feature Values
 ************************************************/
 fragment ValuePart returns SysMLFeature:
    ownedRelationship += FeatureValue
    ;
FeatureValue returns SysMLFeatureValue:
    ( '='
    | isInitial ?= ':='
    | isDefault ?= 'default' ( '=' | isInitial ?= ':=' )?
    )
    value = OwnedExpression
    ;
/************************************************
 * Multiplicities
 ************************************************/
Multiplicity returns SysMLMultiplicity:
    MultiplicitySubset | MultiplicityRange
    ;
fragment MultiplicitySubset returns SysMLMultiplicity:
    'multiplicity' Identification Subsets ';'
    ;
fragment MultiplicityRange returns SysMLMultiplicityRange:
    'multiplicity' Identification MultiplicityBounds ';'
    ;
OwnedMultiplicity returns SysMLOwningMembership:
    OwnedMultiplicityFrag
    ;
fragment OwnedMultiplicityFrag returns SysMLOwningMembership:
    ownedMemberElement = OwnedMultiplicityRange
    ;
OwnedMultiplicityRange returns SysMLMultiplicityRange:
    MultiplicityBounds
    ;
fragment MultiplicityBounds returns SysMLMultiplicityRange:
    '[' ( ownedRelationship += MultiplicityExpressionMember '..' )?
    ownedRelationship += MultiplicityExpressionMember ']'
    ;

MultiplicityExpressionMember returns SysMLOwningMembership:MultiplicityExpressionMemberFrag;

fragment MultiplicityExpressionMemberFrag returns SysMLOwningMembership:
    ownedMemberElement = ( LiteralExpression | FeatureReferenceExpression )
    ;
/************************************************
 * Metadata
 ************************************************/
 fragment Metaclass returns SysMLMetaclass:
    ( isAbstract ?= 'abstract' )? 'metaclass'
    ClassifierDeclaration TypeBody
    ;
OwnedMetadataFeatureAnnotation returns SysMLAnnotation:
    ownedRelatedElement += OwnedMetadataFeature
    ;
OwnedMetadataFeature returns SysMLMetadataFeature:
    OwnedMetadataFeatureFrag
    ;
fragment OwnedMetadataFeatureFrag returns SysMLMetadataFeature:
    ( '@' | 'metadata' )
    ( Identification ( ':' | 'typed' 'by' ) )?
    ownedRelationship += [SysMLMetaclass:ID]
    // ownedRelationship += MetadataTyping
    TypeBody
    ;
MetadataFeature returns SysMLMetadataFeature:
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
fragment MetadataFeatureDeclaration returns SysMLMetadataFeature:
    ( Identification ( ':' | 'typed' 'by' ) )?
    ownedRelationship += OwnedFeatureTyping
    ;
fragment MetadataBody returns SysMLFeature:
    ';' | '{' ( ownedRelationship += MetadataBodyElement )* '}'
    ;
MetadataBodyElement returns SysMLMembership:
    NonFeatureMember
    | MetadataBodyFeatureMember
    | AliasMember
    | Import
    ;
fragment MetadataBodyFeatureMember returns SysMLFeatureMembership:
    ownedMemberFeature = MetadataBodyFeature
    ;
MetadataBodyFeature returns SysMLFeature:
    MetadataBodyFeatureFrag
    ;
fragment MetadataBodyFeatureFrag returns SysMLFeature:
    'feature'? ( ':>>' | 'redefines')? ownedRelationship += OwnedRedefinition
    FeatureSpecializationPart? ValuePart?
    MetadataBody
    ;
/************************************************
 * Packages
 ************************************************/
Package returns SysMLPackage:
    PackageDeclaration PackageBody
    ;
fragment PackageDeclaration  returns SysMLPackage:
    'package' Identification
    ;
fragment PackageBody returns SysMLPackage:
    ';'
    | '{' ( NamespaceBodyElement
    | ownedRelationship += ElementFilterMember
    )*
    '}'
    ;
ElementFilterMember returns SysMLElementFilterMembership:
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