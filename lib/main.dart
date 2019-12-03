import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; //vai permitir fazer as requisições com a API e importa o pacote http
import 'dart:async'; //vai permitir fazer as requisições sem ter que ficar esperando, assim não trava o app
import 'dart:convert'; //Converte o nosso arquivo para o formato JSON

const request =
    "https://api.hgbrasil.com/finance?format=json&key=c652437c"; //API que vai converter os valores

void main() async {
  //Async faz a sincronia com a requsição do get

  runApp(MaterialApp(
    title: "Conversor",
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.black),
  ));
}



Future<Map> getData() async {
  //Função para chamar os dados do async, do futuro
  http.Response response = await http.get(
      request); //Mandei uma request com aquela http da API, irá retornar os dados do futuro
  return json.decode(response.body); //Vai retornar o arquivo json
  //json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();//Controlador do tipo de moeda
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final bitController = TextEditingController();


  double dolar;
  double euro;
  double bit;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    bitController.text = "";
  }

  void _realChanged(String text){//Quando mudar o valor, por isso foi criado essa função, e convertes os valores
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);//Esse to string serve pra mostrar apenas duas casas decimais
    euroController.text = (real/euro).toStringAsFixed(2);
    bitController.text = (real/bit).toStringAsFixed(2);
  }

  void _dolarChanged(String text){//Quando mudar o valor, por isso foi criado essa função
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);//this. pega a váriavel que tá lá em cima
    euroController.text = (dolar/euro).toStringAsFixed(2);
    bitController.text = (dolar/bit).toStringAsFixed(2);
  }

  void _euroChanged(String text){//Quando mudar o valor, por isso foi criado essa função
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro*this.euro).toStringAsFixed(2);
    dolarController.text = (euro*this.euro/dolar).toStringAsFixed(2);
    bitController.text = (euro/bit).toStringAsFixed(2);
  }

  void _bitChanged(String text){//Quando mudar o valor, por isso foi criado essa função
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double bit = double.parse(text);
    realController.text = (bit*this.bit).toStringAsFixed(2);
    dolarController.text = (bit*this.bit/dolar).toStringAsFixed(2);
    euroController.text = (bit*this.bit/euro).toStringAsFixed(2);
  }

  void _resetCampo(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    bitController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Criando a barra
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Conversor de valores"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        ),
      body: FutureBuilder<Map>(
          //Vai ficar carregando até pegar os dados do futuro, dessa forma, vai exibir "Carregando dados", por exemplo
          future: getData(),
          builder: (context, snapshot) {
            //Snapshot, é uma fotofragia momentanea dos dados q ele vai obter
            switch (snapshot.connectionState) {
              //Aq ele tenta carregar os dados, os cases seriam enquanto carrega, para aparecer a mensagem
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  //Vai ficar carregando os dados lá no centro
                  child: Text(
                    "Carregando os dados",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              default: //Caso ele consiga carregar os dados sem problemas
                if (snapshot.hasError) {
                  //Se ele apresentar o erro, ele vai retornar essa mensagem, enquanto carrega os dados
                  return Center(
                    //Vai ficar carregando os dados lá no centro
                    child: Text(
                      "Erro ao carregar dados",
                      style: TextStyle(color: Colors.amber, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  //Se ele não apresentar erros
                  dolar = snapshot.data["results"]["currencies"]["USD"]
                      ["buy"]; //pegando os dados do meu snapshot
                  euro = snapshot.data["results"]["currencies"]["EUR"]
                      ["buy"]; //pegando os dados do meu snapshot
                  bit = snapshot.data["results"]["currencies"]["BTC"]
                      ["buy"]; //pegando os dados do meu snapshot
                  return SingleChildScrollView(
                    //Imagem que fica rolando, assim o teclado não cobre
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          ),
                        onPressed: _resetCampo,
                      ),

                        buildTextField("Reais", "R\$", realController, _realChanged),

                        /*TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Reais",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "R\$" //Já deixa o prefixo da moeda
                              ),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),*/
                        Divider(),
                        //Dá o espaçamento em baixo de cada caixinha, assim não fica colado, serve como um "padding"
                        buildTextField("Dolar", "US\$", dolarController, _dolarChanged),
                        /*TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Dolar",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "US\$" //Já deixa o prefixo da moeda
                              ),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),*/
                        Divider(),
                        buildTextField("Euro", "€", euroController, _euroChanged),
                        /*TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Euro",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "€" //Já deixa o prefixo da moeda
                              ),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),*/
                        Divider(),
                        buildTextField("Bitcoin", "₿", bitController, _bitChanged),

                        Divider(),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}


Widget buildTextField(String label, String prefix, TextEditingController c, Function f){//É uma função que vai retornar o TextField, assim economiza código
  return TextField(
    controller: c,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix //Já deixa o prefixo da moeda
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: f,
  );
}