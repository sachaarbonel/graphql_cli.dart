import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show File;

void save_json_schema(String url) {
  http.post(url, body: introspection_query()).then((response) {

    Map valueMap = json.decode(response.body);
    File('schema.json').writeAsString(jsonEncode(valueMap));
    });
}

String introspection_query(){
  String query = """
  {\"query\":\"fragment FullType on __Type {\\n\\n  kind\\n\\n  name\\n\\n  description\\n\\n  fields(includeDeprecated: true) {\\n\\n    name\\n\\n    description\\n\\n    args {\\n\\n      ...InputValue\\n\\n    }\\n\\n    type {\\n\\n      ...TypeRef\\n\\n    }\\n\\n    isDeprecated\\n\\n    deprecationReason\\n\\n  }\\n\\n  inputFields {\\n\\n    ...InputValue\\n\\n  }\\n\\n  interfaces {\\n\\n    ...TypeRef\\n\\n  }\\n\\n  enumValues(includeDeprecated: true) {\\n\\n    name\\n\\n    description\\n\\n    isDeprecated\\n\\n    deprecationReason\\n\\n  }\\n\\n  possibleTypes {\\n\\n    ...TypeRef\\n\\n  }\\n\\n}\\n\\nfragment InputValue on __InputValue {\\n\\n  name\\n\\n  description\\n\\n  type {\\n\\n    ...TypeRef\\n\\n  }\\n\\n  defaultValue\\n\\n}\\n\\nfragment TypeRef on __Type {\\n\\n  kind\\n\\n  name\\n\\n  ofType {\\n\\n    kind\\n\\n    name\\n\\n    ofType {\\n\\n      kind\\n\\n      name\\n\\n      ofType {\\n\\n        kind\\n\\n        name\\n\\n        ofType {\\n\\n          kind\\n\\n          name\\n\\n          ofType {\\n\\n            kind\\n\\n            name\\n\\n            ofType {\\n\\n              kind\\n\\n              name\\n\\n              ofType {\\n\\n                kind\\n\\n                name\\n\\n              }\\n\\n            }\\n\\n          }\\n\\n        }\\n\\n      }\\n\\n    }\\n\\n  }\\n\\n}\\n\\nquery IntrospectionQuery {\\n\\n  __schema {\\n\\n    queryType {\\n\\n      name\\n\\n    }\\n\\n    mutationType {\\n\\n      name\\n\\n    }\\n\\n    types {\\n\\n      ...FullType\\n\\n    }\\n\\n    directives {\\n\\n      name\\n\\n      description\\n\\n      locations\\n\\n      args {\\n\\n        ...InputValue\\n\\n      }\\n\\n    }\\n\\n  }\\n\\n}\\n\",\"operationName\":\"IntrospectionQuery\"}
  """;
  return query;
}

void get_types(String url) {
  http.post(url, body: introspection_query()).then((response) {
    IntrospectionQuery introspection = introspectionQueryFromJson(response.body);
    for (TypeElement e in introspection.data.schema.types) {
      print(e.name);
      print(e.fields?.expand((Field f)=> ["${f.name}"]).toString());
      
    }
    
  });
}

IntrospectionQuery introspectionQueryFromJson(String str) {
    final jsonData = json.decode(str);
    return IntrospectionQuery.fromJson(jsonData);
}

