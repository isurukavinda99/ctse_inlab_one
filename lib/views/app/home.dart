import 'package:ctse_inlab_one/dtos/RecipeiesData.dart';
import 'package:ctse_inlab_one/dtos/Recipies.dart';
import 'package:ctse_inlab_one/views/login/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/PaddingBox.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController recipeTitle = TextEditingController();
  TextEditingController recipeDescription = TextEditingController();
  TextEditingController recipeIngredients = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("CTSE Recipe APP"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return Login();
              }));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<Recipies>>(
            stream: RecipiesData().listRecipe(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loader();
              }
              List<Recipies>? listRecipies = snapshot.data;
              return Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "All Recipies",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PaddingBox(),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    PaddingBox(),
                    ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[600],
                      ),
                      shrinkWrap: true,
                      itemCount: listRecipies!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () => {
                            showDialog(
                              builder: (context) => SimpleDialog(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 20,
                                ),
                                backgroundColor: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      "Add Recipe",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ),
                                children: [
                                  Divider(),
                                  TextFormField(
                                    controller: recipeTitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: "Recipe title",
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: recipeDescription,
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: "Description",
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: recipeIngredients,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      hintText: "Ingredients",
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  PaddingBox(),
                                  SizedBox(
                                    width: width,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (recipeTitle.text.isNotEmpty) {
                                          await RecipiesData().editRecipe(
                                              listRecipies[index].id,
                                              recipeTitle.text.trim(),
                                              recipeDescription.text.trim(),
                                              recipeIngredients.text.trim());
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        minimumSize: Size(60, 60),
                                        elevation: 10,
                                      ),
                                      child: Text("Add"),
                                    ),
                                  )
                                ],
                              ),
                              context: context,
                            ),
                          },
                          leading: Text(
                            listRecipies[index].title,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          title: Text(
                            listRecipies[index].ingredients +
                                ' ' +
                                listRecipies[index].description,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: TextButton(
                            onPressed: () async {
                              await RecipiesData()
                                  .removeRecipe(listRecipies[index].id);
                            },
                            child: Icon(Icons.delete),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            builder: (context) => SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    "Add Recipe",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              children: [
                Divider(),
                TextFormField(
                  controller: recipeTitle,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.white,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "recipe titile",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  controller: recipeDescription,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.white,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "description",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  controller: recipeIngredients,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.white,
                  ),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "ingredients",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
                PaddingBox(),
                SizedBox(
                  width: width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (recipeTitle.text.isNotEmpty) {
                        await RecipiesData().addRecipe(
                            recipeTitle.text.trim(),
                            recipeDescription.text.trim(),
                            recipeIngredients.text.trim());
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                    child: Text("Add"),
                  ),
                )
              ],
            ),
            context: context,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
