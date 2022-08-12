import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class Cfuser extends HiveObject{
  @HiveField(0)
  late int rating;
  @HiveField(1)  
  late int maxrating;
  @HiveField(2)
  late int friends;
  @HiveField(3)
  late int contribution;

  @HiveField(4)
  late String handle;
  @HiveField(5)  
  late String rank;
  @HiveField(6)  
  late String maxrank;
  @HiveField(7)  
  late String avatar;
  @HiveField(8)  
  late String country;

  Cfuser({
    required this.handle,
    required this.rating,
    required this.rank,
    required this.maxrank,
    required this.friends,
    required this.maxrating,
    required this.contribution, 
    required this.avatar, 
    required this.country, 
  });
    
  factory Cfuser.fromJson(Map<String, dynamic> json) {
    return Cfuser(
      handle: json['handle'],
      rating: json["rating"],
      rank: json['rank'],
      maxrank: json['maxRank'],
      friends: json['friendOfCount'],
      maxrating: json['maxRating'],
      contribution: json['contribution'],
      avatar: json['titlePhoto'],
      country: json['country'] ?? '',
    );
  }
}
