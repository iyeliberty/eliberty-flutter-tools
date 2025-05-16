abstract class StorableModel {
  Map<String, dynamic> toJson();
}
  // This method should be implemented by the model class to convert the object to JSON format.
  // The implementation will depend on the specific fields of the model.
  // For example, if you have a UserModel, it might look like this:
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'email': email,
  //   };
  // }
