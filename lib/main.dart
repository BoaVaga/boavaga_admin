import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

var tokenAdmin = "060ccda9f4f1ba3ed4becbf730edc895";

void main() {
  runApp(MyApp());
}

class GQlConfiguration {
  static HttpLink httplink = HttpLink(
    "http://localhost:5000/graphql",
  );

  static AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer $tokenAdmin',
  );

  final Link link = authLink.concat(httplink);

  GraphQLClient myQlClient() {
    return GraphQLClient(link: link, cache: GraphQLCache());
  }
}

class Queries {
  loginAdmSistema(email, senha) {
    return '''mutation Login {
  login(
    email: "$email",
    senha: "$senha",
    tipo: SISTEMA
  ) {
    success
    error
    token
  }
}''';
  }

  loginAdmEstacionamento(email, senha) {
    return '''mutation Login {
  login(
    email: "$email",
    senha: "$senha",
    tipo: ESTACIONAMENTO
  ) {
    success
    error
    token
  }
}''';
  }

  criarAdmSistema(nome, email, senha) {
    return '''mutation Cadastro {
  createAdminSistema(
    nome: "$nome"
    email: "$email"
    senha: "$senha"
  ) {
    success
    error
    adminSistema {
      id
      nome
      email
    }
  }
}''';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boa Vaga',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(240, 255, 255, 255), // Ligth
      ),
      home: PgCriarAdminSistema(), // AQUI
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  Home createState() => Home();
}

class Home extends State<MyHomePage> {
  Queries _queries = Queries();

  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;
  bool isSwitched = false;

  final controllerTextEmail = TextEditingController();
  final controllerTextSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logonometransparente.png',
              fit: BoxFit.contain,
              height: 70,
            ),
            Container(
              margin: const EdgeInsets.only(top: 40, right: 20, left: 20),
              child: TextField(
                  controller: controllerTextEmail,
                  obscureText: false,
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(20, 20, 20, 20),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 32.0,
                        color: Colors.grey.shade800,
                      ),
                      hintText: 'Usuário')),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: TextField(
                  controller: controllerTextSenha,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(20, 20, 20, 20),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 30.0,
                        color: Colors.grey.shade800,
                      ),
                      hintText: 'Senha')),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30, left: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Entrar como admin:',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Estacionamento',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17)),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                    ),
                    Expanded(
                      child: Text('Sistema',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17)),
                    ),
                  ],
                )),
            new SizedBox(
                width: 200.0,
                child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                        onPressed: () async {
                          // AQUI Login
                          if (isSwitched == false) {
                            var result = await loginAdmEstacionamento(
                                controllerTextEmail.text,
                                controllerTextSenha.text);
                            if (result) {
                              if (jsonResposta["login"]["success"] == true) {
                                tokenAdmin = jsonResposta["login"]["token"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomeAdmEstacionamento()),
                                );
                              } else {
                                if (jsonResposta["login"]["error"] ==
                                    "email_nao_encontrado") {
                                  mostrarAlertDialogErro(context,
                                      "Seu email não foi encontrado em nosso sistema");
                                } else if (jsonResposta["login"]["error"] ==
                                    "senha_incorreta") {
                                  mostrarAlertDialogErro(
                                      context, "Sua senha está incorreta");
                                } else {
                                  mostrarAlertDialogErro(
                                      context, "Erro desconhecido");
                                }
                              }
                            }
                          } else if (isSwitched == true) {
                            var result = await loginAdmSistema(
                                controllerTextEmail.text,
                                controllerTextSenha.text);
                            if (result) {
                              if (jsonResposta["login"]["success"] == true) {
                                tokenAdmin = jsonResposta["login"]["token"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeAdmSistema()),
                                );
                              } else {
                                if (jsonResposta["login"]["error"] ==
                                    "email_nao_encontrado") {
                                  mostrarAlertDialogErro(context,
                                      "Seu email não foi encontrado em nosso sistema");
                                } else if (jsonResposta["login"]["error"] ==
                                    "senha_incorreta") {
                                  mostrarAlertDialogErro(
                                      context, "Sua senha está incorreta");
                                } else {
                                  mostrarAlertDialogErro(
                                      context, "Erro desconhecido");
                                }
                              }
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 30, left: 30, bottom: 15),
                          child: Text('ENTRAR'),
                        )))),
            new SizedBox(
                width: 200.0,
                child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        onPressed: () {
                          // AQUI cadastro
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 30, left: 30, bottom: 15),
                          child: Text('CADASTRE-SE'),
                        )))),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: InkWell(
                  child: Text("Esqueci minha senha",
                      style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PgEmailEsqueciSenha()),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }

  Future loginAdmSistema(email, senha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.loginAdmSistema(email, senha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }

  Future loginAdmEstacionamento(email, senha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(_queries.loginAdmEstacionamento(email, senha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

class PgEmailEsqueciSenha extends StatelessWidget {
  const PgEmailEsqueciSenha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logonometransparente.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 40, left: 40),
              child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(20, 20, 20, 20),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 32.0,
                        color: Colors.grey.shade800,
                      ),
                      hintText: 'Usuário ou Email')),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PgEsqueciSenha()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, right: 30, left: 30, bottom: 15),
                      child: Text('Continuar'),
                    ))),
          ],
        ),
      ),
    );
  }
}

