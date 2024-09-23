import 'order_item.dart';

class Project {
  String? id;
  String? projectTitle;
  String? projectDescription;
  String? orgName;
  String? projectReel;
  List<Media>? media;
  Category? category;
  int? projectTarget;
  int? amountRaised;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? targetLocal;
  String? amountRaisedLocal;

  Project({
    this.id,
    this.projectTitle,
    this.projectDescription,
    this.orgName,
    this.projectReel,
    this.media,
    this.category,
    this.projectTarget,
    this.amountRaised,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.targetLocal,
    this.amountRaisedLocal // Initialize this in the constructor
  });

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    projectTitle = json['project_title'];
    projectDescription = json['project_description'];
    orgName = json['org_name'];
    projectReel = json['project_reel'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    projectTarget = json['project_target'];
    amountRaised = json['amount_raised'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    targetLocal = json['target_local'];
    amountRaisedLocal = json['amount_raised_local'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['project_title'] = projectTitle;
    data['project_description'] = projectDescription;
    data['org_name'] = orgName;
    data['project_reel'] = projectReel;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['project_target'] = projectTarget;
    data['amount_raised'] = amountRaised;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['target_local'] = targetLocal;
    data['amount_raised_local'] = amountRaisedLocal;
    return data;
  }
}

class Comment {
  String? id;
  String? comment;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? replyTo;
  User? user;

  Comment({
    this.id,
    this.comment,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.replyTo,
    this.user,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    replyTo = json['replyTo'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['comment'] = comment;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['replyTo'] = replyTo;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Category {
  String? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;

  Category({this.id, this.name, this.description, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Member {
  String? firstname;
  String? lastname;

  Member({this.firstname, this.lastname});

  Member.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}

class ProjectResource {
  Project? project;
  List<Member>? members;
  List<Comment>? recentComments;

  ProjectResource({this.project, this.members, this.recentComments});

  ProjectResource.fromJson(Map<String, dynamic> json) {
    project = json['project'] != null ? Project.fromJson(json['project']) : null;

    if (json['members'] != null) {
      members = <Member>[];
      json['members'].forEach((v) {
        members!.add(Member.fromJson(v));
      });
    }

    if (json['recentComments'] != null) {
      recentComments = <Comment>[];
      json['recentComments'].forEach((v) {
        recentComments!.add(Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (project != null) {
      data['project'] = project!.toJson();
    }
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    if (recentComments != null) {
      data['recentComments'] = recentComments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  String? id;
  String? url;

  Media({this.id, this.url});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['url'] = url;
    return data;
  }
}
