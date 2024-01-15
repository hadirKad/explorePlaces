class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;

  UserModel({ required this.id ,required this.firstName, required this.lastName, required this.email});


  Map<String,String> toJson(){

    return{
      'id' : id ?? "",
      'firstName' : firstName ?? "",
      'lastName' : lastName?? "",
      'email' : email ?? ""
    };
  }

  UserModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
  }

}
