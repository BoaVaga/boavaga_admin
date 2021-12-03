import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

var tokenAdmin;

void main() {
  runApp(MyApp());
}

class GQlConfiguration {
  static HttpLink httplink = HttpLink(
    "http://192.168.0.117:5000/graphql",
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
        quartaAbr
				quartaFec
				quintaAbr
				quintaFec				
				sextaAbr				
				sextaFec
				sabadoAbr
				sabadoFec
				domingoAbr
				domingoFec
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

  aprovarPedidoCadastro(id, cord) {
    return '''mutation AceitarPedidoCadastro {
  acceptPedidoCadastro(pedidoId: $id, coordenadas: "($cord)") {
    success
    error
  }
}''';
  }

  getUser() {
    return '''query getUser{
  getUser{
    adminEstacio{
      estacionamento{
        id
        cadastroTerminado
      }
    }
  }
}''';
  }

  finalizarCadastroEstacio(id, vagas, descricao, segundaAbr, segundaFec, tercaAbr, tercaFec, quartaAbr, quartaFec, quintaAbr, quintaFec, sextaAbr, sextaFec, sabAbr, sabFec, domAbr, domFec) {
    return '''mutation FinalizarCadastroEstacio {
  finishEstacionamentoCadastro(
    totalVaga: $vagas,
    horarioPadrao: {
      segundaAbr: $segundaAbr,
      segundaFec: $segundaFec,
      tercaAbr: $tercaAbr,
      tercaFec: $tercaFec,
      quartaAbr: $quartaAbr,
      quartaFec: $quartaFec,
      quintaAbr: $quintaAbr,
      quintaFec: $quintaFec,
      sextaAbr: $sextaAbr,
      sextaFec: $sextaFec,
      sabadoAbr: $sabAbr,
      sabadoFec: $sabFec,
      domingoAbr: $domAbr,
      domingoFec: $domFec,
    },
    descricao: "$descricao",
    estacioId: $id
  ) {
    success
    error
  }
}''';
  }

  atualizarQntVaga(qtd) {
    return '''mutation AtualizarQtdVagaLivre {
  atualizarQtdVagaLivre(numVaga: $qtd) {
    success
    error
  }
}''';
  }

  editEstacionamento(id, nome, telefone, rua, estado, cidade, bairro, numero, cep, totalVagas, descricao) {
    return '''mutation EditarEstacionamento {
  editEstacionamento(
    nome: "$nome"
    telefone: "$telefone"
    total_vaga: $totalVagas
    descricao: "$descricao"
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

  editHorarioEstacio(id, hrAbre, hrFecha, dia) {
    return '''mutation editHorarioEstacio {
  editEstacioHorarioPadrao(
    dia: "$dia"
    horaAbre: $hrAbre
    horaFecha: $hrFecha
    estacioId: $id
  ) {
    success
    error
  }
}''';
  }

  editValorEstacio(id, valor, idVeiculo) {
    return '''mutation editValorEstacio {
  editEstacioValorHora(
    veiculoId: $idVeiculo
    valor: $valor
    estacioId: $id
  ) {
    success
    error
  }
}''';
  }

  addAdminToEstacio(email) {
    return '''mutation addAdminToEstacio {
  addAdminToEstacio(
    email: "$email"
  ) {
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
        home: MyHomePage()
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
      body: SingleChildScrollView(
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 100),
              child:
            Image.asset(
              'assets/logonometransparente.png',
              fit: BoxFit.contain,
              height: 70,
            )),
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
                                var result = await getUser();
                                if (result) {
                                  if (jsonResposta["getUser"]["adminEstacio"]["estacionamento"] == null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                          PgInicioAdmEstacio()),
                                );
                                  } else if(jsonResposta["getUser"]["adminEstacio"]["estacionamento"] != null){
                                    if(jsonResposta["getUser"]["adminEstacio"]["estacionamento"]["cadastroTerminado"] == true){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeAdmEstacionamento(id: jsonResposta["getUser"]["adminEstacio"]["estacionamento"]["id"])),
                                      );
                                    } else if(jsonResposta["getUser"]["adminEstacio"]["estacionamento"]["cadastroTerminado"] == false){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StateTerminarCadastroEstacio(id: jsonResposta["getUser"]["adminEstacio"]["estacionamento"]["id"])),
                                      );
                                    }
                                  }
                                }
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

  Future getUser() async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(_queries.getUser())));

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
  final id;
  HomeAdmEstacionamento({Key? key, required this.id}) : super(key: key);

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
                        MaterialPageRoute(builder: (context) => StateEditEstacio(id: id)),
                      );
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
                            mostrarAlertDialogAttQntVaga(context, id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Atualizar vagas'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StateEditHorarioEstacio(id: id)),
                      );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Horario de funcionamento'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StateEditValorEstacio(id: id)),
                      );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Valor por hora'),
                          )))),
              new SizedBox(
                  width: 300.0,
                  child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            mostrarAlertDialogAddAdminToEstacio(context, id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 30, left: 30, bottom: 15),
                            child: Text('Adicionar admins ao estacionamento', textAlign: TextAlign.center,),
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
      body: SingleChildScrollView(
        child: Stack(
        children: <Widget>[
        Column(
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
        ])),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PgListarTodosEstacios(
                                                dados: jsonRespostaTodosEstacio[
                                                        "listEstacionamento"][
                                                    "estacionamentos"][index])),
                                      );
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

