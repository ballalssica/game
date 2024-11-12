import 'dart:math';

import 'package:prg_game/character.dart';

class Monster {
  String name;
  int hp;
  int power;
  int defense = 0;

  Monster(this.name, this.hp, this.power, this.defense);

  void attackCharacter(Character character) {
    int damage = Random().nextInt(20) + 1;
    damage = max(damage, character.defense);
    character.hp -= damage;
    print('${character.name}에게 $damage의 피해를 입혔습니다.');
  }

  void showStatus() {
    print('현재 체력: ${this.hp}');
    print('현재 공격력: ${this.power}');
    print('현재 방어력: ${this.defense}');
  }
}