/*
enum VisibilityKind {
    Private = "Private",
    Protected = "Protected",
    Public = "Public"
}

enum FeatureDirectionKind {
    in,
    inout,
    out
}
*/

interface SysMLElement {
    aliasIds?:string[];
    documentation?:SysMLDocumentation[];
    elementId?:string;
    name?:string;
    ownedAnnotation?:SysMLAnnotation[];
    ownedElement?:SysMLElement[];
    ownedRelationship?:SysMLRelationship[];
    owner?:SysMLElement;
    owningMembership?:SysMLOwningMembership;
    owningNamespace?:SysMLNamespace;
    owningRelationship?:SysMLRelationship;
    qualifiedName?:string;
    shortName?:string[];
    textualRepresentation?:SysMLTextualRepresentation[];
}
interface SysMLAnnotatingElement extends SysMLElement { 
    annotatedElement:SysMLElement[];
    annotation?:SysMLAnnotation[];
}
interface SysMLAnnotation extends SysMLRelationship { 
    annotatedElement:SysMLElement;              // {redefines target}
    annotatingElement:SysMLAnnotatingElement;   // {redefines source}
    owningAnnotatedElement?:SysMLElement;       // {subsets annotatedElement, ownedRelatedElement}
}
interface SysMLComment extends SysMLAnnotatingElement { 
    body:string;
    locale?:string;
}
interface SysMLDocumentation extends SysMLComment { 
    documentedElement:SysMLElement; // {subsets owner, redefines annotatedElement}
}
interface SysMLTextualRepresentation extends SysMLAnnotatingElement { 
    body:string;
    language:string;
    representedElement:SysMLElement; // {subsets owner, redefines annotatedElement}
}
interface SysMLNamespace extends SysMLElement {
    importedMembership?:SysMLMembership[];  // {subsets membership, ordered}
    member?:SysMLElement[];                 // {ordered}
    membership?:SysMLMembership[];          // {ordered, union}
    ownedImport?:SysMLImport[];             // {subsets sourceRelationship, ownedRelationship, ordered}
    ownedMember?:SysMLElement[];            // {subsets member, ordered}
    ownedMembership?:SysMLMembership[];     // {subsets membership, sourceRelationship, ownedRelationship, ordered}
 }
interface SysMLType extends SysMLNamespace { 
    directedFeature?:SysMLFeature[];    // {subsets feature, ordered}
    endFeature?:SysMLFeature[];         // {subsets feature, ordered}
    feature?:SysMLFeature[];            // {subsets feature, ordered}
    featureMembership?:SysMLFeatureMembership[]; // {subsets feature, ordered}
    inheritedFeature?:SysMLFeature[];   // {subsets feature, ordered}
    inheritedMembership?:SysMLMembership[]; // {subsets membership, ordered}
    input?:SysMLFeature[];  // {subsets directedFeature, ordered}
    isAbstract:boolean;
    isConjugated:boolean;
    isSufficient:boolean;
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
    isComposite: boolean;
    isDerived:boolean;
    isEnd:boolean;
    isOrdered:boolean;
    isPortion:boolean;
    isReadOnly:boolean;
    isUnique:boolean;
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
    featureInverted:SysMLFeature;   // {redefines source}
    invertingFeature:SysMLFeature;  // {redefines target}
    owningFeature?:SysMLFeature;    // {subsets owningRelatedElement, featureInverted}
}
interface SysMLClassifier extends SysMLType { 
    ownedSubclassification?:SysMLSubclassification[];   // {subsets ownedSpecialization}
}
interface SysMLMultiplicity extends SysMLFeature { 
    // none
}
interface SysMLStep extends SysMLFeature { 
    behavior:SysMLBehavior[];   // {redefines type, ordered}
    parameter?:SysMLFeature[];  // {redefines directedFeature, ordered}
}
interface SysMLConnector extends SysMLFeature, SysMLRelationship { 
    association:SysMLAssociation[]; // {redefines type}
    connectorEnd:SysMLFeature[];    // {redefines endFeature}
    isDirected:boolean;
    relatedFeature:SysMLFeature[];  // {redefines relatedElement, ordered, nonunique, union}
    sourceFeature?:SysMLFeature;    // {subsets relatedFeature, redefines source}
    targetFeature:SysMLFeature[];   // {subsets relatedFeature, redefines target}
}
interface SysMLAssociation extends SysMLClassifier, SysMLRelationship { 
    associationEnd:SysMLFeature[];  // {redefines endFeature}
    relatedType:SysMLType;          // {redefines relatedElement ordered, nonunique, union}
    sourceType?:SysMLType;          // {subsets relatedType, redefines source}
    targetType:SysMLType[];         // {subsets relatedType, redefines target}
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
    metaclass:SysMLMetaclass; // {redefines type}
}