String introspectionQueryToJson(IntrospectionQuery data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class IntrospectionQuery {
    DataSchema data;

    IntrospectionQuery({
        this.data,
    });

    factory IntrospectionQuery.fromJson(Map<String, dynamic> json) => new IntrospectionQuery(
        data: json["data"] == null ? null : DataSchema.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
    };
}

class DataSchema {
    Schema schema;

    DataSchema({
        this.schema,
    });

    factory DataSchema.fromJson(Map<String, dynamic> json) => new DataSchema(
        schema: json["__schema"] == null ? null : Schema.fromJson(json["__schema"]),
    );

    Map<String, dynamic> toJson() => {
        "__schema": schema == null ? null : schema.toJson(),
    };
}

class Schema {
    List<Directive> directives;
    Type queryType;
    List<TypeElement> types;
    Type mutationType;

    Schema({
        this.directives,
        this.queryType,
        this.types,
        this.mutationType,
    });

    factory Schema.fromJson(Map<String, dynamic> json) => new Schema(
        directives: json["directives"] == null ? null : new List<Directive>.from(json["directives"].map((x) => Directive.fromJson(x))),
        queryType: json["queryType"] == null ? null : Type.fromJson(json["queryType"]),
        types: json["types"] == null ? null : new List<TypeElement>.from(json["types"].map((x) => TypeElement.fromJson(x))),
        mutationType: json["mutationType"] == null ? null : Type.fromJson(json["mutationType"]),
    );

    Map<String, dynamic> toJson() => {
        "directives": directives == null ? null : new List<dynamic>.from(directives.map((x) => x.toJson())),
        "queryType": queryType == null ? null : queryType.toJson(),
        "types": types == null ? null : new List<dynamic>.from(types.map((x) => x.toJson())),
        "mutationType": mutationType == null ? null : mutationType.toJson(),
    };
}

class Directive {
    List<Arg> args;
    String name;
    List<String> locations;
    dynamic description;

    Directive({
        this.args,
        this.name,
        this.locations,
        this.description,
    });

    factory Directive.fromJson(Map<String, dynamic> json) => new Directive(
        args: json["args"] == null ? null : new List<Arg>.from(json["args"].map((x) => Arg.fromJson(x))),
        name: json["name"] == null ? null : json["name"],
        locations: json["locations"] == null ? null : new List<String>.from(json["locations"].map((x) => x)),
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "args": args == null ? null : new List<dynamic>.from(args.map((x) => x.toJson())),
        "name": name == null ? null : name,
        "locations": locations == null ? null : new List<dynamic>.from(locations.map((x) => x)),
        "description": description,
    };
}

class Arg {
    String name;
    dynamic defaultValue;
    OfTypeClass type;
    String description;

    Arg({
        this.name,
        this.defaultValue,
        this.type,
        this.description,
    });

    factory Arg.fromJson(Map<String, dynamic> json) => new Arg(
        name: json["name"] == null ? null : json["name"],
        defaultValue: json["defaultValue"],
        type: json["type"] == null ? null : OfTypeClass.fromJson(json["type"]),
        description: json["description"] == null ? null : json["description"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "defaultValue": defaultValue,
        "type": type == null ? null : type.toJson(),
        "description": description == null ? null : description,
    };
}

class OfTypeClass {
    Kind kind;
    String name;
    OfTypeClass ofType;

    OfTypeClass({
        this.kind,
        this.name,
        this.ofType,
    });

    factory OfTypeClass.fromJson(Map<String, dynamic> json) => new OfTypeClass(
        kind: json["kind"] == null ? null : kindValues.map[json["kind"]],
        name: json["name"] == null ? null : json["name"],
        ofType: json["ofType"] == null ? null : OfTypeClass.fromJson(json["ofType"]),
    );

    Map<String, dynamic> toJson() => {
        "kind": kind == null ? null : kindValues.reverse[kind],
        "name": name == null ? null : name,
        "ofType": ofType == null ? null : ofType.toJson(),
    };
}

enum Kind { SCALAR, LIST, NON_NULL, INPUT_OBJECT, ENUM, OBJECT }

final kindValues = new EnumValues({
    "ENUM": Kind.ENUM,
    "INPUT_OBJECT": Kind.INPUT_OBJECT,
    "LIST": Kind.LIST,
    "NON_NULL": Kind.NON_NULL,
    "OBJECT": Kind.OBJECT,
    "SCALAR": Kind.SCALAR
});

class Type {
    String name;

    Type({
        this.name,
    });

    factory Type.fromJson(Map<String, dynamic> json) => new Type(
        name: json["name"] == null ? null : json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
    };
}

class TypeElement {
    List<Arg> inputFields;
    Kind kind;
    dynamic possibleTypes;
    List<dynamic> interfaces;
    String name;
    List<EnumValue> enumValues;
    String description;
    List<Field> fields;

    TypeElement({
        this.inputFields,
        this.kind,
        this.possibleTypes,
        this.interfaces,
        this.name,
        this.enumValues,
        this.description,
        this.fields,
    });

    factory TypeElement.fromJson(Map<String, dynamic> json) => new TypeElement(
        inputFields: json["inputFields"] == null ? null : new List<Arg>.from(json["inputFields"].map((x) => Arg.fromJson(x))),
        kind: json["kind"] == null ? null : kindValues.map[json["kind"]],
        possibleTypes: json["possibleTypes"],
        interfaces: json["interfaces"] == null ? null : new List<dynamic>.from(json["interfaces"].map((x) => x)),
        name: json["name"] == null ? null : json["name"],
        enumValues: json["enumValues"] == null ? null : new List<EnumValue>.from(json["enumValues"].map((x) => EnumValue.fromJson(x))),
        description: json["description"] == null ? null : json["description"],
        fields: json["fields"] == null ? null : new List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "inputFields": inputFields == null ? null : new List<dynamic>.from(inputFields.map((x) => x.toJson())),
        "kind": kind == null ? null : kindValues.reverse[kind],
        "possibleTypes": possibleTypes,
        "interfaces": interfaces == null ? null : new List<dynamic>.from(interfaces.map((x) => x)),
        "name": name == null ? null : name,
        "enumValues": enumValues == null ? null : new List<dynamic>.from(enumValues.map((x) => x.toJson())),
        "description": description == null ? null : description,
        "fields": fields == null ? null : new List<dynamic>.from(fields.map((x) => x.toJson())),
    };
}

class EnumValue {
    bool isDeprecated;
    dynamic deprecationReason;
    String name;
    String description;

    EnumValue({
        this.isDeprecated,
        this.deprecationReason,
        this.name,
        this.description,
    });

    factory EnumValue.fromJson(Map<String, dynamic> json) => new EnumValue(
        isDeprecated: json["isDeprecated"] == null ? null : json["isDeprecated"],
        deprecationReason: json["deprecationReason"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
    );

    Map<String, dynamic> toJson() => {
        "isDeprecated": isDeprecated == null ? null : isDeprecated,
        "deprecationReason": deprecationReason,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
    };
}

class Field {
    List<Arg> args;
    bool isDeprecated;
    dynamic deprecationReason;
    String name;
    OfTypeClass type;
    String description;

    Field({
        this.args,
        this.isDeprecated,
        this.deprecationReason,
        this.name,
        this.type,
        this.description,
    });

    factory Field.fromJson(Map<String, dynamic> json) => new Field(
        args: json["args"] == null ? null : new List<Arg>.from(json["args"].map((x) => Arg.fromJson(x))),
        isDeprecated: json["isDeprecated"] == null ? null : json["isDeprecated"],
        deprecationReason: json["deprecationReason"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : OfTypeClass.fromJson(json["type"]),
        description: json["description"] == null ? null : json["description"],
    );

    Map<String, dynamic> toJson() => {
        "args": args == null ? null : new List<dynamic>.from(args.map((x) => x.toJson())),
        "isDeprecated": isDeprecated == null ? null : isDeprecated,
        "deprecationReason": deprecationReason,
        "name": name == null ? null : name,
        "type": type == null ? null : type.toJson(),
        "description": description == null ? null : description,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