class PgListarTodosEstacios extends StatelessWidget {
  final dados;
  const PgListarTodosEstacios({Key? key, required this.dados}) : super(key: key);

  String get estaAberto => dados["estaAberto"] ? "Sim" : "Não";
  String get estaSuspenso => dados["estaSuspenso"] ? "Sim" : "Não";

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
        body: Container(
            child: Column(children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Align(alignment: Alignment.topCenter, child: Text(dados["nome"], style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("Endereço: " + dados["endereco"]["logradouro"] + "\nNº " + dados["endereco"]["numero"] + ", " + dados["endereco"]["bairro"] + ", " + dados["endereco"]["cidade"] + ' - ' + dados["endereco"]["estado"],
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Align(alignment: Alignment.topCenter, child: Text('Telefone: ' + dados["telefone"], textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("Descrição: asdcsa", textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text("Aberto: " + estaAberto + "\n Suspenso: " + estaSuspenso + "\n Vagas Livres: " + dados["qtdVagaLivre"].toString() + " / " + dados["totalVaga"].toString(),
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 15))),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                    "Horário de Funcionamento: \n Segunda-Feira: " +
                        formatHHMMSS(dados['horarioPadrao']['segundaAbr']) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["segundaFec"]) +
                        "\n Terça-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["tercaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["tercaFec"]) +
                        "\n Quarta-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["quartaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["quartaFec"]) +
                        "\n Quinta-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["quintaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["quintaFec"]) +
                        "\n Sexta-Feira: " +
                        formatHHMMSS(dados["horarioPadrao"]["sextaAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["sextaFec"]) +
                        "\n Sábado: " +
                        formatHHMMSS(dados["horarioPadrao"]["sabadoAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["sabadoFec"]) +
                        "\n Domingo: " +
                        formatHHMMSS(dados["horarioPadrao"]["domingoAbr"]) +
                        " às " +
                        formatHHMMSS(dados["horarioPadrao"]["domingoFec"]),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15))),
          ),
          new Container(
              margin: const EdgeInsets.only(top: 25.0, bottom: 5.0),
              child: Center(
                child: Text("Valores: "),
              )),
          Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical, // Axis.horizontal for horizontal list view.
              itemCount: dados["valoresHora"].length,
              itemBuilder: (ctx, index) {
                return Align(child: Text("Tipo: " + dados["valoresHora"][index]["veiculo"] + "   Valor: " + dados["valoresHora"][index]["valor"]));
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 15.0, bottom: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Voltar', style: TextStyle(fontSize: 18)),
              ))
        ])));
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
                                              mostrarAlertDialogAprovarPedidoCadastro(context, jsonResposta["listPedidoCadastro"]["pedidosCadastro"][index]["id"]);
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
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
            Column(
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
            ])
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

class StateTerminarCadastroEstacio extends StatefulWidget {
  final id;
  StateTerminarCadastroEstacio({Key? key, required this.id}) : super(key: key);
  @override
  PgTerminarCadastroEstacio createState() => PgTerminarCadastroEstacio(id: id);
}

