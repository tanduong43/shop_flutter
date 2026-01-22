class Usermode {
   String username;
   String password;
   String fullname;
   String gender;
   String dob;
  Usermode({
    required  this.fullname,
    required  this.username,
    required  this.password,
    required  this.gender,
    required  this.dob,
  }
    

  );
  factory Usermode.fromJson(Map<String,dynamic> json){
    return Usermode(
      fullname: json["fullname"],
      username: json["username"],
      password: json["password"],
      gender: json["gender"],
      dob: json["dob"],
      
    );

  }


}