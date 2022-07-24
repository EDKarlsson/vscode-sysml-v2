grammar SysML
// KerML Element Hierarchy
interface SysMLElement {
    elementId?:string
    aliasIds?:string[]
    shortName?:string[]
}
interface SysMLNamespace extends SysMLElement { }
interface SysMLAnnotingElement extends SysMLElement { }
interface SysMLType extends SysMLNamespace { }
interface SysMLPackage extends SysMLNamespace { }
interface SysMLComment extends SysMLAnnotingElement { }
interface SysMLTextualRepresentation extends SysMLAnnotingElement { }
interface SysMLDocumentation extends SysMLComment { }
interface SysMLFeature extends SysMLType { }
interface SysMLMetadataFeature extends SysMLFeature{ }
interface SysMLClassifier extends SysMLType { }
interface SysMLMultiplicity extends SysMLFeature { }
interface SysMLStep extends SysMLFeature { }
interface SysMLConnector extends SysMLFeature { }
interface SysMLAssociation extends SysMLClassifier { }
interface SysMLClass extends SysMLClassifier { }
interface SysMLDataType extends SysMLClassifier { }
interface SysMLInteraction extends SysMLAssociation { }
interface SysMLStructure extends SysML { }
interface SysMLBehavior extends SysML { }
interface SysMLAssociationStructure extends SysML { }
interface SysMLMetaclass extends SysML { }
interface SysMLFunction extends SysML { }
interface SysMLPredicate extends SysML { }
interface SysMLMultiplicityRange extends SysML { }
interface SysMLExpression extends SysML { }
interface SysMLItemFlow extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }

// KerML Relationship Hierarchy
interface SysMLRelationship extends SysMLElement { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }
interface SysML extends SysML { }

entry RootNamespace: 
    package+=Package
    | Comment
    ;

Package:
    'package' Identification '{' element+=Element* '}'
    ;

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
    // | ownedRelationship += OwnedMetadataFeatureAnnotation
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
    ;
NonFeatureMember infers OwningMembership :
    MemberPrefix
    ownedMemberElement = NonFeatureElement
;
NamespaceFeatureMember infers Membership :
    MemberPrefix
    // ownedMemberElement = FeatureElement
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
    // ( ownedRelationship += FilterPackageMember )+
;
FilterPackageImport infers Import :
    ImportedNamespace
;
// FilterPackageMember infers ElementFilterMembership :
//     '[' condition = OwnedExpression ']'
//     // { visibility = 'private' }
//     ;

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
    // | MetadataFeature
    | Namespace
    // | Type
    // | Classifier
    // | DataType
    // | Class
    // | Structure
    // | Metaclass
    // | Association
    // | AssociationStructure
    // | Interaction
    // | Behavior
    // | Function
    // | Predicate
    // | Multiplicity
    | Package
    // | Specialization
    // | Conjugation
    // | Subclassification
    // | Disjoining
    // | FeatureInverting
    // | FeatureTyping
    // | Subsetting
    // | Redefinition
    // | TypeFeaturing
    ;
// FeatureElement infers Feature :
//     Feature
//     | Step
//     | Expression
//     | BooleanExpression
//     | Invariant
//     | Connector
//     | BindingConnector
//     | Succession
//     | ItemFlow
//     | SuccessionItemFlow
//     ;
/************************************************
 * Name Resolution
 ************************************************/
QualifiedName: 
    name=ID( '::' ID )*
    ;
/************************************************
 * Types
 ************************************************/
// Type =
// ( isAbstract ?= 'abstract' )? 'type'
// TypeDeclaration TypeBody
// TypeDeclaration : Type =
// (t.isSufficient ?= 'all' )? Identification
// ( t.ownedRelationship += OwnedMultiplicity )?
// ( SpecializationPart | ConjugationPart )+
// DisjoiningPart?
// SpecializationPart : Type =
// SPECIALIZES ownedRelationship += OwnedSpecialization
// ( ',' ownedRelationship += OwnedSpecialization )*
// ConjugationPart : Type =
// CONJUGATES ownedRelationship += OwnedConjugation
// DisjoiningPart : Type =
// 'disjoint' 'from' ownedRelationship += OwnedDisjoining
// ( ',' ownedRelationship += OwnedDisjoining )*
// TypeBody : Type =
// ';' | '{' TypeBodyElement* '}'
// TypeBodyElement : Type =
// ownedRelationship += NonFeatureMember
// | ownedRelationship += FeatureMember
// | ownedRelationship += AliasMember
// | ownedRelationship += Import
/************************************************
 * 
 ************************************************/
/************************************************
 * 
 ************************************************/
/************************************************
 * 
 ************************************************/
/************************************************
 * 
 ************************************************/
/************************************************
 * 
 ************************************************/
/************************************************
 * Terminals
 ************************************************/
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
// terminal SUBSETS: /\b(\:\>|(subsets))\b/;
terminal SUBSETS: /\bsubsets\b/;

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