class PgTerminarCadastroEstacio extends State<StateTerminarCadastroEstacio> {
  Queries _queries = Queries();

  GQlConfiguration _graphql = GQlConfiguration();

  final id;
  var jsonResposta;
  PgTerminarCadastroEstacio({required this.id}) : super();

  final controllerTotalVaga = TextEditingController();
  final controllerDescricao = TextEditingController();
  TextEditingController inputTimeAbrSegunda = TextEditingController();
  TextEditingController inputTimeFecSegunda = TextEditingController();
  TextEditingController inputTimeAbrTerca = TextEditingController();
  TextEditingController inputTimeFecTerca = TextEditingController();
  TextEditingController inputTimeAbrQuarta = TextEditingController();
  TextEditingController inputTimeFecQuarta = TextEditingController();
  TextEditingController inputTimeAbrQuinta = TextEditingController();
  TextEditingController inputTimeFecQuinta = TextEditingController();
  TextEditingController inputTimeAbrSexta = TextEditingController();
  TextEditingController inputTimeFecSexta = TextEditingController();
  TextEditingController inputTimeAbrSabad = TextEditingController();
  TextEditingController inputTimeFecSabad = TextEditingController();
  TextEditingController inputTimeAbrDoming = TextEditingController();
  TextEditingController inputTimeFecDoming = TextEditingController();

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
        body: SingleChildScrollView(
child: Stack(
    children: <Widget>[
      Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Finalize o cadastro de seu estacionamento!", style: TextStyle(fontSize: 16)),
                  Container(
                    margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                        child: TextField(
                          controller: controllerTotalVaga,
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
                              hintText: 'Total de vagas'))),
                  Container(
                    margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                        child: TextField(
                          controller: controllerDescricao,
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
                              hintText: 'Descrição')
                            )),
                            Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Horário de funcionamento: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Segunda-Feira: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeAbrSegunda,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Abertura"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeAbrSegunda.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeFecSegunda,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Fechamento"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeFecSegunda.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Terça-Feira: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeAbrTerca,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Abertura"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeAbrTerca.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeFecTerca,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Fechamento"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeFecTerca.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Quarta-Feira: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeAbrQuarta,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Abertura"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeAbrQuarta.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeFecQuarta,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Fechamento"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeFecQuarta.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Quinta-Feira: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeAbrQuinta,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Abertura"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeAbrQuinta.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeFecQuinta,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Fechamento"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeFecQuinta.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Sexta-Feira: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeAbrSexta,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Abertura"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeAbrSexta.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeFecSexta,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Fechamento"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeFecSexta.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Sábado: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeAbrSabad,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Abertura"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeAbrSabad.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeFecSabad,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Fechamento"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeFecSabad.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Domingo: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeAbrDoming,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Abertura"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeAbrDoming.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeFecDoming,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Fechamento"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeFecDoming.text = formattedTime;
                      });
                  }
                },
             )),
                  new SizedBox(
                    width: 200.0,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: ElevatedButton(
                            onPressed: () async {
                              var result = await finalizarCadastroEstacio(id, controllerTotalVaga.text, controllerDescricao.text, getSeconds(inputTimeAbrSegunda.text),getSeconds(inputTimeFecSegunda.text),getSeconds(inputTimeAbrTerca.text),getSeconds(inputTimeFecTerca.text),getSeconds(inputTimeAbrQuarta.text),getSeconds(inputTimeFecQuarta.text),getSeconds(inputTimeAbrQuinta.text),getSeconds(inputTimeFecQuinta.text),getSeconds(inputTimeAbrSexta.text),getSeconds(inputTimeFecSexta.text),getSeconds(inputTimeAbrSabad.text),getSeconds(inputTimeFecSabad.text),getSeconds(inputTimeAbrDoming.text),getSeconds(inputTimeFecDoming.text));
                              if (result) {
                                if (jsonResposta["finishEstacionamentoCadastro"]["success"] ==true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                  );
                                  mostrarAlertDialogSucesso(context,"Cadastro feito com sucesso, por favor, faça o login");
                                } else {
                                  if (jsonResposta["finishEstacionamentoCadastro"]["error"] =="hora_padrao_fecha_antes_de_abrir") {
                                    mostrarAlertDialogErro(context, "Horários inválidos");
                                  } else if (jsonResposta["finishEstacionamentoCadastro"]["error"] =="sem_permissao") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()),
                                    );
                                    mostrarAlertDialogErro(context,"Você não tem permissão para isso, faça o login");
                                  } else if (jsonResposta["finishEstacionamentoCadastro"]["error"] =="hora_padrao_dia_incompleto") {
                                    mostrarAlertDialogErro(context, "Preencha todos os horários");
                                  } else {
                                    mostrarAlertDialogErro(context, "Erro desconhecido");
                                  } 
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 30, left: 30, bottom: 15),
                              child: Text('Finalizar'),
                            )
                          )
                        )
                      ),
                    ]
                  )
                )]))
              );
  }

  Future finalizarCadastroEstacio(id, vagas, descricao, segundaAbr, segundaFec, tercaAbr, tercaFec, quartaAbr, quartaFec, quintaAbr, quintaFec, sextaAbr, sextaFec, sabAbr, sabFec, domAbr, domFec) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.finalizarCadastroEstacio(id, vagas, descricao, segundaAbr, segundaFec, tercaAbr, tercaFec, quartaAbr, quartaFec, quintaAbr, quintaFec, sextaAbr, sextaFec, sabAbr, sabFec, domAbr, domFec))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

