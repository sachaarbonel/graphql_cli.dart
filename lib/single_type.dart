import 'package:http/http.dart' as http;
import 'dart:convert';

String single_type_introspection(String type_name){
  String query = """
  {\"query\":\"fragment FullType on __Type {\\n\\n  kind\\n\\n  name\\n\\n  description\\n\\n  fields(includeDeprecated: true) {\\n\\n    name\\n\\n    description\\n\\n    args {\\n\\n      ...InputValue\\n\\n    }\\n\\n    type {\\n\\n      ...TypeRef\\n\\n    }\\n\\n    isDeprecated\\n\\n    deprecationReason\\n\\n  }\\n\\n  inputFields {\\n\\n    ...InputValue\\n\\n  }\\n\\n  interfaces {\\n\\n    ...TypeRef\\n\\n  }\\n\\n  enumValues(includeDeprecated: true) {\\n\\n    name\\n\\n    description\\n\\n    isDeprecated\\n\\n    deprecationReason\\n\\n  }\\n\\n  possibleTypes {\\n\\n    ...TypeRef\\n\\n  }\\n\\n}\\n\\nfragment InputValue on __InputValue {\\n\\n  name\\n\\n  description\\n\\n  type {\\n\\n    ...TypeRef\\n\\n  }\\n\\n  defaultValue\\n\\n}\\n\\nfragment TypeRef on __Type {\\n\\n  kind\\n\\n  name\\n\\n  ofType {\\n\\n    kind\\n\\n    name\\n\\n    ofType {\\n\\n      kind\\n\\n      name\\n\\n      ofType {\\n\\n        kind\\n\\n        name\\n\\n        ofType {\\n\\n          kind\\n\\n          name\\n\\n          ofType {\\n\\n            kind\\n\\n            name\\n\\n            ofType {\\n\\n              kind\\n\\n              name\\n\\n              ofType {\\n\\n                kind\\n\\n                name\\n\\n              }\\n\\n            }\\n\\n          }\\n\\n        }\\n\\n      }\\n\\n    }\\n\\n  }\\n\\n}\\n\\nquery {\\n\\n  __type(name: \\\"${type_name}\\\") {\\n\\n    ...FullType\\n\\n  }\\n\\n}\\n\"}
  """;
  return query;
}

void get_type(String url) {
  http.post(url, body: single_type_introspection("pair")).then((response) {
    SingleTypeQuery introspection = singleTypeQueryFromJson(response.body);
    List<Field> fields = introspection.data.type.fields;
    print(fields.expand((Field f) => ["${f?.name}: ${f.type.ofType?.name}${f.type.kind} \n"]));
 
  });
}

SingleTypeQuery singleTypeQueryFromJson(String str) {
    final jsonData = json.decode(str);
    return SingleTypeQuery.fromJson(jsonData);
}

String singleTypeQueryToJson(SingleTypeQuery data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class SingleTypeQuery {
    DataType data;

    SingleTypeQuery({
        this.data,
    });

    factory SingleTypeQuery.fromJson(Map<String, dynamic> json) => new SingleTypeQuery(
        data: json["data"] == null ? null : DataType.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
    };
}

class DataType {
    Type type;

    DataType({
        this.type,
    });

    factory DataType.fromJson(Map<String, dynamic> json) => new DataType(
        type: json["__type"] == null ? null : Type.fromJson(json["__type"]),
    );

    Map<String, dynamic> toJson() => {
        "__type": type == null ? null : type.toJson(),
    };
}

class Type {
    dynamic inputFields;
    Kind kind;
    dynamic possibleTypes;
    List<dynamic> interfaces;
    String name;
    dynamic enumValues;
    String description;
    List<Field> fields;

    Type({
        this.inputFields,
        this.kind,
        this.possibleTypes,
        this.interfaces,
        this.name,
        this.enumValues,
        this.description,
        this.fields,
    });

    factory Type.fromJson(Map<String, dynamic> json) => new Type(
        inputFields: json["inputFields"],
        kind: json["kind"] == null ? null : kindValues.map[json["kind"]],
        possibleTypes: json["possibleTypes"],
        interfaces: json["interfaces"] == null ? null : new List<dynamic>.from(json["interfaces"].map((x) => x)),
        name: json["name"] == null ? null : json["name"],
        enumValues: json["enumValues"],
        description: json["description"] == null ? null : json["description"],
        fields: json["fields"] == null ? null : new List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "inputFields": inputFields,
        "kind": kind == null ? null : kindValues.reverse[kind],
        "possibleTypes": possibleTypes,
        "interfaces": interfaces == null ? null : new List<dynamic>.from(interfaces.map((x) => x)),
        "name": name == null ? null : name,
        "enumValues": enumValues,
        "description": description == null ? null : description,
        "fields": fields == null ? null : new List<dynamic>.from(fields.map((x) => x.toJson())),
    };
}

class Field {
    List<dynamic> args;
    bool isDeprecated;
    dynamic deprecationReason;
    String name;
    TypeClass type;
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
        args: json["args"] == null ? null : new List<dynamic>.from(json["args"].map((x) => x)),
        isDeprecated: json["isDeprecated"] == null ? null : json["isDeprecated"],
        deprecationReason: json["deprecationReason"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : TypeClass.fromJson(json["type"]),
        description: json["description"] == null ? null : json["description"],
    );

    Map<String, dynamic> toJson() => {
        "args": args == null ? null : new List<dynamic>.from(args.map((x) => x)),
        "isDeprecated": isDeprecated == null ? null : isDeprecated,
        "deprecationReason": deprecationReason,
        "name": name == null ? null : name,
        "type": type == null ? null : type.toJson(),
        "description": description == null ? null : description,
    };
}

class TypeClass {
    Kind kind;
    String name;
    TypeClass ofType;

    TypeClass({
        this.kind,
        this.name,
        this.ofType,
    });

    factory TypeClass.fromJson(Map<String, dynamic> json) => new TypeClass(
        kind: json["kind"] == null ? null : kindValues.map[json["kind"]],
        name: json["name"] == null ? null : json["name"],
        ofType: json["ofType"] == null ? null : TypeClass.fromJson(json["ofType"]),
    );

    Map<String, dynamic> toJson() => {
        "kind": kind == null ? null : kindValues.reverse[kind],
        "name": name == null ? null : name,
        "ofType": ofType == null ? null : ofType.toJson(),
    };

    @override
  String toString() {
    
    return super.toString();
  }
}

enum Kind { NON_NULL, OBJECT, SCALAR }

final kindValues = new EnumValues({
    "NON_NULL": Kind.NON_NULL,
    "OBJECT": Kind.OBJECT,
    "SCALAR": Kind.SCALAR
});

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