interface SysMLFunction extends SysMLBehavior { 
    expression?:SysMLExpression[];  // {redefines step}
    isModelLevelEvaluable:boolean;
    result:SysMLFeature;            // {subsets parameter, output}
}

interface SysMLMultiplicityRange extends SysMLMultiplicity { 
    bound:SysMLExpression[];        // {redefines ownedMember, ordered, union}
    lowerBound?:SysMLExpression;    // {subsets bound}
    upperBound:SysMLExpression;     // {subsets bound}
}

interface SysMLExpression extends SysMLStep { 
    function:SysMLFunction; // {redefines behavior}
    isModelLevelEvaluable:boolean;
    result:SysMLFeature;    // {subsets parameter, output}
}

interface SysMLItemFeature extends SysMLFeature { }
interface SysMLItemFlowFeature extends SysMLItemFlow, SysMLFeature { }
interface SysMLItemFlowEnd extends SysMLItemFlow { }

interface SysMLItemFlow extends SysMLConnector, SysMLStep { 
    itemFeature:SysMLItemFeature[]; // {subsets ownedFeature}
    itemFlowEnd:SysMLItemFlowEnd[]; // {redefines connectorEnd}
    itemFlowFeature:SysMLItemFlowFeature[];
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
    referent:SysMLFeature; // {subsets member}
}
interface SysMLLiteralBoolean extends SysMLLiteralExpression { 
    value:boolean;
}
interface SysMLLiteralString extends SysMLLiteralExpression { 
    value:string;
}
interface SysMLLiteralInteger extends SysMLLiteralExpression { 
    value:number;
}
interface SysMLLiteralReal extends SysMLLiteralExpression { 
    value:number;
}
interface SysMLLiteralRational extends SysMLLiteralExpression { }
interface SysMLLiteralInfinity extends SysMLLiteralExpression { 
    // none
}
interface SysMLOperatorExpression extends SysMLInvocationExpression { 
    operand?:SysMLExpression[]; // {ordered}
    operator:string;
}
interface SysMLInvariant extends SysMLBooleanExpression { 
    isNegated:boolean;
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
    ownedRelatedElement?:SysMLElement[];    // {subsets relatedElement, ordered}
    owningRelatedElement?:SysMLElement;     // {subsets relatedElement}
    relatedElement:SysMLElement[];          // {ordered, nonunique, union}
    source?:SysMLElement;                   // {subsets relatedElement, ordered}
    target?:SysMLElement;                   // {subsets relatedElement, ordered}
}
interface SysMLImport extends SysMLRelationship { 
    importedMemberName?:string;
    importedNamespace:SysMLNamespace;       // {redefines target}
    importOwningNamespace:SysMLNamespace;   // {subsets owningRelatedElement, redefines source}
    isImportAll:boolean;
    isRecursive:boolean;
    // visibility:SysMLVisibilityKind;
}
interface SysMLMembership extends SysMLRelationship { 
    memberElement:SysMLElement;     // {redefines target}
    memberElementId:string;
    memberName?:string;
    membershipOwningNamespace:SysMLNamespace; // {subsets membershipNamespace, owningRelatedElement, redefines source}
    memberShortName?:string;
    // visibility:SysMLVisibilityKind;
}
interface SysMLOwningMembership extends SysMLMembership {
    ownedMemberElement:SysMLElement;    // {subsets ownedRelatedElement, redefines memberElement}
    ownedMemberElementId:string;        // {redefines memberElementId}
    ownedMemberName?:string;            // {redefines memberName}
    ownedMemberShortName?:string;       // {redefines memberShortName}
}
interface SysMLConjugation extends SysMLRelationship { 
    conjugatedType:SysMLType;   // { redefines source }
    originalType:SysMLType;     // { redefines target }
    owningType?:SysMLType;      // { subsets conjugatedType, owningRelatedElement }
}
interface SysMLDisjoining extends SysMLRelationship { 
    disjoiningType:SysMLType;   // { redefines target }
    owningType:SysMLType;       // { subsets typeDisjoined, owningRelatedElement }
    typeDisjoined:SysMLType;    // { redefines source }
}
interface SysMLTypeFeaturing extends SysMLRelationship { 
    featureOfType:SysMLFeature; // {redefines source}
    featuringType:SysMLType;    // {redefines target}
    owningFeatureOfType?:SysMLFeature;  // {subsets featureOfType, owningRelatedElement}
}

