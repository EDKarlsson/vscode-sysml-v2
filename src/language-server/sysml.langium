grammar SysML

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
    | ownedRelationship += OwnedCommentAnnotation
    // | ownedRelationship += OwnedTextualRepresentationAnnotation
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
// Relationship:
//     'relationship' Identification
//     RelationshipRelatedElements
//     RelationshipBody
//     ;

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
    ownedRelatedElement += (OwnedRelatedElement|OwnedRelatedRelationship)*
    // | OwnedRelationship += (
    //     OwnedCommentAnnotation
    //     | OwnedTextualRepresentationAnnotation
    //     | OwnedMetadataFeatureAnnotation
    // )*
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
// fragment OwnedTextualRepresentationAnnotation infers Annotation :
//     // ownedRelatedElement += OwnedTextualRepresentation
//     ownedRelatedElement += OwnedTextualRepresentation
//     ;
// OwnedTextualRepresentation infers TextualRepresentation :
//     ( 'rep' Identification )?
//     'language' language = STRING_VALUE 
//     body = REGULAR_COMMENT
//     // { annotation += a }
//     ;
// TextualRepresentation:
//     ( 'rep' Identification )?
//     'language' language = STRING_VALUE 
//     body = REGULAR_COMMENT
//     ;
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