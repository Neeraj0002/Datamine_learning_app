class Courses {
  Title title;
  Title details;
  Title thumbnail;
  Title price;

  Courses({this.title, this.details, this.thumbnail, this.price});

  Courses.fromJson(Map<String, dynamic> json) {
    title = json['Title'] != null ? new Title.fromJson(json['Title']) : null;
    details =
        json['Details'] != null ? new Title.fromJson(json['Details']) : null;
    thumbnail = json['Thumbnail'] != null
        ? new Title.fromJson(json['Thumbnail'])
        : null;
    price = json['Price'] != null ? new Title.fromJson(json['Price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.title != null) {
      data['Title'] = this.title.toJson();
    }
    if (this.details != null) {
      data['Details'] = this.details.toJson();
    }
    if (this.thumbnail != null) {
      data['Thumbnail'] = this.thumbnail.toJson();
    }
    if (this.price != null) {
      data['Price'] = this.price.toJson();
    }
    return data;
  }
}

class Title {
  String enUS;

  Title({this.enUS});

  Title.fromJson(Map<String, dynamic> json) {
    enUS = json['en-US'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en-US'] = this.enUS;
    return data;
  }
}
