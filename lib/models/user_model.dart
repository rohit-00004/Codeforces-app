class Cfuser{
  late int rating, maxrating, friends, contribution;
  late String handle, rank, maxrank, avatar;
  late int usid;

  Cfuser({
    required this.handle,
    required this.rating,
    required this.rank,
    required this.maxrank,
    required this.friends,
    required this.maxrating,
    required this.contribution, 
    required this.avatar, 
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
    );
  }
}


// problems solved
class Problem {
  late int contestId, rating;
  late String index, name;
  late List<dynamic> tags;
  
  Problem({
    required this.contestId,
    required this.index,
    required this.name,
    required this.tags,
    required this.rating,
  });
  
             
  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
    contestId : json['contestId'] ?? 0,
    index : json['index'],
    name : json['name'] ?? '',
    rating : json['rating'] ?? 0,
    tags : json['tags'],
    );
  }
}


const Map<String, String> alternateNames = {
  "COMPILATION_ERROR": "COMP_ERR",
  "RUNTIME_ERROR": "RUN_ERR",
  "WRONG_ANSWER": "WRG_ANS",
  "PRESENTATION_ERROR": "PST_ERR",
  "TIME_LIMIT_EXCEEDED": "TLE",
  "MEMORY_LIMIT_EXCEEDED": "MLE",
  "IDLENESS_LIMIT_EXCEEDED": "ILE",
  "SECURITY_VIOLATED": "SEC_VIOL",
  "INPUT_PREPARATION_CRASHED": "IPC"
};


class Submission{
  late int id, contestId;
  late Problem problem;
  late String verdict;

  Submission(
      {required this.id,
      required this.contestId,
      required this.problem,
      required this.verdict,
    });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'], 
      contestId: json['contestId'] ?? 0, 
      problem: Problem.fromJson(json['problem']),
      // problem: json['problem'], 
      verdict: json['verdict']
    );
  }
}
