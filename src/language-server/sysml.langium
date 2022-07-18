grammar SysML

entry RootNamespace: 
    package+=Package
    ;

Package:
    'package' Identification '{' element+=Element* '}'
    ;

Element:
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
    // | ownedRelationship += OwnedCommentAnnotation
    // | ownedRelationship += OwnedTextualRepresentationAnnotation
    // | ownedRelationship += OwnedMetadataFeatureAnnotation
    | OtherOwnedElement
    ;
fragment OtherOwnedElement infers Element:
    'language' language=STRING
    | 'doc' DOC_COMMENT
    ;

// Relationship:
//     'relationship' Identification
//     RelationshipRelatedElements
//     RelationshipBody
//     ;

interface Relationship {
    target?:@Element
    source?:@Element
    ownedRelationship?:Relationship[]
    ownedRelatedElement?:OwnedRelatedElement[]
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

RelationshipOwnedElement returns Relationship:
    ownedRelatedElement += OwnedRelatedElement*
    // | ownedRelatedElement += OwnedRelatedRelationship
    ;

OwnedRelatedElement:
    'element' Identification ElementBody
    ;

OwnedRelatedRelationship:
    'relationship' Identification
    RelationshipRelatedElements
    RelationshipBody
    ;


terminal ID: /[_a-zA-Z][\w_\d]*/;
// terminal INT returns number: /[0-9]+/;
terminal STRING: /"[^"]*"|'[^']*'/;
terminal DOC_COMMENT: /\/\*[\s\S]*?\*\//;

hidden terminal WS: /[\s+\n]/;
// hidden terminal ML_COMMENT: /\/\*[\s\S]*?\*\//;
hidden terminal SL_COMMENT: /\/\/[^\n\r]*/;
