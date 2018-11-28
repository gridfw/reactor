'use strict';
var PATH, PUG, compile;

PUG = require('pug');

PATH = require('path');

console.log('---- compile pug');

compile = function(filePath) {
  return PUG.renderFile(filePath, {
    self: true,
    pretty: true,
    filters: [],
    // plugings
    plugins: [
      {
        // lexer
        lex: {
          tag: function(value) {
            console.log('--- preLex',
      value);
            return value;
          }
        },
        // lex: -> console.log '--- lex'
        postLex: function(value) {
          console.log('--- args: ',
      value);
          return value;
        }
      }
    ],
    // data
    // console.log '--- lex: ', Object.keys this
    // console.log '--- tokens: ', @tokens.length
    // parse: ->
    // 	console.log '--- parse'
    image: {
      src: 'kkk.jpg',
      width: 200,
      height: 625
    }
  });
};

console.log(compile(PATH.join(__dirname, 'test1.pug')));
