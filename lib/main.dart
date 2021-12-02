import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

var tokenAdmin;

void main() {
  runApp(MyApp());
}

class GQlConfiguration {
  static HttpLink httplink = HttpLink(
    "http://192.168.0.114:5000/graphql",
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

  criarPedidoCadastroEstacio(
      nome, telefone, rua, estado, cidade, bairro, numero, cep) {
    return '''mutation Cadastro {
      createPedidoCadastro(
        nome: "$nome"
        telefone: "$telefone"
        endereco: {
          logradouro: "$rua"
          estado: $estado
          cidade: "$cidade"
          bairro: "$bairro"
          numero: "$numero"
          cep: "$cep"
        }
      ) {
        success
        error
      }
    }''';
  }

  buscarPedidosCadastro() {
    return '''query ListarPedidoCadastro {
  listPedidoCadastro {
    success
    error
    pedidosCadastro {
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
      adminEstacio {
        id
        email
      }
    }
  }
}''';
  }

  rejeitarPedidoCadastro(id, motivo) {
    return '''mutation RejeitarPedidoCadastro {
  rejectPedidoCadastro(pedidoId: $id, motivo: "$motivo") {
    success
    error
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PgCadastroAdminEstacio()),
                          );
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
                          builder: (context) => StateEmailEsqueciSenha()),
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
                      child: Text('Tipo de admin:',
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
            Container(
                margin: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    onPressed: () async {
                      if (isSwitched == false) {
                        var result = await envioEmailSenhaAdmEstacio(
                            controllerTextEmail.text);
                        if (result) {
                          if (jsonResposta["enviarEmailSenha"]["success"] ==
                              true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PgEsqueciSenha()),
                            );
                          } else {
                            if (jsonResposta["enviarEmailSenha"]["error"] ==
                                "email_nao_encontrado") {
                              mostrarAlertDialogErro(context,
                                  "Seu email não foi encontrado em nosso sistema");
                            } else if (jsonResposta["enviarEmailSenha"]
                                    ["error"] ==
                                "erro_envio_email") {
                              mostrarAlertDialogErro(context,
                                  "Ocorreu um erro ao tentarmos enviar o email");
                            } else {
                              mostrarAlertDialogErro(
                                  context, "Erro desconhecido");
                            }
                          }
                        }
                      } else if (isSwitched == true) {
                        var result = await envioEmailSenhaAdmSistema(
                            controllerTextEmail.text);
                        if (result) {
                          if (jsonResposta["enviarEmailSenha"]["success"] ==
                              true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PgEsqueciSenha()),
                            );
                          } else {
                            if (jsonResposta["enviarEmailSenha"]["error"] ==
                                "email_nao_encontrado") {
                              mostrarAlertDialogErro(context,
                                  "Seu email não foi encontrado em nosso sistema");
                            } else if (jsonResposta["enviarEmailSenha"]
                                    ["error"] ==
                                "erro_envio_email") {
                              mostrarAlertDialogErro(context,
                                  "Ocorreu um erro ao tentarmos enviar o email");
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
                      child: Text('Continuar'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future envioEmailSenhaAdmSistema(email) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(_queries.envioEmailSenhaAdmSistema(email))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }

  Future envioEmailSenhaAdmEstacio(email) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(_queries.envioEmailSenhaAdmEstacio(email))));

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
            Container(
                margin: const EdgeInsets.only(right: 40, left: 40, bottom: 30),
                child: Text(
                    'Foi enviado um código de confirmação para seu email, insira o mesmo abaixo!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17))),
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
                      var result = await recuperarSenha(
                          controllerTextCodigo.text,
                          controllerTextNovaSenha.text);
                      if (result) {
                        if (jsonResposta["recuperarSenha"]["success"] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                          mostrarAlertDialogSucesso(
                              context, "Senha alterada com sucesso");
                        } else {
                          if (jsonResposta["recuperarSenha"]["error"] ==
                              "codigo_invalido") {
                            mostrarAlertDialogErro(
                                context, "O código inserido não é válido!");
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
                      child: Text('Continuar'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future recuperarSenha(codigo, novaSenha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(_queries.recuperarSenha(codigo, novaSenha))));

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
            Container(
                margin: const EdgeInsets.only(right: 40, left: 40, bottom: 30),
                child: Text(
                    'O código informado está correto, insira uma nova senha para sua conta!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17))),
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PgListarEstacios()),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PgListarPedidosCadastro()),
                            );
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
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 10.0, right: 10.0),
                                  child: ListTile(
                                    leading: FlutterLogo(size: 72.0),
                                    title: Text(jsonRespostaTodosEstacio[
                                            "listEstacionamento"]
                                        ["estacionamentos"][index]["nome"]),
                                    subtitle: Text('Vagas disponíveis: ' +
                                        jsonRespostaTodosEstacio[
                                                        "listEstacionamento"]
                                                    ["estacionamentos"][index]
                                                ["qtdVagaLivre"]
                                            .toString()),
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
    QueryResult result = await _client.query(
        QueryOptions(document: gql(_queries.buscarTodosEstacionamentos())));

    if (result.hasException)
      return false;
    else {
      jsonRespostaTodosEstacio = result.data;
      for (var i = 0;
          i <
              jsonRespostaTodosEstacio["listEstacionamento"]["estacionamentos"]
                  .length;
          i++) {
        listTodosEstacio.add(i);
      }
      return true;
    }
  }
}

// ignore: must_be_immutable
class PgListarPedidosCadastro extends StatelessWidget {
  Queries _queries = Queries();

  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;
  final ScrollController controllerScroll = ScrollController();
  final List<int> listTodosPedidos = [];

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
              future: buscarPedidos(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Aguarde');
                  default:
                    if (!snapshot.hasError) {
                      if (listTodosPedidos.length == 0) {
                        return Text("Nenhum pedido encontrado");
                      }
                      return Flexible(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          height: 900,
                          width: double.infinity,
                          child: ListView.builder(
                              shrinkWrap: true,
                              controller: controllerScroll,
                              itemCount: listTodosPedidos.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: FlutterLogo(size: 72.0),
                                        title: Text(
                                            jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["nome"]),
                                        subtitle: Text('ID: ' +
                                            jsonResposta["listPedidoCadastro"]
                                                    ["pedidosCadastro"][index]
                                                ["id"]),
                                        isThreeLine: true,
                                      ),
                                      Row(
                                        mainAxisAlignment:MainAxisAlignment.end,
                                        children: <Widget>[
                                          TextButton(
                                            child: const Text('Informações'),
                                            onPressed: () {
                                              mostrarAlertDialogInformacoes(context, "ID: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["id"] + 
                                              "\nNome: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["nome"] + 
                                              "\nTelefone: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["telefone"] + 
                                              "\n\nAdmin estacionamento:\nID: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["adminEstacio"]["id"] + 
                                              "\nEmail: "  + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["adminEstacio"]["email"] + 
                                              "\n\nEndereço:\nLogradouro: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["endereco"]["logradouro"] + 
                                              "\nNúmero: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["endereco"]["numero"] + 
                                              "\nBairro: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["endereco"]["bairro"] + 
                                              "\nCidade: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["endereco"]["cidade"] + 
                                              "\nEstado: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["endereco"]["estado"] + 
                                              "\nCEP: " + jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["endereco"]["cep"]);
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Aprovar'),
                                            onPressed: () {

                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            child: const Text('Negar'),
                                            onPressed: () {
                                              mostrarAlertDialogNegarPedidoCadastro(context, jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["id"]);
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
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

  Future<bool> buscarPedidos() async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client
        .query(QueryOptions(document: gql(_queries.buscarPedidosCadastro())));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      for (var i = 0;
          i < jsonResposta["listPedidoCadastro"]["pedidosCadastro"].length;
          i++) {
        listTodosPedidos.add(i);
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
                      var result = await criarAdmEstacio(
                          controllerTextEmailNovoAdmin.text,
                          controllerTextSenhaNovoAdmin.text);
                      if (result) {
                        if (jsonResposta["createAdminEstacio"]["success"] ==
                            true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                          var email = jsonResposta['createAdminEstacio']
                              ['adminEstacio']['email'];
                          mostrarAlertDialogSucesso(context,
                              "Conta criada com sucesso!\nEmail: $email");
                        } else {
                          if (jsonResposta["createAdminEstacio"]["error"] ==
                              "email_ja_cadastrado") {
                            mostrarAlertDialogErro(
                                context, "Esse email já está cadastrado");
                          } else if (jsonResposta["createAdminEstacio"]
                                  ["error"] ==
                              "sem_permissao") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                            mostrarAlertDialogErro(context,
                                "Você não tem permissão para isso, faça o login");
                          } else if (jsonResposta["createAdminEstacio"]
                                  ["error"] ==
                              "email_not_found") {
                            mostrarAlertDialogErro(
                                context, "Email não encontrado");
                          } else if (jsonResposta["createAdminEstacio"]
                                  ["error"] ==
                              "admin_already_assigned") {
                            mostrarAlertDialogErro(
                                context, "Administrador já atribuído");
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
                      child: Text('Cadastre-se'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future criarAdmEstacio(email, senha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.criarAdmEstacio(email, senha))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

class PgInicioAdmEstacio extends StatelessWidget {
  const PgInicioAdmEstacio({Key? key}) : super(key: key);

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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StateCadastrarEstacio()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Cadastrar estacionamento'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: Text(
                        "Caso você for administrador de um estacionamento já existente aguarde um administrador mestre lhe adicionar!",
                        textAlign: TextAlign.center,
                      ))),
            ])));
  }
}

class StateCadastrarEstacio extends StatefulWidget {
  @override
  PgCadastrarEstacio createState() => PgCadastrarEstacio();
}

class PgCadastrarEstacio extends State<StateCadastrarEstacio> {
  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;

  final controllerTextNomeEstacio = TextEditingController();
  final controllerTextTelefoneEstacio = TextEditingController();
  final controllerTextRuaEstacio = TextEditingController();
  String dropdownEstado = 'SP';
  final controllerTextCidadeEstacio = TextEditingController();
  final controllerTextBairroEstacio = TextEditingController();
  final controllerTextNumeroEstacio = TextEditingController();
  final controllerTextCepEstacio = TextEditingController();

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
                    controller: controllerTextNomeEstacio,
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
                          Icons.local_parking,
                          size: 30.0,
                          color: Colors.grey.shade800,
                        ),
                        hintText: 'Nome do estacionamento')),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                    controller: controllerTextTelefoneEstacio,
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
                          Icons.local_phone,
                          size: 30.0,
                          color: Colors.grey.shade800,
                        ),
                        hintText: 'Telefone do estacionamento')),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                    controller: controllerTextRuaEstacio,
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
                          Icons.edit_location,
                          size: 30.0,
                          color: Colors.grey.shade800,
                        ),
                        hintText: 'Rua do estacionamento')),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: Text("Estado do estacionamento"),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5, right: 20, left: 20),
                child: DropdownButton<String>(
                  value: dropdownEstado,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.grey),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownEstado = newValue!;
                    });
                  },
                  items: <String>[
                    'AC',
                    'AL',
                    'AP',
                    'AM',
                    'BA',
                    'CE',
                    'DF',
                    'ES',
                    'GO',
                    'MA',
                    'MT',
                    'MS',
                    'MG',
                    'PA',
                    'PB',
                    'PR',
                    'PE',
                    'PI',
                    'RJ',
                    'RN',
                    'RS',
                    'RO',
                    'RR',
                    'SC',
                    'SP',
                    'SE',
                    'TO'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                    controller: controllerTextCidadeEstacio,
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
                          Icons.edit_location,
                          size: 30.0,
                          color: Colors.grey.shade800,
                        ),
                        hintText: 'Cidade do estacionamento')),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                    controller: controllerTextBairroEstacio,
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
                          Icons.edit_location,
                          size: 30.0,
                          color: Colors.grey.shade800,
                        ),
                        hintText: 'Bairro do estacionamento')),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                    controller: controllerTextNumeroEstacio,
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
                          Icons.edit_location,
                          size: 30.0,
                          color: Colors.grey.shade800,
                        ),
                        hintText: 'Número do estacionamento')),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                    controller: controllerTextCepEstacio,
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
                          Icons.edit_location,
                          size: 30.0,
                          color: Colors.grey.shade800,
                        ),
                        hintText: 'CEP do estacionamento')),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                      onPressed: () async {
                        var result = await criarPedidoCadastro(
                            controllerTextNomeEstacio.text,
                            controllerTextTelefoneEstacio.text,
                            controllerTextRuaEstacio.text,
                            dropdownEstado,
                            controllerTextCidadeEstacio.text,
                            controllerTextBairroEstacio.text,
                            controllerTextNumeroEstacio.text,
                            controllerTextCepEstacio.text);
                        if (result) {
                          if (jsonResposta["createPedidoCadastro"]["success"] ==
                              true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                            mostrarAlertDialogSucesso(context,
                                "Solicitação feita com sucesso, aguarde um administrador do sistema aprovar seu pedido");
                          } else {
                            if (jsonResposta["createPedidoCadastro"]["error"] ==
                                "email_ja_cadastrado") {
                              mostrarAlertDialogErro(
                                  context, "Esse email já está cadastrado");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "sem_permissao") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                              );
                              mostrarAlertDialogErro(context,
                                  "Você não tem permissão para isso, faça o login");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "limite_pedido_atingido") {
                              mostrarAlertDialogErro(
                                  context, "Você atingiu o limite de pedidos");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "nome_muito_grande") {
                              mostrarAlertDialogErro(context,
                                  "O nome de seu estacionamento é muito grande");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "telefone_formato_invalido") {
                              mostrarAlertDialogErro(context,
                                  "O telefone de seu estacionamento esta em um formato inválido");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "telefone_sem_cod_internacional") {
                              mostrarAlertDialogErro(context,
                                  "O telefone de seu estacionamento esta sem o código internacional");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "telefone_muito_grande") {
                              mostrarAlertDialogErro(context,
                                  "O telefone de seu estacionamento é muito grande");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "foto_formato_invalido") {
                              mostrarAlertDialogErro(
                                  context, "O formato de sua foto é inválido");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "upload_error") {
                              mostrarAlertDialogErro(
                                  context, "Ocorreu um erro de upload");
                            } else if (jsonResposta["createPedidoCadastro"]
                                    ["error"] ==
                                "max_num_rejeicoes_atingido") {
                              mostrarAlertDialogErro(context,
                                  "Seu estacionamento atingiu o número máximo de rejeições");
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
                        child: Text('Continuar'),
                      ))),
            ])));
  }

  Future criarPedidoCadastro(
      nome, telefone, rua, estado, cidade, bairro, numero, cep) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(_queries.criarPedidoCadastroEstacio(
            nome, telefone, rua, estado, cidade, bairro, numero, cep))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

mostrarAlertDialogInformacoes(BuildContext context, info) {
  Widget okButton = ElevatedButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alerta = AlertDialog(
    title: Text("Informações"),
    content: Text(info),
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

mostrarAlertDialogNegarPedidoCadastro(BuildContext context, id) {
  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;

  Future rejeitarPedidoCadastro(id, motivo) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.rejeitarPedidoCadastro(id, motivo))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }

  var controllerMotivoReprova = TextEditingController();
  AlertDialog alerta = AlertDialog(
    title: Text("Negar estacionamento ID: " + id),
    content: TextField(
      controller: controllerMotivoReprova,
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
            Icons.block,
            size: 30.0,
            color: Colors.grey.shade800,
          ),
          hintText: 'Motivo')),
            
    actions: [
      ElevatedButton(
    child: Text("Confirmar"),
    onPressed: () async {
      var result = await rejeitarPedidoCadastro(id,controllerMotivoReprova.text);
          if (result) {
            if (jsonResposta["rejectPedidoCadastro"]["success"] ==true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeAdmSistema()),
              );
              mostrarAlertDialogSucesso(context,
                  "Pedido negado com sucesso");
            } else {
              if (jsonResposta["rejectPedidoCadastro"]["error"] ==
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
  )
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
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
