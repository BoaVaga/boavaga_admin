import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

var tokenAdmin;

void main() {
  runApp(MyApp());
}

class GQlConfiguration {
  static HttpLink httplink = HttpLink(
    "http://192.168.0.130:5000/graphql",
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

  envioEmailSenhaAdmSistema(email) {
    return '''mutation envioEmailSenha {
  enviarEmailSenha(
    email: "$email",
    tipo: SISTEMA
  ) {
    success
    error
  }
}''';
  }

  envioEmailSenhaAdmEstacio(email) {
    return '''mutation envioEmailSenha {
  enviarEmailSenha(
    email: "$email",
    tipo: ESTACIONAMENTO
  ) {
    success
    error
  }
}''';
  }

  recuperarSenha(codigo, novaSenha) {
    return '''mutation recuperarSenha {
  recuperarSenha(
    code: "$codigo",
    novaSenha: "$novaSenha"
  ) {
    success
    error
  }
}''';
  }

  buscarTodosEstacionamentos() {
    return '''query ProcurarEstacio {
  listEstacionamento {
    success
    error
    estacionamentos {
      id
      nome
      telefone
      endereco {
        logradouro
        estado
        cidade
        bairro
        numero
        cep
        coordenadas
    	}
      foto
      estaSuspenso
      estaAberto
      cadastroTerminado
      descricao
      qtdVagaLivre
      totalVaga
      horarioPadrao {
        segundaAbr
        segundaFec
        tercaAbr
        tercaFec
      }
      valoresHora {
        id
        valor
        veiculo
      }
      horasDivergentes {
        id
        data
        horaAbr
        horaFec
      }
    }
  }
}''';
  }

  criarAdmEstacio(email, senha) {
    return '''mutation Cadastro {
  createAdminEstacio(
    email: "$email"
    senha: "$senha"
  ) {
    success
    error
    adminEstacio {
      id
      email
      adminMestre
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
        home: MyHomePage() // AQUI
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
                      hintText: 'Email')),
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
                      child: Text('Entrar como admin:', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Estacionamento', textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
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
                      child: Text('Sistema', textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
                    ),
                  ],
                )),
            new SizedBox(
                width: 200.0,
                child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (isSwitched == false) {
                            var result = await loginAdmEstacionamento(controllerTextEmail.text, controllerTextSenha.text);
                            if (result) {
                              if (jsonResposta["login"]["success"] == true) {
                                tokenAdmin = jsonResposta["login"]["token"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeAdmEstacionamento()),
                                );
                              } else {
                                if (jsonResposta["login"]["error"] == "email_nao_encontrado") {
                                  mostrarAlertDialogErro(context, "Seu email não foi encontrado em nosso sistema");
                                } else if (jsonResposta["login"]["error"] == "senha_incorreta") {
                                  mostrarAlertDialogErro(context, "Sua senha está incorreta");
                                } else {
                                  mostrarAlertDialogErro(context, "Erro desconhecido");
                                }
                              }
                            }
                          } else if (isSwitched == true) {
                            var result = await loginAdmSistema(controllerTextEmail.text, controllerTextSenha.text);
                            if (result) {
                              if (jsonResposta["login"]["success"] == true) {
                                tokenAdmin = jsonResposta["login"]["token"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeAdmSistema()),
                                );
                              } else {
                                if (jsonResposta["login"]["error"] == "email_nao_encontrado") {
                                  mostrarAlertDialogErro(context, "Seu email não foi encontrado em nosso sistema");
                                } else if (jsonResposta["login"]["error"] == "senha_incorreta") {
                                  mostrarAlertDialogErro(context, "Sua senha está incorreta");
                                } else {
                                  mostrarAlertDialogErro(context, "Erro desconhecido");
                                }
                              }
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                          child: Text('ENTRAR'),
                        )))),
            new SizedBox(
                width: 200.0,
                child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PgCadastroAdminEstacio()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                          child: Text('CADASTRE-SE'),
                        )))),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: InkWell(
                  child: Text("Esqueci minha senha", style: TextStyle(fontSize: 15)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StateEmailEsqueciSenha()),
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
    QueryResult result = await _client.mutate(MutationOptions(document: gql(_queries.loginAdmSistema(email, senha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }

  Future loginAdmEstacionamento(email, senha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(document: gql(_queries.loginAdmEstacionamento(email, senha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

class StateEmailEsqueciSenha extends StatefulWidget {
  @override
  PgEmailEsqueciSenha createState() => PgEmailEsqueciSenha();
}

class PgEmailEsqueciSenha extends State<StateEmailEsqueciSenha> {
  Queries _queries = Queries();

  GQlConfiguration _graphql = GQlConfiguration();

  final controllerTextEmail = TextEditingController();
  var jsonResposta;
  bool isSwitched = false;

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
                      hintText: 'Email')), // MAQUI
            ),
            Container(
                margin: const EdgeInsets.only(top: 30, left: 40),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Tipo de admin:', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Estacionamento', textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
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
                      child: Text('Sistema', textAlign: TextAlign.center, style: TextStyle(fontSize: 17)),
                    ),
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    onPressed: () async {
                      if (isSwitched == false) {
                        var result = await envioEmailSenhaAdmEstacio(controllerTextEmail.text);
                        if (result) {
                          if (jsonResposta["enviarEmailSenha"]["success"] == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PgEsqueciSenha()),
                            );
                          } else {
                            if (jsonResposta["enviarEmailSenha"]["error"] == "email_nao_encontrado") {
                              mostrarAlertDialogErro(context, "Seu email não foi encontrado em nosso sistema");
                            } else if (jsonResposta["enviarEmailSenha"]["error"] == "erro_envio_email") {
                              mostrarAlertDialogErro(context, "Ocorreu um erro ao tentarmos enviar o email");
                            } else {
                              mostrarAlertDialogErro(context, "Erro desconhecido");
                            }
                          }
                        }
                      } else if (isSwitched == true) {
                        var result = await envioEmailSenhaAdmSistema(controllerTextEmail.text);
                        if (result) {
                          if (jsonResposta["enviarEmailSenha"]["success"] == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PgEsqueciSenha()),
                            );
                          } else {
                            if (jsonResposta["enviarEmailSenha"]["error"] == "email_nao_encontrado") {
                              mostrarAlertDialogErro(context, "Seu email não foi encontrado em nosso sistema");
                            } else if (jsonResposta["enviarEmailSenha"]["error"] == "erro_envio_email") {
                              mostrarAlertDialogErro(context, "Ocorreu um erro ao tentarmos enviar o email");
                            } else {
                              mostrarAlertDialogErro(context, "Erro desconhecido");
                            }
                          }
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                      child: Text('Continuar'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future envioEmailSenhaAdmSistema(email) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(document: gql(_queries.envioEmailSenhaAdmSistema(email))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }

  Future envioEmailSenhaAdmEstacio(email) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(document: gql(_queries.envioEmailSenhaAdmEstacio(email))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

// ignore: must_be_immutable
class PgEsqueciSenha extends StatelessWidget {
  PgEsqueciSenha({Key? key}) : super(key: key);

  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  final controllerTextCodigo = TextEditingController();
  final controllerTextNovaSenha = TextEditingController();
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
            Container(margin: const EdgeInsets.only(right: 40, left: 40, bottom: 30), child: Text('Foi enviado um código de confirmação para seu email, insira o mesmo abaixo!', textAlign: TextAlign.center, style: TextStyle(fontSize: 17))),
            Container(
              margin: const EdgeInsets.only(right: 40, left: 40),
              child: TextField(
                  controller: controllerTextCodigo,
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
                      hintText: 'Código de confirmação')),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, right: 40, left: 40),
              child: TextField(
                  controller: controllerTextNovaSenha,
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
                        size: 32.0,
                        color: Colors.grey.shade800,
                      ),
                      hintText: 'Nova senha')),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    onPressed: () async {
                      var result = await recuperarSenha(controllerTextCodigo.text, controllerTextNovaSenha.text);
                      if (result) {
                        if (jsonResposta["recuperarSenha"]["success"] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),
                          );
                          mostrarAlertDialogSucesso(context, "Senha alterada com sucesso");
                        } else {
                          if (jsonResposta["recuperarSenha"]["error"] == "codigo_invalido") {
                            mostrarAlertDialogErro(context, "O código inserido não é válido!");
                          } else {
                            mostrarAlertDialogErro(context, "Erro desconhecido");
                          }
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                      child: Text('Continuar'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future recuperarSenha(codigo, novaSenha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(document: gql(_queries.recuperarSenha(codigo, novaSenha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

class PgNovaSenha extends StatelessWidget {
  const PgNovaSenha({Key? key}) : super(key: key);

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
            Container(margin: const EdgeInsets.only(right: 40, left: 40, bottom: 30), child: Text('O código informado está correto, insira uma nova senha para sua conta!', textAlign: TextAlign.center, style: TextStyle(fontSize: 17))),
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
                      hintText: 'Nova senha')),
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
                      padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                      child: Text('Continuar'),
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
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          new SizedBox(
              width: 300.0,
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        // AQUI alterar email
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
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
                        padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                        child: Text('Atualizar vagas'),
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
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          new SizedBox(
              width: 300.0,
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PgListarEstacios()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
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
                        padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
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
                          MaterialPageRoute(builder: (context) => PgCriarAdminSistema()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
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
                      var result = await criarAdmSistema(controllerTextNomeNovoAdmin.text, controllerTextEmailNovoAdmin.text, controllerTextSenhaNovoAdmin.text);
                      if (result) {
                        if (jsonResposta["createAdminSistema"]["success"] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeAdmSistema()),
                          );
                          var nome = jsonResposta['createAdminSistema']['adminSistema']['nome'];
                          var email = jsonResposta['createAdminSistema']['adminSistema']['email'];
                          mostrarAlertDialogSucesso(context, "Admin criado com sucesso!\nNome: $nome\nEmail: $email");
                        } else {
                          if (jsonResposta["createAdminSistema"]["error"] == "email_ja_cadastrado") {
                            mostrarAlertDialogErro(context, "Esse email já está cadastrado");
                          } else if (jsonResposta["createAdminSistema"]["error"] == "sem_permissao") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                            mostrarAlertDialogErro(context, "Você não tem permissão para isso, faça o login");
                          } else {
                            mostrarAlertDialogErro(context, "Erro desconhecido");
                          }
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                      child: Text('Criar'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future criarAdmSistema(nome, email, senha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(document: gql(_queries.criarAdmSistema(nome, email, senha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

// ignore: must_be_immutable
class PgListarEstacios extends StatelessWidget {
  Queries _queries = Queries();

  GQlConfiguration _graphql = GQlConfiguration();

  var jsonRespostaTodosEstacio;
  final ScrollController controllerScroll = ScrollController();
  final List<int> listTodosEstacio = [];

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
            new FutureBuilder<bool>(
              future: buscarTodosEstacio(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Aguarde');
                  default:
                    if (!snapshot.hasError) {
                      if (listTodosEstacio.length == 0) {
                        return Text("Nenhum estacionamento encontrado");
                      }
                      return Flexible(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          height: 900,
                          width: double.infinity,
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: controllerScroll,
                              itemCount: listTodosEstacio.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                  child: ListTile(
                                    leading: FlutterLogo(size: 72.0),
                                    title: Text(jsonRespostaTodosEstacio["listEstacionamento"]["estacionamentos"][index]["nome"]),
                                    subtitle: Text('Vagas disponíveis: ' + jsonRespostaTodosEstacio["listEstacionamento"]["estacionamentos"][index]["qtdVagaLivre"].toString()),
                                    isThreeLine: true,
                                    onTap: () {
                                      /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PageEstacionamento(
                                                dados: jsonRespostaTodosEstacio[
                                                        "listEstacionamento"][
                                                    "estacionamentos"][index])),
                                      );*/
                                    },
                                  ),
                                );
                              }),
                        ),
                      );
                    } else
                      return new Text('Erro: ${snapshot.error}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> buscarTodosEstacio() async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.query(QueryOptions(document: gql(_queries.buscarTodosEstacionamentos())));

    if (result.hasException)
      return false;
    else {
      jsonRespostaTodosEstacio = result.data;
      for (var i = 0; i < jsonRespostaTodosEstacio["listEstacionamento"]["estacionamentos"].length; i++) {
        listTodosEstacio.add(i);
      }
      return true;
    }
  }
}

// ignore: must_be_immutable
class PgCadastroAdminEstacio extends StatelessWidget {
  Queries _queries = Queries();

  GQlConfiguration _graphql = GQlConfiguration();

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
                      var result = await criarAdmEstacio(controllerTextEmailNovoAdmin.text, controllerTextSenhaNovoAdmin.text);
                      if (result) {
                        if (jsonResposta["createAdminEstacio"]["success"] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeAdmEstacio()),
                          );
                          var email = jsonResposta['createAdminEstacio']['adminEstacio']['email'];
                          mostrarAlertDialogSucesso(context, "Conta criada com sucesso!\nEmail: $email");
                        } else {
                          if (jsonResposta["createAdminEstacio"]["error"] == "email_ja_cadastrado") {
                            mostrarAlertDialogErro(context, "Esse email já está cadastrado");
                          } else if (jsonResposta["createAdminEstacio"]["error"] == "sem_permissao") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                            mostrarAlertDialogErro(context, "Você não tem permissão para isso, faça o login");
                          } else if (jsonResposta["createAdminEstacio"]["error"] == "email_not_found") {
                            mostrarAlertDialogErro(context, "Email não encontrado");
                          } else if (jsonResposta["createAdminEstacio"]["error"] == "admin_already_assigned") {
                            mostrarAlertDialogErro(context, "Administrador já atribuído");
                          } else {
                            mostrarAlertDialogErro(context, "Erro desconhecido");
                          }
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                      child: Text('Cadastre-se'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future criarAdmEstacio(email, senha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(document: gql(_queries.criarAdmEstacio(email, senha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

class HomeAdmEstacio extends StatelessWidget {
  const HomeAdmEstacio({Key? key}) : super(key: key);

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
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text("OPA"),
          /*new SizedBox(
              width: 300.0,
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PgListarEstacios()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
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
                        padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
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
                          MaterialPageRoute(builder: (context) => PgCriarAdminSistema()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                        child: Text('Cadastrar novo Admin Sistema'),
                      )))),*/
        ])));
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
