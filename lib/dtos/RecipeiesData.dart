import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_inlab_one/dtos/Recipies.dart';

class RecipiesData {
  final CollectionReference recipieCollection =
  FirebaseFirestore.instance.collection('recipies');

  Future addRecipe(String title, String description, String ingredients) async {
    return await recipieCollection.add({
      "title": title,
      "description": description,
      "ingredients":ingredients,
    });
  }

  Future editRecipe(id,String title, String description, String ingredients) async {
    await recipieCollection.doc(id).update({
      "title": title,
      "description": description,
      "ingredients":ingredients,
    });
  }

  Future removeRecipe(id) async {
    await recipieCollection.doc(id).delete();
  }

  List<Recipies> recipeList(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return Recipies(
        ingredients: e.get("ingredients"),
        description: e.get("description"),
        title: e.get("title"),
        id: e.id,
      );
    }).toList();
  }

  Stream<List<Recipies>> listRecipe() {
    return recipieCollection.snapshots().map(recipeList);
  }
}
