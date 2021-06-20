import 'package:flutter/material.dart';
import 'package:freshwatch/features/database.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/screen/home/daily_veges.dart';
import 'package:freshwatch/widgets/card.dart';
import 'package:freshwatch/widgets/title.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllVegePosts>(
      future: AllVegePosts.init(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Text('Loading'),
          );
        } else {
          return ChangeNotifierProvider<AllVegePosts>(
            create: (_) => snapshot.data!,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20, horizontal: 10
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 15
                        ),
                        child: AppTitle(),
                      ),
                      const DashboardCard(
                        backgroundColor: Color(0xff56ad54),
                        content: Text(
                          'You should eat 350g of vegetables everyday !',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const DashboardCard(
                        content: DailyVeges(date: '19062021'),
                      ),
                      DashboardCard(
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                print(await Database.printSP);
                              }, 
                              child: const Text('print shared preferences'),
                            ),
                            _Test(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
    );
  }
}

class _Test extends StatelessWidget {
  const _Test({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(Provider.of<AllVegePosts>(context).posts.toString());
  }
}