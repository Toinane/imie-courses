class Player {
  
  constructor() {
    this.directions = ['left', 'forward', 'right', 'backward'];
    this.warrior = {};
    this.health = 20;
    this.maxHealth = 20;
  }

  hasLowHealth() {
    if(this.maxHealth - 10 < this.health) return false;

    return true;
  }

  towerEmpty() {
    if(this.warrior.listen().length) return false;

    return true;
  }

  escapeOrRest(observations) {
    if(observations.includes('enemy')) {
      if(observations.includes('empty')) {
        const key = observations.indexOf('empty');
        this.warrior.walk(this.directions[key]);
      } else {
        const key = observations.indexOf('enemy');
        this.warrior.attack(this.directions[key]);
      }
    }
    else this.warrior.rest();
  }

  attackOrWalk(observations) {
    if(observations.includes('enemy')) {
      const key = observations.indexOf('enemy');
      this.warrior.attack(this.directions[key]);
    } else {
      if(!this.towerEmpty()) return this.priorizeWalk();

      const direction = this.warrior.directionOfStairs();
      this.warrior.walk(direction);
    }
  }

  priorizeWalk() {
    const spaces = this.warrior.listen();

    const entities = spaces.map(space => this.foundEntity(space));

    if(entities.includes('captive')) {
      const key = entities.indexOf('captive');
      let direction = this.warrior.directionOf(spaces[key]);
      
      if(direction === this.ignoreStairs()) {
        const observations = this.makeObservation();
        if(observations.includes('empty')) direction = this.directions[observations.indexOf('empty')];
      }

      this.warrior.walk(direction);
    }
    else if(entities.includes('enemy')) {
      const key = entities.indexOf('enemy');
      const direction = this.warrior.directionOf(spaces[key]);
      this.warrior.walk(direction);
    }
  }

  foundEntity(space) {
    if(space.isUnit() && !space.getUnit().isBound()) return 'enemy';
    else if(space.isUnit() && space.getUnit().isBound()) return 'captive';
    else return 'empty';
  }

  ignoreStairs() {
    const observations = this.makeObservation();
    let key = 0;
    if(observations.includes('stairs')) key = observations.indexOf('stairs');

    return this.directions[key];
  }

  makeObservation() {
    const observations = this.directions.map(direction => {
      const feeling = this.warrior.feel(direction);
      let observation = 'empty';

      if(feeling.isWall()) observation = 'wall';
      if(feeling.isStairs()) observation = 'stairs';
      else if(feeling.isUnit() && !feeling.getUnit().isBound()) observation = 'enemy';
      else if(feeling.isUnit() && feeling.getUnit().isBound()) observation = 'captive';
      
      return observation;
    });

    return observations;
  }

  makeDecision(observations) {
    this.warrior.think(observations);
    if(observations.includes('captive')) {
      const key = observations.indexOf('captive');
      this.warrior.rescue(this.directions[key]);
    }
    else if(this.hasLowHealth()) return this.escapeOrRest(observations);
    else this.attackOrWalk(observations);
  }

  playTurn(warrior) {
    this.health = warrior.health();
    this.maxHealth = warrior.maxHealth();
    this.warrior = warrior;

    const observations = this.makeObservation();

    this.makeDecision(observations);
  }
}
