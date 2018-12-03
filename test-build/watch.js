console.log('--- watch');

Reactor.watch('a.test1', {
  click: function(event) {
    console.log('--- a clicked: ', event.currentTarget);
    console.log('--- target: ', event.target);
    event.preventDefault();
  },
  mouseover: function(event) {
    return this.style.background = 'red';
  },
  mouseout: function(event) {
    return this.style.background = '';
  }
});

Reactor.watch('.test2', {
  mouseover: function(event) {
    return console.log('*** mouseover');
  },
  hover: function(event) {
    return console.log('--- hOver');
  },
  mouseout: function(event) {
    return console.log('*** mouseout');
  },
  hout: function(event) {
    return console.log('--- hOut');
  }
});
