import 'package:http/http.dart' as http;

void fetchServerData() async {
  var url = Uri.parse('http://localhost:3000/data');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    print('Response from Node.js: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