class StateEditEstacio extends StatefulWidget {
  final id;
  StateEditEstacio({Key? key, required this.id}) : super(key: key);
  @override
  PgEditEstacio createState() => PgEditEstacio(id: id);
}

class PgEditEstacio extends State<StateEditEstacio> {
  final id;
  PgEditEstacio({required this.id}) : super();

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
  final controllerTextTotalVagaEstacio = TextEditingController();
  final controllerTextDescricaoEstacio = TextEditingController();

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
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                    controller: controllerTextTotalVagaEstacio,
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
                        hintText: 'Total de vagas'))),
              Container(
                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                    controller: controllerTextDescricaoEstacio,
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
                        hintText: 'Descrição do estacionamento'))),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                      onPressed: () async {
                        var result = await editEstacionamento(id,
                            controllerTextNomeEstacio.text,
                            controllerTextTelefoneEstacio.text,
                            controllerTextRuaEstacio.text,
                            dropdownEstado,
                            controllerTextCidadeEstacio.text,
                            controllerTextBairroEstacio.text,
                            controllerTextNumeroEstacio.text,
                            controllerTextCepEstacio.text,
                            controllerTextTotalVagaEstacio.text,
                            controllerTextDescricaoEstacio.text);
                        if (result) {
                          if (jsonResposta["editEstacionamento"]["success"] == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmEstacionamento(id: id)),
                            );
                            mostrarAlertDialogSucesso(context,"Alterações feitas com sucesso");
                          } else {
                            if (jsonResposta["editEstacionamento"]["error"] =="total_vaga_nao_positivo") {
                              mostrarAlertDialogErro(context, "Total de vagas não é positivo");
                            } else if (jsonResposta["editEstacionamento"]["error"] =="sem_permissao") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()),
                              );
                              mostrarAlertDialogErro(context,"Você não tem permissão para isso, faça o login");
                            } else if (jsonResposta["editEstacionamento"]["error"] =="descricao_muito_grande") {
                              mostrarAlertDialogErro(context,"A descrição de seu estacionamento é muito grande");
                            } else if (jsonResposta["editEstacionamento"]["error"] =="nome_muito_grande") {
                              mostrarAlertDialogErro(context,"O nome de seu estacionamento é muito grande");
                            } else if (jsonResposta["editEstacionamento"]["error"] =="cadastro_nao_terminado") {
                              mostrarAlertDialogErro(context,"O cadastro de seu estacionamento não foi finalizado");
                            } else if (jsonResposta["editEstacionamento"]["error"] =="telefone_muito_grande") {
                              mostrarAlertDialogErro(context,"O telefone de seu estacionamento é muito grande");
                            } else if (jsonResposta["editEstacionamento"]["error"] =="telefone_formato_invalido") {
                              mostrarAlertDialogErro(context,"O telefone de seu estacionamento é inválido");
                            } else if (jsonResposta["editEstacionamento"]["error"] =="telefone_sem_cod_internacional") {
                              mostrarAlertDialogErro(context,"O telefone de seu estacionamento não possui código internacional");
                            } else {
                              mostrarAlertDialogErro(context, "Erro desconhecido");
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15, right: 30, left: 30, bottom: 15),
                        child: Text('Alterar'),
                      ))),
            ])));
  }

  Future editEstacionamento(
      id, nome, telefone, rua, estado, cidade, bairro, numero, cep, totalVagas, descricao) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(MutationOptions(
        document: gql(_queries.editEstacionamento(
            id, nome, telefone, rua, estado, cidade, bairro, numero, cep, totalVagas, descricao))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

class StateEditValorEstacio extends StatefulWidget {
  final id;
  StateEditValorEstacio({Key? key, required this.id}) : super(key: key);
  @override
  PgEditValorEstacio createState() => PgEditValorEstacio(id: id);
}

class PgEditValorEstacio extends State<StateEditValorEstacio> {
  final id;
  PgEditValorEstacio({required this.id}) : super();

  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;

  String dropdownVeiculo = '1 - Carro';
  TextEditingController inputValor = TextEditingController();

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
                  Text("Tipo de veículo: "),
                  Container(
                margin: const EdgeInsets.only(top: 5, right: 20, left: 20),
                child: DropdownButton<String>(
                  value: dropdownVeiculo,
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
                      dropdownVeiculo = newValue!;
                    });
                  },
                  items: <String>[
                    '1 - Carro',
                    '2 - Moto',
                    '3 - Van',
                    '4 - Ônibus',
                    '5 - Outros'
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
                          controller: inputValor,
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
                              hintText: 'Valor')
                            )),
                  new SizedBox(
                    width: 200.0,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: ElevatedButton(
                            onPressed: () async {
                              var result = await editValorEstacio(id, inputValor.text, dropdownVeiculo);
                              if (result) {
                                if (jsonResposta["editEstacioValorHora"]["success"] ==true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeAdmEstacionamento(id: id)),
                                  );
                                  mostrarAlertDialogSucesso(context,"Dados alterados com sucesso");
                                } else {
                                  if (jsonResposta["editEstacioValorHora"]["error"] =="valor_nao_positivo") {
                                    mostrarAlertDialogErro(context, "Esse valor não é positivo");
                                  } else if (jsonResposta["editEstacioValorHora"]["error"] =="sem_permissao") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()),
                                    );
                                    mostrarAlertDialogErro(context,"Você não tem permissão para isso, faça o login");
                                  } else if (jsonResposta["editEstacioValorHora"]["error"] =="veiculo_nao_encontrado") {
                                    mostrarAlertDialogErro(context, "Veículo não encontrado");
                                  } else if (jsonResposta["editEstacioValorHora"]["error"] =="ERRO_ESTACIO_NAO_ENCONTRADO") {
                                    mostrarAlertDialogErro(context, "Estacionamento não encontrado");
                                  } else {
                                    mostrarAlertDialogErro(context, "Erro desconhecido");
                                  } 
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 30, left: 30, bottom: 15),
                              child: Text('Alterar'),
                            )
                          )
                        )
                      ),
                    ]
                  )
                )
              );
  }

  Future editValorEstacio(id, valor, veiculo) async {
    var idVeiculo = veiculo.split(" - ");
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.editValorEstacio(id, valor, idVeiculo[0]))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }
}

