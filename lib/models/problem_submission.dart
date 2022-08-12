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