interface SysMLFeatureChaining extends SysMLRelationship { }

interface SysMLSpecialization extends SysMLRelationship { 
    general:SysMLType;      // {redefines target}
    owningType?:SysMLType;  // {subsets specific, owningRelatedElement}
    specific:SysMLType;     // {redefines source}
}

interface SysMLFeatureValue extends SysMLOwningMembership { 
    featureWithValue:SysMLFeature;  // {subsets membershipOwningNamespace}
    isDefault:boolean;
    isInitial:boolean;
    value:SysMLExpression;  // {redefines ownedMemberElement}
}
interface SysMLElementFilterMembership extends SysMLOwningMembership { 
    condition:SysMLExpression;  // {redefines ownedMemberElement}
}

interface SysMLFeatureMembership extends SysMLOwningMembership, SysMLTypeFeaturing { 
    ownedMemberFeature?:SysMLFeature;   // { subsets featureOfType, redefines ownedMemberElement }
    owningType:SysMLType;               // subsets featuringType, type, redefines membershipOwningNamespace }
}
interface SysMLEndFeatureMembership extends SysMLFeatureMembership {
    // ownedMemberFeature:SysMLFeature; // {redefines ownedMemberFeature}
}
interface SysMLFeatureTyping extends SysMLSpecialization { 
    owningFeature?:SysMLFeature;    // {subsets typedFeature, redefines owningType}
    sysmlType:SysMLType;            // {redefines general}
    typedFeature:SysMLFeature;      // {redefines specific}
}
interface SysMLSubsetting extends SysMLSpecialization { 
    owningFeature:SysMLFeature; // {subsets subsettingFeature, redefines owningType}
    subsettedFeature:SysMLFeature;  // {redefines general}
    subsettingFeature:SysMLFeature; // {redefines specific}
}
interface SysMLSubclassification extends SysMLSpecialization { 
    owningClassifier?:SysMLClassifier;  // {redefines owningType}
    subclassifier:SysMLClassifier;      // {redefines specific}
    superclassifier:SysMLClassifier;    // {redefines general}
}
interface SysMLParameterMembership extends SysMLFeatureMembership {
    ownedMemberParameter:SysMLFeature;  // {redefines ownedMemberFeature}
}
interface SysMLResultExpressionMembership extends SysMLFeatureMembership { 
    ownedResultExpression: SysMLExpression; // {redefines ownedMemberFeature}
}
interface SysMLRedefinition extends SysMLSubsetting {
    redefinedFeature:SysMLFeature;  // {redefines subsettedFeature}
    redefiningFeature:SysMLFeature; // {redefines subsettingFeature}
}
interface SysMLReturnParameterMembership extends SysMLParameterMembership { 
    // None
}