class StateEditHorarioEstacio extends StatefulWidget {
  final id;
  StateEditHorarioEstacio({Key? key, required this.id}) : super(key: key);
  @override
  PgEditHorarioEstacio createState() => PgEditHorarioEstacio(id: id);
}

class PgEditHorarioEstacio extends State<StateEditHorarioEstacio> {
  final id;
  PgEditHorarioEstacio({required this.id}) : super();

  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;

  TextEditingController inputTextDia = TextEditingController();
  TextEditingController inputTimeAbr = TextEditingController();
  TextEditingController inputTimeFecha = TextEditingController();

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
                          controller: inputTextDia,
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
                              hintText: 'Dia da semana')
                            )),
                            Container(
                        margin: const EdgeInsets.only(top: 25),
                  child:Text("Horário de funcionamento: ", style: TextStyle(fontSize: 14))),
                  Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeAbr,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Abertura"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeAbr.text = formattedTime;
                      });
                  }
                },
             )),
             Container(
                        margin: const EdgeInsets.only(right: 25, left: 25),
                  child: TextField(
                controller: inputTimeFecha,
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer),
                   labelText: "Fechamento"
                ),
                readOnly: true, 
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  if(pickedTime != null ){
                      DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      String formattedTime = DateFormat('HH:mm').format(parsedTime);
                      setState(() {
                        inputTimeFecha.text = formattedTime;
                      });
                  }
                },
             )),
                  new SizedBox(
                    width: 200.0,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: ElevatedButton(
                            onPressed: () async {
                              var result = await editHorarioEstacio(id, inputTextDia.text, getSeconds(inputTimeAbr.text),getSeconds(inputTimeFecha.text));
                              if (result) {
                                if (jsonResposta["editEstacioHorarioPadrao"]["success"] ==true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeAdmEstacionamento(id: id)),
                                  );
                                  mostrarAlertDialogSucesso(context,"Dados alterados com sucesso");
                                } else {
                                  if (jsonResposta["editEstacioHorarioPadrao"]["error"] =="hora_padrao_fecha_antes_de_abrir") {
                                    mostrarAlertDialogErro(context, "Horários inválidos");
                                  } else if (jsonResposta["editEstacioHorarioPadrao"]["error"] =="sem_permissao") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()),
                                    );
                                    mostrarAlertDialogErro(context,"Você não tem permissão para isso, faça o login");
                                  } else if (jsonResposta["editEstacioHorarioPadrao"]["error"] =="hora_padrao_dia_incompleto") {
                                    mostrarAlertDialogErro(context, "Preencha todos os horários");
                                  } else if (jsonResposta["editEstacioHorarioPadrao"]["error"] =="dia_invalido") {
                                    mostrarAlertDialogErro(context, "Dia inválido");
                                  } else {
                                    mostrarAlertDialogErro(context, "Erro desconhecido");
                                  } 
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 30, left: 30, bottom: 15),
                              child: Text('Alterar'),
                            )
                          )
                        )
                      ),
                    ]
                  )
                )
              );
  }

  Future editHorarioEstacio(id, dia, hrAbre, hrFecha) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.editHorarioEstacio(id, hrAbre, hrFecha, dia))));

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

