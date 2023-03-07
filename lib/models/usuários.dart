class User {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String senha;
  final List bairros;

  const User({
    this.id;
    @required this.nome;
    @required this.email;
    this.telefone;
    @required this.senha
})
}