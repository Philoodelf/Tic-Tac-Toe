import 'package:flutter/material.dart';

class Gamescreen extends StatefulWidget {
  @override
  State<Gamescreen> createState() => _GamescreenState();
}

class _GamescreenState extends State<Gamescreen> {
  static const String player_x = "X";
  static const String player_y = "O";

  late String currentplayer;
  late bool gameend;
  late List<String> occupied;
  List<int> winningindices = [];

  @override
  void initState() {
    initializgame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF033B45),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headertext(),
            _gamecontainer(),
            _restart(),
          ],
        ),
      ),
    );
  }

  void initializgame() {
    currentplayer = player_x;
    gameend = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
    winningindices.clear();
  }

  _restart() {
    return Container(
        margin: EdgeInsets.all(16),
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                initializgame();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "Restart Game",
            )));
  }

  Widget _gamecontainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

  Widget _box(int index) {
    return InkWell(
        onTap: () {
          if (gameend || occupied[index].isNotEmpty) {
            return;
          }
          setState(() {
            occupied[index] = currentplayer;
            changeturn();
            winner();
            draw();
          });
        },
        child: Container(
            color: winningindices.contains(index)
            ? Color(0xFFFFF738)
            :occupied[index].isEmpty
                ? Colors.white
                : occupied[index] == player_x
                    ? Color(0xFF0094FF)
                    :  Color(0xFFFF00FF)
          //  Color(0xFFFF6B00)
            ,
            margin: const EdgeInsets.all(8),
            child: Center(
                child: Text(
              occupied[index],
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: occupied[index].isEmpty
                  ? Colors.white
               : occupied[index] == player_x
                    ? Colors.white
                    :Colors.white,
              ),
            ))));
  }

  winner() {
    List<List<int>> winlist = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var winpos in winlist) {
      String playerpostion0 = occupied[winpos[0]];
      String playerpostion1 = occupied[winpos[1]];
      String playerpostion2 = occupied[winpos[2]];

      if (playerpostion0.isNotEmpty) {
        if (playerpostion0 == playerpostion1 &&
            playerpostion0 == playerpostion2) {
          showmessege("player $playerpostion0 Won");
          gameend = true;
          winningindices =winpos;
          setState(() {

          });
          return;
        }
      }
    }
  }

  draw() {
    if (gameend) {
      return;
    }
    bool draw = true;
    for (var occupiedplayer in occupied) {
      if (occupiedplayer.isEmpty) {
        draw = false;
      }
    }
    if (draw) {
      showmessege("Draw");
      gameend = true;
    }
  }

  showmessege(String mesege) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Game Over \n $mesege",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          )),
    );
  }

  changeturn() {
    if (currentplayer == player_x) {
      currentplayer = player_y;
    } else {
      currentplayer = player_x;
    }
  }

  Widget _headertext() {
    return Column(
      children: [
        const Text(
          ("Tic Tac Toe"),
          style: TextStyle(
            color: Colors.green,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$currentplayer turn",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
