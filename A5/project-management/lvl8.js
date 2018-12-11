class Player {
  constructor() {
    this.maxHealth = 20;
    this.health = 20;
    this.lastHealth = 20;
    this.direction = 'backward';
  }

  changeDirection() {
    switch(this.direction) {
      case('forward'): this.direction = 'right'; break;
      case('right'): this.direction = 'backward'; break;
      case('backward'): this.direction = 'left'; break;
      case('left'): this.direction = 'forward'; break;
      default: this.direction = 'forward'; break;
    }
  }

  moveBack() {
    switch(this.direction) {
      case('forward'): this.warrior.walk('backward'); break;
      case('right'): this.warrior.walk('left'); break;
      case('backward'): this.warrior.walk('forward'); break;
      case('left'): this.warrior.walk('right'); break;
    }
  }

  checkHealth(boundWithEnemy) {
    if (this.maxHealth === this.health) return true;

    if (boundWithEnemy) {
      this.moveBack();
      return false;
    }

    this.warrior.rest();
    return false;
  }

  makeObservation(space) {
    if (!space) return 0; // air
    else if (space.isUnit() && space.getUnit().isEnemy()) return 1; // enemy
    else if (space.isUnit() && space.getUnit().isBound()) return 2; // captive
    else if (space.isWall()) return 3; // wall
    else return 0; // air
  }

  makeLookUp() {
    const spaces = this.warrior.look(this.direction);
    const observation1 = this.makeObservation(spaces[0]);
    const observation2 = this.makeObservation(spaces[1]);
    const observation3 = this.makeObservation(spaces[2]);

    if (observation1) return this.makeHandAction(observation1);
    else if (observation2) return this.makeDistanceAction(observation2);
    else return this.makeDistanceAction(observation3);
  }

  makeHandAction(observation) {
    switch(observation) {
      case 1:
        if (!this.checkHealth(true)) return;
        this.warrior.attack(this.direction);
        break;
      case 2:
        this.warrior.rescue(this.direction);
        break;
      case 3:
        this.changeDirection();
        this.makeLookUp();
        break;
      default:
        if (!this.checkHealth(false)) return;
        this.warrior.walk(this.direction);
        break;
    }
  }

  makeDistanceAction(observation) {
    switch(observation) {
      case 1:
        this.warrior.shoot(this.direction);
        break;
      default:
        if (!this.checkHealth()) return;
        this.warrior.walk(this.direction);
        break;
    }
  }

  playTurn(warrior) {
    this.warrior = warrior;
    this.health = warrior.health();
    this.maxHealth = warrior.maxHealth();

    this.makeLookUp();

    this.lastHealth = this.health;
  }
}
