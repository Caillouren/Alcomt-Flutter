class User {
  final string id;
  final string nome;
  final string email;
  final string telefone;
  final string senha;

  const User({
    this.id;
    @required this.nome;
    @required this.email;
    this.telefone;
    @required this.senha
})
}