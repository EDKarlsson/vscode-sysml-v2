grammar SysMLv2

// entry Model:
//     (persons+=Person | greetings+=Greeting)*;

// Person:
//     'person' name=ID;

// Greeting:
//     'Hello' person=[Person:ID] '!';

entry RootNamespace: 
    package+=Package
    ;

Package:
    'package' Identification '{' ( element+=Element | '}')
    ;

Element:
    'element' Identification ElementBody
    ;

fragment Identification:
    ( '<' shortName = ID '>' )? ( name=ID )?
    ;

fragment ElementBody
    : ';'
    | '{' ownedRelationship += OwnedRelationship '}'
    // | ownedRelationship += OwnedCommentAnnotation
    // | ownedRelationship += OwnedTextualRepresentationAnnotation
    // | ownedRelationship += OwnedMetadataFeatureAnnotation
    ;

OwnedRelationship:
    'relationship' 'to' relationshipTo=[Element:ID] ';'
    ;

hidden terminal WS: /\s+/;
terminal ID: /[_a-zA-Z][\w_]*/;
// terminal INT returns number: /[0-9]+/;
// terminal STRING: /"[^"]*"|'[^']*'/;

hidden terminal ML_COMMENT: /\/\*[\s\S]*?\*\//;
hidden terminal SL_COMMENT: /\/\/[^\n\r]*/;
