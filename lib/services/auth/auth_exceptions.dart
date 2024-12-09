//login exceptions
class UserNotFoundAuthExceptions implements Exception{}
class WrongPasswordAuthExceptions implements Exception{}
class InvalidCredentialsAuthExceptions implements Exception{}
//register exceptions

class WeakPasswordAuthExceptions implements Exception{}
class EmailAlreadyInUseAuthExceptions implements Exception{}
class InvalidEmailAuthExceptions implements Exception{}

//generic exceptions

class GenericAuthExceptions implements Exception{}
class UserNotLoggedINAuthExceptions implements Exception{}