mostrarAlertDialogAttQntVaga(BuildContext context, id) {
  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;

  Future atualizarQntVaga(qtd) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.atualizarQntVaga(qtd))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }

  var controllerQtdVagas = TextEditingController();
  AlertDialog alerta = AlertDialog(
    title: Text("Atualizar vagas disponíveis"),
    content: TextField(
      controller: controllerQtdVagas,
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
            Icons.edit,
            size: 30.0,
            color: Colors.grey.shade800,
          ),
          hintText: 'Vagas')),
            
    actions: [
      ElevatedButton(
    child: Text("Confirmar"),
    onPressed: () async {
      var result = await atualizarQntVaga(controllerQtdVagas.text);
          if (result) {
            if (jsonResposta["atualizarQtdVagaLivre"]["success"] ==true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeAdmEstacionamento(id: id)),
              );
              mostrarAlertDialogSucesso(context,
                  "Vagas atualizadas com sucesso");
            } else {
              if (jsonResposta["atualizarQtdVagaLivre"]["error"] ==
                  "sem_permissao") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                            mostrarAlertDialogErro(context,
                                "Você não tem permissão para isso, faça o login");
              } else if (jsonResposta["atualizarQtdVagaLivre"]["error"] =="quantia_negativa") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmEstacionamento(id: id)),
                            );
                            mostrarAlertDialogErro(context,"Quantia de vagas negativa");
              } else if (jsonResposta["atualizarQtdVagaLivre"]["error"] =="sem_estacionamento") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmEstacionamento(id: id)),
                            );
                            mostrarAlertDialogErro(context,"Sem estacionamento");
              } else if (jsonResposta["atualizarQtdVagaLivre"]["error"] =="quantia_maior_que_total") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmEstacionamento(id: id)),
                            );
                            mostrarAlertDialogErro(context,"Quantia de vagas disponíveis maior que a de vagas totais");
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

