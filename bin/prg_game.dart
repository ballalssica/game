import 'dart:io';
import 'package:prg_game/character.dart';
import 'package:prg_game/game.dart';
import 'package:prg_game/monster.dart';


void main() async {
  print('캐릭터의 이름을 입력해주세요.');
  String? characterName = stdin.readLineSync();

  while (characterName == null || characterName.isEmpty || !RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(characterName)) {
    print('잘못된 이름입니다. 다시 입력해주세요.');
    characterName = stdin.readLineSync();
  }

  print('캐릭터의 이름은 $characterName 입니다. 게임을 시작합니다!');
  Character character = await loadCharacterFromFile(characterName, 'characters.txt');
  print('${character.name} - 체력: ${character.hp}, 공격력: ${character.power}, 방어력: ${character.defense}');

  List<Monster> monsters = await loadMonstersFromFile('monsters.txt');
  Game game = Game(character, monsters);
  await game.startGame();
}