class PgEsqueciSenha extends StatelessWidget {
  const PgEsqueciSenha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logonometransparente.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                  "Foi enviada uma nova senha para seu email, efetue o login utilizando essa senha!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18)),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, right: 30, left: 30, bottom: 15),
                      child: Text('Login'),
                    ))),
          ],
        ),
      ),
    );
  }
}

class HomeAdmEstacionamento extends StatelessWidget {
  const HomeAdmEstacionamento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logonometransparente.png',
                fit: BoxFit.contain,
                height: 40,
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            // AQUI alterar email
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Alterar meu email'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            // AQUI alterar email
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Alterar minha senha'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            // AQUI alterar email
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Editar estacionamento'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            // AQUI alterar email
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Atualizar vagas manualmente'),
                          )))),
            ])));
  }
}

class HomeAdmSistema extends StatelessWidget {
  const HomeAdmSistema({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logonometransparente.png',
                fit: BoxFit.contain,
                height: 40,
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            // AQUI
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Alterar meu email'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            // AQUI
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Alterar minha senha'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            // AQUI
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Listar Estacionamentos'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            // AQUI
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Analisar novos estacionamentos'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PgCriarAdminSistema()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Cadastrar novo Admin Sistema'),
                          )))),
            ])));
  }
}

// ignore: must_be_immutable
class PgCriarAdminSistema extends StatelessWidget {
  Queries _queries = Queries();

  GQlConfiguration _graphql = GQlConfiguration();

  final controllerTextNomeNovoAdmin = TextEditingController();
  final controllerTextEmailNovoAdmin = TextEditingController();
  final controllerTextSenhaNovoAdmin = TextEditingController();

  var jsonResposta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logonometransparente.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 40, right: 20, left: 20),
              child: TextField(
                  controller: controllerTextNomeNovoAdmin,
                  obscureText: false,
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(20, 20, 20, 20),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 32.0,
                        color: Colors.grey.shade800,
                      ),
                      hintText: 'Nome')),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: TextField(
                  controller: controllerTextEmailNovoAdmin,
                  obscureText: false,
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(20, 20, 20, 20),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 32.0,
                        color: Colors.grey.shade800,
                      ),
                      hintText: 'Email')),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: TextField(
                  controller: controllerTextSenhaNovoAdmin,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(20, 20, 20, 20),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 30.0,
                        color: Colors.grey.shade800,
                      ),
                      hintText: 'Senha')),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    onPressed: () async {
                      var result = await criarAdmSistema(
                          controllerTextNomeNovoAdmin.text,
                          controllerTextEmailNovoAdmin.text,
                          controllerTextSenhaNovoAdmin.text);
                      if (result) {
                        if (jsonResposta["createAdminSistema"]["success"] ==
                            true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeAdmSistema()),
                          );
                          var nome = jsonResposta['createAdminSistema']
                              ['adminSistema']['nome'];
                          var email = jsonResposta['createAdminSistema']
                              ['adminSistema']['email'];
                          mostrarAlertDialogSucesso(context,
                              "Admin criado com sucesso!\nNome: $nome\nEmail: $email");
                        } else {
                          if (jsonResposta["createAdminSistema"]["error"] ==
                              "email_ja_cadastrado") {
                            mostrarAlertDialogErro(
                                context, "Esse email já está cadastrado");
                          } else if (jsonResposta["createAdminSistema"]
                                  ["error"] ==
                              "sem_permissao") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                            mostrarAlertDialogErro(context,
                                "Você não tem permissão para isso, faça o login");
                          } else {
                            mostrarAlertDialogErro(
                                context, "Erro desconhecido");
                          }
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, right: 30, left: 30, bottom: 15),
                      child: Text('Criar'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future criarAdmSistema(nome, email, senha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(_queries.criarAdmSistema(nome, email, senha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

mostrarAlertDialogErro(BuildContext context, msgErro) {
  Widget okButton = ElevatedButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alerta = AlertDialog(
    title: Text("Erro"),
    content: Text(msgErro),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}

mostrarAlertDialogSucesso(BuildContext context, msgSucesso) {
  Widget okButton = ElevatedButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alerta = AlertDialog(
    title: Text("Parabéns"),
    content: Text(msgSucesso),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}
