import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
final String href= 'https://api.unsplash.com/photos/?client_id=ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9&per_page=20&order_by=popular';



void main() => runApp(new PhotoGallery());

class PhotoGallery extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Photo Gallery'),
        ),
        body:  Gallery(),
      ),
    );
  }
}
class Gallery extends StatefulWidget{
  @override
  _GalleryState createState()=>new _GalleryState();
}

class _GalleryState extends State <Gallery>{
  List _imagesData;
  _loadingImages() async{
    try{
        var response = await http.get(href);
          setState(() {
          var responseBody = json.decode(response.body);
          _imagesData = responseBody;
        });
      } on SocketException catch(_) {
        Center(child:Text('Please, check your Internet connection!'));
      }
  }


 @override
  void initState() {
    super.initState();
    _loadingImages();
  }
  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: orientation == Orientation.portrait ? 2 : 4,crossAxisSpacing: 5,mainAxisSpacing: 5),
            itemCount: _imagesData == null ? 0 : _imagesData.length,
            itemBuilder: (BuildContext context,index)=>GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context)=>ImagePage(_imagesData[index]['urls']['regular']),
                    ),
                );
              },
              child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                      Container(
                        margin:EdgeInsets.all(8.0),
                        child: Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                          child: InkWell(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: Image.network(
                                    _imagesData[index]['urls']['small'],
                                    height: 100,
                                    fit:BoxFit.fill

                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                children:<Widget>[Container(

                                  child:ListTile(
                                    title: Text(_imagesData[index]['user']['name'],
                                                style: new TextStyle(
                                                  fontSize: 10,
                                                  height: 0
                                                ),
                                        ),
                                    subtitle: Text(_imagesData[index]['user']['username']),
                                   ),
                                ),
                              ]
                              ),
                            ],

                          ),
                        ),
                       ),
                      ),
                ]
              ),
            )
          );
        },
      );
   }
}

class ImagePage extends StatelessWidget {
  final String image;
  ImagePage(this.image);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('Full photo'),
      ),
      body:Center(
          child:Image.network(image)),
          backgroundColor: Colors.black,);
  }

}

