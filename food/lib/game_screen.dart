import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:food/home_screen.dart';
import 'package:food/db/database_helper.dart';
import 'package:path_provider/path_provider.dart';

//import dart ffi
class GameScreen extends StatefulWidget {
  String player1;
  String player2;

  GameScreen({required this.player1, required this.player2});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    _currentPlayer = "X";
    _winner = "";
    _gameOver = false;
  }

  //guardar juego
  void _saveGame(String winner) async {
    final dbHelper = DatabaseHelper();
    final player1 = widget.player1;
    final player2 = widget.player2;

    await dbHelper.insertGame(player1, player2, winner);
  }

  //Resetear el juego
  void _resetgame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      _currentPlayer = "X";
      _winner = "";
      _gameOver = false;
    });
  }

  //Eliminar datos
  Future<void> _deleteData() async {
    final dbHelper = DatabaseHelper();
    await dbHelper
        .deleteAllGames(); // Llama al método deleteAllGames para eliminar todos los registros de la tabla

    setState(() {
      // Actualiza el estado de la pantalla o realiza cualquier otra acción necesaria
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }

    setState(() {
      _board[row][col] = _currentPlayer;

      // Verificar al ganador
      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][2] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][0] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      }

      // Cambiar de jugador
      _currentPlayer = _currentPlayer == "X" ? "O" : "X";

      // Verificar empate
      bool isBoardFull = !_board.any((row) => row.any((cell) => cell == ""));
      if (isBoardFull && _winner == "") {
        _gameOver = true;
        _winner = "Empate";
      }

      // Mostrar el mensaje de resultado
      if (_gameOver) {
        String resultMessage;
        if (_winner == "X") {
          resultMessage = widget.player1 + " Won!";
        } else if (_winner == "O") {
          resultMessage = widget.player2 + " Won!";
        } else {
          resultMessage = "Empate";
        }

        var awesomeDialog = AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          btnOkText: "Jugar Otra Vez",
          title: resultMessage,
          btnOkOnPress: () {
            _saveGame(
                _winner); // Guardar el resultado del juego en la base de datos;
            _resetgame();
          },
        );
        awesomeDialog.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 72, 20, 216),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            SizedBox(
                height: 70,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Turno de ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _currentPlayer == "X"
                            ? widget.player1 + "($_currentPlayer)"
                            : widget.player2 + "($_currentPlayer)",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: _currentPlayer == "X"
                              ? Color.fromARGB(255, 20, 183, 139)
                              : Color.fromARGB(255, 187, 124, 227),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ])),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(bottom: 20, left: 15, right: 15),
              //padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.all(15),
              child: GridView.builder(
                  itemCount: 9,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return GestureDetector(
                      onTap: () => _makeMove(row, col),
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 72, 20, 216),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(_board[row][col],
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: _board[row][col] == "X"
                                    ? Color.fromARGB(255, 20, 183, 139)
                                    : Color.fromARGB(255, 187, 124, 227),
                              )),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  shape: const CircleBorder(),
                  color: Color.fromARGB(255, 187, 124, 227),
                  padding: const EdgeInsets.all(20),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                    widget.player1 = "";
                    widget.player2 = "";
                  },
                  child: const Icon(
                    Icons.arrow_circle_left_rounded,
                    size: 40,
                    color: Colors.yellow,
                  ),
                ),
                InkWell(
                  onTap: _resetgame,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 187, 124, 227),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Text(
                      "Reset Game",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                MaterialButton(
                  shape: const CircleBorder(),
                  color: Color.fromARGB(255, 187, 124, 227),
                  padding: const EdgeInsets.all(20),
                  onPressed: _deleteData,
                  child: const Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puntuaciones por Partido:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 117, 20, 177),
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: DatabaseHelper().getGames(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error al cargar las puntuaciones');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No hay puntuaciones registradas');
                      }

                      final games = snapshot.data!;
                      return Column(
                        children: games.map((game) {
                          final player1 = game['player1'];
                          final player2 = game['player2'];
                          final winner = game['winner'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Text(
                              '$player1 vs $player2: $winner',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 117, 20, 177),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