mostrarAlertDialogAprovarPedidoCadastro(BuildContext context, id) {
  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;

  Future aprovarPedidoCadastro(id, cord) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.aprovarPedidoCadastro(id, cord))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }

  var controllerCordX = TextEditingController();
  var controllerCordY = TextEditingController();
  AlertDialog alerta = AlertDialog(
    title: Text("Aprovar estacionamento ID: " + id),
    content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[TextField(
      controller: controllerCordX,
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
          hintText: 'Cordenada X')),
          Container(
              margin: const EdgeInsets.only(top: 20),
          child: TextField(
      controller: controllerCordY,
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
          hintText: 'Cordenada Y'))),] ),
            
    actions: [
      ElevatedButton(
    child: Text("Confirmar"),
    onPressed: () async {
      var result = await aprovarPedidoCadastro(id, (controllerCordX.text + " " + controllerCordY.text));
          if (result) {
            if (jsonResposta["acceptPedidoCadastro"]["success"] ==true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeAdmSistema()),
              );
              mostrarAlertDialogSucesso(context,
                  "Pedido aprovado com sucesso");
            } else {
              if (jsonResposta["acceptPedidoCadastro"]["error"] ==
                  "sem_permissao") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                            mostrarAlertDialogErro(context,
                                "Você não tem permissão para isso, faça o login");
              } else if (jsonResposta["acceptPedidoCadastro"]["error"] ==
                  "pedido_nao_encontrado") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmSistema()),
                            );
                            mostrarAlertDialogErro(context,
                                "Pedido de cadastro não encontrado");
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

mostrarAlertDialogAddAdminToEstacio(BuildContext context, id) {
  Queries _queries = Queries();
  GQlConfiguration _graphql = GQlConfiguration();

  var jsonResposta;

  Future addAdminToEstacio(email) async {
    GraphQLClient _client = _graphql.myQlClient();
    QueryResult result = await _client.mutate(
        MutationOptions(document: gql(_queries.addAdminToEstacio(email))));

    if (result.hasException)
      return false;
    else {
      jsonResposta = result.data;
      return true;
    }
  }

  var controllerEmailAdmin = TextEditingController();
  AlertDialog alerta = AlertDialog(
    title: Text("Adicionar admin ao estacionamento:"),
    content: TextField(
      controller: controllerEmailAdmin,
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
            size: 30.0,
            color: Colors.grey.shade800,
          ),
          hintText: 'Email do admin')),
            
    actions: [
      ElevatedButton(
    child: Text("Confirmar"),
    onPressed: () async {
      var result = await addAdminToEstacio(controllerEmailAdmin.text);
          if (result) {
            if (jsonResposta["addAdminToEstacio"]["success"] ==true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeAdmEstacionamento(id: id)),
              );
              mostrarAlertDialogSucesso(context,
                  "Admin cadastrado com sucesso");
            } else {
              if (jsonResposta["addAdminToEstacio"]["error"] ==
                  "sem_permissao") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmEstacionamento(id: id)),
                            );
                            mostrarAlertDialogErro(context,
                                "Você não tem permissão para isso");
              } else if (jsonResposta["addAdminToEstacio"]["error"] ==
                  "email_not_found") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmEstacionamento(id: id)),
                            );
                            mostrarAlertDialogErro(context,
                                "Email não encontrado");
              } else if (jsonResposta["addAdminToEstacio"]["error"] ==
                  "admin_already_assigned") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeAdmEstacionamento(id: id)),
                            );
                            mostrarAlertDialogErro(context,
                                "Esse admin já está cadastrado em outro estacionamento");
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

String formatHHMMSS(seconds) {
  if(seconds == null){
    return "Não definido";
  }
  if (seconds != 0) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }
    return "$hoursStr:$minutesStr:$secondsStr";
  } else {
    return "";
  }
}
 
int getSeconds(tempo){
  var horario = tempo.split(":");
  int segundos = (int.parse(horario[0])  * 3600) + (int.parse(horario[1]) * 60);
  return segundos;
}