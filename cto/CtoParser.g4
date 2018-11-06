parser grammar CtoParser;

options { tokenVocab=CtoLexer; }

modelUnit
    : namespaceDeclaration? importDeclaration* typeDeclaration* EOF
    ;

namespaceDeclaration
    : NAMESPACE qualifiedName
    ;

importDeclaration
    : IMPORT qualifiedName (DOT MUL)?
    ;

typeDeclaration
    : (assetDeclaration
    | conceptDeclaration  
    | enumDeclaration
    | participantDeclaration
    | transactionDeclaration
    | eventDeclaration)
    ;

classModifier
    : decorator
    | ABSTRACT
    ;

assetDeclaration
    : classModifier*
      ASSET IDENTIFIER
      extendsOrIdentified
      classBody
    ;

conceptDeclaration
    : classModifier*
      CONCEPT IDENTIFIER
      (EXTENDS IDENTIFIER)?
      classBody
    ;

enumDeclaration
    : ENUM IDENTIFIER LBRACE enumConstant* RBRACE;

enumConstant
    : VAR IDENTIFIER;

eventDeclaration
    : EVENT IDENTIFIER
      classBody
    ;

participantDeclaration
    : classModifier*
      PARTICIPANT IDENTIFIER
      extendsOrIdentified
      classBody
    ;

transactionDeclaration
    : classModifier*
      TRANSACTION IDENTIFIER
      classBody
    ;

extendsOrIdentified: ((EXTENDS IDENTIFIER) | identified);

identified: (IDENTIFIED IDENTIFIER);

classBody
    : LBRACE classBodyDeclaration* RBRACE;

classBodyDeclaration
    : ';'
    | fieldDeclaration
    ;

fieldDeclaration
    : stringFieldType identifier defaultLiteral? regexDeclaration? OPTIONAL?
    | numericFieldType identifier defaultLiteral? rangeValidation? OPTIONAL?
    | otherFieldType identifier defaultOptional
    | identifierFieldType identifier
    | refType identifier;

identifierFieldType
    : VAR IDENTIFIER ('[' ']')*;

numericFieldType
    : VAR numericPrimitive ('[' ']')*;

numericPrimitive
    : DOUBLE
    | INTEGER
    | LONG
    ;

otherFieldType
    : VAR otherPrimitive ('[' ']')*;

otherPrimitive
    : BOOLEAN
    | DATE_TIME
    ;

regexDeclaration
    : REGEX ASSIGN REGEX_EXPR;

stringFieldType
    : VAR STRING ('[' ']')*;

refType
    : REF IDENTIFIER ('[' ']')*;

qualifiedName
    : IDENTIFIER ('.' IDENTIFIER)*;

rangeValidation
    : RANGE ASSIGN rangeDeclaration;

rangeDeclaration
    : ('[' numberLiteral ',' ']')
    | ('[' ',' numberLiteral ']')
    | ('[' numberLiteral ',' numberLiteral ']');

defaultOptional
    : defaultLiteral? OPTIONAL?;

defaultLiteral
    : (DEFAULT ASSIGN literal);

identifier: IDENTIFIER | ASSET | PARTICIPANT;

literal
    : numberLiteral
    | CHAR_LITERAL
    | STRING_LITERAL
    | BOOL_LITERAL
    ;

numberLiteral
    : integerLiteral
    | floatLiteral;

integerLiteral
    : DECIMAL_LITERAL
    | HEX_LITERAL
    | OCT_LITERAL
    ;

floatLiteral
    : FLOAT_LITERAL
    | HEX_FLOAT_LITERAL
    ;

decorator
    : AT qualifiedName ('(' elementValuePair ')')?;

elementValuePair
    : literal (',' literal)*;

