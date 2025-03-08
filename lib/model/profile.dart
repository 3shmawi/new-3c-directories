/*
{
  "results": [
    {
      "gender": "female",
      "name": {
        "title": "Miss",
        "first": "Rümeysa",
        "last": "Vorstermans"
      },
      "location": {
        "street": {
          "number": 1447,
          "name": "Bernhardsteeg"
        },
        "city": "Joure",
        "state": "Flevoland",
        "country": "Netherlands",
        "postcode": "2250 BK",
        "coordinates": {
          "latitude": "30.3322",
          "longitude": "106.9482"
        },
        "timezone": {
          "offset": "+5:30",
          "description": "Bombay, Calcutta, Madras, New Delhi"
        }
      },
      "email": "rumeysa.vorstermans@example.com",
      "login": {
        "uuid": "ce1b2262-d422-4187-bdcd-e934c7a54812",
        "username": "ticklishtiger613",
        "password": "ripper",
        "salt": "qhkgHC81",
        "md5": "ed7135160325711084f965cdd0b6c4c4",
        "sha1": "65da1d7b19641c85bca1360c0c51c8321ec3c01c",
        "sha256": "1bda79faf57cd4babbd10fe627b6f0c5e69b3030ff3ebc97767fa4ad8a640dfe"
      },
      "dob": {
        "date": "1955-05-27T03:35:46.646Z",
        "age": 69
      },
      "registered": {
        "date": "2007-07-16T17:11:36.623Z",
        "age": 17
      },
      "phone": "(0333) 054183",
      "cell": "(06) 82920810",
      "id": {
        "name": "BSN",
        "value": "41280213"
      },
      "picture": {
        "large": "https://randomuser.me/api/portraits/women/76.jpg",
        "medium": "https://randomuser.me/api/portraits/med/women/76.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/women/76.jpg"
      },
      "nat": "NL"
    }
  ],
  "info": {
    "seed": "8c2082395a6da39c",
    "results": 1,
    "page": 1,
    "version": "1.4"
  }
}
 */

class ProfileModel {
  final String gender;
  final NameModel name;
  final String email;

  ProfileModel({
    required this.gender,
    required this.name,
    required this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json["results"][0];

    return ProfileModel(
      gender: data['gender'],
      name: NameModel.fromJson(data['name'] as Map<String, dynamic>),
      email: data['email'],
    );
  }
}

class NameModel {
  final String title;
  final String first;
  final String last;

  NameModel({
    required this.title,
    required this.first,
    required this.last,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      title: json['title'],
      first: json['first'],
      last: json['last'],
    );
  }

  String displayName() => "$title: $first $last";
}
