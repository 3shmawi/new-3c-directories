class UserModel {
  UserModel({
    this.results,
    this.info,
  });

  UserModel.fromJson(dynamic json) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }
    info = json['info'] != null ? Info.fromJson(json['info']) : null;
  }
  List<Results>? results;
  Info? info;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    if (info != null) {
      map['info'] = info?.toJson();
    }
    return map;
  }
}

class Info {
  Info({
    this.seed,
    this.results,
    this.page,
    this.version,
  });

  Info.fromJson(dynamic json) {
    seed = json['seed'];
    results = json['results'];
    page = json['page'];
    version = json['version'];
  }
  String? seed;
  int? results;
  int? page;
  String? version;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['seed'] = seed;
    map['results'] = results;
    map['page'] = page;
    map['version'] = version;
    return map;
  }
}

class Results {
  Results({
    this.gender,
    this.name,
    this.location,
    this.email,
    this.login,
    this.dob,
    this.registered,
    this.phone,
    this.cell,
    this.id,
    this.picture,
    this.nat,
  });

  Results.fromJson(dynamic json) {
    gender = json['gender'];
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    email = json['email'];
    login = json['login'] != null ? Login.fromJson(json['login']) : null;
    dob = json['dob'] != null ? Dob.fromJson(json['dob']) : null;
    registered = json['registered'] != null
        ? Registered.fromJson(json['registered'])
        : null;
    phone = json['phone'];
    cell = json['cell'];
    id = json['id'] != null ? Id.fromJson(json['id']) : null;
    picture =
        json['picture'] != null ? Picture.fromJson(json['picture']) : null;
    nat = json['nat'];
  }
  String? gender;
  Name? name;
  Location? location;
  String? email;
  Login? login;
  Dob? dob;
  Registered? registered;
  String? phone;
  String? cell;
  Id? id;
  Picture? picture;
  String? nat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gender'] = gender;
    if (name != null) {
      map['name'] = name?.toJson();
    }
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['email'] = email;
    if (login != null) {
      map['login'] = login?.toJson();
    }
    if (dob != null) {
      map['dob'] = dob?.toJson();
    }
    if (registered != null) {
      map['registered'] = registered?.toJson();
    }
    map['phone'] = phone;
    map['cell'] = cell;
    if (id != null) {
      map['id'] = id?.toJson();
    }
    if (picture != null) {
      map['picture'] = picture?.toJson();
    }
    map['nat'] = nat;
    return map;
  }
}

class Picture {
  Picture({
    this.large,
    this.medium,
    this.thumbnail,
  });

  Picture.fromJson(dynamic json) {
    large = json['large'];
    medium = json['medium'];
    thumbnail = json['thumbnail'];
  }
  String? large;
  String? medium;
  String? thumbnail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['large'] = large;
    map['medium'] = medium;
    map['thumbnail'] = thumbnail;
    return map;
  }
}

class Id {
  Id({
    this.name,
    this.value,
  });

  Id.fromJson(dynamic json) {
    name = json['name'];
    value = json['value'];
  }
  String? name;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['value'] = value;
    return map;
  }
}

class Registered {
  Registered({
    this.date,
    this.age,
  });

  Registered.fromJson(dynamic json) {
    date = json['date'];
    age = json['age'];
  }
  String? date;
  int? age;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['age'] = age;
    return map;
  }
}

class Dob {
  Dob({
    this.date,
    this.age,
  });

  Dob.fromJson(dynamic json) {
    date = json['date'];
    age = json['age'];
  }
  String? date;
  int? age;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['age'] = age;
    return map;
  }
}

class Login {
  Login({
    this.uuid,
    this.username,
    this.password,
    this.salt,
    this.md5,
    this.sha1,
    this.sha256,
  });

  Login.fromJson(dynamic json) {
    uuid = json['uuid'];
    username = json['username'];
    password = json['password'];
    salt = json['salt'];
    md5 = json['md5'];
    sha1 = json['sha1'];
    sha256 = json['sha256'];
  }
  String? uuid;
  String? username;
  String? password;
  String? salt;
  String? md5;
  String? sha1;
  String? sha256;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = uuid;
    map['username'] = username;
    map['password'] = password;
    map['salt'] = salt;
    map['md5'] = md5;
    map['sha1'] = sha1;
    map['sha256'] = sha256;
    return map;
  }
}

class Location {
  Location({
    this.street,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.coordinates,
    this.timezone,
  });

  Location.fromJson(dynamic json) {
    street = json['street'] != null ? Street.fromJson(json['street']) : null;
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postcode = json['postcode'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    timezone =
        json['timezone'] != null ? Timezone.fromJson(json['timezone']) : null;
  }
  Street? street;
  String? city;
  String? state;
  String? country;
  String? postcode;
  Coordinates? coordinates;
  Timezone? timezone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (street != null) {
      map['street'] = street?.toJson();
    }
    map['city'] = city;
    map['state'] = state;
    map['country'] = country;
    map['postcode'] = postcode;
    if (coordinates != null) {
      map['coordinates'] = coordinates?.toJson();
    }
    if (timezone != null) {
      map['timezone'] = timezone?.toJson();
    }
    return map;
  }
}

class Timezone {
  Timezone({
    this.offset,
    this.description,
  });

  Timezone.fromJson(dynamic json) {
    offset = json['offset'];
    description = json['description'];
  }
  String? offset;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offset'] = offset;
    map['description'] = description;
    return map;
  }
}

class Coordinates {
  Coordinates({
    this.latitude,
    this.longitude,
  });

  Coordinates.fromJson(dynamic json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
  String? latitude;
  String? longitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}

class Street {
  Street({
    this.number,
    this.name,
  });

  Street.fromJson(dynamic json) {
    number = json['number'];
    name = json['name'];
  }
  int? number;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = number;
    map['name'] = name;
    return map;
  }
}

class Name {
  Name({
    this.title,
    this.first,
    this.last,
  });

  Name.fromJson(dynamic json) {
    title = json['title'];
    first = json['first'];
    last = json['last'];
  }
  String? title;
  String? first;
  String? last;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['first'] = first;
    map['last'] = last;
    return map;
  }
}
