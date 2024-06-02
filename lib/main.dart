import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_client.dart';
import 'package:flutter/material.dart';
import 'queries.dart';

void main() {
  final client = clientFor(uri: 'http://localhost:4000/');
  runApp(MyApp(client: client!));
}
class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  MyApp({required this.client});
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'GraphQL Flutter',
          home: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GraphQL Flutter')),
      body: Query(
        options: QueryOptions(document: gql(getUsers)),
        builder: (QueryResult? result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result!.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return CircularProgressIndicator();
          }
          final users = result.data?['allUser'];
          return ListView.builder(
            itemCount: users?.length ?? 0,
            itemBuilder: (context, index) {
              final user = users![index];
              return ListTile(
                title: Text(user['name']),
                subtitle: Text(user['email']),
              );
            },
          );
        },
      ),
    );
  }
}